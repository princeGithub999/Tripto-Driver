import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripto_driver/utils/constants/colors.dart';
import 'package:tripto_driver/view_model/provider/form_fillup_provider/form_fillup_provider.dart';

class VehicleRc extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FormFillupProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle RC'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.help_outline), onPressed: () {})
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isPortrait = constraints.maxWidth < 600;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: isPortrait
                ? _buildPortraitLayout(provider)
                : _buildLandscapeLayout(provider),
          );
        },
      ),
    );
  }

  Widget _buildPortraitLayout(FormFillupProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildUploadSection('Front side of your RC', true, provider),
        const SizedBox(height: 16),
        _buildUploadSection('Back side of your RC', false, provider),
        const SizedBox(height: 16),
        _buildSubmitButton(provider),
      ],
    );
  }

  Widget _buildLandscapeLayout(FormFillupProvider provider) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            children: [
              _buildUploadSection('Front side of your RC', true, provider),
              const SizedBox(height: 16),
              _buildUploadSection('Back side of your RC', false, provider),
            ],
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSubmitButton(provider),
        ),
      ],
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

  Widget _buildSubmitButton(FormFillupProvider provider) {
    return ElevatedButton(
      onPressed: provider.isFormComplete ? () {} : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: provider.isFormComplete ? AppColors.blue900 : Colors.grey,
        minimumSize: const Size(360, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      child: const Text('Submit'),
    );
  }
}