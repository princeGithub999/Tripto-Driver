import 'dart:convert';
import 'package:tripto_driver/model/driver_data_model/driver_address_model.dart';

/// JSON se DriverModel convert karne ke liye helper functions
DriverModel driverProfileFromJson(String str) => DriverModel.fromJson(json.decode(str));
String driverProfileToJson(DriverModel data) => json.encode(data.toJson());

class DriverModel {
  DriverAddressModel? address;
  String? fcmToken;
  String? driverEmail;
  String? driverFirstName;
  String? driverLastName;
  String? driverGender;
  String? driverID;
  bool? isVerified;
  int? driverPhoneNumber;
  String? driverImage;
  String? vehiclesId;
  String? documentId;

  DriverModel({
    this.address,
    this.fcmToken,
    this.driverEmail,
    this.driverFirstName,
    this.driverLastName,
    this.driverGender,
    this.driverID,
    this.isVerified,
    this.driverPhoneNumber,
    this.driverImage,
    this.vehiclesId,
    this.documentId,
  });

  /// ✅ **Fixed fromJson method**
  factory DriverModel.fromJson(Map<String, dynamic> json) => DriverModel(
    address: json["address"] != null
        ? DriverAddressModel.fromJson(Map<String, dynamic>.from(json["address"])) // ✅ FIXED: Ensure proper Map<String, dynamic>
        : null,
    fcmToken: json["fcmToken"],
    driverEmail: json["driverEmail"],
    driverFirstName: json["driverFirstName"],
    driverLastName: json["driverLastName"],
    driverGender: json["driverGender"],
    driverID: json["driverID"],
    isVerified: json["isVerified"],
    driverPhoneNumber: json["driverPhoneNumber"] != null
        ? int.tryParse(json["driverPhoneNumber"].toString())
        : null,
    driverImage: json["driverImage"],
    vehiclesId: json["vehiclesId"],
    documentId: json["documentId"],
  );

  /// ✅ **Fixed toJson method**
  Map<String, dynamic> toJson() => {
    "address": address?.toJson(),
    "fcmToken": fcmToken,
    "driverEmail": driverEmail,
    "driverFirstName": driverFirstName,
    "driverLastName": driverLastName,
    "driverGender": driverGender,
    "driverID": driverID,
    "isVerified": isVerified,
    "driverPhoneNumber": driverPhoneNumber?.toString(),
    "driverImage": driverImage,
    "vehiclesId": vehiclesId,
    "documentId": documentId,
  };
}
