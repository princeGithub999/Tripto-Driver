import 'dart:convert';

TripTrackerModel tripTrackerModelFromJson(String str) => TripTrackerModel.fromJson(json.decode(str));

String tripTrackerModelToJson(TripTrackerModel data) => json.encode(data.toJson());

class TripTrackerModel {
  String? tripId;
  String? driverName;
  double? startLocationLat;
  double? startLocationLang;
  double? endLocationLat;
  double? endLocationLang;
  double? currentLocationLat;
  double? currentLocationLang;
  String? status;

  TripTrackerModel({
    this.tripId,
    this.driverName,
    this.startLocationLat,
    this.startLocationLang,
    this.endLocationLat,
    this.endLocationLang,
    this.currentLocationLat,
    this.currentLocationLang,
    this.status
  });

  factory TripTrackerModel.fromJson(Map<String, dynamic> json) => TripTrackerModel(
    tripId: json["tripId"],
    driverName: json["driverName"],
    startLocationLat: json["startLocationLat"]?.toDouble(),
    startLocationLang: json["startLocationLang"]?.toDouble(),
    endLocationLat: json["endLocationLat"]?.toDouble(),
    endLocationLang: json["endLocationLang"]?.toDouble(),
    currentLocationLat: json["currentLocationLat"]?.toDouble(),
    currentLocationLang: json["currentLocationLang"]?.toDouble(),
    status: json['status']
  );

  Map<String, dynamic> toJson() => {
  "tripId": tripId,
  "driverName": driverName,
  "startLocationLat": startLocationLat,
  "startLocationLang": startLocationLang,
  "endLocationLat": endLocationLat,
  "endLocationLang": endLocationLang,
  "currentLocationLat": currentLocationLat,
  "currentLocationLang": currentLocationLang,
    "status":status
  };
}
