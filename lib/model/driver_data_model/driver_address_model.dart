 import 'dart:convert';

DriverAddressModel welcomeFromJson(String str) => DriverAddressModel.fromJson(json.decode(str));

String welcomeToJson(DriverAddressModel data) => json.encode(data.toJson());

class DriverAddressModel {
  String? vill;
  String? post;
  String? policeStation;
  String? district;
  String? state;
  int? pinCode;
  double? lang;
  double? lat;

  DriverAddressModel({
    this.vill,
    this.post,
    this.policeStation,
    this.district,
    this.state,
    this.pinCode,
    this.lang,
    this.lat
  });

  factory DriverAddressModel.fromJson(Map<String, dynamic> json) => DriverAddressModel(
    vill: json["vill"],
    post: json["post"],
    policeStation: json["police_station"],
    district: json["district"],
    state: json["state"],
    pinCode: json["pinCode"],
    lang: json['lang'],
    lat: json['lat']
  );

  Map<String, dynamic> toJson() => {
    "vill": vill,
    "post": post,
    "police_station": policeStation,
    "district": district,
    "state": state,
    "pinCode": pinCode,
    "lang":lang,
    "lat":lat
  };
}
