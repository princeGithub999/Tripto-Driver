import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:just_audio/just_audio.dart';
import '../model/ride_request_model/user_ride_request_notification_model.dart';


class NotificationDialogBox extends StatefulWidget {
  final UserRideRequestInformation? userRideRequestDetails;

  NotificationDialogBox({this.userRideRequestDetails});

  @override
  State<NotificationDialogBox> createState() => _NotificationDialogBoxState();
}

class _NotificationDialogBoxState extends State<NotificationDialogBox> {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  late AudioPlayer _audioPlayer;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        margin: const EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: darkTheme ? Colors.black : Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Ride Request Image
            Image.asset('assets/icons/trip_provider.png', height: 100, width: 100),
            const SizedBox(height: 10),

            // Title
            Text(
              "New Ride Request",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
                color: darkTheme ? Colors.amber.shade400 : Colors.blue,
              ),
            ),
            const SizedBox(height: 10),

            Divider(
              height: 2,
              thickness: 2,
              color: darkTheme ? Colors.amber.shade400 : Colors.blue,
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Pickup Location
                  Row(
                    children: [
                      Image.asset('assets/icons/origin.png', height: 24, width: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(  
                          widget.userRideRequestDetails?.originAddress ?? "Unknown Location",
                          style: TextStyle(
                            fontSize: 16,
                            color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),

                  // Destination Location
                  Row(
                    children: [
                      Image.asset('assets/icons/destination.png', height: 24, width: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          widget.userRideRequestDetails?.destinationAddress ?? "Unknown Destination",
                          style: TextStyle(
                            fontSize: 16,
                            color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Divider(
              height: 2,
              thickness: 2,
              color: darkTheme ? Colors.amber.shade400 : Colors.blue,
            ),

            // Buttons
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _audioPlayer.pause();
                      _audioPlayer.stop();
                      Navigator.pop(context); // Close the dialog
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: Text(
                      "Cancel".toUpperCase(),
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: () {
                      _audioPlayer.pause();
                      _audioPlayer.stop();
                      acceptRideRequest(context);
                    },
                    child: Text(
                      "Accept".toUpperCase(),
                      style: const TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Accept Ride Request
  void acceptRideRequest(BuildContext context) async {
    DatabaseReference driverRef = FirebaseDatabase.instance
        .ref()
        .child("driver")
        .child(firebaseAuth.currentUser!.uid)
        .child("newRideStatus");

    DataSnapshot snapshot = await driverRef.get();

    if (snapshot.exists && snapshot.value == "idle") {
      await driverRef.set("accept");
      AssistantMethod.pauseLiveLocationUpdates();


      // Navigator.push(
      //   context,
      //   // MaterialPageRoute(builder: (context) => NewTripScreen()),
      // );
    } else {
      Fluttertoast.showToast(msg: 'This ride request does not exist');
    }
  }
}

class AssistantMethod {
  static StreamSubscription? streamSubscriptionPosition;

  /// Pauses live location updates
  static void pauseLiveLocationUpdates() {
    if (streamSubscriptionPosition != null) {
      streamSubscriptionPosition!.pause();
    } else {
        ("Error: streamSubscriptionPosition is null!");
    }

    String? currentUserId = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserId != null) {
      FirebaseFirestore.instance.collection("drivers").doc(currentUserId).update({
        "isActive": false
      });
      print("Live location updates paused for user: $currentUserId");
    } else {
      print("Error: No authenticated user found!");
    }
  }
}
