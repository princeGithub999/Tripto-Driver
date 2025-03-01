import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';

DriverProfileModel welcomeFromJson(String str) => DriverProfileModel.fromJson(json.decode(str));

String welcomeToJson(DriverProfileModel data) => json.encode(data.toJson());

class DriverProfileModel {

  String? driverID;
  String? driverName;
  int? driverPhoneNumber;
  String? driverEmail;
  String? driverAddress;
  String? driverImage;
  String? carName;
  String? fcmToken;
  double? drCurrantLongitude;
  double? drCurrantLatitude;
  bool? isOnline;
  String? carType;

  DriverProfileModel({
    this.driverID,
    this.driverName,
    this.driverPhoneNumber,
    this.driverEmail,
    this.driverAddress,
    this.driverImage,
    this.carName,
    this.fcmToken,
    this.drCurrantLongitude,
    this.drCurrantLatitude,
    this.isOnline,
    this.carType
  });

  factory DriverProfileModel.fromJson(Map<String, dynamic> json) => DriverProfileModel(
      driverID: json["driverID"],
      driverName: json["driverName"],
      driverPhoneNumber: json["driverPhoneNumber"],
      driverEmail: json["driverEmail"],
      driverAddress: json["driverAddress"],
      driverImage: json["driverImage"],
      carName: json['carName'],
      fcmToken: json['fcmToken'],
      drCurrantLongitude: json['drCurrantLongitude'],
      drCurrantLatitude: json['drCurrantLatitude'],
    isOnline: json['isOnline'],
    carType: json['carType']
  );

  Map<String, dynamic> toJson() => {
    "driverID" : driverID,
    "driverName": driverName,
    "driverPhoneNumber": driverPhoneNumber,
    "driverEmail": driverEmail,
    "driverAddress": driverAddress,
    "carName" : carName,
    "fcmToken" :fcmToken,
    "drCurrantLongitude":drCurrantLongitude,
    "drCurrantLatitude":drCurrantLatitude,
    "isOnline" : isOnline,
    "carType" : carType
  };
}
