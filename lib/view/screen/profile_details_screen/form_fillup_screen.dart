import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:tripto_driver/model/driver_data_model/driver_data_model.dart';
import 'package:tripto_driver/utils/app_sizes/sizes.dart';
import 'package:tripto_driver/utils/constants/colors.dart';
import 'package:tripto_driver/utils/helpers/helper_functions.dart';
import 'package:tripto_driver/view_model/provider/auth_provider_in/auth_provider.dart';
import 'package:tripto_driver/view_model/provider/from_provider/licence_provider.dart';
import 'package:tripto_driver/view/screen/profile_details_screen/select_car.dart';

class FormFillupScreen extends StatefulWidget {
  const FormFillupScreen({super.key});

  @override
  _FormFillupScreenState createState() => _FormFillupScreenState();
}

class _FormFillupScreenState extends State<FormFillupScreen> {
  int _currentStep = 0;
  bool _isComplete = false;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    FromProvider fromProvider = Provider.of(context, listen: false);

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

       //  backgroundColor: Colors.white,
        // elevation: 1,

        title: const Text(
          "Complete Your Profile",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
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
                        "Complete all the steps to activate your account",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    Icon(Icons.verified_user, color: Colors.white, size: 40),
                  ],
                ),
              ),
              Expanded(
                child: Stepper(
                  currentStep: _currentStep,
                  onStepTapped: (int index) {
                    setState(() {
                      _currentStep = index;
                    });
                  },
                  onStepContinue: () {
                    if (_currentStep < 4) {
                      setState(() {
                        _currentStep++;
                      });
                    } else {
                      if (_isComplete) {
                        var data = DriverDataModel(
                          driverName: fromProvider.driverName.text,
                          driverPhoneNumber: int.parse(fromProvider.driverPhone.text),
                          driverEmail: fromProvider.driverEmail.text,
                          driverAddress: fromProvider.driverAddress.text,
                          driverDateOfBirth: fromProvider.driverDateOfBirth.text,
                          driverBankName: fromProvider.driverBankName.text,
                          driverAccountNumber: fromProvider.driverAccountNumber.text,
                          driverIfscCode: fromProvider.driverIFSCCode.text,
                          driverUpiCode: fromProvider.driverUPIID.text,
                          dlNumber: fromProvider.dlNumberContro.text,
                          carName: fromProvider.selectedCar,
                        );
                        authProvider.saveProfileData(data);
                      } else {
                        AppHelperFunctions.showSnackBar('Please fill in all required fields!');
                      }
                    }
                  },
                  onStepCancel: () {
                    if (_currentStep > 0) {
                      setState(() {
                        _currentStep--;
                      });
                    }
                  },
                  steps: [
                    Step(
                      title: const Text("Driving License", style: TextStyle(color: Colors.black)),
                      content: _uploadCard(context, fromProvider, "Driving License"),
                      isActive: _currentStep >= 0,
                      state: _isComplete ? StepState.complete : StepState.indexed,
                    ),
                    Step(
                      title: const Text("Profile Info", style: TextStyle(color: Colors.black)),
                      content: _uploadCard(context, fromProvider, "Profile Info"),
                      isActive: _currentStep >= 1,
                      state: _isComplete ? StepState.complete : StepState.indexed,
                    ),
                    Step(
                      title: const Text("Vehicle RC", style: TextStyle(color: Colors.black)),
                      content: _uploadCard(context, fromProvider, "Vehicle RC"),
                      isActive: _currentStep >= 2,
                      state: _isComplete ? StepState.complete : StepState.indexed,
                    ),
                    Step(
                      title: const Text("Aadhaar/PAN card", style: TextStyle(color: Colors.black)),
                      content: _uploadCard(context, fromProvider, "Aadhaar/PAN card"),
                      isActive: _currentStep >= 3,
                      state: _isComplete ? StepState.complete : StepState.indexed,
                    ),
                    Step(
                      title: const Text("Select Car", style: TextStyle(color: Colors.black)),
                      content: _selectCarCard(context),
                      isActive: _currentStep >= 4,
                      state: _isComplete ? StepState.complete : StepState.indexed,
                    ),
                  ],
                ),
              ),
              if (_currentStep == 4) ...[
                SizedBox(height: size.height * 0.1 ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue900,
                    shadowColor: Colors.black26,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    Fluttertoast.showToast(msg: 'click');
                    if (_isComplete) {
                      var data = DriverDataModel(
                        driverName: fromProvider.driverName.text,
                        driverPhoneNumber: int.parse(fromProvider.driverPhone.text),
                        driverEmail: fromProvider.driverEmail.text,
                        driverAddress: fromProvider.driverAddress.text,
                        driverDateOfBirth: fromProvider.driverDateOfBirth.text,
                        driverBankName: fromProvider.driverBankName.text,
                        driverAccountNumber: fromProvider.driverAccountNumber.text,
                        driverIfscCode: fromProvider.driverIFSCCode.text,
                        driverUpiCode: fromProvider.driverUPIID.text,
                        dlNumber: fromProvider.dlNumberContro.text,
                        carName: fromProvider.selectedCar,
                      );
                      authProvider.saveProfileData(data);
                    } else {
                      AppHelperFunctions.showSnackBar('Please fill in all required fields!');
                    }
                  },
                  child: authProvider.isLoding
                      ? const CircularProgressIndicator(backgroundColor: Colors.white)
                      : const Text(
                    "Submit",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: AppSizes.buttomTextSize,
                    ),
                  ),
                ),
              ],
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
        elevation: isSelected ? 8 : 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: isSelected ? const BorderSide(color: AppColors.blue900, width: 2) : BorderSide.none,
        ),
        color: isSelected ? Colors.white : Colors.grey.shade100,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(color: AppColors.blue900, fontWeight: FontWeight.bold),
              ),
              if (isSelected)
                const Text(
                  "Upload Now",
                  style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectCarCard(BuildContext context) {
    return Consumer<FromProvider>(
      builder: (context, carProvider, child) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SelectCar()),
            );
          },
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
              side: BorderSide(
                color: carProvider.selectedCar != null ? AppColors.blue900 : Colors.grey,
                width: 2,
              ),
            ),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    carProvider.selectedCar ?? "Select Your Car",
                    style: TextStyle(
                      color: carProvider.selectedCar != null ? AppColors.blue900 : Colors.black54,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Icon(Icons.directions_car, color: Colors.blue, size: 24),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
