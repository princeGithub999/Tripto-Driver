import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
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
