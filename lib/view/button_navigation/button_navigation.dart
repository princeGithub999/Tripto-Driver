import 'package:flutter/material.dart';
import 'package:tripto_driver/view/button_navigation/button_navigation_screen/earning_acc_details.dart';
import 'package:tripto_driver/view/button_navigation/button_navigation_screen/rating_screen.dart';
import 'button_navigation_screen/map_screen.dart';
import 'button_navigation_screen/profile_details.dart';


class BottomNavigation extends StatefulWidget {
  const BottomNavigation({super.key});

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {
  int _selectIndex=0;
  var listPage = [
    const MapScreen(),
    const EarningAccDetails(),
    const RatingScreen(),
    ProfileDetailsScreen()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: listPage[_selectIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        onTap: (value){
          setState(() {
            _selectIndex=value;
          });
        },
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_balance),
              label: "Account"
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.star),
              label: "Rating"
          ),

          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: "Profile"
          ),
        ],
        currentIndex: _selectIndex,
        unselectedItemColor: Colors.grey,
        selectedItemColor: Colors.blue,type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
