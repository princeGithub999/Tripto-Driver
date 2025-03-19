import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tripto_driver/model/ride_request_model/ride_request_model.dart';
import 'package:tripto_driver/utils/helpers/helper_functions.dart';

class RideRequestProvider extends ChangeNotifier{

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  bool isLoding = false;

  Stream<List<RideRequestModel>> getPendingRideRequests() {
    return firestore
        .collection('ride_requests')
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => RideRequestModel.fromMap(doc.data())).toList());
  }


  Future<void> acceptRideRequest(String userId, String status)async{


    try{
      isLoding = true;
      notifyListeners();

    await  firestore.collection('ride_requests').doc(userId).update({'status':status});

      var doc = await firestore.collection('ride_requests').doc(userId).get();
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


}