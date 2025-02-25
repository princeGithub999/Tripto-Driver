import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DriverHomeScreen extends StatefulWidget {
  final String driverId; // Driver ka Unique ID

  DriverHomeScreen({required this.driverId});

  @override
  _DriverHomeScreenState createState() => _DriverHomeScreenState();
}

class _DriverHomeScreenState extends State<DriverHomeScreen> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    _listenForRideRequests();
  }

  // 🔥 Firestore me naye Ride Requests suno
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

  // ✅ Accept Ride
  void _acceptRide(String rideId) async {
    await _db.collection('rides').doc(rideId).update({
      'driver_id': widget.driverId,
      'status': 'accepted',
    });
    Navigator.pop(context); // Dialog Close
  }

  // ❌ Cancel Ride
  void _cancelRide(String rideId) async {
    await _db.collection('rides').doc(rideId).update({
      'status': 'cancelled',
    });
    Navigator.pop(context); // Dialog Close
  }

  // 📌 Alert Dialog for New Ride Request
  void _showRideRequestDialog(DocumentSnapshot ride) {
    showDialog(
      context: context,
      barrierDismissible: false, // Dialog dismiss nahi hoga bina action ke
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
