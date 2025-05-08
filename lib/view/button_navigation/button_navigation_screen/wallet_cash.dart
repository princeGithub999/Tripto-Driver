import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
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

  @override
  void initState() {
    super.initState();
    _fetchWalletBalance();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _fetchWalletBalance() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    DocumentSnapshot walletDoc = await FirebaseFirestore.instance
        .collection('wallets')
        .doc(userId)
        .get();

    setState(() {
      walletBalance = (walletDoc.exists && walletDoc['balance'] != null)
          ? walletDoc['balance'].toDouble()
          : 0.0;
    });
  }

  void _addMoney(double amount) {
    if (amount <= 0) {
      _showSnackBar("Enter a valid amount");
      return;
    }

    var options = {
      'key': 'rzp_test_8R6MNZhzqoqifN',
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
    String userId = FirebaseAuth.instance.currentUser!.uid;

    double commission = 134.0;
    double finalAmount = amount - commission;

    await FirebaseFirestore.instance.collection('wallets').doc(userId).update({
      'balance': FieldValue.increment(finalAmount),
    });

    _fetchWalletBalance();
    _showSnackBar("Payment Successful! ₹$finalAmount added to Wallet");
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

    String userId = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('wallets').doc(userId).update({
      'balance': FieldValue.increment(-amount),
    });

    await FirebaseFirestore.instance.collection('withdraw_requests').add({
      'userId': userId,
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
        appBar: AppBar(title: const Text('Wallet')),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Wallet Balance", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text("₹${walletBalance.toStringAsFixed(2)}", style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green)),
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
