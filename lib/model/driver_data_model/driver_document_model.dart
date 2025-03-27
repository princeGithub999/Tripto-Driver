import 'dart:convert';

DriverDocumentModel driverDocumentModelFromJson(String str) => DriverDocumentModel.fromJson(json.decode(str));

String driverDocumentModelToJson(DriverDocumentModel data) => json.encode(data.toJson());

class DriverDocumentModel {
  String? id;
  String? driverId;
  String? adharBack;
  String? adharFront;
  String? pen;
  String? driverLicence;
  bool? isAdharVerifide;
  bool? isPanVerifide;
  bool? isDriverLicenceVerifide;

  DriverDocumentModel({
    this.id,
    this.driverId,
    this.adharBack,
    this.adharFront,
    this.pen,
    this.driverLicence,
    this.isAdharVerifide,
    this.isPanVerifide,
    this.isDriverLicenceVerifide,
  });

  factory DriverDocumentModel.fromJson(Map<String, dynamic> json) => DriverDocumentModel(
    id: json["id"],
    driverId: json['driverId'],
    adharBack: json["adhar_back"],
    adharFront: json["adhar_front"],
    pen: json["pen"],
    driverLicence: json["driver_licence"],
    isAdharVerifide: json["is_adhar_verifide"],
    isPanVerifide: json["is_pan_verifide"],
    isDriverLicenceVerifide: json["is_driver_licence_verifide"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "driverId" : driverId,
    "adhar_back": adharBack,
    "adhar_front": adharFront,
    "pen": pen,
    "driver_licence": driverLicence,
    "is_adhar_verifide": isAdharVerifide,
    "is_pan_verifide": isPanVerifide,
    "is_driver_licence_verifide": isDriverLicenceVerifide,
  };
}
