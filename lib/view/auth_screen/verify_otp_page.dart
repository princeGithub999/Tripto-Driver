import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:tripto_driver/view/auth_screen/send_otp_page.dart';
import 'package:tripto_driver/view_model/provider/auth_provider_in/auth_provider.dart';
import 'package:tripto_driver/view_model/provider/permission_handler/permission_provider.dart';

import '../../utils/globle_widget/buttom.dart';

class VerifyOtpPage extends StatefulWidget {
  const VerifyOtpPage({super.key});

  @override
  _VerifyOtpPageState createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProviderIn>(
      builder: (BuildContext context, authProvider, Widget? child) {
        return  Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SendOtpPage()));
              },
            ),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Phone verification", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text("Enter your OTP code", style: TextStyle(fontSize: 16, color: Colors.black)),
                SizedBox(height: 20),
                Center(
                  child: Pinput(
                    controller: _otpController,
                    length: 6,
                    keyboardType: TextInputType.number,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    defaultPinTheme: PinTheme(
                      width: 50,
                      height: 50,
                      textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: Text("Didn’t receive code? Resend again", style: TextStyle(color: Colors.black, fontSize: 14)),
                  ),
                ),
                SizedBox(height: 20),


                Consumer<PermissionProvider>(
                  builder: (BuildContext context, permissionProvider, Widget? child) {
                    return MyButton.verifyOtpButton(() {
                      authProvider.supaVeryfiOTP(authProvider.inputNumber.text,_otpController.text);
                      // permissionProvider.checkLocationPermission();
                    },'Verify OTP',authProvider.isLoding);
                  },
                ),
                // ElevatedButton(
                //   onPressed: _checkLocationPermission,
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.black,
                //     minimumSize: Size(double.infinity, 50),
                //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                //   ),
                //   child: Text("Verify", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                // ),
              ],
            ),
          ),
        );
      },
    );
    }
}