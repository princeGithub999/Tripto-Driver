import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tripto_driver/model/driver_data_model/driver_data_model.dart';
import 'package:tripto_driver/utils/helpers/helper_functions.dart';
import 'package:tripto_driver/view/auth_screen/verify_otp_page.dart';
import 'package:tripto_driver/view_model/provider/from_provider/licence_provider.dart';
import 'package:tripto_driver/view_model/provider/map_provider/maps_provider.dart';
import 'package:tripto_driver/view_model/service/auth_service.dart';
import '../../../model/driver_data_model/driver_profile_model.dart';
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
  final FirebaseDatabase realTimeDb = FirebaseDatabase.instance;
  bool isOnline = false;
  var mapProvider = Provider.of<MapsProvider>(Get.context!, listen: false);
  DriverProfileModel? driverProfile;


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
        // Get.to(() =>  FormFillupScreen());
        AppHelperFunctions.navigateToScreenBeforeEndPage(Get.context!, FormFillupScreen());
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

  // Future<DriverProfileModel?> getData()async{
  //
  //   var currentUser =  FirebaseAuth.instance.currentUser;
  //
  //   // if(currentUser!.uid.isNotEmpty){
  //   //   Fluttertoast.showToast(msg: 'Error: Driver ID is empty');
  //   //   return null;
  //   // }
  //
  //   try{
  //     DatabaseReference driverRef = realTimeDb.ref('Drivers_Data').child(currentUser!.uid);
  //     DatabaseEvent event = await driverRef.once();
  //
  //     if(event.snapshot.value != null){
  //       Map<String, dynamic> data = Map<String, dynamic>.from(event.snapshot.value as Map);
  //       return DriverProfileModel.fromJson(data);
  //     }else{
  //       Fluttertoast.showToast(msg: 'No data found');
  //       return null;
  //     }
  //
  //   }catch(e){
  //     Fluttertoast.showToast(msg: 'Error: $e');
  //     return null;
  //   }
  //
  //   }


  // Future<DriverProfileModel?> getData() async {
  //   var currentUser = FirebaseAuth.instance.currentUser;
  //   if (currentUser == null) {
  //     Fluttertoast.showToast(msg: 'User not logged in');
  //     return null;
  //   }
  //
  //   try {
  //     DatabaseReference driverRef = realTimeDb.ref('Drivers_Data').child(currentUser.uid);
  //     DatabaseEvent event = await driverRef.once();
  //
  //     if (event.snapshot.value != null) {
  //       Map<String, dynamic> data = Map<String, dynamic>.from(event.snapshot.value as Map);
  //       print("Fetched Driver Data: $data");  // Debugging
  //
  //       return DriverProfileModel.fromJson(data);
  //     } else {
  //       Fluttertoast.showToast(msg: 'No data found');
  //       return null;
  //     }
  //   } catch (e) {
  //     Fluttertoast.showToast(msg: 'Error: $e');
  //     return null;
  //   }
  // }

  void fetchLiveProfileData(String driverId) {

    DatabaseReference ref = realTimeDb.ref('Drivers_Data').child(driverId);

    ref.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.exists && event.snapshot.value != null) {
        Map<String, dynamic> data = Map<String, dynamic>.from(event.snapshot.value as Map);
        print("🔥 Live Updated Driver Data: $data");

        driverProfile = DriverProfileModel.fromJson(data);
        notifyListeners();  // **🔥 UI को Auto-Refresh करें**
      } else {
        Fluttertoast.showToast(msg: 'No data found in Firebase.');
      }
    }, onError: (error) {
      Fluttertoast.showToast(msg: 'Error: $error');
    });
  }


  /// **🔥 Update Profile Data in Firebase (Live Reflect in UI)**
  Future<void> updateProfileData(String driverId, String newName, String newPhone) async {
    DatabaseReference ref = realTimeDb.ref('Drivers_Data').child(driverId);

    try {
      await ref.update({
        "driverName": newName,
        "driverPhoneNumber": newPhone,
      });

      Fluttertoast.showToast(msg: "Profile updated successfully!");
    } catch (e) {
      Fluttertoast.showToast(msg: "Error updating profile: $e");
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



      var realTimeData = DriverProfileModel(
        driverID: driverId,
        driverName: driverData.driverName,
        driverPhoneNumber: driverData.driverPhoneNumber,
        driverAddress: driverData.driverAddress,
        driverImage: driverImgUrl ?? "",
        fcmToken: token,
        isOnline: false,
        carName: driverData.carName,
        drCurrantLongitude: mapProvider.currentLocation?.latitude,
        drCurrantLatitude: mapProvider.currentLocation?.longitude
      );

      await authService.saveDriverData(driverId, data);

      await authService.saveDriverDataInRealTime(driverId, realTimeData);

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
      AppHelperFunctions.navigateToScreenBeforeEndPage(context, const BottomNavigation());
    }else{
      AppHelperFunctions.navigateToScreenBeforeEndPage(context, const OnBoardingScreen());

    }
    }


}