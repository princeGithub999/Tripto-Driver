import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripto_driver/view_model/provider/form_fillup_provider/form_fillup_provider.dart';

class VehicleRc extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FormFillupProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text('Vehicle RC'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.help_outline, color: Colors.white), onPressed: () {})
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUploadSection('Front side of your RC', true, provider),
            const SizedBox(height: 16),
            _buildUploadSection('Back side of your RC', false, provider),
            const SizedBox(height: 16),
            _buildSubmitButton(provider, context),
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
          onTap: () => provider.pickRcImage(isFront),
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: (isFront ? provider.frontImage : provider.backImage) == null
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
              child: Image.file(
                isFront ? provider.frontImage! : provider.backImage!,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(FormFillupProvider provider, BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        shadowColor: Colors.black26,
        minimumSize: const Size(double.infinity, 50),
      ),
      onPressed: () async {
        if (provider.frontImageUrl != null && provider.backImageUrl != null) {
          await provider.saveDriverRcDetails('driver123');
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('RC details uploaded successfully!')));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Please upload both images!')));
        }
      },
      child: const Text(
        "Submit",
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
      ),
    );
  }
}
