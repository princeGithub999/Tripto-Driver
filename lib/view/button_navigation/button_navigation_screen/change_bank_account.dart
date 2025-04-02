import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripto_driver/utils/constants/colors.dart';
import 'package:tripto_driver/utils/validator/validation.dart';
import 'package:tripto_driver/view_model/provider/from_provider/from_provider.dart';

class ChangeBankAccount extends StatefulWidget {
  const ChangeBankAccount({super.key});

  @override
  State<ChangeBankAccount> createState() => _ChangeBankAccountState();
}

class _ChangeBankAccountState extends State<ChangeBankAccount> {
  final GlobalKey<FormState> _bankDetailsKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final formProvider = Provider.of<FromProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Bank Account'),
        backgroundColor: AppColors.blue900,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _bankDetailsKey,
          child: Column(
            children: [
              _buildCustomTextField('Bank Name', formProvider.driverBankName, Icons.account_balance,
                  validator: Validation.validateBankName),
              _buildCustomTextField('Account Number', formProvider.driverAccountNumber, Icons.credit_card,
                  validator: Validation.validateAccountNumber),
              _buildCustomTextField('IFSC Code', formProvider.driverIFSCCode, Icons.code,
                  validator: Validation.validateIFSC),
              _buildCustomTextField('UPI ID', formProvider.driverUPIID, Icons.qr_code,
                  validator: Validation.validateUPI),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_bankDetailsKey.currentState!.validate()) {
                    // Save bank details logic
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Bank details updated successfully!')),
                    );
                    Future.delayed(Duration(seconds: 4),() {
                      Navigator.pop(context);
                    },);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.blue900,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Update Bank Details',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTextField(
      String hint, TextEditingController controller, IconData icon,
      {String? Function(String?)? validator}) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: TextFormField(
            controller: controller,
            validator: validator,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              prefixIcon: Icon(icon, color: AppColors.blue900),
              hintText: hint,
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            ),
        );
    }
}
