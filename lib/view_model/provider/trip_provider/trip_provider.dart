import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tripto_driver/model/ride_request_model/trip_model.dart';
import 'package:tripto_driver/model/ride_request_model/trip_tracker_model.dart';
import 'package:tripto_driver/utils/helpers/helper_functions.dart';
import 'package:tripto_driver/view_model/provider/map_provider/maps_provider.dart';
import '../../../model/ride_request_model/active_driver_model.dart';
import '../../../notification/push_notification.dart';


class TripProvider extends ChangeNotifier{

  TripTrackerModel? trackerModel;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseDatabase realTimeDb = FirebaseDatabase.instance;
  bool isLoding = false;
  List<ActiveModel>  tripM = [];
  TripModel tripData = TripModel();
  StreamSubscription<List<TripModel>>? subscription;
  PushNotificationSystem pushNotificationSystem = PushNotificationSystem();
  final ValueNotifier<int> countdown = ValueNotifier(30);
  String? currentRideId;
  Timer? _timer;


  TripProvider() {
    getActiveDriverOnce();
  }

  Stream<List<TripModel>> getPendingRideRequests(String vehiclesType) {
    var stream = firestore
        .collection('trip')
        .where('status', isEqualTo: 'pending')
        .where('type', isEqualTo: vehiclesType)
        .snapshots()
        .map((snapshot) =>
        snapshot.docs.map((doc) => TripModel.fromMap(doc.data())).toList());

    return stream;
  }

  Future<void> isTripValid()async{

  }


  Future<void> acceptRideRequest(
      BuildContext context, String userId,
      String status,
      LatLng pickUpLatLng,
      LatLng dropLatLng,
      TripTrackerModel tripData,
      )async{

    try{
      isLoding = true;
      notifyListeners();

      await  firestore.collection('trip').doc(userId).update({'status':status});

      var doc = await firestore.collection('trip').doc(userId).get();
      if (doc.exists && doc.data()?['status'] == status) {

       await tripTracker(tripData, pickUpLatLng, dropLatLng);
       AppHelperFunctions.showSnackBar('Ride request accepted successfully');
       // pushNotificationSystem.sendOrderNotification(tripData.fcmToken!);


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


  void startCountdown() {
    _timer?.cancel();
    countdown.value = 30;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdown.value > 0) {
        countdown.value--;
      } else {
        timer.cancel();
        Fluttertoast.showToast(msg: 'Your ride request has expired.');
      }
    });
  }

  Future<void> activeDriver(ActiveModel ride)async{
    await realTimeDb.ref('activeDriver').child(ride.id!).set(ride.toJson());

  }

  Future<void> diActiveDriver(ActiveModel ride)async{
    await realTimeDb.ref('activeDriver').child(ride.id!).remove();
  }


  Future<void> tripTracker(TripTrackerModel data, LatLng pickUpLatLng, LatLng dropLatLng)async{

  try{
    await realTimeDb.ref('tripTracker').child(data.tripId!).set(data.toJson());

    await Provider.of<MapsProvider>(Get.context!,listen: false).setMarkersAndRoute(pickUpLatLng, dropLatLng);

  }catch(error){
    AppHelperFunctions.showSnackBar('Error tripTracker :-$error');
    print('Error tripTracker :-$error');
  }
}


  Future<List<ActiveModel>> getActiveDriverOnce() async {
    List<ActiveModel> drivers = [];
    try {
      final snapshot = await realTimeDb.ref('activeDriver').get();

      if (snapshot.value == null) {
        Fluttertoast.showToast(msg: 'No active drivers found');
        return [];
      }

      if (snapshot.value is Map<Object?, Object?>) {
        final Map<String, dynamic> data = jsonDecode(jsonEncode(snapshot.value));

        print("🔥 Parsed Firebase Data: $data");

        for (var entry in data.values) {
          try {
            var driverData = ActiveModel.fromJson(entry as Map<String, dynamic>);
            drivers.add(driverData);
          } catch (e) {
            print("❌ Error parsing ActiveModel: $e");
          }
        }
      } else {
        print("❌ Unexpected Data Format: ${snapshot.value}");
      }
    } catch (e) {
      print("❌ Error fetching active drivers: $e");
    }
    return drivers; // Saare drivers return karna
  }

  void getAllDriverTrip(String tripId, String driverID)async{
    var db =await firestore.collection("drivers_trip").where("tripId",isEqualTo: tripId).where("driverID",isEqualTo: driverID).where("status", isEqualTo: "pending").get();
    print("driver doc ${db.docs.length}");
    var data = db.docs.map((e) => TripModel.fromMap(e.data())).toList();
    var id = data[0].id;
    if(data.length==1){
      firestore.collection("trip").doc("$tripId").update({"status": "rejected"});
    }

    firestore.collection("drivers_trip").doc("$id").update({"status": "rejected"});


  }

  @override
  void dispose() {
    _timer?.cancel();
    countdown.dispose();
    super.dispose();
  }


}