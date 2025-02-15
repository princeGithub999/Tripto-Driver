import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tripto_driver/utils/helpers/helper_functions.dart';
import 'package:tripto_driver/view/auth_screen/verify_otp_page.dart';
import 'package:tripto_driver/view/home_page.dart';
import 'package:tripto_driver/view_model/service/auth_service.dart';

class AuthProviderIn extends ChangeNotifier {

  TextEditingController inputNumber = TextEditingController();
  bool isLoding = false;
  AuthService authService = AuthService();



  Future<void> requestOTP(String phoneNumber)async{

    try{

      isLoding = true;
      notifyListeners();
      if(phoneNumber.isNotEmpty){
        authService.requestOTP(phoneNumber).then((value) {
          if(value == true){
            AppHelperFunctions.navigateToScreen(Get.context!, const VerifyOtpPage());
          }
        },);
      }else{
        Fluttertoast.showToast(msg: 'please enter phone number');
      }
    }catch(error){
      Fluttertoast.showToast(msg: '$error');

    }finally{

      isLoding = false;
      notifyListeners();
    }
  }


  Future<void> signInWithGoogle()async{

    try {
      isLoding = true;
      notifyListeners();
      print('Loading started...');

      var success = await authService.signInWithGoogle();

      if (success == true) {
        print('Login Success! Navigating to HomePage...');
        Get.to(() => const HomePage());
      } else {
        print('Login Failed!');
      }
    } catch (error) {
      Fluttertoast.showToast(msg: '$error');
    } finally {
      isLoding = false;
      notifyListeners();
      print('Loading finished...');
    }

  }

}