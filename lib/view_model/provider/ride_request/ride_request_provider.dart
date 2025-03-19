import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:tripto_driver/model/ride_request_model/ride_request_model.dart';

class RideRequestProvider extends ChangeNotifier{

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<RideRequestModel>> getPendingRideRequests() {
    return FirebaseFirestore.instance
        .collection('ride_requests')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => RideRequestModel.fromMap(doc.data())).toList());
  }


}