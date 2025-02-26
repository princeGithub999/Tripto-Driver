import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripto_driver/utils/validator/validation.dart';
import 'package:tripto_driver/view_model/provider/from_provider/licence_provider.dart';
import '../../../utils/globle_widget/text_from_page.dart';

class ProfileUpdate extends StatelessWidget {
  const ProfileUpdate({super.key});

  @override
  Widget build(BuildContext context) {

    final formProvider = Provider.of<FromProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formProvider.formKey2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: () {
                    formProvider.pickDriverImage();
                  },
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: formProvider.driverImage != null
                        ? FileImage(formProvider.driverImage!)
                        : const AssetImage('assets/profile_placeholder.png')
                            as ImageProvider,
                    child: formProvider.driverImage == null
                        ? const Icon(Icons.camera_alt,
                            size: 40, color: Colors.white)
                        : null,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextFromPage.buildTextField(
                  controller: formProvider.driverName,
                  hintText: 'Full Name',
                  validator: (value) {
                    return Validation.validateName(value);
                  },
                  inputType: TextInputType.text,
                  context: context),
              const SizedBox(height: 10),
              TextFromPage.buildTextField(
                  controller: formProvider.driverPhone,
                  hintText: 'Phone number',
                  validator: (value) {
                    return Validation.validatePhoneNumber(value);
                  },
                  inputType: TextInputType.phone,
                  context: context),
              const SizedBox(height: 10),
              TextFromPage.buildTextField(
                  controller: formProvider.driverEmail,
                  hintText: 'Driver Email',
                  validator: (value) {
                    return Validation.validateEmail(value);
                  },
                  inputType: TextInputType.emailAddress,
                  context: context),
              const SizedBox(height: 10),
              TextFromPage.buildTextField(
                controller: formProvider.driverAddress,
                hintText: 'Driver Address',
                validator: (value) {
                  return Validation.validateAddress(value);
                },
                context: context,
                inputType: TextInputType.streetAddress,
              ),
              const SizedBox(height: 10),
              TextFromPage.buildTextField(
                controller: formProvider.driverDateOfBirth,
                hintText: 'Date of Birth',
                validator: (value) {
                  return Validation.validateDateOfBirth(value);
                },
                context: context,
              ),
              const SizedBox(height: 10),
              TextFromPage.buildTextField(
                  controller: formProvider.driverBankName,
                  hintText: 'Bank Name',
                  validator: (value) {
                    return Validation.validateBankName(value);
                  },
                  context: context),
              const SizedBox(height: 10),
              TextFromPage.buildTextField(
                  controller: formProvider.driverAccountNumber,
                  hintText: 'Account Number',
                  validator: (value) {
                    return Validation.validateAccountNumber(value);
                  },
                  context: context),
              const SizedBox(height: 10),
              TextFromPage.buildTextField(
                  controller: formProvider.driverIFSCCode,
                  hintText: 'IFSC Code',
                  validator: (value) {
                    return Validation.validateIFSC(value);
                  },
                  context: context),
              const SizedBox(height: 10),
              TextFromPage.buildTextField(
                  controller: formProvider.driverUPIID,
                  hintText: 'UPI ID',
                  validator: (value) {
                    return Validation.validateUPI(value);
                  },
                  context: context),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (formProvider.formKey2.currentState!.validate()) {
                    formProvider.setErrorMessage('');
                    Navigator.pop(context);
                  } else {
                    formProvider.setErrorMessage('Please fix the errors above');
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shadowColor: Colors.black26,
                  elevation: 6,
                ),
                child:const Text(
                  'Submit Profile',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
