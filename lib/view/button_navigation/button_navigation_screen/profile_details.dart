import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tripto_driver/utils/constants/colors.dart';
import 'package:tripto_driver/view_model/provider/auth_provider_in/auth_provider.dart';
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
      backgroundColor: Colors.grey[200],
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(),
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
  }

  Widget _buildProfileHeader() {
    return Consumer<AuthProviderIn>(
      builder: (BuildContext context, authProvider, Widget? child) {
        return Container(
          decoration: BoxDecoration(
              color: AppColors.blue900,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20),bottomRight: Radius.circular(20))),
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                    backgroundColor: Colors.white,
                    child: _profileImage == null
                        ? const Icon(Icons.camera_alt, size: 30, color: Colors.grey)
                        : null,
                  ),
                ),
                const SizedBox(width: 16),
                 Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authProvider.driverModels.driverFirstName ?? '',
                        style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(height: 4),
                      Text(
                        authProvider.vehiclesModels.type ?? '',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
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
        onTap: () {},
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
            onPressed: () {},
            child: const Text(
              "Logout",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
            ),
            ),
        );
    }
}
