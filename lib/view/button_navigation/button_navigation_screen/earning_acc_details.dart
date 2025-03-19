import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../notification/notificatin_dialog.dart';
import '../../../model/ride_request_model/user_ride_request_notification_model.dart';



class DriverHomePage extends StatefulWidget {
  const DriverHomePage({super.key});

  @override
  _DriverHomePageState createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    initializePushNotifications();
  }

  void initializePushNotifications() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.data.containsKey("rideRequestId")) {
        String rideRequestId = message.data["rideRequestId"];
        fetchRideRequestDetails(rideRequestId);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data.containsKey("rideRequestId")) {
        String rideRequestId = message.data["rideRequestId"];
        fetchRideRequestDetails(rideRequestId);
      }
    });
  }

  void fetchRideRequestDetails(String rideRequestId) {
    DatabaseReference rideRequestRef = FirebaseDatabase.instance
        .ref()
        .child("All Ride Request")
        .child(rideRequestId);

    rideRequestRef.once().then((DatabaseEvent event) {
      if (event.snapshot.value != null) {
        Map<String, dynamic> rideData =
        Map<String, dynamic>.from(event.snapshot.value as Map);

        if (rideData["driverId"] == "waiting" ||
            rideData["driverId"] == firebaseAuth.currentUser!.uid) {

          UserRideRequestInformation rideDetails = UserRideRequestInformation(
            rideRequestId: rideRequestId,
            originalLatLng: LatLng(
              double.parse(rideData["origin"]["latitude"].toString()),
              double.parse(rideData["origin"]["longitude"].toString()),
            ),
            destinationLatLng: LatLng(
              double.parse(rideData["destination"]["latitude"].toString()),
              double.parse(rideData["destination"]["longitude"].toString()),
            ),
            originAddress: rideData["originAddress"],
            destinationAddress: rideData["destinationAddress"],
            userName: rideData["userName"],
            userPhone: rideData["userPhone"],
          );

          showDialog(
            context: context,
            builder: (BuildContext context) =>
                NotificationDialogBox(userRideRequestDetails: rideDetails),
          );
        } else {
          Fluttertoast.showToast(msg: "This ride request has been taken.");
        }
      } else {
        Fluttertoast.showToast(msg: "Ride request not found.");
      }
    }).catchError((error) {
      Fluttertoast.showToast(msg: "Error fetching ride details: $error");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Driver Home")),
      body: Center(child: Text("Waiting for ride requests...")),
    );
  }
}
