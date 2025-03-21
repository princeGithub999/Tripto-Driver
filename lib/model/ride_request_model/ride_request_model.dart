import 'package:cloud_firestore/cloud_firestore.dart';

class TripModel {
  String? id;
  String? userId;
  String? userName;
  double? pickupLat;
  double? pickupLng;
  double? dropLat;
  double? dropLng;
  String? status;
  Timestamp? createdAt;
  String? vehicleType;
  String? driverId;
  String? fcmToken;

  TripModel({
     this.id,
     this.userId,
     this.userName,
     this.pickupLat,
     this.pickupLng,
     this.dropLat,
     this.dropLng,
     this.status,
     this.createdAt,
     this.vehicleType,
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

  factory TripModel.fromMap(Map<String, dynamic> map,) {
    return TripModel(
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
