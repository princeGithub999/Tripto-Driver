import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../view_model/provider/form_fillup_provider/form_fillup_provider.dart';
import 'dart:io';

class AdharPanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<FormFillupProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aadhar & PAN Upload'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUploadSection(context, 'Front side of Aadhar Card', true, true, provider.aadharFrontImage),
            const SizedBox(height: 16),
            _buildUploadSection(context, 'Back side of Aadhar Card', false, true, provider.aadharBackImage),
            const SizedBox(height: 16),
            _buildUploadSection(context, 'Upload PAN Card', false, false, provider.panImage),
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
          onTap: () => provider.pickAndUploadImage(isFront, isAadhar),
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 1),
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

  Widget _buildSubmitButton(FormFillupProvider provider) {
    return ElevatedButton(
      onPressed: () {
        if (provider.aadharFrontImageUrl != null &&
            provider.aadharBackImageUrl != null &&
            provider.panImageUrl != null) {
          print("All documents uploaded successfully!");
        } else {
          print("Please upload all documents.");
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text('Submit', style: TextStyle(color: Colors.white, fontSize: 16)),
    );
  }
}
