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
import '../../../view/onBoarding/on_boarding_screen.dart';
import '../../../view/screen/profile_details_screen/form_fillup_screen.dart';
import '../../service/notifaction_service.dart';

class AuthProviderIn extends ChangeNotifier {

  TextEditingController inputNumber = TextEditingController();
  bool isLoding = false;
  AuthService authService = AuthService();
  FromProvider fromProvider = Provider.of(Get.context!, listen: false);
  NotificationService notificationService = NotificationService();



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
    var driverId = FirebaseAuth.instance.currentUser?.uid;
    if (driverId == null) {
      AppHelperFunctions.showSnackBar("User not logged in!");
      return;
    }

    String? token = await notificationService.getDeviceToken();

    try {
      isLoding = true;
      notifyListeners();

      // Image uploads with null safety checks
      String? frontDlUrl = fromProvider.frontDrivingLicenceImage != null
          ? await authService.uploadImageToFirebase(fromProvider.frontDrivingLicenceImage!, "driving_license/front_$driverId.jpg")
          : null;

      String? backDlUrl = fromProvider.backDrivingLicenceImage != null
          ? await authService.uploadImageToFirebase(fromProvider.backDrivingLicenceImage!, "driving_license/back_$driverId.jpg")
          : null;



      String? frontRcUrl = fromProvider.frontRcImage != null
          ? await authService.uploadImageToFirebase(fromProvider.frontRcImage!, "vehicle_rc/front_$driverId.jpg")
          : null;

      String? backRcUrl = fromProvider.backRcImage != null
          ? await authService.uploadImageToFirebase(fromProvider.backRcImage!, "vehicle_rc/back_$driverId.jpg")
          : null;

      String? frontAadharUrl = fromProvider.frontAadharCardImage != null
          ? await authService.uploadImageToFirebase(fromProvider.frontAadharCardImage!, "aadhar/front_$driverId.jpg")
          : null;

      String? backAadharUrl = fromProvider.backAadharCardImage != null
          ? await authService.uploadImageToFirebase(fromProvider.backAadharCardImage!, "aadhar/back_$driverId.jpg")
          : null;

      String? panUrl = fromProvider.penCardImage != null
          ? await authService.uploadImageToFirebase(fromProvider.penCardImage!, "pan_card_$driverId.jpg")
          : null;

      String? driverImgUrl = fromProvider.driverImage != null
          ? await authService.uploadImageToFirebase(fromProvider.driverImage!, "driver_image_$driverId.jpg")
          : null;

      // Assign data to DriverDataModel
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
        backAadharCardImage: backAadharUrl ?? "",  // Fixed the incorrect assignment
        penCardImage: panUrl ?? "",
        carName: driverData.carName,
        fcmToken: token,
      );

      var realTimeData = DriverDataModel(
        driverID: driverId,
        driverName: driverData.driverName,
        driverPhoneNumber: driverData.driverPhoneNumber,
        driverAddress: driverData.driverAddress,
        driverImage: driverImgUrl ?? "",
        fcmToken: token,
      );

      // Store data in Firestore
      await authService.saveDriverData(driverId, data);

      // Store minimal data in Realtime Database
      await authService.saveDriverDataInRealTime(realTimeData);

      // Navigate to home screen
      AppHelperFunctions.navigateToScreen(Get.context!, BottomNavigation());

      fromProvider.clearFeald();
      AppHelperFunctions.showSnackBar("Driver data successfully saved!");
    } catch (e) {
      AppHelperFunctions.showSnackBar("Error saving driver data: $e");
    } finally {
      isLoding = false;
      notifyListeners();
    }
  }

  Future<void> checkLoginStatus(BuildContext context)async{

    var currentUser =  FirebaseAuth.instance.currentUser;
    if(currentUser != null){
      AppHelperFunctions.navigateToScreen(context, const BottomNavigation());
    }else{
      AppHelperFunctions.navigateToScreen(context, const OnBoardingScreen());

    }
    }


}