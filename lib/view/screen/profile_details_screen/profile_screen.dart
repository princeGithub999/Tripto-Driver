import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tripto_driver/utils/constants/colors.dart';
import '../../../view_model/provider/form_fillup_provider/form_fillup_provider.dart';

class ProfileUpdate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<FormFillupProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.blue900,
        title: Text('Update Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: GestureDetector(
                onTap: () => profileProvider.pickProfileImage(ImageSource.gallery),
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: profileProvider.profileImage != null
                      ? FileImage(profileProvider.profileImage!)
                      : AssetImage('assets/profile_placeholder.png') as ImageProvider,
                  child: profileProvider.profileImage == null
                      ? Icon(Icons.camera_alt, size: 40, color: Colors.white)
                      : null,
                ),
              ),
            ),
            SizedBox(height: 20),
            buildTextField('Full Name', profileProvider.name, profileProvider.updateName),
            buildTextField('Mobile', profileProvider.mobile, profileProvider.updateMobile, keyboardType: TextInputType.phone),
            buildTextField('Email', profileProvider.email, profileProvider.updateEmail, keyboardType: TextInputType.emailAddress),
            buildTextField('Address', profileProvider.address, profileProvider.updateAddress),
            buildTextField('Date of Birth', profileProvider.dob, profileProvider.updateDob),
            buildTextField('Bank Name', profileProvider.bankName, profileProvider.updateBankName),
            buildTextField('Account Number', profileProvider.accountNumber, profileProvider.updateAccountNumber, keyboardType: TextInputType.number),
            buildTextField('IFSC Code', profileProvider.ifsc, profileProvider.updateIfsc),
            buildTextField('UPI ID', profileProvider.upi, profileProvider.updateUpi),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: profileProvider.isFormComplete
                  ? () async {
                await profileProvider.submitProfile();
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Profile updated successfully!")),
                );
              }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.blue900,
                minimumSize: Size(double.infinity, 50),
                shadowColor: Colors.black26,
                elevation: 6,
              ),
              child: Text(
                'Submit Profile',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildTextField(String label, String value, Function(String) onChanged, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        onChanged: onChanged,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }
}

