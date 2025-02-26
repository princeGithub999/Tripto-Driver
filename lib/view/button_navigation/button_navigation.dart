import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'button_navigation_screen/earning_acc_details.dart';
import 'button_navigation_screen/map_screen.dart';
import 'button_navigation_screen/profile_details.dart';
import 'button_navigation_screen/rating_screen.dart';

class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectIndex = 0;

  // Provide default LatLng values
  LatLng defaultPickup = const LatLng(25.5941, 85.1376); // Example coordinates (Patna, Bihar)
  LatLng defaultDrop = const LatLng(25.6102, 85.1415); // Example coordinates

  late final List<Widget> listPage;

  @override
  void initState() {
    super.initState();
    listPage = [
      DriverMapScreen(pickUpLatLng: defaultPickup, dropLatLng: defaultDrop, driverId: '', driverName: '',),
      RatingScreen(),
      DriverHomeScreen(driverId: '',),
      ProfileScreen()
    ];
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
