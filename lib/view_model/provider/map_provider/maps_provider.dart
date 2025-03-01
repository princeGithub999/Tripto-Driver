import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../service/auth_service.dart';

class MapsProvider extends ChangeNotifier {

  final FirebaseDatabase realTimeDb = FirebaseDatabase.instance;
  AuthService authService = AuthService();


  final Completer<GoogleMapController> controller = Completer();
  LatLng? _currentPosition;
  StreamSubscription<Position>? _positionStream;
  bool isOnline = false;

  static const CameraPosition initialPosition = CameraPosition(
    target: LatLng(25.9753007, 84.9217521),
    zoom: 15,
  );


  Future<bool> checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: "Location permissions are denied.");
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: "Location permissions are permanently denied. Open settings.");
      await Geolocator.openAppSettings();
      return false;
    }
    return permission == LocationPermission.whileInUse || permission == LocationPermission.always;
  }



  Future<void> trackLiveLocation() async {
    bool hasPermission = await checkLocationPermission();
    if (!hasPermission) return;

    await _positionStream?.cancel();

    _positionStream = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    ).listen((Position position) async {
      _currentPosition = LatLng(position.latitude, position.longitude);
      notifyListeners();

      if (controller.isCompleted) {
        GoogleMapController mapController = await controller.future;
        if (_currentPosition != null) {
          mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: _currentPosition!, zoom: 17),
            ),
          );
        }
      }
    });
  }


  void listenToOnlineStatus() {
    realTimeDb.ref('DriverData').onValue.listen((event) {
      if (event.snapshot.exists) {
        bool status = event.snapshot.value as bool;
        isOnline = status;
        notifyListeners();
      }
    });
  }


  Future<void> toggleOnlineStatus(bool isOnline)async{
    await authService.updateToggleButtonStatus(isOnline);
  }


  void onMapCreated(GoogleMapController mapController) {
    if (!controller.isCompleted) {
      controller.complete(mapController);
    }
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }
}
