import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapProvider extends ChangeNotifier {
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

  /// Toggles online status and manages live location updates
  Future<void> toggleOnlineStatus(bool value) async {
    debugPrint("Toggle button pressed: $value");

    if (isOnline == value) return; // Avoid unnecessary state updates

    isOnline = value;
    notifyListeners(); // Notify UI update

    Fluttertoast.showToast(msg: isOnline ? "You are Online" : "You are Offline");

    if (isOnline) {
      await trackLiveLocation();
    } else {
      await _positionStream?.cancel();
      _positionStream = null;
    }

    notifyListeners(); // Ensure UI updates
  }

  /// Assigns the GoogleMapController when the map is created
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
