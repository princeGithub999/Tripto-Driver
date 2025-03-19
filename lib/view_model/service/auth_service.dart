import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tripto_driver/model/driver_data_model/driver_data_model.dart';
import 'package:tripto_driver/model/driver_data_model/driver_document_model.dart';
import 'package:tripto_driver/model/driver_data_model/vehicles_model.dart';
import 'package:tripto_driver/utils/helpers/helper_functions.dart';
import '../../model/driver_data_model/driver_profile_model.dart';
import '../../view/button_navigation/button_navigation.dart';
import '../../view/screen/profile_details_screen/form_fillup_screen.dart';

class AuthService {

   final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseDatabase realTimeDb = FirebaseDatabase.instance;
  String? userEmail;
  String? crruntUserId;

  AuthService() {
    crruntUserId = FirebaseAuth.instance.currentUser?.uid;
  }


  Future<bool?> requestOTP(String phoneNumber)async{

    Completer<bool?> completer = Completer<bool?>();
    try{
      auth.verifyPhoneNumber(
          phoneNumber: '+91$phoneNumber',
          verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
          completer.complete(true);
          },
          verificationFailed:  (FirebaseAuthException error) {
            Fluttertoast.showToast(msg: '$error');
            completer.complete(false);
          },

          codeSent: (String verificationId, int? forceResendingToken) {
            completer.complete(true);
          },

          codeAutoRetrievalTimeout:  (String verificationId) {
            Fluttertoast.showToast(msg: "OTP Timeout");
            completer.complete(false);
          }

      );
      return completer.future;
    }catch(error){

      Fluttertoast.showToast(msg: 'Request OTP Error $error');
      return false;
    }
  }


  Future<bool?> signInWithGoogle() async {
    Completer<bool?> completer = Completer<bool?>();

    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        await auth.signInWithCredential(credential);
         userEmail = auth.currentUser?.email;
        Fluttertoast.showToast(msg: 'Google auth success');
        completer.complete(true);
      } else {
        Fluttertoast.showToast(msg: 'Google Sign-In aborted');
        completer.complete(false);
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error auth: $e');
      print('Error auth $e');
      completer.complete(false);
    }

    return completer.future;
  }



  Future<void> saveDriverData(String currentUserID, DriverDataModel driverData) async {
    await db
        .collection('DriverData')
        .doc(currentUserID)
        .set(driverData.toJson());

  }

  Future<String?> uploadImageToFirebase(File imageFile, String path) async {
    try {
      final Reference storageRef = FirebaseStorage.instance.ref('DriverDocumentImage').child(path);
      final UploadTask uploadTask = storageRef.putFile(imageFile);
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }
  Future<void> saveDriverDataInRealTime(String driverID, DriverModel driverData) async {
    if (driverID.isEmpty) {
      Fluttertoast.showToast(msg: 'Error: Driver ID is empty');
      return;
    }

    try {
      await realTimeDb.ref('Drivers').child(driverID).set(driverData.toJson());
      Fluttertoast.showToast(msg: 'Saved in real-time database');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }

  Future<void> saveDriverVehiclesData(String driverID, VehiclesModel driverData) async {
    if (driverID.isEmpty) {
      Fluttertoast.showToast(msg: 'Error: Driver ID is empty');
      return;
    }

    try {
      await realTimeDb.ref('Vehicle').child(driverID).set(driverData.toJson());
      Fluttertoast.showToast(msg: 'Saved in real-time database');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }

  Future<void> saveDriverDocumentData(String driverID, DriverDocumentModel driverData) async {
    if (driverID.isEmpty) {
      Fluttertoast.showToast(msg: 'Error: Driver ID is empty');
      return;
    }

    try {
      await realTimeDb.ref('driver_documents').child(driverID).set(driverData.toJson());
      Fluttertoast.showToast(msg: 'Saved in real-time database');
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }


  Future<void> updateToggleBS(bool isOnline,String userId)async{
    try{
      realTimeDb.ref('Vehicle').child(userId).update({
        'status':isOnline
      });
      // print(crruntUserId!);
    }catch(e){
      Fluttertoast.showToast(msg: 'Error s $e');
    }
  }


   Future<void> checkStatus(String number) async {
     try {
       final DatabaseReference ref = realTimeDb.ref('Drivers');
       final DatabaseEvent event = await ref.once();
       final DataSnapshot snapshot = event.snapshot;
       final String? email = auth.currentUser?.email;

       if (snapshot.exists && snapshot.value != null) {
         Map<dynamic, dynamic> driversData = snapshot.value as Map<dynamic, dynamic>;

         bool found = false;

         for (var key in driversData.keys) {
           var driverData = driversData[key] as Map<dynamic, dynamic>;

           var n = driverData["driverPhoneNumber"] ?? '';
           var e = driverData["driverEmail"] ?? '';

           if (n.toString().trim() == number.trim() || e == email) {
             found = true;
             Fluttertoast.showToast(msg: 'Phone: $n, Email: $e');
             AppHelperFunctions.navigateToScreenBeforeEndPage(Get.context!, const BottomNavigation());
             break;
           }
         }

         if (!found) {
           AppHelperFunctions.navigateToScreenBeforeEndPage(Get.context!, const FormFillupScreen());
         }
       } else {
         AppHelperFunctions.navigateToScreenBeforeEndPage(Get.context!, const FormFillupScreen());
       }

     } catch (error) {
       print("Error checking status: $error");
       AppHelperFunctions.showSnackBar("Failed to check status: $error");
     }
   }



}