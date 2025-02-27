import 'package:firebase_database/firebase_database.dart';

class DriverDataModel {
  String driverID;
  String driverName;
  int driverPhoneNumber;
  String driverEmail;
  String driverAddress;
  String driverDateOfBirth;
  String driverBankName;
  String driverAccountNumber;
  String driverIfscCode;
  String driverUpiCode;
  String dlNumber;
  bool isOnline;

  DriverDataModel({
    required this.driverID,
    required this.driverName,
    required this.driverPhoneNumber,
    required this.driverEmail,
    required this.driverAddress,
    required this.driverDateOfBirth,
    required this.driverBankName,
    required this.driverAccountNumber,
    required this.driverIfscCode,
    required this.driverUpiCode,
    required this.dlNumber,
    required this.isOnline,
  });

  // Convert a DriverDataModel to a Map for Firebase
  Map<String, dynamic> toMap() {
    return {
      "driverID": driverID,
      "driverName": driverName,
      "driverPhoneNumber": driverPhoneNumber,
      "driverEmail": driverEmail,
      "driverAddress": driverAddress,
      "driverDateOfBirth": driverDateOfBirth,
      "driverBankName": driverBankName,
      "driverAccountNumber": driverAccountNumber,
      "driverIfscCode": driverIfscCode,
      "driverUpiCode": driverUpiCode,
      "dlNumber": dlNumber,
      "isOnline": isOnline,
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
      driverDateOfBirth: data?["driverDateOfBirth"] ?? "",
      driverBankName: data?["driverBankName"] ?? "",
      driverAccountNumber: data?["driverAccountNumber"] ?? "",
      driverIfscCode: data?["driverIfscCode"] ?? "",
      driverUpiCode: data?["driverUpiCode"] ?? "",
      dlNumber: data?["dlNumber"] ?? "",
      isOnline: data?["isOnline"] ?? false,
    );
  }
}
