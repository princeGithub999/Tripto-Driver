import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as loc;
import 'package:provider/provider.dart';
import 'package:tripto_driver/model/ride_request_model/active_driver_model.dart';
import 'package:tripto_driver/view_model/provider/auth_provider_in/auth_provider.dart';
import 'package:uuid/uuid.dart';
import '../../service/auth_service.dart';
import '../../service/location_service.dart';
import '../../service/map_service.dart';
import 'package:geolocator/geolocator.dart' as geo;

import '../trip_provider/trip_provider.dart';


class MapsProvider extends ChangeNotifier {

  MapsProvider() {
    fetchOnlineStatus();
  }

  loc.Location location =  loc.Location();
  final db = FirebaseFirestore.instance;
  final FirebaseDatabase realTimeDb = FirebaseDatabase.instance;
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;
  BitmapDescriptor? liveLocationMarker;
  AuthService authService = AuthService();
  MapService mapService = MapService();
  GoogleMapController? mapController;
  LatLng? currentLocation;
  // var auth = FirebaseAuth.instance.currentUser!.uid;
  Set<Marker> markers = {};
  Set<Polyline> polyline = {};

  LatLng? originLatLang;
  LatLng destinationLatLang = const LatLng(25.9753007, 84.9217521);
  CameraPosition? initialPosition;

  String distanceText = "";
  String durationText = "";

  final Completer<GoogleMapController> controller = Completer();
  LatLng? _currentPosition;
  StreamSubscription<Position>? _positionStream;
  bool isOnline = false;
  String na = '';
  String name = '';

  var uuid =  Uuid().v4();

  Future<void> fetchOnlineStatus() async {
    DocumentSnapshot ref = await db.collection('vehicle').doc(authService.crruntUserId!).get();

    if (ref.data() != null) {
     var data = ref.data() as Map<dynamic, dynamic>;
      bool status = data['status'] ?? false;
      isOnline = status;
      notifyListeners();
    }else{
      Fluttertoast.showToast(msg: 'not get status');
    }
  }

  Future<void> toggleOnlineStatus(bool status, BuildContext context) async {
    var authProvider = Provider.of<AuthProviderIn>(context,listen: false);
    var rideProvider = Provider.of<TripProvider>(context,listen: false);
    var currentUserId = FirebaseAuth.instance.currentUser?.uid;
    isOnline = status;
    notifyListeners();

    await authService.updateToggleBS(status,currentUserId!);
    var ad = await getAddressFromLatLng(currentLocation!.latitude, currentLocation!.longitude);

    var activeVehicle = ActiveVehicleModel(
      id: authProvider.vehiclesModels.id,
      type: authProvider.vehiclesModels.type,
      name: '',
      color: '',
      imageUrl: '',
      price: '250',
      isOnline: isOnline
    );
    var activeDrivers = ActiveDriverModel(
      id: authProvider.driverModels.driverID,
      fullName: authProvider.driverModels.driverFirstName,
      location: ad,
      vehicle: activeVehicle,
      fcmToken: authProvider.driverModels.fcmToken,
      lat: currentLocation?.latitude,
      lang: currentLocation?.longitude,

    );
    var data = ActiveModel(
      id: authProvider.driverModels.driverID,
      city: 'chhapra',
      driver: activeDrivers,

    );

    if (isOnline) {
      await getCurrentLocation();
      trackLiveLocation();

      rideProvider.activeDriver(data);
      if (currentLocation != null && mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(currentLocation!, 17),
        );
      }
      notifyListeners();
    }else{

     rideProvider.diActiveDriver(data);
      notifyListeners();
    }
  }


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
      locationSettings: const LocationSettings(accuracy: geo.LocationAccuracy.high),
    ).listen((Position position) async {
      _currentPosition = LatLng(position.latitude, position.longitude);
      notifyListeners();

      if (controller.isCompleted) {
        mapController = await controller.future;
        if (_currentPosition != null && mapController != null) {
          mapController!.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: _currentPosition!, zoom: 17),
            ),
          );

          notifyListeners();
        }
      }
    });
  }

  void onMapCreated(GoogleMapController controllerInstance) {
    if (!controller.isCompleted) {
      controller.complete(controllerInstance);
    }
    mapController = controllerInstance;
  }

  Future<void> setMarkersAndRoute(LatLng pickUpLatLng, LatLng dropLatLng) async {
    markers.add(Marker(
      markerId: const MarkerId("pickup"),
      position: pickUpLatLng,
      infoWindow: const InfoWindow(title: "User Pickup Location"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
    ));
    markers.add(Marker(
      markerId: const MarkerId("drop"),
      position: dropLatLng,
      infoWindow: const InfoWindow(title: "User Destination"),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    ));

    final result = await LocationServices.getRouteAndDistance(pickUpLatLng, dropLatLng);

    if (result.isNotEmpty) {
      distanceText = result["distance"];
      durationText = result["duration"];

      polyline.add(Polyline(
        polylineId: const PolylineId("route"),
        points: result["polyline"],
        width: 5,
        color: Colors.blue,
      ));

      moveCameraToRoute(pickUpLatLng, dropLatLng);

      notifyListeners();
    } else {
      Fluttertoast.showToast(msg: 'Failed to fetch route.');
    }
  }

  void moveCameraToRoute(LatLng pickUpLatLng, LatLng dropLatLng) {
    if (mapController != null) {
      mapController!.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(
            pickUpLatLng.latitude < dropLatLng.latitude
                ? pickUpLatLng.latitude
                : dropLatLng.latitude,
            pickUpLatLng.longitude < dropLatLng.longitude
                ? pickUpLatLng.longitude
                : dropLatLng.longitude,
          ),
          northeast: LatLng(
            pickUpLatLng.latitude > dropLatLng.latitude
                ? pickUpLatLng.latitude
                : dropLatLng.latitude,
            pickUpLatLng.longitude > dropLatLng.longitude
                ? pickUpLatLng.longitude
                : dropLatLng.longitude,
          ),
        ),
        100,
      ));
    }
  }

  Future<void> getCurrentLocation() async {
    var locationData = await location.getLocation();

    if (locationData.latitude != null && locationData.longitude != null) {
      currentLocation = LatLng(locationData.latitude!, locationData.longitude!);

      markers.add(Marker(
        markerId: const MarkerId("current_location"),
        position: currentLocation!,
        infoWindow: const InfoWindow(title: "Your Current Location"),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
      ));

      notifyListeners();

      if (controller.isCompleted) {
        mapController = await controller.future;
        if (mapController != null) {
          mapController!.animateCamera(
            CameraUpdate.newLatLngZoom(currentLocation!, 17),
          );
        }
      }
    }
  }


  Future<String?> getAddressFromLatLng(double lat, double lang)async{

    try{
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lang);

      if(placemarks.isNotEmpty){
        Placemark place = placemarks[0];

        return "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
      }else{
        Fluttertoast.showToast(msg: 'address is null');
      }
    }catch(e){
      Fluttertoast.showToast(msg: 'Error');
    }
    return null;
  }


  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }
}
