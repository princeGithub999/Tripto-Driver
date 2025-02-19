import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripto_driver/model/driver_data_model/driver_data_model.dart';
import 'package:tripto_driver/utils/app_sizes/sizes.dart';
import 'package:tripto_driver/utils/constants/colors.dart';
import 'package:tripto_driver/utils/helpers/helper_functions.dart';
import 'package:tripto_driver/view_model/provider/auth_provider_in/auth_provider.dart';
import 'package:tripto_driver/view_model/provider/from_provider/licence_provider.dart';



class FormFillupScreen extends StatelessWidget {
  const FormFillupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("Help",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Consumer<AuthProviderIn>(
        builder: (BuildContext context, authProvider, Widget? child) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                width: double.infinity,
                color: AppColors.blue900,
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        "Please complete all the steps to activate your account",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    Icon(Icons.verified_user, color: Colors.white, size: 40),
                  ],
                ),
              ),
              Expanded(
                child: Consumer<FromProvider>(
                  builder: (context, provider, child) {
                    return ListView(
                      padding: const EdgeInsets.all(16),
                      children: [
                        _uploadCard(context, provider, "Driving License"),
                        _uploadCard(context, provider, "Profile Info"),
                        _uploadCard(context, provider, "Vehicle RC"),
                        _uploadCard(context, provider, "Aadhaar/PAN card"),

                        SizedBox(height: size.height * 0.2 + 60),
                        Consumer<FromProvider>(
                          builder: (BuildContext context, value, Widget? child) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.blue900,
                                shadowColor: Colors.black26,
                                minimumSize: const Size(double.infinity, 50),
                              ),
                              onPressed: () {

                                if(value.isDocumentFormComplete){
                                  var data = DriverDataModel(
                                      driverName: value.driverBankName.text,
                                      driverPhoneNumber: int.parse(value.driverPhone.text),
                                      driverEmail: value.driverEmail.text,
                                      driverAddress: value.driverAddress.text,
                                      driverDateOfBirth: value.driverDateOfBirth.text,
                                      driverBankName: value.driverBankName.text,
                                      driverAccountNumber: value.driverAccountNumber.text,
                                      driverIfscCode: value.driverIFSCCode.text,
                                      driverUpiCode: value.driverUPIID.text,
                                      dlNumber: value.dlNumberContro.text);
                                  authProvider.saveProfileData(data);
                                }else{
                                  AppHelperFunctions.showSnackBar('Please fill in all required fields!');
                                }

                              },
                              child: authProvider.isLoding ? CircularProgressIndicator(backgroundColor: Colors.white,

                              ): const Text("Submit",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: AppSizes.buttomTextSize),),
                            );
                          },
                        ),

                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _uploadCard(BuildContext context, FromProvider provider, String title) {
    bool isSelected = title == provider.selectedDocument;

    return GestureDetector(
      onTap: () => provider.selectDocument(title, context),
      child: Card(
        elevation: isSelected ? 4 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: isSelected ? const BorderSide(color: AppColors.blue900, width: 2) : BorderSide.none,
        ),
        color: isSelected ? Colors.white : Colors.grey.shade200,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: isSelected ? AppColors.blue900 : AppColors.blue900),
              ),
              if (isSelected)
                const Text(
                  "Upload Now",
                  style: TextStyle(color: Colors.orange),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
