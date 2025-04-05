import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tripto_driver/utils/constants/colors.dart';
import 'package:tripto_driver/view/button_navigation/button_navigation_screen/support_screen.dart';
import 'package:tripto_driver/view/button_navigation/button_navigation_screen/wallet_cash.dart';

import '../../screen/my_ride.dart';
import 'change_bank_account.dart';
import 'driver_setting_screen.dart';

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
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 170,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildProfileHeader(),
            ),
            pinned: true,
            elevation: 0,
            backgroundColor: AppColors.blue900,
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 16),
              _buildProfileSection(),
              const SizedBox(height: 24),
              _buildLogoutButton(),
              const SizedBox(height: 30),
            ]),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.blue900, AppColors.black700],
        ),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Image.asset(
                'assets/pattern.png', // Add your pattern asset
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: _profileImage != null
                          ? Image.file(_profileImage!, fit: BoxFit.cover)
                          : Container(
                        color: Colors.white,
                        child: Icon(
                          Icons.camera_alt,
                          size: 30,
                          color: AppColors.blue900,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Driver Name",
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        "Not Available",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, color: Colors.amber, size: 18),
                            const SizedBox(width: 6),
                            Text(
                              "4.8 (120 rides)",
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildProfileOption(
            icon: Icons.directions_car_filled,
            title: "My Rides",
            color: Colors.blueAccent,
          ),
          _buildProfileOption(
            icon: Icons.attach_money_rounded,
            title: "Earnings",
            color: Colors.green,
          ),
          _buildProfileOption(
            icon: Icons.account_balance,
            title: "Update Bank Account",
            color: Colors.purple,
          ),
          _buildProfileOption(
            icon: Icons.account_balance_wallet,
            title: "Wallet",
            color: Colors.orange,
          ),
          _buildProfileOption(
            icon: Icons.notifications_active,
            title: "Notifications",
            color: Colors.red,
          ),
          _buildProfileOption(
            icon: Icons.support_agent,
            title: "Support",
            color: Colors.teal,
          ),
          _buildProfileOption(
            icon: Icons.settings,
            title: "Settings",
            color: Colors.indigo,
          ),
        ],
      ),
    );
  }

  Widget _buildProfileOption({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // Keep your existing navigation logic
          if (title == "Update Bank Account") {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChangeBankAccount()));
          } else if (title == "Wallet") {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => WalletScreen()));
          } else if (title == "Support") {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => DriverSupportScreen()));
          }else if(title == "Settings"){
            Navigator.push(context, MaterialPageRoute(builder: (context) => DriverSettingsScreen(),));
          }else if(title == "My Rides"){
            Navigator.push(context, MaterialPageRoute(builder: (context) => RideHistoryScreen(),));
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 22,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.red,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: Colors.red.withOpacity(0.3), width: 1),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.logout, size: 20),
                const SizedBox(width: 10),
                Text(
                  "Logout",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            ),
        );
    }
}
