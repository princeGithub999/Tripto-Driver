// import 'package:flutter/material.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:location/location.dart';
//
// import '../../../view_model/service/location_service.dart';
//
//
// class DriverMapScreen extends StatefulWidget {
//   final LatLng pickUpLatLng;
//   final LatLng dropLatLng;
//   final String driverId; // Added driverId to track the specific driver in Firebase
//
//   const DriverMapScreen({
//     super.key,
//     required this.pickUpLatLng,
//     required this.dropLatLng,
//     required this.driverId, // Required parameter for Firebase tracking
//   });
//
//   @override
//   State<DriverMapScreen> createState() => _DriverMapScreenState();
// }
//
// class _DriverMapScreenState extends State<DriverMapScreen> {
//   GoogleMapController? mapController;
//   Set<Marker> markers = {};
//   Set<Polyline> polylines = {};
//   String distanceText = "";
//   String durationText = "";
//   bool isOnline = false;
//   LatLng? currentLocation;
//   late DatabaseReference driverRef; // Firebase reference for the driver
//   Location location = Location();
//
//   @override
//   void initState() {
//     super.initState();
//     // driverRef = FirebaseDatabase.instance.ref("drivers/${widget.driverId}"); // Firebase reference for this driver
//     _setMarkersAndRoute();
//     _listenToOnlineStatus();
//   }
//
//   /// **Listen to driver's online status from Firebase in real-time**
//   void _listenToOnlineStatus() {
//     driverRef.child("isOnline").onValue.listen((event) {
//       if (event.snapshot.exists) {
//         bool status = event.snapshot.value as bool;
//         setState(() {
//           isOnline = status;
//         });
//       }
//     });
//   }
//
//   /// **Toggle the online status and update Firebase**
//   Future<void> _toggleOnlineStatus(bool status) async {
//     setState(() {
//       isOnline = status;
//     });
//
//     await driverRef.update({"isOnline": isOnline});
//
//     Fluttertoast.showToast(
//       msg: isOnline ? "You are now Online" : "You are now Offline",
//       toastLength: Toast.LENGTH_SHORT,
//       gravity: ToastGravity.BOTTOM,
//     );
//
//     if (isOnline) {
//       _getCurrentLocation();
//       _trackLiveLocation(); // Start tracking live location
//     }
//   }
//
//   /// **Get the driver's current location and update Firebase**
//   Future<void> _getCurrentLocation() async {
//     var locationData = await location.getLocation();
//
//     setState(() {
//       currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
//       markers.add(Marker(
//         markerId: const MarkerId("current_location"),
//         position: currentLocation!,
//         infoWindow: const InfoWindow(title: "Your Current Location"),
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//       ));
//     });
//
//     await driverRef.update({
//       "latitude": locationData.latitude,
//       "longitude": locationData.longitude,
//     });
//
//     if (mapController != null) {
//       mapController!.animateCamera(
//         CameraUpdate.newLatLngZoom(currentLocation!, 14),
//       );
//     }
//   }
//
//   /// **Track live location updates and update Firebase**
//   void _trackLiveLocation() {
//     location.onLocationChanged.listen((locationData) {
//       if (isOnline) {
//         setState(() {
//           currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
//           markers.removeWhere((marker) => marker.markerId.value == "current_location");
//           markers.add(Marker(
//             markerId: const MarkerId("current_location"),
//             position: currentLocation!,
//             infoWindow: const InfoWindow(title: "Your Live Location"),
//             icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//           ));
//         });
//
//         // Update location in Firebase
//       }
//     });
//   }
//
//   /// ** Fetch the route and update markers ** ///
//   Future<void> _setMarkersAndRoute() async {
//     setState(() {
//       markers.add(Marker(
//         markerId: const MarkerId("pickup"),
//         position: widget.pickUpLatLng,
//         infoWindow: const InfoWindow(title: "User Pickup Location"),
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
//       ));
//
//       markers.add(Marker(
//         markerId: const MarkerId("drop"),
//         position: widget.dropLatLng,
//         infoWindow: const InfoWindow(title: "User Destination"),
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
//       ));
//     });
//
//     final result = await LocationServices.getRouteAndDistance(widget.pickUpLatLng, widget.dropLatLng);
//
//     if (result.isNotEmpty) {
//       setState(() {
//         distanceText = result["distance"];
//         durationText = result["duration"];
//         polylines.add(Polyline(
//           polylineId: const PolylineId("route"),
//           points: result["polyline"],
//           width: 5,
//           color: Colors.blue,
//         ));
//       });
//
//       _moveCameraToRoute();
//     }
//   }
//
//   /// **Move camera to fit the route**
//   void _moveCameraToRoute() {
//     mapController?.animateCamera(CameraUpdate.newLatLngBounds(
//       LatLngBounds(
//         southwest: LatLng(
//           widget.pickUpLatLng.latitude < widget.dropLatLng.latitude
//               ? widget.pickUpLatLng.latitude
//               : widget.dropLatLng.latitude,
//           widget.pickUpLatLng.longitude < widget.dropLatLng.longitude
//               ? widget.pickUpLatLng.longitude
//               : widget.dropLatLng.longitude,
//         ),
//         northeast: LatLng(
//           widget.pickUpLatLng.latitude > widget.dropLatLng.latitude
//               ? widget.pickUpLatLng.latitude
//               : widget.dropLatLng.latitude,
//           widget.pickUpLatLng.longitude > widget.dropLatLng.longitude
//               ? widget.pickUpLatLng.longitude
//               : widget.dropLatLng.longitude,
//         ),
//       ),
//       100,
//     ));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Driver Map")),
//       body: Stack(
//         children: [
//           GoogleMap(
//             initialCameraPosition: CameraPosition(
//               target: widget.pickUpLatLng,
//               zoom: 12,
//             ),
//             onMapCreated: (controller) {
//               setState(() {
//                 mapController = controller;
//               });
//             },
//             markers: markers,
//             polylines: polylines,
//           ),
//           // Distance and ETA display (Top Center)
//           Positioned(
//             top: 30,
//             left: 10,
//             right: 10,
//             child: Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: Text(
//                 "Distance: $distanceText, ETA: $durationText",
//                 style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//               ),
//             ),
//           ),
//           // Online/Offline color indicator (Top Right Corner)
//           Positioned(
//             top: 40,
//             right: 10,
//             child: Row(
//               children: [
//                 Container(
//                   width: 15,
//                   height: 15,
//                   decoration: BoxDecoration(
//                     color: isOnline ? Colors.green : Colors.red,
//                     shape: BoxShape.circle,
//                   ),
//                 ),
//                 const SizedBox(width: 5),
//                 Text(
//                   isOnline ? "Online" : "Offline",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: isOnline ? Colors.green : Colors.red,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           // Online/Offline switch (Bottom Left)
//           Positioned(
//             bottom: 20,
//             left: 20,
//             child: CupertinoSwitch(
//               value: isOnline,
//               onChanged: _toggleOnlineStatus,
//               activeColor: Colors.green,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }