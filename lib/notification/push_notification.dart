import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:tripto_driver/model/ride_request_model/user_ride_request_notification_model.dart';
import 'notificatin_dialog.dart';





class PushNotificationSystem {

  FirebaseMessaging messaging = FirebaseMessaging.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final AudioPlayer audioPlayer=AudioPlayer();

  Future initializeCloudMessaging(BuildContext context) async {
    // 1. Terminated
    // When the app is closed and opened directly from the push notification
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        readUserRideRequestInformation(remoteMessage.data["rideRequestId"], context);
      }
    });

    // 2. Foreground
    // When the app is open and receives a push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
      readUserRideRequestInformation(remoteMessage.data["rideRequestId"], context);
    });

    // 3. Background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) {
      readUserRideRequestInformation(remoteMessage.data["rideRequestId"], context);
    });
  }

   readUserRideRequestInformation(String userRideRequestId, BuildContext context) {
    FirebaseDatabase.instance.ref().child("All Ride Request").child(userRideRequestId).child("driverId").onValue.listen((event){
      if(event.snapshot.value=="waiting"||event.snapshot.value== firebaseAuth.currentUser!.uid){
        FirebaseDatabase.instance.ref().child("All Ride Request").child(userRideRequestId).once().then((snapData){
         if(snapData.snapshot.value!=null){
             audioPlayer.setAsset('');
             audioPlayer.play();

             double originLat= double.parse((snapData.snapshot.value! as Map)["origin"]["latitude"]);
             double originLng= double.parse((snapData.snapshot.value! as Map)["origin"]["latitude"]);
             String originAddress=(snapData.snapshot.value! as Map)["originAddress"];


             double destinationLat= double.parse((snapData.snapshot.value! as Map)["destination"]["latitude"]);
             double destinationLng= double.parse((snapData.snapshot.value! as Map)["destination"]["latitude"]);
             String destinationAddress=(snapData.snapshot.value! as Map)["destinationAddress"];

             String userName=(snapData.snapshot.value! as Map)["userName"];
             String  userPhone=(snapData.snapshot.value! as Map)["userPhone"];

             String? reduRequestId= snapData.snapshot.key;
             UserRideRequestInformation userRideRequestDetail=UserRideRequestInformation();
             userRideRequestDetail.originalLatLng = LatLng(originLat, originLng);
             userRideRequestDetail.originAddress=originAddress;
             userRideRequestDetail.destinationLatLng=LatLng(destinationLat, originLng);
             userRideRequestDetail.destinationAddress=destinationAddress;
             userRideRequestDetail.userName=userName;
             userRideRequestDetail.userPhone=userPhone;


             userRideRequestDetail.rideRequestId=reduRequestId;

             showDialog(
                 context: context,
                 builder: (BuildContext context)=>NotificationDialogBox(
                   userRideRequestDetails: userRideRequestDetail,
                 )
             );
         }
         else{
          Fluttertoast.showToast(msg: "this Ride Request Id do not exist.");
         }
        });
      }
      else{
        Fluttertoast.showToast(msg: "This Ride Request has been cancelled");
        Navigator.pop(context);
      }
    });
  }

  Future generateAndGetToken() async {
    String? registrationToken = await messaging.getToken();
    print("FCM registration Token: $registrationToken");

    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseDatabase.instance.ref()
          .child("drivers")
          .child(user.uid)
          .child("token")
          .set(registrationToken);
    }

    messaging.subscribeToTopic("allDrivers");
    messaging.subscribeToTopic("allUsers");
  }

}
