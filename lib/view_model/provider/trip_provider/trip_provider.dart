import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:tripto_driver/model/ride_request_model/ride_request_model.dart';
import 'package:tripto_driver/utils/helpers/helper_functions.dart';

import '../../../model/ride_request_model/active_driver_model.dart';

class TripProvider extends ChangeNotifier{

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseDatabase realTimeDb = FirebaseDatabase.instance;
  bool isLoding = false;

  Stream<List<TripModel>> getPendingRideRequests() {
    return firestore
        .collection('trip')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => TripModel.fromMap(doc.data())).toList());
  }


  Future<void> acceptRideRequest(String userId, String status)async{


    try{
      isLoding = true;
      notifyListeners();

    await  firestore.collection('trip').doc(userId).update({'status':status});

      var doc = await firestore.collection('trip').doc(userId).get();
      if (doc.exists && doc.data()?['status'] == status) {
        AppHelperFunctions.showSnackBar('Ride request accepted successfully');
      } else {
        AppHelperFunctions.showSnackBar('Failed to accept ride request');
      }

    }catch(error){
      AppHelperFunctions.showSnackBar('Error $error');
    }finally{
      isLoding = false;
      notifyListeners();
    }
  }


  Future<void> activeDriver(ActiveModel ride)async{
    await realTimeDb.ref('activeDriver').child(ride.id!).set(ride.toJson());

  }

  Future<void> diActiveDriver(ActiveModel ride)async{

    await realTimeDb.ref('activeDriver').child(ride.id!).remove();
  }

}