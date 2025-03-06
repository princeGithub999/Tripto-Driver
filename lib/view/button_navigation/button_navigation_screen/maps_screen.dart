import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tripto_driver/view_model/provider/map_provider/maps_provider.dart';
import 'package:tripto_driver/view_model/service/auth_service.dart';

import '../../../model/driver_data_model/driver_profile_model.dart';
import '../../../utils/globle_widget/ride_accpated_buttom_sheet.dart';



class MapsScreen extends StatefulWidget {
  final LatLng pickUpLatLng;
  final LatLng dropLatLng;
  final String driverId; // Added driverId to track the specific driver in Firebase

  const MapsScreen({
    super.key,
    required this.pickUpLatLng,
    required this.dropLatLng,
    required this.driverId, // Required parameter for Firebase tracking
  });

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  GoogleMapController? mapController;
  bool isRideAccepted = false;  // Added this variable

  @override
  void initState() {
    super.initState();
    Provider.of<MapsProvider>(context,listen: false).setMarkersAndRoute(widget.pickUpLatLng,widget.dropLatLng);
  }
  // Add this method to show bottom sheet
  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 10),
            Container(
              height: 5,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Ride Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Add your ride details widgets here
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // AuthService authService = AuthService();
    var sizes = MediaQuery.of(context).size;
   // var auht = FirebaseAuth.instance.currentUser!.uid;
    return Consumer<MapsProvider>(
      builder: (BuildContext context, mapProvider, Widget? child) {
        // Add this listener
        if (isRideAccepted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showBottomSheet();
            isRideAccepted = false; // Reset the value after showing
          });
        }

        return Scaffold(
          appBar: AppBar(
            title:  InkWell(
                // onTap: () {
                //   var realTimeData = DriverProfileModel(
                //       driverID: 'cvbn',
                //       driverName: 'cvbnm',
                //       driverPhoneNumber: 1233,
                //       driverAddress: 'xcvbnm',
                //       driverImage: 'cvbn',
                //       fcmToken: 'token',
                //       isOnline: false,
                //       carName: 'driverData',
                //       drCurrantLatitude: mapProvider.currentLocation?.latitude,
                //       drCurrantLongitude: mapProvider.currentLocation?.longitude,
                //   );
                //
                //   authService.saveDriverDataInRealTime(auht, realTimeData);
                //
                // },
                child: Text("Location sharing ${mapProvider.isOnline ? ' Enable' :'Disable'}. Tap hare")),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: CupertinoSwitch(
                  value: mapProvider.isOnline,
                  onChanged: (value) {
                    mapProvider.toggleOnlineStatus(value);
                  },
                  activeColor: Colors.green,
                ),
              ),

            ],
          ),
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: mapProvider.isOnline
                      ? (mapProvider.currentLocation??LatLng(25.6102, 85.1415))
                      : const LatLng(25.6102, 85.1415),
                  zoom: 15,
                ),
                onMapCreated: (controller) {
                  mapProvider.onMapCreated(controller);
                },

                markers: mapProvider.markers,
                polylines: mapProvider.polyline,
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
                      const SizedBox(width: 5,),
                      Text(
                      mapProvider. isOnline ? "Online" : "Offline",
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
              Positioned(child:
              ElevatedButton(onPressed: () {
                RideAccpatedButtomSheet().showRideRequestBottomSheet(context);
              }, child: const Text('Click'))
        
         )
            ],
          ),
        );
      },
    );
  }
}