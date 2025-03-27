import 'dart:convert';

VehiclesModel vehiclesModelFromJson(String str) => VehiclesModel.fromJson(json.decode(str));

String vehiclesModelToJson(VehiclesModel data) => json.encode(data.toJson());

class VehiclesModel {
  String? id;
  String? driverToken;
  String? driverId;
  String? rcImageFront;
  String? rcImageBack;
  bool? status;
  String? type;
  String? vehicleNumber;
  String? vehicleImage;

  VehiclesModel({
    this.id,
    this.driverToken,
    this.driverId,
    this.rcImageFront,
    this.rcImageBack,
    this.status,
    this.type,
    this.vehicleNumber,
    this.vehicleImage
  });

  factory VehiclesModel.fromJson(Map<String, dynamic> json) => VehiclesModel(
    id: json["id"],
    driverToken: json["driver_id_token"],
    driverId: json["driver_id"],
    rcImageFront: json["rcImageFront"],
    rcImageBack: json["rcImageBack"],
    status: json["status"],
    type: json["type"],
    vehicleNumber: json["vehicle_number"],
    vehicleImage: json['vehicleImage']
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "driver_id_token": driverToken,
    "driver_id": driverId,
    "rcImageFront": rcImageFront,
    "rcImageBack": rcImageBack,
    "status": status,
    "type": type,
    "vehicle_number": vehicleNumber,
    "vehicleImage" : vehicleImage
  };
}