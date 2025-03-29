import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';

class WalletCash extends StatefulWidget {
  const WalletCash({super.key});

  @override
  State<WalletCash> createState() => _WalletCashState();
}

class _WalletCashState extends State<WalletCash> {
  double walletBalance = 0.0;
  final Razorpay _razorpay = Razorpay();
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getWalletBalance();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  // Fetch wallet balance from Firebase
  void _getWalletBalance() async {
    String userId = FirebaseAuth.instance.currentUser !.uid;
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

  // Add money to wallet using Razorpay
  void _addMoney(double amount) {
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Enter a valid amount")));
      return;
    }

    var options = {
      'key': 'rzp_test_8R6MNZhzqoqifN', // Replace with your Razorpay API Key
      'amount': (amount * 100).toInt(),
      'name': 'Wallet Top-Up',
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

  // Handle payment success
  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    double amount = double.parse(_amountController.text);
    String userId = FirebaseAuth.instance.currentUser !.uid;

    // Commission Amount
    double commission = 134.0;
    double finalAmount = amount - commission;

    // Step 1: Send commission to Owner's Bank Account via Razorpay Payout API
    var payoutData = {
      "account_number": "2323230076543210", // App owner Razorpay account number
      "amount": (commission * 100).toInt(),
      "currency": "INR",
      "mode": "IMPS",
      "purpose": "commission",
      "fund_account": {
        "account_type": "bank_account",
        "bank_account": {
          "name": "App Owner Name",
          "ifsc": "HDFC0001234",
          "account_number": "123456789012"
        },
        "contact": {
          "name": "App Owner Name",
          "email": "owner@example.com",
          "contact": "9876543210",
          "type": "self"
        }
      },
      "queue_if_low_balance": true
    };

    var responsePayout = await http.post(
      Uri.parse("https://api.razorpay.com/v1/payouts"),
      headers: {
        "Content-Type": "application/json",
        "Authorization":
        "Basic ${base64Encode(utf8.encode('rzp_test_8R6MNZhzqoqifN:6ylXeZhSGfSTXNyYXXoiqSei'))}" // Replace with your Razorpay API Keys
      },
      body: jsonEncode(payoutData),
    );

    if (responsePayout.statusCode == 200) {
      print("Commission Sent to Owner Successfully!");
    } else {
      print("Commission Transfer Failed: ${responsePayout.body}");
    }

    // Step 2: Add Remaining Money to User's Wallet in Firebase
    await FirebaseFirestore.instance.collection('wallets').doc(userId).update({
      'balance': FieldValue.increment(finalAmount),
    });

    _getWalletBalance();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Payment Successful! ₹$finalAmount added to Wallet")));
    _amountController.clear();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Payment Failed! Please try again.")));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("External Wallet Used")));
  }

  // Withdraw Money Function
  void _withdrawMoney(double amount) async {
    if (amount <= 0 || amount > walletBalance) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Invalid withdrawal amount")));
      return;
    }

    String userId = FirebaseAuth.instance.currentUser !.uid;
    await FirebaseFirestore.instance.collection('wallets').doc(userId).update({
      'balance': FieldValue.increment(-amount),
    });

    await FirebaseFirestore.instance.collection('withdraw_requests').add({
      'userId': userId,
      'amount': amount,
      'status': 'Pending',
      'timestamp': FieldValue.serverTimestamp(),
    });

    _getWalletBalance();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
        Text("Withdrawal Request Sent! ₹$amount will be transferred to your Bank")));
    _amountController.clear();
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
                const Text("Wallet Balance",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text("₹${walletBalance.toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold, color: Colors.green)),
                const SizedBox(height: 20),

                // Display Commission Amount
                const Text("Commission Amount: ₹134.00",
                    style: TextStyle(fontSize: 16, color: Colors.red)),

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
