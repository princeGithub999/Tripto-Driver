import 'package:cloud_firestore/cloud_firestore.dart';

class RideRequestModel {
  String id;
  String userId;
  String userName;
  double pickupLat;
  double pickupLng;
  double dropLat;
  double dropLng;
  String status;
  Timestamp createdAt;
  String vehicleType;
  String? driverId;
  String? fcmToken;

  RideRequestModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropLat,
    required this.dropLng,
    required this.status,
    required this.createdAt,
    required this.vehicleType,
    this.driverId,
    this.fcmToken
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'pickupLat': pickupLat,
      'pickupLng': pickupLng,
      'dropLat': dropLat,
      'dropLng': dropLng,
      'status': status,
      'createdAt': createdAt,
      'type': vehicleType,
      'driverID': driverId,
      'fcmToken': fcmToken
    };
  }

  factory RideRequestModel.fromMap(Map<String, dynamic> map,) {
    return RideRequestModel(
        id: map['id'],
        userId: map['userId'],
        userName: map['userName'],
        pickupLat: map['pickupLat'],
        pickupLng: map['pickupLng'],
        dropLat: map['dropLat'],
        dropLng: map['dropLng'],
        status: map['status'],
        createdAt: map['createdAt'],
        vehicleType: map['type'],
        driverId: map['driverID'],
        fcmToken: map['fcmToken']
        );
    }
}
