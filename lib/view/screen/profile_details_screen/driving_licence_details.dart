import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripto_driver/utils/app_sizes/sizes.dart';
import 'package:tripto_driver/utils/constants/colors.dart';
import 'package:tripto_driver/utils/validator/validation.dart';
import 'package:tripto_driver/view_model/provider/from_provider/licence_provider.dart';
import '../../../utils/globle_widget/text_from_page.dart';
import 'package:tripto_driver/view/screen/profile_details_screen/form_fillup_screen.dart';
import '../../../view_model/provider/form_fillup_provider/form_fillup_provider.dart';

class DrivingLicenseDetails extends StatelessWidget {
  const DrivingLicenseDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FromProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blue900,
        title: const Text('Driving License'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: provider.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildUploadSection('Front side of your DL', true, provider),
              const SizedBox(height: 16),
              _buildUploadSection('Back side of your DL', false, provider),
              const SizedBox(height: 16),
        
              TextFromPage.buildTextField(
                  controller: provider.dlNumberContro,
                  hintText: 'License number',
                  validator: (value) {
                   return Validation.validateLicence(value);
                  },
                  context: context,
                icons: const Icon(Icons.library_books)
                 ),
        
              const SizedBox(height: 16),
              _buildSubmitButton(provider),
            ],
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
            _buildSubmitButton(provider,context),
          ],
        ),
      ),
    );
  }


  Widget _buildUploadSection(String title, bool isFront, FromProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => provider.pickDrivingLicenceImage(isFront),
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.blue900, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: provider.frontDrivingLicenceImage == null && isFront || provider.backDrivingLicenceImage == null && !isFront
                ? const Center(child: Icon(Icons.cloud_upload, color: Colors.grey, size: 40))
                : ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                isFront ? provider.frontDrivingLicenceImage! : provider.backDrivingLicenceImage!,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }




  Widget _buildSubmitButton(FromProvider provider) {
    return ElevatedButton(
      onPressed: () async {

         await provider.checkLicenceFeald();

        if (provider.formKey.currentState!.validate()) {
          provider.setErrorMessage('');

        } else {
          provider.setErrorMessage('Please fix the errors above');

        }
      },
  Widget _buildLicenseInputSection(FormFillupProvider provider) {
    return TextField(
      controller: provider.licenseController,
      onChanged: (_) => provider.notifyListeners(),
      decoration: InputDecoration(
        hintText: 'Eg: KA12345677899029',
        hintStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(),
        errorText: provider.isLicenseNumberValid ? null : 'License number must be 15 characters (A-Z, 0-9 only)',
      ),
    );
  }
// submit //
  Widget _buildSubmitButton(FormFillupProvider provider,BuildContext context) {
    return ElevatedButton(
      onPressed: provider.isDocumentFormComplete
          ? () {
        print('License Front Image URL: ${provider.frontImageUrl}');
        print('License Back Image URL: ${provider.backImageUrl}');
        Navigator.push(context, MaterialPageRoute(builder: (context) => FormFillupScreen(),));
      }
          : null,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.blue900,
        minimumSize: const Size(double.infinity, 50),
      ),
      child:  const Text('Submit', style: TextStyle(color: Colors.white, fontSize:  AppSizes.buttomTextSize),
      ),
    );
  }
}
