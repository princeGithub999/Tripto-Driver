import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripto_driver/utils/constants/colors.dart';
import 'package:tripto_driver/view_model/provider/form_fillup_provider/form_fillup_provider.dart';
import 'dart:io';

class AdharPanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<FormFillupProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aadhar & PAN Upload'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(icon: const Icon(Icons.help_outline), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUploadSection(
                context, 'Front side of your Aadhar Card', true, true, provider.aadharFrontImage),
            const SizedBox(height: 16),
            _buildUploadSection(
                context, 'Back side of your Aadhar Card', false, true, provider.aadharBackImage),
            const SizedBox(height: 16),
            _buildAadharInputSection(provider),
            const SizedBox(height: 16),
            _buildUploadSection(
                context, 'Upload PAN Card', false, false, provider.panImage),
            const SizedBox(height: 16),
            _buildPanInputSection(provider),
            const SizedBox(height: 16),
            _buildSubmitButton(provider),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadSection(BuildContext context, String title, bool isFront, bool isAadhar, File? imageFile) {
    var provider = Provider.of<FormFillupProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => provider.pickAadharImage(isFront,isAadhar),
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: imageFile == null
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_upload, color: Colors.grey, size: 40),
                  Text('Upload Photo', style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
                : ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(imageFile, fit: BoxFit.cover),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAadharInputSection(FormFillupProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Enter Aadhar Number', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: provider.licenseController,
          keyboardType: TextInputType.number,
          maxLength: 12,
          decoration: InputDecoration(
            hintText: 'Enter 12-digit Aadhar Number',
            border: OutlineInputBorder(),
            errorText: provider.isLicenseNumberValid ? null : 'Aadhar number must be 12 digits',
          ),
        ),
      ],
    );
  }

  Widget _buildPanInputSection(FormFillupProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Enter PAN Number', style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(
          controller: provider.licenseController,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.characters,
          maxLength: 10,
          decoration: InputDecoration(
            hintText: 'Enter PAN (ABCDE1234F)',
            border: OutlineInputBorder(),
            errorText: provider.isLicenseNumberValid ? null : 'Invalid PAN format',
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(FormFillupProvider provider) {
    return ElevatedButton(
      onPressed: provider.isFormComplete ? () {} : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: provider.isFormComplete ? AppColors.blue900 : AppColors.blue900,
        minimumSize: const Size(360, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text('Submit'),
    );
  }
}
