import 'package:firebase_database/firebase_database.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverDataModel {
  String? driverID;
  String? driverName;
  int? driverPhoneNumber;
  String? driverEmail;
  String? driverAddress;
  bool? isOnline;
  LatLng? driverCurrentLocation;

  DriverDataModel({
    this.driverID,
    this.driverName,
    this.driverPhoneNumber,
    this.driverEmail,
    this.driverAddress,
    this.isOnline,
    this.driverCurrentLocation
  });

  // Convert a DriverDataModel to a Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      "driverID": driverID,
      "driverName": driverName,
      "driverPhoneNumber": driverPhoneNumber,
      "driverEmail": driverEmail,
      "driverAddress": driverAddress,
      "isOnline": isOnline,
      "driverCurrentLocation" : driverCurrentLocation
    };
  }

  // Convert Firebase snapshot data to a DriverDataModel
  factory DriverDataModel.fromSnapshot(DataSnapshot snapshot) {
    Map<dynamic, dynamic>? data = snapshot.value as Map<dynamic, dynamic>?;

    return DriverDataModel(
      driverID: data?["driverID"] ?? "",
      driverName: data?["driverName"] ?? "",
      driverPhoneNumber: data?["driverPhoneNumber"] ?? 0,
      driverEmail: data?["driverEmail"] ?? "",
      driverAddress: data?["driverAddress"] ?? "",
      isOnline: data?["isOnline"] ?? false,
      driverCurrentLocation: data?['driverCurrentLocation']
    );
  }
}
