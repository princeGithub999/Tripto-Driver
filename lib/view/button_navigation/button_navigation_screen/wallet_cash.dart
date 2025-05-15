import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});
  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  double walletBalance = 0.0;
  final Razorpay _razorpay = Razorpay();
  final TextEditingController _amountController = TextEditingController();
  final String adminWalletId = "admin_wallet"; // Use fixed ID for admin wallet

  @override
  void initState() {
    super.initState();
    _fetchWalletBalance();
    _calculateAndDistributeCommissions();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _fetchWalletBalance() async {
    DocumentSnapshot walletDoc = await FirebaseFirestore.instance
        .collection('wallets')
        .doc(adminWalletId)
        .get();

    setState(() {
      walletBalance = (walletDoc.exists && walletDoc['balance'] != null)
          ? walletDoc['balance'].toDouble()
          : 0.0;
    });
  }

  Future<void> _calculateAndDistributeCommissions() async {
    final firestore = FirebaseFirestore.instance;
    final QuerySnapshot paymentsSnapshot = await firestore
        .collection('payments')
        .where('status', isEqualTo: 'completed')
        .get();

    double totalCommission = 0.0;

    for (var doc in paymentsSnapshot.docs) {
      if (!(doc.data() as Map).containsKey('commissionSettled') || doc['commissionSettled'] == false) {
        double amount = doc['amount'].toDouble();
        String driverId = doc['driverId'];

        double commission = amount * 0.10;
        double driverShare = amount - commission;
        totalCommission += commission;

        // Credit driver 90%
        await firestore.collection('wallets').doc(driverId).set({
          'balance': FieldValue.increment(driverShare),
        }, SetOptions(merge: true));

        // Mark commission settled
        await firestore.collection('payments').doc(doc.id).update({
          'commissionSettled': true,
        });
      }
    }

    // Credit admin wallet
    if (totalCommission > 0) {
      await firestore.collection('wallets').doc(adminWalletId).set({
        'balance': FieldValue.increment(totalCommission),
      }, SetOptions(merge: true));

      _fetchWalletBalance();
    }
  }

  void _addMoney(double amount) {
    if (amount <= 0) {
      _showSnackBar("Enter a valid amount");
      return;
    }

    var options = {
      'key': 'rzp_test_KiNtLLkdqw8ygJ',
      'amount': (amount * 100).toInt(),
      'name': 'Wallet Recharge',
      'description': 'Adding money to wallet',
      'prefill': {
        'contact': '9876543210',
        'email': 'user@example.com',
      },
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print("Error: $e");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    double amount = double.parse(_amountController.text);

    await FirebaseFirestore.instance.collection('wallets').doc(adminWalletId).set({
      'balance': FieldValue.increment(amount),
    }, SetOptions(merge: true));

    _fetchWalletBalance();
    _showSnackBar("Payment Successful! ₹$amount added to Wallet");
    _amountController.clear();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    _showSnackBar("Payment Failed! Please try again.");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    _showSnackBar("External Wallet Used");
  }

  void _withdrawMoney(double amount) async {
    if (amount <= 0 || amount > walletBalance) {
      _showSnackBar("Invalid withdrawal amount");
      return;
    }

    await FirebaseFirestore.instance.collection('wallets').doc(adminWalletId).update({
      'balance': FieldValue.increment(-amount),
    });

    await FirebaseFirestore.instance.collection('withdraw_requests').add({
      'userId': adminWalletId,
      'amount': amount,
      'status': 'Pending',
      'timestamp': FieldValue.serverTimestamp(),
    });

    _fetchWalletBalance();
    _showSnackBar("Withdrawal Request Sent! ₹$amount will be transferred soon.");
    _amountController.clear();
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Wallet')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Wallet Balance", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text("₹${walletBalance.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green)),
            const SizedBox(height: 20),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Enter Amount",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.currency_rupee),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                double amount = double.tryParse(_amountController.text) ?? 0.0;
                _addMoney(amount);
              },
              child: const Text("Add Money"),
            ),
            ElevatedButton(
              onPressed: () {
                double amount = double.tryParse(_amountController.text) ?? 0.0;
                _withdrawMoney(amount);
              },
              child: const Text("Withdraw Money"),
            ),
          ],
        ),
      ),
    );
  }
}
