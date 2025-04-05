import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
        title: Text(
          'Change Bank Account',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.blue900,
        centerTitle: true,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [AppColors.blue900, AppColors.black700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Color(0xFFF8F9FA)],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _bankDetailsKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bank Account Details',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Update your bank information for payments',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildCustomTextField(
                    'Bank Name',
                    formProvider.driverBankName,
                    Icons.account_balance,
                    validator: Validation.validateBankName,
                  ),
                  const SizedBox(height: 16),
                  _buildCustomTextField(
                    'Account Number',
                    formProvider.driverAccountNumber,
                    Icons.credit_card,
                    validator: Validation.validateAccountNumber,
                  ),
                  const SizedBox(height: 16),
                  _buildCustomTextField(
                    'IFSC Code',
                    formProvider.driverIFSCCode,
                    Icons.code,
                    validator: Validation.validateIFSC,
                  ),
                  const SizedBox(height: 16),
                  _buildCustomTextField(
                    'UPI ID',
                    formProvider.driverUPIID,
                    Icons.qr_code,
                    validator: Validation.validateUPI,
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_bankDetailsKey.currentState!.validate()) {
                          // Save bank details logic
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Bank details updated successfully!'),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                          Future.delayed(Duration(seconds: 2), () {
                            Navigator.pop(context);
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue900,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        shadowColor: Colors.transparent,
                      ),
                      child: Text(
                        'Update Bank Details',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomTextField(
      String label,
      TextEditingController controller,
      IconData icon, {
        String? Function(String?)? validator,
      }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Text(
      label,
      style: GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.grey[700],
      ),
    ),
    const SizedBox(height: 8),
    TextFormField(
    controller: controller,
    validator: validator,
    keyboardType: TextInputType.text,
    decoration: InputDecoration(
    prefixIcon: Container(
    margin: const EdgeInsets.only(right: 12),
    decoration: BoxDecoration(
    border: Border(
    right: BorderSide(
    color: Colors.grey[300]!,
    width: 1,
    ),
    ),
    ),
    child: Icon(
    icon,
    color: AppColors.blue900,
    ),
    ),
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(
    color: Colors.grey[300]!,
    width: 1,
    ),
    ),
    enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(
    color: Colors.grey[300]!,
    width: 1,
    ),
    ),
    focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(
    color: AppColors.blue900,
    width: 1.5,
    ),
    ),
    contentPadding: const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 14,
    ),
    ),
    ),
    ],
    );
    }
}
