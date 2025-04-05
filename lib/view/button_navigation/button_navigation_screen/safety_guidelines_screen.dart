import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tripto_driver/utils/constants/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class SafetyGuidelinesScreen extends StatelessWidget {
  final List<SafetyItem> safetyGuidelines = [
    SafetyItem(
      title: "Vehicle Safety Check",
      icon: Icons.car_repair,
      items: [
        "Check brakes, lights, and indicators daily",
        "Ensure tires have adequate tread and pressure",
        "Verify all mirrors are properly adjusted",
        "Keep emergency tools (jack, spare tire) accessible"
      ],
    ),
    SafetyItem(
      title: "Passenger Verification",
      icon: Icons.verified_user,
      items: [
        "Confirm rider's name matches app details",
        "Verify drop location before starting ride",
        "Check for intoxicated passengers before ride begins",
        "Cancel if passenger refuses safety protocols"
      ],
    ),
    SafetyItem(
      title: "On-Road Safety",
      icon: Icons.directions_car,
      items: [
        "Always wear seatbelt",
        "Follow speed limits and traffic rules",
        "No phone usage while driving",
        "Use GPS navigation responsibly"
      ],
    ),
    SafetyItem(
      title: "Emergency Protocols",
      icon: Icons.emergency,
      items: [
        "Save local emergency numbers in speed dial",
        "Know how to use in-app emergency button",
        "In case of accident: 1. Secure scene 2. Call help 3. Report to company",
        "First aid kit must be available in vehicle"
      ],
    ),
    // SafetyItem(
    //   title: "COVID-19 Safety",
    //   icon: Icons.medical_services,
    //   items: [
    //     "Sanitize vehicle after every ride",
    //     "Keep windows slightly open for ventilation",
    //     "Wear mask throughout the ride",
    //     "Provide sanitizer for passengers"
    //   ],
    // ),
    SafetyItem(
      title: "Night Driving",
      icon: Icons.nightlight_round,
      items: [
        "Extra vigilance for pedestrians and bikes",
        "Ensure all interior lights are functional",
        "Avoid poorly lit areas if possible",
        "Share live location with trusted contact"
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Safety Guidelines",
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.blue900,
        actions: [
          IconButton(
            icon: Icon(Icons.help_outline),
            onPressed: () => _launchSafetyManual(),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.blue.shade50],
          ),
        ),
        child: ListView(
          padding: EdgeInsets.all(16),
          children: [
            _buildSafetyHeader(),
            SizedBox(height: 20),
            ...safetyGuidelines.map((guideline) => _buildSafetyCard(guideline)).toList(),
            _buildEmergencySection(),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyHeader() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(Icons.security, size: 50, color: AppColors.blue900),
            SizedBox(height: 10),
            Text(
              "Your Safety is Our Priority",
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.blue900,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Follow these guidelines to ensure safe rides for you and your passengers",
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSafetyCard(SafetyItem guideline) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        leading: Icon(guideline.icon, color: AppColors.blue900),
        title: Text(
          guideline.title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: guideline.items.map((item) => _buildBulletPoint(item)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 4, right: 8),
            child: Icon(Icons.brightness_1, size: 8, color: Colors.blue),
          ),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.poppins(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencySection() {
    return Card(
      color: Colors.red[50],
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber, color: Colors.red),
                SizedBox(width: 10),
                Text(
                  "Emergency Contacts",
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            _buildEmergencyButton("Police", "100", Icons.local_police),
            _buildEmergencyButton("Ambulance", "108", Icons.medical_services),
            _buildEmergencyButton("Company Safety", "1800-123-456", Icons.security),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyButton(String label, String number, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.red),
      title: Text(label, style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
      subtitle: Text(number),
      trailing: IconButton(
        icon: Icon(Icons.phone, color: Colors.green),
        onPressed: () => _makePhoneCall(number),
      ),
    );
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    }
  }

  Future<void> _launchSafetyManual() async {
    const url = 'https://www.yourcompany.com/driver-safety-manual';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }
}

class SafetyItem {
  final String title;
  final IconData icon;
  final List<String> items;

  SafetyItem({required this.title, required this.icon, required this.items});
}
