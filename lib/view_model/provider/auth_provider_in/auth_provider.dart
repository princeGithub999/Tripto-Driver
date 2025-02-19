import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:tripto_driver/model/driver_data_model/driver_data_model.dart';
import 'package:tripto_driver/utils/helpers/helper_functions.dart';
import 'package:tripto_driver/view/auth_screen/verify_otp_page.dart';
import 'package:tripto_driver/view_model/provider/from_provider/licence_provider.dart';
import 'package:tripto_driver/view_model/service/auth_service.dart';
import '../../../view/button_navigation/button_navigation.dart';
import '../../../view/screen/profile_details_screen/form_fillup_screen.dart';

class AuthProviderIn extends ChangeNotifier {

  TextEditingController inputNumber = TextEditingController();
  bool isLoding = false;
  AuthService authService = AuthService();
  FromProvider fromProvider = Provider.of(Get.context!, listen: false);




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

      var success = await authService.signInWithGoogle();

      if (success == true) {
        print('Login Success! Navigating to HomePage...');
        Get.to(() =>  FormFillupScreen());
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


  Future<void> saveProfileData(DriverDataModel driverData) async {
    var driverId = FirebaseAuth.instance.currentUser!.uid;



    try {
      isLoding = true;
      notifyListeners();
      // Images ko upload karne se pehle null check karna zaroori hai
      String? frontDlUrl = fromProvider.frontDrivingLicenceImage != null
          ? await authService.uploadImageToFirebase(fromProvider.frontDrivingLicenceImage!, "driving_license/front.jpg")
          : null;

      String? backDlUrl = fromProvider.backDrivingLicenceImage != null
          ? await authService.uploadImageToFirebase(fromProvider.backDrivingLicenceImage!, "driving_license/back.jpg")
          : null;

      String? frontRcUrl = fromProvider.frontRcImage != null
          ? await authService.uploadImageToFirebase(fromProvider.frontRcImage!, "vehicle_rc/front.jpg")
          : null;

      String? backRcUrl = fromProvider.backRcImage != null
          ? await authService.uploadImageToFirebase(fromProvider.backRcImage!, "vehicle_rc/back.jpg")
          : null;

      String? frontAadharUrl = fromProvider.frontAadharCardImage != null
          ? await authService.uploadImageToFirebase(fromProvider.frontAadharCardImage!, "aadhar/front.jpg")
          : null;

      String? backAadharUrl = fromProvider.backAadharCardImage != null
          ? await authService.uploadImageToFirebase(fromProvider.backAadharCardImage!, "aadhar/back.jpg")
          : null;

      String? panUrl = fromProvider.penCardImage != null
          ? await authService.uploadImageToFirebase(fromProvider.penCardImage!, "pan_card.jpg")
          : null;

      String? driverImgUrl = fromProvider.driverImage != null
          ? await authService.uploadImageToFirebase(fromProvider.driverImage!, "driver_image.jpg")
          : null;

      // Driver data model me assign karna
      var data = DriverDataModel(
        driverID: driverId,
        driverName: driverData.driverName,
        driverPhoneNumber: driverData.driverPhoneNumber,
        driverEmail: driverData.driverEmail,
        driverAddress: driverData.driverAddress,
        driverDateOfBirth: driverData.driverDateOfBirth,
        driverBankName: driverData.driverBankName,
        driverAccountNumber: driverData.driverAccountNumber,
        driverIfscCode: driverData.driverIfscCode,
        driverUpiCode: driverData.driverUpiCode,
        driverImage: driverImgUrl ?? "",
        frontDlImage: frontDlUrl ?? "",
        backDlImage: backDlUrl ?? "",
        dlNumber: driverData.dlNumber,
        frontVehicleRcImage: frontRcUrl ?? "",
        backVehicleRcImage: backRcUrl ?? "",
        frontAadharCardImage: frontAadharUrl ?? "",
        backAadharCardImage: backAadharUrl ?? "",
        penCardImage: panUrl ?? "",
      );

      await authService.saveDriverData(driverId, data);
      AppHelperFunctions.navigateToScreen(Get.context!, BottomNavigation());
      fromProvider.clearFeald();
      AppHelperFunctions.showSnackBar("Driver data successfully saved in Firebase!");
    } catch (e) {
      AppHelperFunctions.showSnackBar("Error saving driver data: $e");
    }finally {
      isLoding = false;
      notifyListeners();
    }
  }


  // Future<void> uploadAllImages() async {
  //   if (fromProvider.frontDrivingLicenceImage != null) {
  //     String? frontDlUrl = await authService.uploadImageToFirebase(fromProvider.frontDrivingLicenceImage!, "driving_license/front.jpg");
  //    }
  //   if (fromProvider.backDrivingLicenceImage != null) {
  //     String? backDlUrl = await authService.uploadImageToFirebase(fromProvider.backDrivingLicenceImage!, "driving_license/back.jpg");
  //   }
  //   if (fromProvider.frontRcImage != null) {
  //     String? frontRcUrl = await authService.uploadImageToFirebase(fromProvider.frontRcImage!, "vehicle_rc/front.jpg");
  //     print("Front RC URL: $frontRcUrl");
  //   }
  //   if (fromProvider.backRcImage != null) {
  //     String? backRcUrl = await authService.uploadImageToFirebase(fromProvider.backRcImage!, "vehicle_rc/back.jpg");
  //     print("Back RC URL: $backRcUrl");
  //   }
  //   if (fromProvider.frontAadharCardImage != null) {
  //     String? frontAadharUrl = await authService.uploadImageToFirebase(fromProvider.frontAadharCardImage!, "aadhar/front.jpg");
  //     print("Front Aadhar URL: $frontAadharUrl");
  //   }
  //   if (fromProvider.backAadharCardImage != null) {
  //     String? backAadharUrl = await authService.uploadImageToFirebase(fromProvider.backAadharCardImage!, "aadhar/back.jpg");
  //     print("Back Aadhar URL: $backAadharUrl");
  //   }
  //   if (fromProvider.penCardImage != null) {
  //     String? panUrl = await authService.uploadImageToFirebase(fromProvider.penCardImage!, "pan_card.jpg");
  //     print("PAN Card URL: $panUrl");
  //   }
  //   if (fromProvider.driverImage != null) {
  //     String? driverImgUrl = await authService.uploadImageToFirebase(fromProvider.driverImage!, "driver_image.jpg");
  //     print("Driver Image URL: $driverImgUrl");
  //   }
  // }


}