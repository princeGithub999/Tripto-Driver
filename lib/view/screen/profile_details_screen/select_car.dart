import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripto_driver/utils/constants/colors.dart';
import 'package:tripto_driver/utils/helpers/helper_functions.dart';
import 'package:tripto_driver/utils/validator/validation.dart';
import '../../../utils/app_sizes/sizes.dart';
import '../../../utils/globle_widget/text_from_page.dart';
import '../../../view_model/provider/from_provider/from_provider.dart';

class SelectCar extends StatelessWidget {
  const SelectCar({super.key});

  @override
  Widget build(BuildContext context) {
    final carProvider = Provider.of<FromProvider>(context);
    final GlobalKey<FormState> _vehiclesNumberKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(title: const Text('Select Your Car')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Text(
                    'Choose your car',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 5),
                  Text("*", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20)),
                ],
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: carProvider.selectedCar,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                ),
                items: carProvider.carList
                    .map((car) => DropdownMenuItem(
                  value: car,
                  child: Text(car, style: TextStyle(color: AppColors.blue900, fontSize: 14)),
                ))
                    .toList(),
                onChanged: (value) {
                  carProvider.selectCar(value!);
                },
              ),
              const SizedBox(height: 20),

              Form(
                key: _vehiclesNumberKey,
                child: TextFromPage.buildCustomTextField(
                  "Vehicle Number",
                  carProvider.vehiclesNumber,
                  CupertinoIcons.car,
                  context: context,
                  validator: Validation.vehiclesNumber,
                ),
              ),

              // Single Vehicle Image Upload Section
              _buildUploadSection('Vehicle Image', "*", carProvider),
              const SizedBox(height: 16),

              const SizedBox(height: 20),

              _buildSubmitButton(carProvider, context, _vehiclesNumberKey),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadSection(String title, String important, FromProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(width: 5),
            Text(important, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.red)),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => provider.pickSingleRcImage(),
          child: Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.blue900, width: 2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: provider.carImage == null
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
                provider.carImage!,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(FromProvider provider, BuildContext context, GlobalKey<FormState> key) {
    return ElevatedButton(
      onPressed: () async {
        if (provider.selectedCar == null || provider.selectedCar!.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text("Please select a car")),
          );
          return;
        }

        if (provider.carImage == null) {
          AppHelperFunctions.showSnackBar("Please upload an image");
          return;
        }

        if (!key.currentState!.validate()) {
          return;
        }

        // ✅ Jab form successfully submit ho jaye
        AppHelperFunctions.showSnackBar("Form submitted successfully!");

        // ✅ Pichli screen pe wapas jao
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pop(context);
        });
      },
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 50),
      ),
      child: const Text(
        'Submit',
        style: TextStyle(color: Colors.white, fontSize: AppSizes.buttomTextSize),
      ),
    );
  }
}
