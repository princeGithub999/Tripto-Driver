import 'dart:convert';

DriverDataModel welcomeFromJson(String str) => DriverDataModel.fromJson(json.decode(str));

String welcomeToJson(DriverDataModel data) => json.encode(data.toJson());

class DriverDataModel {

  String? driverID;
  String? driverName;
  int? driverPhoneNumber;
  String? driverEmail;
  String? driverAddress;
  String? driverDateOfBirth;
  String? driverBankName;
  String? driverAccountNumber;
  String? driverIfscCode;
  String? driverUpiCode;
  String? driverImage;
  String? frontDlImage;
  String? backDlImage;
  String? dlNumber;
  String? frontVehicleRcImage;
  String? backVehicleRcImage;
  String? frontAadharCardImage;
  String? backAadharCardImage;
  String? penCardImage;
  String? carName;
  String? fcmToken;
  String? vehiclesImage;
  String? vehiclesNumber;

  DriverDataModel({
     this.driverID,
     this.driverName,
     this.driverPhoneNumber,
     this.driverEmail,
     this.driverAddress,
     this.driverDateOfBirth,
     this.driverBankName,
     this.driverAccountNumber,
     this.driverIfscCode,
     this.driverUpiCode,
     this.driverImage,
     this.frontDlImage,
     this.backDlImage,
     this.dlNumber,
     this.frontVehicleRcImage,
     this.backVehicleRcImage,
     this.frontAadharCardImage,
     this.backAadharCardImage,
     this.penCardImage,
     this.carName,
     this.fcmToken,
    this.vehiclesImage,
    this.vehiclesNumber
  });

  factory DriverDataModel.fromJson(Map<String, dynamic> json) => DriverDataModel(
    driverID: json["driverID"],
    driverName: json["driverName"],
    driverPhoneNumber: json["driverPhoneNumber"],
    driverEmail: json["driverEmail"],
    driverAddress: json["driverAddress"],
    driverDateOfBirth: json["driverDateOfBirth"],
    driverBankName: json["driverBankName"],
    driverAccountNumber: json["driverAccountNumber"],
    driverIfscCode: json["driverIfscCode"],
    driverUpiCode: json["driverUpiCode"],
    driverImage: json["driverImage"],
    frontDlImage: json["frontDlImage"],
    backDlImage: json["backDlImage"],
    dlNumber: json["dlNumber"],
    frontVehicleRcImage: json["frontVehicleRcImage"],
    backVehicleRcImage: json["backVehicleRcImage"],
    frontAadharCardImage: json["frontAadharCardImage"],
    backAadharCardImage: json["backAadharCardImage"],
    penCardImage: json["penCardImage"],
    carName: json['carName'],
    fcmToken: json['fcmToken'],
    vehiclesImage: json['vehiclesImage'],
    vehiclesNumber: json['vehiclesNumber']
  );

  Map<String, dynamic> toJson() => {
    "driverID" : driverID,
    "driverName": driverName,
    "driverPhoneNumber": driverPhoneNumber,
    "driverEmail": driverEmail,
    "driverAddress": driverAddress,
    "driverDateOfBirth": driverDateOfBirth,
    "driverBankName": driverBankName,
    "driverAccountNumber": driverAccountNumber,
    "driverIfscCode": driverIfscCode,
    "driverUpiCode": driverUpiCode,
    "driverImage": driverImage,
    "frontDlImage": frontDlImage,
    "backDlImage": backDlImage,
    "dlNumber": dlNumber,
    "frontVehicleRcImage": frontVehicleRcImage,
    "backVehicleRcImage": backVehicleRcImage,
    "frontAadharCardImage": frontAadharCardImage,
    "backAadharCardImage": backAadharCardImage,
    "penCardImage": penCardImage,
    "carName" : carName,
    "fcmToken" :fcmToken,
    "vehiclesImage" : vehiclesImage,
    "vehiclesNumber" : vehiclesNumber
  };
}
