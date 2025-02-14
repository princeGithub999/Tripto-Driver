import 'package:flutter/material.dart';
import 'package:tripto_driver/utils/constants/app_image.dart';
import 'package:tripto_driver/utils/constants/colors.dart';

class MyButton {

  static Widget sendOtpButton(VoidCallback onPress) {
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue900,
          padding: EdgeInsets.symmetric(horizontal:130)
      ),
      child: const Text('Send OTP',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),),
    );
  }


  static Widget googleButton(VoidCallback onPress) {
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.blue900,
        padding: const EdgeInsets.symmetric(horizontal: 90,),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            AppImage.googleIcon,
            height: 24,
            width: 24,
          ),
           const SizedBox(width: 10), // Icon aur text ke beech gap
          const Text(
            'Login with Google',
            style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15),
          ),
        ],
      ),
    );
  }
}
