import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tripto_driver/utils/constants/colors.dart';
import 'package:tripto_driver/view_model/provider/auth_provider_in/auth_provider.dart';
import '../../../model/ride_request_model/active_driver_model.dart';
import '../../../view_model/provider/trip_provider/trip_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _profileImage;


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      var authProvider = Provider.of<AuthProviderIn>(context, listen: false);
      String? driverId = FirebaseAuth.instance.currentUser?.uid;
      if (driverId != null) {
        authProvider.fetchLiveProfileData(driverId);
      }
    });
  }


  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    Provider.of<TripProvider>(context, listen: false).getActiveDriverOnce();
  }


        return Scaffold(
          backgroundColor: Colors.grey[200],
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildProfileHeader(data),
                const SizedBox(height: 30),
                _buildProfileOption(Icons.directions_car, "My Rides"),
                _buildProfileOption(Icons.wallet, "Earnings"),
                _buildProfileOption(Icons.history, "Ride History"),
                _buildProfileOption(Icons.notifications, "Notifications"),
                _buildProfileOption(Icons.support, "Support"),
                _buildProfileOption(Icons.settings, "Settings"),
                const SizedBox(height: 20),
                _buildLogoutButton(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfileHeader(driverData) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
      color: AppColors.blue900,
      child: Row(
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: 55,
              backgroundColor: Colors.white,
              backgroundImage: _profileImage != null
                  ? FileImage(_profileImage!)
                  : (driverData?.driverImage != null
                  ? NetworkImage(driverData!.driverImage!) as ImageProvider
                  : null),
              child: _profileImage == null && driverData?.driverImage == null
                  ? const Icon(Icons.person, size: 55, color: Colors.grey)
                  : null,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  driverData?.driverName ?? "Driver Name",
                  style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 4),
                Text(
                  driverData?.driverPhoneNumber.toString() ?? "Not Available",
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: ListTile(
        leading: Icon(icon, size: 30, color: AppColors.blue900),
        title: Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
        onTap: () {
          // TODO: Add navigation logic
        },
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.blue900,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.symmetric(vertical: 14),
          minimumSize: const Size(double.infinity, 50),
        ),
        onPressed: () {
          // TODO: Add logout logic
        },
        child: const Text(
          "Logout",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
    );
  }
}


// class VehicleDetailsScreen extends StatelessWidget {
//   const VehicleDetailsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text("Vehicle Details"),
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               const TextField(
//                 decoration: InputDecoration(
//                     labelText: "Vehicle Number",
//                     border: OutlineInputBorder()),
//               ),
//               const SizedBox(height: 20),
//               const TextField(
//                 decoration: InputDecoration(
//                     labelText: "Vehicle Model",
//                     border: OutlineInputBorder()),
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                   onPressed: () {},
//                   child: const Text("Save Vehicle Details")),
//             ],
//           ),
//         ),
//         );
//     }
// }
=======

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 50, bottom: 16, left: 16, right: 16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blueAccent, Colors.teal],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Consumer2<AuthProviderIn, TripProvider>(
                builder: (context, authProvider, tripProvider, child) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: _pickImage,
                            child: CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.white,
                              backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                              child: _profileImage == null
                                  ? const Icon(Icons.person, size: 40, color: Colors.grey)
                                   : null,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  authProvider.driverModels.driverFirstName ?? "Unknown",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  authProvider.driverModels.address?.vill ?? "No Address",
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                Text(
                                  authProvider.vehiclesModels.type ?? "No Vehicle Type",
                                  style: const TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Active Trips",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 10),

                      Consumer<TripProvider>(
                        builder: (BuildContext context, value, Widget? child) {
                          return ElevatedButton(
                            onPressed: () async {
                              List<ActiveModel> drivers = await tripProvider.getActiveDriverOnce();

                              if (drivers.isEmpty) {
                                Fluttertoast.showToast(msg: 'No active drivers found');
                                return;
                              }

                              for (var driver in drivers) {
                                Fluttertoast.showToast(msg: 'Driver: ${driver.driver?.fullName}');
                                await Future.delayed(Duration(seconds: 1)); // Thoda delay taaki Toast properly show ho
                              }
                            },
                            child: Text('Click'),
                          );
                        },
                      )

                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

