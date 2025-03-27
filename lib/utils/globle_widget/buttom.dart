import 'package:flutter/material.dart';
import 'package:tripto_driver/utils/constants/app_image.dart';
import 'package:tripto_driver/utils/constants/colors.dart';

import '../app_sizes/sizes.dart';

class MyButton {

  static Widget sendOtpButton(VoidCallback onPress, String buttomName, bool isLoding) {
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue900,
          // padding: EdgeInsets.symmetric(horizontal:130),
        minimumSize: const Size(double.infinity,40),

      ),
      child: isLoding ? SizedBox(height: 25, width: 25, child: const CircularProgressIndicator(backgroundColor: Colors.white,color: Colors.blueGrey,)) :  Text(buttomName,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: AppSizes.buttomTextSize),),
    );
  }

  static Widget verifyOtpButton(VoidCallback onPress, String buttomName, bool isLoding) {
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.blue900,
        // padding: EdgeInsets.symmetric(horizontal:130),
        minimumSize: const Size(double.infinity,40),

      ),
      child: isLoding ? SizedBox(height: 25, width: 25, child: const CircularProgressIndicator(backgroundColor: Colors.white,color: Colors.blueGrey,)) :

      Text(buttomName,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: AppSizes.buttomTextSize),),
    );
  }


  static Widget googleButton(VoidCallback onPress, bool isLoading) {
    return ElevatedButton(
      onPressed: onPress,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.blue900,
        minimumSize: const Size(double.infinity,40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child:

      isLoading ? const SizedBox(height: 25, width: 25, child: CircularProgressIndicator(backgroundColor: Colors.white,color: Colors.blueGrey,)) :

      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            AppImage.googleIcon,
            height: 24,
            width: 24,
          ),
           const SizedBox(width: 10),

          const Text('Login with Google',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: AppSizes.buttomTextSize),)

        ],
      ),
    );
  }
}
