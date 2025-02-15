import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripto_driver/view_model/provider/form_fillup_provider/form_fillup_provider.dart';

class DrivingLicenseDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FormFillupProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Driving License'),
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
            _buildUploadSection('Front side of your DL', true, provider),
            const SizedBox(height: 16),
            _buildUploadSection('Back side of your DL', false, provider),
            const SizedBox(height: 16),
            _buildLicenseInputSection(provider),
            const SizedBox(height: 16),
            _buildSubmitButton(provider),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadSection(String title, bool isFront, FormFillupProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => provider.pickImage(isFront),
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: provider.frontImage == null && isFront || provider.backImage == null && !isFront
                ? const Center(child: Icon(Icons.cloud_upload, color: Colors.grey, size: 40))
                : ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(isFront ? provider.frontImage! : provider.backImage!, fit: BoxFit.cover),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLicenseInputSection(FormFillupProvider provider) {
    return TextField(
      controller: provider.licenseController,
      onChanged: (_) => provider.notifyListeners(),
      decoration: InputDecoration(
        hintText: 'Eg: KA12345677899029',
        border: OutlineInputBorder(),
        errorText: provider.isLicenseNumberValid ? null : 'License number must be 15 characters (A-Z, 0-9 only)',
      ),
    );
  }

  Widget _buildSubmitButton(FormFillupProvider provider) {
    return ElevatedButton(
      onPressed: provider.isFormComplete ? () {} : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: provider.isFormComplete ? Colors.yellow : Colors.grey,
        minimumSize: const Size(360, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text('Submit'),
    );
  }
}
