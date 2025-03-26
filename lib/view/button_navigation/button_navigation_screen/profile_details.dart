import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tripto_driver/utils/constants/colors.dart';
import 'package:tripto_driver/view_model/provider/auth_provider_in/auth_provider.dart';

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  _buildProfileInfo(),
                  const SizedBox(height: 20),
                  _buildMenuItems(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 180,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.teal],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
        ),
        Positioned(
          top: 40,
          left: 20,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        Positioned(
          top: 100,
          child: GestureDetector(
            onTap: _pickImage,
            child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
              child: _profileImage == null
                  ? const Icon(Icons.person, size: 50, color: Colors.grey)
                  : null,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfo() {
    return Consumer<AuthProviderIn>(
      builder: (context, authProvider, child) {
        return Column(
          children: [
            Text(
              authProvider.driverModels.driverFirstName ?? "Unknown",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              authProvider.driverModels.address?.vill ?? "No Address",
              style: const TextStyle(color: Colors.grey),
            ),
            Text(
              authProvider.vehiclesModels.type ?? "No Vehicle Type",
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMenuItems() {
    return Column(
      children: [
        _buildListTile("Home", Icons.home),
        _buildListTile("Your Trips", Icons.directions_car),
        _buildListTile("Wallet", Icons.account_balance_wallet),
        _buildListTile("Payment", Icons.payment),
        _buildListTile("Notifications", Icons.notifications_active),
        _buildListTile("Settings", Icons.settings),
        _buildListTile("Logout", Icons.logout, color: Colors.red),
      ],
    );
  }

  Widget _buildListTile(String title, IconData icon, {Color? color}) {
    return ListTile(
      leading: Icon(icon, color: color ?? Colors.blueAccent, size: 28),
      title: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
      onTap: () {},
    );
  }
}
