import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import '../../utils/constants/colors.dart';
import '../../utils/globle_widget/buttom.dart';
import '../../utils/globle_widget/form_divider.dart';
import '../../view_model/provider/auth_provider_in/auth_provider.dart';



class SendOtpPage extends StatefulWidget {
  const SendOtpPage({super.key});

  @override
  State<SendOtpPage> createState() => _SendOtpPageState();
}

class _SendOtpPageState extends State<SendOtpPage> {
  @override
  Widget build(BuildContext context) {
    var sizes = MediaQuery.of(context).size;
    var authProvider =  Provider.of<AuthProviderIn>(context, listen: false);

    return Scaffold(

      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left:30,right: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.center,
             children: [

               SizedBox( height: sizes.height * 0.1 - 30,),
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
                 controller: authProvider.inputNumber,
                 decoration: InputDecoration(
                   hintText: 'Phone Number',
                   labelStyle: const TextStyle(color: AppColors.blue900),
                   border: const UnderlineInputBorder(
                     borderSide: BorderSide(color: AppColors.blue900), // Default border color
                   ),
                   focusedBorder: const UnderlineInputBorder(
                     borderSide: BorderSide(color: AppColors.blue900, width: 2), // Border color when focused
                   ),
                   enabledBorder: const UnderlineInputBorder(
                     borderSide: BorderSide(color: AppColors.blue900), // Border color when enabled
                   ),
                   disabledBorder: UnderlineInputBorder(
                     borderSide: BorderSide(color: Colors.green.withOpacity(0.5)), // Border color when disabled
                   ),
                   errorBorder: UnderlineInputBorder(
                     borderSide: BorderSide(color: Colors.red.withOpacity(0.8)), // Error border color
                   ),
                   focusedErrorBorder: const UnderlineInputBorder(
                     borderSide: BorderSide(color: Colors.red, width: 2), // Error border when focused
                   ),
                 ),
                 initialCountryCode: 'IN',
                 onChanged: (phone) {
                   // print(phone.completeNumber);
                 },
               ),


               SizedBox(height: sizes.height * 0.3,),

               MyButton.globalButton(() {
                 authProvider.requestOTP(authProvider.inputNumber.text);
               },'Send OTP'),
               SizedBox(height: sizes.height * 0.1 - 70,),


               const FormDivider(dividerText: 'or',),

               SizedBox(height: sizes.height * 0.1 - 70,),

               MyButton.googleButton(() {
                authProvider.signInWithGoogle();
               },)
             ],
           ),
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