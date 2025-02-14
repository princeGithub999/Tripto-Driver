import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:tripto_driver/utils/constants/app_image.dart';

import '../../utils/constants/colors.dart';
import '../../utils/globle_widget/buttom.dart';
import '../../utils/globle_widget/form_divider.dart';

class SendOtpPage extends StatefulWidget {
  const SendOtpPage({super.key});

  @override
  State<SendOtpPage> createState() => _SendOtpPageState();
}

class _SendOtpPageState extends State<SendOtpPage> {
  @override
  Widget build(BuildContext context) {
    var sizes = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                // Background Waves
                // ClipPath(
                //   clipper: ExactWaveClipper2(),
                //   child: Container(
                //       height: sizes.height * 0.3 + 20, color: AppColors.blue100),
                // ),
                // ClipPath(
                //   clipper: ExactWaveClipper(),
                //   child: Container(
                //       height: sizes.height * 0.3, color: AppColors.blue900),
                // ),


              ],
            ),


           Padding(
             padding: const EdgeInsets.only(left:30,right: 30),
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  SizedBox( height: sizes.height * 0.2 - 40,),
                  Text(
                    'Enter Phone number for verification',
                    style: TextStyle(
                      fontSize: sizes.width * 0.06, // Responsive font
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'This number will be used for all ride-related communication. You shall receive an SMS with code for verification.',
                     style: TextStyle(
                      fontSize: sizes.width * 0.04, // Responsive font
                      color: Colors.black,
                    ),
                  ),




                   SizedBox(height: sizes.height * 0.1 - 50,),
                  IntlPhoneField(
                    flagsButtonPadding: const EdgeInsets.all(8),
                    dropdownIconPosition: IconPosition.trailing,
                    decoration: InputDecoration(
                      hintText: 'Phone Number',
                      labelStyle: TextStyle(color: AppColors.blue900),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.blue900), // Default border color
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.blue900, width: 2), // Border color when focused
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColors.blue900), // Border color when enabled
                      ),
                      disabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green.withOpacity(0.5)), // Border color when disabled
                      ),
                      errorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red.withOpacity(0.8)), // Error border color
                      ),
                      focusedErrorBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 2), // Error border when focused
                      ),
                    ),
                    initialCountryCode: 'IN',
                    onChanged: (phone) {
                      // print(phone.completeNumber);
                    },
                  ),


                  SizedBox(height: sizes.height * 0.3,),

                  MyButton.sendOtpButton(() {

                  },),
                  SizedBox(height: sizes.height * 0.1 - 70,),


                  FormDivider(dividerText: 'or',),

                  SizedBox(height: sizes.height * 0.1 - 70,),

                  MyButton.googleButton(() {

                  },)
                ],
              ),
           ),

          ],
        ),
      ),
    );
  }
}


class ExactWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height * 0.9); // Start from bottom left

    // First Bezier Curve (Small bump)
    path.quadraticBezierTo(size.width * 0.2, size.height, size.width * 0.4, size.height * 0.8);

    // Second Bezier Curve (Big wave)
    path.quadraticBezierTo(size.width * 0.7, size.height * 0.4, size.width, size.height * 0.8);

    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}

class ExactWaveClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.moveTo(0, size.height * 0.9 - 50); // Start from bottom left

    path.quadraticBezierTo(size.width * 0.2, size.height, size.width * 0.4, size.height * 0.8);

    // Second Bezier Curve (Big wave)
    path.quadraticBezierTo(size.width * 0.7, size.height * 0.4, size.width, size.height * 0.8);

    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}