import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tripto_driver/utils/constants/colors.dart';
import 'package:tripto_driver/utils/validator/validation.dart';
import 'package:tripto_driver/view_model/provider/from_provider/from_provider.dart';


class ProfileUpdate extends StatefulWidget {
  const ProfileUpdate({super.key});

  @override
  _ProfileUpdateState createState() => _ProfileUpdateState();
}

class _ProfileUpdateState extends State<ProfileUpdate> {
  int _currentStep = 0;
  final GlobalKey<FormState> _personalInfoKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _bankDetailsKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final formProvider = Provider.of<FromProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Update Profile'),
        backgroundColor: AppColors.blue900,
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Container(
          //   padding: const EdgeInsets.all(12),
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //       colors: [AppColors.blue900, Colors.blue.shade600],
          //     ),
          //   ),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //     children: List.generate(3, (index) {
          //       return AnimatedContainer(
          //         duration: const Duration(milliseconds: 300),
          //         width: _currentStep >= index ? 35 : 20,
          //         height: 10,
          //         decoration: BoxDecoration(
          //           color: _currentStep >= index ? Colors.yellow.shade600 : Colors.white30,
          //           borderRadius: BorderRadius.circular(5),
          //         ),
          //       );
          //     }),
          //   ),
          // ),
          Expanded(
            child: Theme(
              data: ThemeData(
                colorScheme: ColorScheme.light(primary: AppColors.blue900),
              ),
              child: Stepper(
                type: StepperType.horizontal,
                currentStep: _currentStep,
                onStepContinue: () {
                  if (_currentStep == 0) {
                    if (_personalInfoKey.currentState!.validate()) {
                      setState(() {
                        _currentStep += 1;
                      });
                    } else {
                      formProvider.setErrorMessage('Please fill out all required fields.');
                    }
                  } else if (_currentStep == 1) {
                    if (_bankDetailsKey.currentState!.validate()) {
                      setState(() {
                        _currentStep += 1;
                      });
                    } else {
                      formProvider.setErrorMessage('Please fill out all required fields for Bank Details.');
                    }
                  } else if (_currentStep == 2) {
                    formProvider.setErrorMessage('');
                    Navigator.pop(context);
                  }
                },
                onStepCancel: () {
                  if (_currentStep > 0) {
                    setState(() {
                      _currentStep -= 1;
                    });
                  }
                },
                controlsBuilder: (context, details) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (_currentStep != 0)
                          ElevatedButton(
                            onPressed: details.onStepCancel,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade300,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: Text(
                              'Back',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ElevatedButton(
                          onPressed: details.onStepContinue,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blue900,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            _currentStep == 2 ? 'Submit' : 'Next',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                steps: [
                  Step(
                    title: const Text("Personal"),
                    content: _buildStepCard(
                      child: Form(
                        key: _personalInfoKey,
                        child: Column(
                          children: [
                            Center(
                              child: GestureDetector(
                                onTap: () {
                                  formProvider.pickDriverImage();
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 54,
                                      backgroundColor: Colors.yellow.shade700,
                                    ),
                                    Container(
                                      padding: const EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        gradient: const LinearGradient(
                                          colors: [Colors.blue, Colors.yellow],
                                        ),
                                      ),
                                      child: CircleAvatar(
                                        radius: 50,
                                        backgroundImage: formProvider.driverImage != null
                                            ? FileImage(formProvider.driverImage!)
                                            : const AssetImage('assets/profile_placeholder.png') as ImageProvider,
                                        child: formProvider.driverImage == null
                                            ? const Icon(Icons.camera_alt, size: 40, color: Colors.white)
                                            : null,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildCustomTextField(
                                'Full Name', formProvider.driverName, Icons.person,
                                validator: Validation.validateName,type: TextInputType.name),
                            _buildCustomTextField(
                                'Phone Number', formProvider.driverPhone, Icons.phone,
                                validator: Validation.validatePhoneNumber,type: TextInputType.number),
                            _buildCustomTextField(
                                'Email', formProvider.driverEmail, Icons.email,
                                validator: Validation.validateEmail,type: TextInputType.emailAddress),
                            _buildCustomTextField(
                                'Address', formProvider.driverAddress, Icons.location_on,
                                validator: Validation.validateAddress,type: TextInputType.text),
                            _buildCustomTextField(
                                'Date of Birth', formProvider.driverDateOfBirth, Icons.calendar_today,
                                validator: Validation.validateDateOfBirth,type: TextInputType.datetime,isDateField: true),
                          ],
                        ),
                      ),
                    ),
                    isActive: _currentStep >= 0,
                  ),
                  Step(
                    title: const Text("Bank Details"),
                    content: _buildStepCard(
                      child: Form(
                        key: _bankDetailsKey,
                        child: Column(
                          children: [
                            _buildCustomTextField('Bank Name', formProvider.driverBankName, Icons.account_balance,
                                validator: Validation.validateBankName),
                            _buildCustomTextField('Account Number', formProvider.driverAccountNumber, Icons.credit_card,
                                validator: Validation.validateAccountNumber),
                            _buildCustomTextField('IFSC Code', formProvider.driverIFSCCode, Icons.code,
                                validator: Validation.validateIFSC),
                            _buildCustomTextField('UPI ID', formProvider.driverUPIID, Icons.qr_code,
                                validator: Validation.validateUPI),
                          ],
                        ),
                      ),
                    ),
                    isActive: _currentStep >= 1,
                  ),
                  Step(
                    title: const Text("Submit"),
                    content: _buildStepCard(
                      child: Column(
                        children: [
                          const Text(
                            "Review your details before submitting.",
                            style: TextStyle(fontSize: 16),
                          ),
                          // const SizedBox(height: 20),
                          // ElevatedButton(
                          //   onPressed: () {
                          //     Navigator.pop(context);
                          //   },
                          //   style: ElevatedButton.styleFrom(
                          //     minimumSize: const Size(double.infinity, 50),
                          //     backgroundColor: AppColors.blue900,
                          //     shape: RoundedRectangleBorder(
                          //       borderRadius: BorderRadius.circular(10),
                          //     ),
                          //   ),
                          //   child: const Text(
                          //     'Submit Profile',
                          //     style: TextStyle(fontSize: 18, color: Colors.white),
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                    isActive: _currentStep >= 2,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.grey.shade300, blurRadius: 10, spreadRadius: 2),
        ],
      ),
      child: child,
    );
  }

  Widget _buildCustomTextField(
      String hint, TextEditingController controller, IconData icon,
      {String? Function(String?)? validator, TextInputType type = TextInputType.text, bool isDateField = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: type,
        readOnly: isDateField, // Date field editable nahi hoga
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColors.blue900),
          suffixIcon: isDateField
              ? IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.blue),
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                initialDate: DateTime.now(),
              );
              if (pickedDate != null) {
                String formattedDate = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                controller.text = formattedDate;
              }
            },
          )
              : null,
          hintText: hint,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

}



