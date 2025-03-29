import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tripto_driver/model/driver_data_model/driver_address_model.dart';
import 'package:tripto_driver/model/driver_data_model/driver_data_model.dart';
import 'package:tripto_driver/model/driver_data_model/driver_document_model.dart';
import 'package:tripto_driver/model/driver_data_model/vehicles_model.dart';
import 'package:tripto_driver/utils/helpers/helper_functions.dart';
import 'package:tripto_driver/view/auth_screen/verify_otp_page.dart';
import 'package:tripto_driver/view/home_page.dart';
import 'package:tripto_driver/view_model/provider/from_provider/from_provider.dart';
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
  bool isGoogleAuthLoading = false;
  AuthService authService = AuthService();
  FromProvider fromProvider = Provider.of(Get.context!, listen: false);
  NotificationService notificationService = NotificationService();
  final FirebaseDatabase realTimeDb = FirebaseDatabase.instance;
  bool isOnline = false;
  var mapProvider = Provider.of<MapsProvider>(Get.context!, listen: false);
  final supabaseOTP = Supabase.instance.client;
  dynamic supaNumber;
  DriverModel driverModels = DriverModel();
  VehiclesModel vehiclesModels = VehiclesModel();
  DriverDocumentModel driverDocumentModels = DriverDocumentModel();



  AuthProviderIn(){
    supaNumber = supabaseOTP.auth.currentUser?.phone;
    print('Number $supaNumber');
  }

  Future<void> supaOtp(String phoneNumber) async {

    isLoding = true;
    notifyListeners();
    try {

      await supabaseOTP.auth.signInWithOtp(
        phone: '+91$phoneNumber',
      );
      AppHelperFunctions.navigateToScreen(Get.context!,const VerifyOtpPage());
      AppHelperFunctions.showSnackBar('OTP sent successfully!');
    } catch (e, stackTrace) {
      print('OTP Error: $e');
      print('Stack Trace: $stackTrace');
      AppHelperFunctions.showSnackBar('Failed to send OTP: $e');
    } finally {
      isLoding = false;
      notifyListeners();
    }
  }

  Future<void> supaVeryfiOTP(String phoneNumber, String otp)async{

    var currentUserId = FirebaseAuth.instance.currentUser?.uid;
    isLoding = true;
    notifyListeners();
    try{
        final response = await supabaseOTP.auth.verifyOTP(
            phone: '+91$phoneNumber',
            token: otp,
            type: OtpType.sms
        );

        if(response.session != null){
          Fluttertoast.showToast(msg: 'v success');
        authService.checkStatus(phoneNumber,);
        }else{
          AppHelperFunctions.showSnackBar('Invalid OTP!');
        }
    }catch(e){
        AppHelperFunctions.showSnackBar('Failed to verify OTP: $e');
    }finally{
      isLoding = false;
      notifyListeners();
    }
  }

  Future<void> signInWithGoogle()async{

    try {
      isGoogleAuthLoading = true;
      notifyListeners();

      var success = await authService.signInWithGoogle();

      if (success == true) {
        print('Login Success! Navigating to HomePage...');
        // Get.to(() =>  FormFillupScreen());
        // AppHelperFunctions.navigateToScreenBeforeEndPage(Get.context!, FormFillupScreen());

        authService.checkStatus(inputNumber.text.trim());
      } else {
        print('Login Failed!');
      }
    } catch (error) {
      Fluttertoast.showToast(msg: '$error');
    } finally {
      isGoogleAuthLoading = false;
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




  void fetchLiveProfileData(String driverId) {

    DatabaseReference ref = realTimeDb.ref('Drivers_Data').child(driverId);

    ref.onValue.listen((DatabaseEvent event) {
      if (event.snapshot.exists && event.snapshot.value != null) {
        Map<String, dynamic> data = Map<String, dynamic>.from(event.snapshot.value as Map);
        print("🔥 Live Updated Driver Data: $data");

        // driverProfile = DriverModel.fromJson(data);
        notifyListeners();  //
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

      String? penUrl = fromProvider.penCardImage != null
          ? await authService.uploadImageToFirebase(fromProvider.penCardImage!, "pan_card_$driverId.jpg")
          : null;

      String? driverImgUrl = fromProvider.driverImage != null
          ? await authService.uploadImageToFirebase(fromProvider.driverImage!, "driver_image_$driverId.jpg")
          : null;

      String? carImage = fromProvider.carImage != null
            ? await authService.uploadImageToFirebase(fromProvider.carImage!, "car_image_$driverId.jpg")
            :null;

      var lat = mapProvider.currentLocation?.latitude;
      var lang = mapProvider.currentLocation?.longitude;
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
        penCardImage: penUrl ?? "",
        carName: driverData.carName,
        fcmToken: token,
      );

      var address = DriverAddressModel(
        vill: driverData.driverAddress,
        district: 'hello',
        pinCode: 841218,
        policeStation: 'beheld',
        post: 'paiga',
        state: 'bihar',
        lat:  lat,
        lang: lang
      );

      var driver = DriverModel(
        driverID: driverId,
        documentId: driverId,
        vehiclesId: driverId,
        driverFirstName: driverData.driverName,
        driverLastName: 'kumar',
        driverEmail: driverData.driverEmail,
        driverImage: driverImgUrl,
        driverGender: 'male',
        driverPhoneNumber: driverData.driverPhoneNumber,
        fcmToken: token,
        address: address
      );

      var vehiclesData = VehiclesModel(
        driverId: driverId,
        driverToken: token,
        id: driverId,
        rcImageFront: frontRcUrl,
        rcImageBack: backRcUrl,
        type: driverData.carName,
        status: false,
        vehicleNumber: driverData.vehiclesNumber,
          vehicleImage: carImage

      );
      var documentData = DriverDocumentModel(
        id: driverId,
        driverId: driverId,
        adharFront: frontAadharUrl,
        adharBack: backAadharUrl,
        driverLicence: driverData.dlNumber,
        isAdharVerifide: false,
        isDriverLicenceVerifide: false,
        isPanVerifide: false,
        pen: penUrl,

      );

       // await authService.saveDriverData(driverId, data);
      await authService.saveDriver(driverId, driver);
      await authService.saveDriverVehiclesData(driverId, vehiclesData);
      await authService.saveDriverDocumentData(driverId, documentData);


      notifyListeners();
      AppHelperFunctions.navigateToScreenBeforeEndPage(Get.context!, const BottomNavigation());

      fromProvider.clearFeald();
      AppHelperFunctions.showSnackBar("Driver data successfully saved!");
    } catch (e) {
      AppHelperFunctions.showSnackBar("Error saving driver data: $e");
    } finally {
      isLoding = false;
      notifyListeners();
    }
  }

  Future<void> retriveDriver() async {

    var currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) {
      Fluttertoast.showToast(msg: 'User not logged in.');
      return;
    }
    retriveVehicle();
   var retriveData = await authService.retriveDriver(currentUserId);
    if(retriveData != null){
      driverModels = retriveData;
      notifyListeners();
    }else{
      Fluttertoast.showToast(msg: 'dont retrive driver');
    }
  }

  void retriveVehicle()async {

    retriveDriverDocuments();
    var currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) {

      Fluttertoast.showToast(msg: 'User not logged in.');
      return;
    }
    var data = await authService.retriveVehicle(currentUserId);
    if(data != null){
      vehiclesModels = data;
      notifyListeners();
    }else{
      Fluttertoast.showToast(msg: "don't retrive vehicle");
    }
  }

  void retriveDriverDocuments() async{

    var currentUserId = FirebaseAuth.instance.currentUser?.uid;
    if (currentUserId == null) {

      Fluttertoast.showToast(msg: 'User not logged in.');
      return;
    }

   var data = await authService.retriveDoc(currentUserId);
    if(data != null){
      driverDocumentModels = data;
      notifyListeners();
    }else{
      Fluttertoast.showToast(msg: "don't retrive driver doc");
    }
  }

  Future<void> checkLoginStatus(BuildContext context)async{

    var currentUser =  FirebaseAuth.instance.currentUser;
    var respons = Supabase.instance.client;
    if(currentUser != null || respons.auth.currentUser != null){
      AppHelperFunctions.navigateToScreenBeforeEndPage(context, const BottomNavigation());
    }else{
      AppHelperFunctions.navigateToScreenBeforeEndPage(context, const OnBoardingScreen());

    }
  }

    Future<DriverModel?> getData()async{

      var currentUser =  FirebaseAuth.instance.currentUser;

      // if(currentUser!.uid.isNotEmpty){
      //   Fluttertoast.showToast(msg: 'Error: Driver ID is empty');
      //   return null;
      // }

      try{
          DatabaseReference driverRef = realTimeDb.ref('Drivers_Data').child('Otc5g5d4PiWdiRa5MAaiqMhJrot1');
          DatabaseEvent event = await driverRef.once();

          if(event.snapshot.value != null){
            Map<String, dynamic> data = Map<String, dynamic>.from(event.snapshot.value as Map);
            return DriverModel.fromJson(data);
          }else{
            Fluttertoast.showToast(msg: 'No data found');
            return null;
          }

      }catch(e){
        Fluttertoast.showToast(msg: 'Error: $e');
        return null;
      }

    }





}