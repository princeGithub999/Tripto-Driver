import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class DriverHomeScreen extends StatefulWidget {
  final String driverId;

  DriverHomeScreen({required this.driverId});

  @override
  _DriverHomeScreenState createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    _setupFCM();
    _listenForRideRequests();
  }

  // ✅ Setup Firebase Cloud Messaging
  void _setupFCM() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("FCM Permission Granted!");
    }

    // Subscribe driver to 'drivers' topic
    _firebaseMessaging.subscribeToTopic("drivers");

    // Initialize Local Notifications
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initSettings =
    InitializationSettings(android: androidSettings);

    await flutterLocalNotificationsPlugin.initialize(initSettings);

    // Listen for messages when app is foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _showLocalNotification(
          message.notification?.title ?? "New Ride",
          message.notification?.body ?? "You have a new ride request!");
    });
  }


  void _showLocalNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
    AndroidNotificationDetails(
      "ride_request_channel",
      "Ride Requests",
      importance: Importance.high,
      priority: Priority.high,
    );

    const NotificationDetails details = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(0, title, body, details);
  }


  void _listenForRideRequests() {
    _db
        .collection('rides')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        _showRideRequestDialog(snapshot.docs.first);
      }
    });
  }


  void _acceptRide(String rideId) async {
    await _db.collection('rides').doc(rideId).update({
      'driver_id': widget.driverId,
      'status': 'accepted',
    });
    Navigator.pop(context);
  }


  void _cancelRide(String rideId) async {
    await _db.collection('rides').doc(rideId).update({
      'status': 'cancelled',
    });
    Navigator.pop(context);
  }


  void _showRideRequestDialog(DocumentSnapshot ride) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: Text("New Ride Request 🚖"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Pickup: ${ride['pickup_location']['lat']}, ${ride['pickup_location']['lng']}"),
              Text("Drop: ${ride['drop_location']['lat']}, ${ride['drop_location']['lng']}"),
              SizedBox(height: 10),
              Text("Do you want to accept this ride?", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => _cancelRide(ride.id),
              child: Text("Reject", style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () => _acceptRide(ride.id),
              child: Text("Accept"),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Driver Home")),
      body: Center(child: Text("Waiting for Ride Requests... 🚖")),
    );
  }
}
