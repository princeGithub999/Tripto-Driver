import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripto_driver/utils/app_sizes/sizes.dart';
import 'package:tripto_driver/utils/constants/colors.dart';
import '../../../view_model/provider/form_fillup_provider/form_fillup_provider.dart';

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
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Help",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            color: AppColors.blue900,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "Please complete all the steps to activate your account",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const Icon(Icons.verified_user, color: Colors.white, size: 40),
              ],
            ),
          ),
          Expanded(
            child: Consumer<FormFillupProvider>(
              builder: (context, provider, child) {
                return ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    _uploadCard(context, provider, "Driving License"),
                    _uploadCard(context, provider, "Profile Info"),
                    _uploadCard(context, provider, "Vehicle RC"),
                    _uploadCard(context, provider, "Aadhaar/PAN card"),

                    SizedBox(height: size.height * 0.2 + 60),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue900,
                        shadowColor: Colors.black26,
                        minimumSize: Size(double.infinity, 50),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, "/register");
                      },
                      child: Text("Submit",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: AppSizes.buttomTextSize),),
                    ),

                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _uploadCard(BuildContext context, FormFillupProvider provider, String title) {
    bool isSelected = title == provider.selectedDocument;

    return GestureDetector(
      onTap: () => provider.selectDocument(title, context),
      child: Card(
        elevation: isSelected ? 4 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: isSelected ? BorderSide(color: AppColors.blue900, width: 2) : BorderSide.none,
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
