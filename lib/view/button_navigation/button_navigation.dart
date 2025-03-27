import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tripto_driver/view_model/provider/auth_provider_in/auth_provider.dart';
import '../../notification/push_notification.dart';
import '../../view_model/provider/map_provider/maps_provider.dart';
import '../../view_model/service/notifaction_service.dart';
import 'button_navigation_screen/earning_acc_details.dart';
import 'button_navigation_screen/maps_screen.dart';
import 'button_navigation_screen/profile_details.dart';
import 'button_navigation_screen/rating_screen.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectIndex = 0;

  LatLng defaultPickup = const LatLng(25.5941, 85.1376);
  LatLng defaultDrop = const LatLng(25.6102, 85.1415);
  PushNotificationSystem notificationService = PushNotificationSystem();


  late final List<Widget> listPage;

  @override
  void initState() {
    super.initState();

    Provider.of<AuthProviderIn>(context,listen: false).retriveDriver();

    // Provider.of<MapsProvider>(context,listen: false).getCurrentLocation();
     Provider.of<MapsProvider>(context,listen: false).determinePosition(context);
    listPage = [
      MapsScreen(pickUpLatLng: defaultPickup, dropLatLng: defaultDrop, driverId: '', ),
      const RatingScreen(),

      DriverHomePage(),
      ProfileScreen()
    ];

    notificationHandler();

  }

  void notificationHandler() {
    notificationService.initialize();
    FirebaseMessaging.onMessage.listen((message) {
      notificationService.showNotification(message);
    });
    notificationService.requestNotificationPermission();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: listPage[_selectIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        onTap: (value) {
          setState(() {
            _selectIndex = value;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: "Rating"),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance), label: "Account"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
        currentIndex: _selectIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.blue,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
