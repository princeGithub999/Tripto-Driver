import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripto_driver/view_model/provider/from_provider/licence_provider.dart';
import 'dart:io';

class AdharPanPage extends StatelessWidget {
  const AdharPanPage({super.key});

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<FromProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aadhar & PAN Upload'),
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
            _buildUploadSection(context, 'Front side of Aadhar Card', true, true, provider.frontAadharCardImage),
            const SizedBox(height: 16),
            _buildUploadSection(context, 'Back side of Aadhar Card', false, true, provider.backAadharCardImage),
            const SizedBox(height: 16),
            _buildUploadSection(context, 'Upload PAN Card', false, false, provider.penCardImage),
            const SizedBox(height: 16),
            _buildSubmitButton(provider),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadSection(BuildContext context, String title, bool isFront, bool isAadhar, File? imageFile) {
    var provider = Provider.of<FromProvider>(context, listen: false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => provider.pickAadharCardImage(isFront, isAadhar),
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

  Widget _buildSubmitButton(FromProvider provider) {
    return ElevatedButton(
        onPressed: () {
          // if (provider.aadharFrontImageUrl != null &&
          //     provider.aadharBackImageUrl != null &&
          //     provider.panImageUrl != null) {
          //   print("All documents uploaded successfully!");
          // } else {
          //   print("Please upload all documents.");
          // }

          provider.checkAadharCardImage();
        },
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text('Submit', style: TextStyle(color: Colors.white, fontSize: 16)),
        );
    }
}