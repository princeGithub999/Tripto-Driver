import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bank Details',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const BankDetailScreen(),
    );
  }
}

class BankDetailScreen extends StatefulWidget {
  const BankDetailScreen({super.key});

  @override
  _BankDetailScreenState createState() => _BankDetailScreenState();
}

class _BankDetailScreenState extends State<BankDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _accountHolderController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _bankNameController = TextEditingController();
  final TextEditingController _ifscController = TextEditingController();
  final TextEditingController _branchController = TextEditingController();
  String _accountType = 'Savings';
  List<BankDetail> _savedBankDetails = [];

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getStringList('bankDetails') ?? [];
    setState(() {
      _savedBankDetails = data.map((e) => BankDetail.fromJson(e)).toList();
    });
  }

  Future<void> _saveForm() async {
    if (_formKey.currentState!.validate()) {
      final newDetail = BankDetail(
        accountHolder: _accountHolderController.text,
        accountNumber: _accountNumberController.text,
        bankName: _bankNameController.text,
        ifscCode: _ifscController.text,
        branch: _branchController.text,
        accountType: _accountType,
        timestamp: DateTime.now(),
      );
      setState(() {
        _savedBankDetails.add(newDetail);
      });
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList(
        'bankDetails',
        _savedBankDetails.map((e) => e.toJson()).toList(),
      );
      _formKey.currentState!.reset();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Details saved successfully!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bank Details Form')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: BankDetailForm(
                formKey: _formKey,
                controllers: {
                  'accountHolder': _accountHolderController,
                  'accountNumber': _accountNumberController,
                  'bankName': _bankNameController,
                  'ifsc': _ifscController,
                  'branch': _branchController,
                },
                accountType: _accountType,
                onAccountTypeChanged: (value) => setState(() => _accountType = value!),
                onSave: _saveForm,
              ),
            ),
            const Divider(),
            const Text('Saved Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: BankDetailList(details: _savedBankDetails),
            ),
          ],
        ),
      ),
    );
  }
}

class BankDetailForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Map<String, TextEditingController> controllers;
  final String accountType;
  final ValueChanged<String?> onAccountTypeChanged;
  final VoidCallback onSave;

  const BankDetailForm({
    required this.formKey,
    required this.controllers,
    required this.accountType,
    required this.onAccountTypeChanged,
    required this.onSave,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: ListView(
        children: [
          CustomTextField(
            label: 'Account Holder Name',
            controller: controllers['accountHolder']!,
            validator: (value) => value!.isEmpty ? 'Please enter name' : null,
          ),
          CustomTextField(
            label: 'Account Number',
            controller: controllers['accountNumber']!,
            inputType: TextInputType.number,
            maxLength: 18,
            validator: (value) => value!.length < 9 || value.length > 18
                ? 'Invalid account number'
                : null,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          ),
          CustomTextField(
            label: 'Bank Name',
            controller: controllers['bankName']!,
            validator: (value) => value!.isEmpty ? 'Please enter bank name' : null,
          ),
          CustomTextField(
            label: 'IFSC Code',
            controller: controllers['ifsc']!,
            maxLength: 11,
            validator: (value) =>
            value!.length != 11 ? 'IFSC must be 11 characters' : null,
          ),
          CustomTextField(
            label: 'Branch',
            controller: controllers['branch']!,
          ),
          DropdownButtonFormField<String>(
            value: accountType,
            items: ['Savings', 'Current']
                .map((type) => DropdownMenuItem(
              value: type,
              child: Text(type),
            ))
                .toList(),
            onChanged: onAccountTypeChanged,
            decoration: const InputDecoration(
              labelText: 'Account Type',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onSave,
            child: const Text('Save Details'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? inputType;
  final int? maxLength;
  final String? Function(String?)? validator;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    this.inputType,
    this.maxLength,
    this.validator,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        maxLength: maxLength,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: validator,
        inputFormatters: inputFormatters,
      ),
    );
  }
}

class BankDetailList extends StatelessWidget {
  final List<BankDetail> details;

  const BankDetailList({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: details.length,
      itemBuilder: (context, index) {
        final detail = details[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: ListTile(
            title: Text(detail.accountHolder),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Acc: ${detail.accountNumber}'),
                Text('IFSC: ${detail.ifscCode}'),
                Text(DateFormat('dd MMM yyyy hh:mm a').format(detail.timestamp)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class BankDetail {
  final String accountHolder;
  final String accountNumber;
  final String bankName;
  final String ifscCode;
  final String branch;
  final String accountType;
  final DateTime timestamp;

  BankDetail({
    required this.accountHolder,
    required this.accountNumber,
    required this.bankName,
    required this.ifscCode,
    required this.branch,
    required this.accountType,
    required this.timestamp,
  });

  factory BankDetail.fromJson(String json) {
    final data = json.split('||');
    return BankDetail(
      accountHolder: data[0],
      accountNumber: data[1],
      bankName: data[2],
      ifscCode: data[3],
      branch: data[4],
      accountType: data[5],
      timestamp: DateTime.parse(data[6]),
    );
  }

  String toJson() {
    return [
      accountHolder,
      accountNumber,
      bankName,
      ifscCode,
      branch,
      accountType,
      timestamp.toIso8601String(),
    ].join('||');
  }
}