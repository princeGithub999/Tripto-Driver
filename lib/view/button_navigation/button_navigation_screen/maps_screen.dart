import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tripto_driver/model/ride_request_model/trip_model.dart';
import 'package:tripto_driver/utils/helpers/helper_functions.dart';
import 'package:tripto_driver/view_model/provider/auth_provider_in/auth_provider.dart';
import 'package:tripto_driver/view_model/provider/map_provider/maps_provider.dart';
import 'package:uuid/uuid.dart';
import '../../../model/ride_request_model/trip_tracker_model.dart';
import '../../../notification/push_notification.dart';
import '../../../utils/constants/colors.dart';
import '../../../view_model/provider/trip_provider/trip_provider.dart';
import '../../screen/user_get_otp.dart';

class MapsScreen extends StatefulWidget {
  final LatLng pickUpLatLng;
  final LatLng dropLatLng;
  final String driverId;

  const MapsScreen({
    super.key,
    required this.pickUpLatLng,
    required this.dropLatLng,
    required this.driverId,
  });

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> with SingleTickerProviderStateMixin {
  GoogleMapController? mapController;
  bool isRideAccepted = false;
  PushNotificationSystem pushNotificationSystem = PushNotificationSystem();
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  var tripId = Uuid().v4();
  var auth = FirebaseAuth.instance.currentUser?.uid;
  Timer? trackingTimer;
  bool isAccept = false;
  String acceptUserName = "";
  String acceptUserImage = "";
  String acceptUserPhone = "";
  double? acceptUserPickupLat;
  double? acceptUserPickupLang;
  double? acceptUserDropLat;
  double? acceptUserDropLang;



  @override
  void initState() {
    super.initState();
   var  p = Provider.of<MapsProvider>(context, listen: false).determinePosition(context);

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animationController, curve: Curves.easeInOut));


  }



  void showRideRequests() {
    _animationController.forward();
  }

  void hideRideRequests() {
    _animationController.reverse();
  }




  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    var sizes = MediaQuery.of(context).size;
    return Consumer<MapsProvider>(
      builder: (BuildContext context, mapProvider, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: InkWell(
                child: Text("Location sharing ${mapProvider.isOnline ? ' Enable' : 'Disable'}. Tap here")),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: CupertinoSwitch(
                  value: mapProvider.isOnline,
                  onChanged: (value) {
                    mapProvider.toggleOnlineStatus(value,context);
                  },
                  activeColor: Colors.green,
                ),
              ),
            ],
          ),

          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: mapProvider.initialPosition ?? CameraPosition(target: LatLng(0, 0), zoom: 2),
                mapType: MapType.normal,
                myLocationEnabled: false,
                onMapCreated: (GoogleMapController controller) {
                  mapProvider.googleMapController = controller;
                  mapProvider.controller.complete(controller);
                },
                markers: mapProvider.markers,
                polylines: mapProvider.polyline,
              ),

              Consumer<TripProvider>(
                builder: (BuildContext context, rideRequest, Widget? child) {

                  return Consumer<AuthProviderIn>(
                    builder: (BuildContext context, authProvider, Widget? child) {
                      var type = authProvider.vehiclesModels.type ?? '';
                      return Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: StreamBuilder<List<TripModel>>(
                          stream: rideRequest.getPendingRideRequests(type),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              hideRideRequests();
                              return const SizedBox();
                            }

                            var latestRide = snapshot.data!.last;
                            showRideRequests();

                            if(rideRequest.currentRideId != latestRide.id){
                              rideRequest.currentRideId = latestRide.id;
                              rideRequest.startCountdown();
                            }

                            var startLocationFormat = mapProvider.getAddressFromLatLng(latestRide.pickupLat!, latestRide.pickupLng!);
                            var endLocationFormat = mapProvider.getAddressFromLatLng(latestRide.dropLat!, latestRide.dropLng!);

                            for (int i = 0; i < snapshot.data!.length; i++) {
                              if(i == snapshot.data?.length){

                                Fluttertoast.showToast(msg: 'Reject');
                              }else{
                                Fluttertoast.showToast(msg: ' ride rejected from your side');

                              }
                              print("Index: $i, Trip ID: ${snapshot.data![i].id}");
                            }

                            return SlideTransition(
                                position: _slideAnimation,
                                child: Container(
                                  height: sizes.height * 0.4 - 50,
                                  padding: const EdgeInsets.all(10),
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                                  ),
                                  child:  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: sizes.height * 0.1 - 70),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            "New Ride Request",
                                            style: GoogleFonts.aBeeZee(fontSize: 18, fontWeight: FontWeight.bold),
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.timer, color: Colors.red),
                                              SizedBox(width: 5),
                                              ValueListenableBuilder<int>(
                                                valueListenable: rideRequest.countdown,
                                                builder: (context, value, child) {
                                                  return Text(
                                                    "Expires in: $value sec",
                                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                                                  );
                                                },
                                              ),
                                            ],
                                          ),

                                        ],
                                      ),
                                      const SizedBox(height: 5),
                                      const Divider(),
                                      const SizedBox(height: 10),

                                      Row(
                                        children: [
                                          const CircleAvatar(
                                            maxRadius: 30,
                                            backgroundColor: AppColors.blue900,
                                            child: Icon(Icons.person, color: Colors.white),
                                          ),
                                          const SizedBox(width: 15),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text('${latestRide.userName}', style: GoogleFonts.aBeeZee(fontSize: 18, fontWeight: FontWeight.bold)),
                                              Text('Cash Payment', style: GoogleFonts.aBeeZee()),
                                            ],
                                          )
                                        ],
                                      ),

                                      const SizedBox(height: 10),

                                      Row(
                                        children: [
                                          const Icon(Icons.pin_drop),
                                          const SizedBox(width: 5),
                                          Text("Pickup: ${latestRide.pickupAddress}", style: const TextStyle(fontSize: 16)),
                                        ],
                                      ),
                                      const SizedBox(height: 10),

                                      Row(
                                        children: [
                                          const Icon(Icons.local_fire_department_rounded),
                                          const SizedBox(width: 5),
                                          Text("Drop: ${latestRide.dropAddress}", style: const TextStyle(fontSize: 16)),
                                        ],
                                      ),
                                      const SizedBox(height: 20),

                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {

                                              },
                                              style: ElevatedButton.styleFrom(
                                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                                  backgroundColor: Colors.red
                                              ),
                                              child: const Text("Cancel", style: TextStyle(fontSize: 18, color: Colors.white)),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Consumer<TripProvider>(
                                              builder: (context, rideRequest, child) {

                                                  trackingTimer = Timer.periodic(Duration(seconds: 60), (timer)async {
                                                    mapProvider.updateTripTracker(mapProvider.currentLocation!.latitude, mapProvider.currentLocation!.longitude, latestRide.id!);
                                                  },);

                                                return Consumer<MapsProvider>(
                                                  builder: (BuildContext context, value, Widget? child) {
                                                    return ElevatedButton(
                                                      onPressed: () async {


                                                        var tripData = TripTrackerModel(
                                                            tripId: latestRide.id,
                                                            driverName: authProvider.driverModels.driverFirstName,
                                                            startLocationLang: latestRide.pickupLat,
                                                            startLocationLat: latestRide.pickupLng,
                                                            startLocationFormat: await startLocationFormat,
                                                            endLocationFormat: await endLocationFormat,
                                                            endLocationLang: latestRide.dropLng,
                                                            endLocationLat: latestRide.dropLat,
                                                            currentLocationLang: value.currentLocation?.longitude,
                                                            currentLocationLat: value.currentLocation?.latitude,
                                                            status: 'accepted',
                                                            fcmToken: latestRide.fcmToken

                                                        );
                                                        LatLng defaultPickup =  LatLng(latestRide.pickupLat!, latestRide.pickupLng!);
                                                        LatLng defaultDrop =  LatLng(latestRide.dropLat!, latestRide.dropLng!);
                                                        await rideRequest.acceptRideRequest(
                                                            context,
                                                            latestRide.id!,
                                                            'accept',
                                                            defaultPickup,
                                                            defaultDrop,
                                                            tripData
                                                        );


                                                        acceptUserName = latestRide.userName ?? 'Anowen';
                                                        acceptUserPickupLang = latestRide.pickupLng;
                                                        acceptUserPickupLat = latestRide.pickupLat;
                                                        acceptUserDropLang = latestRide.dropLng;
                                                        acceptUserDropLat = latestRide.dropLat;
                                                         isAccept = true;
                                                        setState(() {

                                                        });

                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                                        backgroundColor: Colors.green,
                                                      ),
                                                      child: rideRequest.isLoding
                                                          ? const SizedBox(
                                                        height: 21,
                                                        width: 21,
                                                        child: CircularProgressIndicator(
                                                          color: Colors.white,
                                                        ),
                                                      )
                                                          : const Text("Accept", style: TextStyle(fontSize: 18, color: Colors.white)),
                                                    );
                                                  },

                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                            );
                          },
                        ),
                      );
                    },
                  );
                },
              ),

              Positioned(
                top: 10,
                left: 5,
                right: 5,
                child: Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Distance: ${mapProvider.distanceText}, ETA: ${mapProvider.durationText}",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: sizes.width * 0.1),
                      Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: mapProvider.isOnline ? Colors.green : Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        mapProvider.isOnline ? "Online" : "Offline",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: mapProvider.isOnline ? Colors.green : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              isAccept ?
              Stack(
                children: [
                  Consumer<AuthProviderIn>(
                    builder: (BuildContext context, authProvider, Widget? child) {
                      return  Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                            height: sizes.height * 0.3 - 50,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(topRight: Radius.circular(10),topLeft: Radius.circular(10))
                            ),
                            child: Column(
                              children: [

                                SizedBox(height: 10,),
                                Text('Go to Pickup Location',
                                  style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold,fontSize: 16),
                                ),

                                Padding(padding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),

                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          const CircleAvatar(
                                            maxRadius: 28,
                                            backgroundColor: AppColors.blue900,
                                            child: Icon(CupertinoIcons.person,color: Colors.white,),
                                          ),

                                          // SizedBox(width: 10,),
                                          Text(acceptUserName,
                                            style: GoogleFonts.aBeeZee(fontWeight: FontWeight.bold,fontSize: 15),
                                          ),

                                          IconButton(onPressed: () {
                                            mapProvider.openGoogleMapsApp(acceptUserPickupLat!, acceptUserPickupLang!);
                                          }, icon: Icon(CupertinoIcons.location_circle_fill,size: 50,color: AppColors.blue900,))

                                        ],
                                      ),

                                      SizedBox(height: 15,),
                                      mapProvider.isArivePickup ?

                                      SwipeButton(
                                        activeTrackColor: Colors.blueGrey,
                                        inactiveTrackColor: Colors.blueGrey,
                                        activeThumbColor: AppColors.blue900,
                                        trackPadding: const EdgeInsets.all(6),
                                        elevationThumb: 2,
                                        elevationTrack: 2,

                                        child: const Text(
                                          "Go to drop location",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),

                                        onSwipe: () {
                                          authProvider.supaOtp('9798677908',false);
                                        },
                                      ) :
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                mapProvider.takeCall('9798677908');
                                              },
                                              style: ElevatedButton.styleFrom(
                                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                                  backgroundColor: Colors.blueGrey
                                              ),
                                              child: const Text("Call Now", style: TextStyle(fontSize: 18, color: Colors.white)),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: Consumer<TripProvider>(
                                              builder: (context, rideRequest, child) {

                                                return Consumer<MapsProvider>(
                                                  builder: (BuildContext context, value, Widget? child) {
                                                    return ElevatedButton(
                                                      onPressed: () async {


                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        padding: const EdgeInsets.symmetric(vertical: 10),
                                                        backgroundColor: Colors.blueGrey,
                                                      ),
                                                      child: rideRequest.isLoding
                                                          ? const SizedBox(
                                                        height: 21,
                                                        width: 21,
                                                        child: CircularProgressIndicator(color: Colors.white,),
                                                      )
                                                          : const Text("Message", style: TextStyle(fontSize: 18, color: Colors.white)),
                                                    );
                                                  },

                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),

                                )
                              ],
                            )
                        ),
                      );
                    },
                  ),
                ],
              ) :
                  SizedBox()

            ],
          ),
        );
      },
    );
  }
}
