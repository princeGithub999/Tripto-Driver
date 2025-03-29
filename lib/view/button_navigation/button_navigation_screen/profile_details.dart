import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:tripto_driver/utils/constants/colors.dart';

import 'package:tripto_driver/view/auth_screen/send_otp_page.dart';
import 'package:tripto_driver/view/button_navigation/button_navigation_screen/wallet_cash.dart';
import 'package:tripto_driver/view_model/provider/auth_provider_in/auth_provider.dart';
import 'package:tripto_driver/view_model/provider/trip_provider/trip_provider.dart';
import '../../screen/my_ride.dart';
import 'change_bank_account.dart';


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

            _buildProfileOption(Icons.directions_car, "My Rides", () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => RideHistoryScreen(),));
            }),
            _buildProfileOption(Icons.wallet, "Earnings", () {}),
            _buildProfileOption(Icons.notifications, "Notifications", () {}),
            _buildProfileOption(Icons.account_balance, "Update Bank Account", () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeBankAccount(),));
            }),
            _buildProfileOption(Icons.support, "Wallet", () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => WalletCash(),));
            }),
            _buildProfileOption(Icons.support, "Support", () {}),
            _buildProfileOption(Icons.settings, "Settings", () {}),

            _buildProfileOption(Icons.directions_car, "My Rides"),
            _buildProfileOption(Icons.wallet, "Earnings"),
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
            borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
          ),
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
                    child: _profileImage == null && authProvider.driverModels.driverImage!.isEmpty
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
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        authProvider.vehiclesModels.type ?? '',
                        style: const TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ],
                  ),

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 16),
      color: AppColors.blue900,
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
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Driver Name",
                  style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                SizedBox(height: 4),
                Text(
                  "Not Available",
                  style: TextStyle(color: Colors.white70, fontSize: 16),

                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap) {
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

        onTap: onTap,

        onTap: () {

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

        onPressed: ()  async {
          // await Provider.of<AuthProviderIn>(context, listen: false).signout();
          Navigator.push(context, MaterialPageRoute(builder: (context) => SendOtpPage(),));

        onPressed: () {},

        child: const Text(
          "Logout",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
    );
  }
}
