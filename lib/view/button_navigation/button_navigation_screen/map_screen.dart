import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:location/location.dart';

import '../../../view_model/service/location_service.dart';

class DriverMapScreen extends StatefulWidget {
  final LatLng pickUpLatLng;
  final LatLng dropLatLng;

  const DriverMapScreen({super.key, required this.pickUpLatLng, required this.dropLatLng});

  @override
  State<DriverMapScreen> createState() => _DriverMapScreenState();
}

class _DriverMapScreenState extends State<DriverMapScreen> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  Set<Polyline> polylines = {};
  String distanceText = "";
  String durationText = "";
  bool isOnline = false;
  LatLng? currentLocation;

  @override
  void initState() {
    super.initState();
    _setMarkersAndRoute();
  }

  Future<void> _setMarkersAndRoute() async {
    setState(() {
      markers.add(Marker(
        markerId: const MarkerId("pickup"),
        position: widget.pickUpLatLng,
        infoWindow: const InfoWindow(title: "User Pickup Location"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      ));

      markers.add(Marker(
        markerId: const MarkerId("drop"),
        position: widget.dropLatLng,
        infoWindow: const InfoWindow(title: "User Destination"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      ));
    });

    final result = await LocationServices.getRouteAndDistance(widget.pickUpLatLng, widget.dropLatLng);

    if (result.isNotEmpty) {
      setState(() {
        distanceText = result["distance"];
        durationText = result["duration"];
        polylines.add(Polyline(
          polylineId: const PolylineId("route"),
          points: result["polyline"],
          width: 5,
          color: Colors.blue,
        ));
      });

      _moveCameraToRoute();
    }
  }

  void _moveCameraToRoute() {
    mapController?.animateCamera(CameraUpdate.newLatLngBounds(
      LatLngBounds(
        southwest: LatLng(
          widget.pickUpLatLng.latitude < widget.dropLatLng.latitude
              ? widget.pickUpLatLng.latitude
              : widget.dropLatLng.latitude,
          widget.pickUpLatLng.longitude < widget.dropLatLng.longitude
              ? widget.pickUpLatLng.longitude
              : widget.dropLatLng.longitude,
        ),
        northeast: LatLng(
          widget.pickUpLatLng.latitude > widget.dropLatLng.latitude
              ? widget.pickUpLatLng.latitude
              : widget.dropLatLng.latitude,
          widget.pickUpLatLng.longitude > widget.dropLatLng.longitude
              ? widget.pickUpLatLng.longitude
              : widget.dropLatLng.longitude,
        ),
      ),
      100,
    ));
  }

  Future<void> _toggleOnlineStatus(bool status) async {
    setState(() {
      isOnline = status;
    });

    Fluttertoast.showToast(
      msg: isOnline ? "You are online" : "You are offline",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );

    if (isOnline) {
      _getCurrentLocation();
      _fetchFirebaseData();
    }
  }

  Future<void> _getCurrentLocation() async {
    Location location = Location();
    var locationData = await location.getLocation();

    setState(() {
      currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
      markers.add(Marker(
        markerId: const MarkerId("current_location"),
        position: currentLocation!,
        infoWindow: const InfoWindow(title: "Your Current Location"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ));
    });

    if (mapController != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(currentLocation!, 14),
      );
    }
  }

  void _fetchFirebaseData() {
    DatabaseReference databaseRef = FirebaseDatabase.instance.ref("drivers");
    databaseRef.onValue.listen((event) {
      if (event.snapshot.exists) {
        var data = event.snapshot.value;
        print("Firebase Data: $data");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Driver Map")),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: widget.pickUpLatLng,
              zoom: 12,
            ),
            onMapCreated: (controller) {
              setState(() {
                mapController = controller;
              });
            },
            markers: markers,
            polylines: polylines,
          ),
          // Distance and ETA display (Top Center)
          Positioned(
            top: 30,
            left: 10,
            right: 10,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "Distance: $distanceText, ETA: $durationText",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // Online/Offline color indicator (Top Right Corner)
          Positioned(
            top: 30,
            right: 10,
            child: Container(
              width: 15,
              height: 15,
              decoration: BoxDecoration(
                color: isOnline ? Colors.green : Colors.red,
                shape: BoxShape.circle,
              ),
            ),
          ),
          // Online/Offline switch (Bottom Left)
          Positioned(
            bottom: 20,
            left: 20,
            child: CupertinoSwitch(
              value: isOnline,
              onChanged: _toggleOnlineStatus,
              activeColor: Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
