import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tripto_driver/utils/constants/colors.dart';
import 'package:tripto_driver/view/button_navigation/button_navigation_screen/report_issue_screen.dart';
import 'package:tripto_driver/view/button_navigation/button_navigation_screen/ride_disputes_screen.dart';
import 'package:tripto_driver/view/button_navigation/button_navigation_screen/safety_guidelines_screen.dart';
import 'package:tripto_driver/view/button_navigation/button_navigation_screen/training_tutorial_screen.dart';
import 'package:url_launcher/url_launcher.dart';

import 'help_center.dart';

class DriverSupportScreen extends StatefulWidget {
  @override
  State<DriverSupportScreen> createState() => _DriverSupportScreenState();
}

class _DriverSupportScreenState extends State<DriverSupportScreen> {
  final List<SupportOption> supportOptions = [
    SupportOption(
      icon: Icons.help_outline,
      title: "Help Center",
      route: HelpCenterScreen(),
      gradientColors: [Color(0xFF4A6CF7), Color(0xFF2541B2)],
    ),
    SupportOption(
      icon: Icons.call_outlined,
      title: "Call Support",
      action: 'callpage',
      gradientColors: [Color(0xFF20C997), Color(0xFF099268)],
    ),
    SupportOption(
      icon: Icons.report_gmailerrorred,
      title: "Report Issue",
      route: ReportIssueScreen(),
      gradientColors: [Color(0xFFFF6B6B), Color(0xFFF03E3E)],
    ),
    SupportOption(
      icon: Icons.money_off_csred_rounded,
      title: "Ride Disputes",
      route: RideDisputesScreen(),
      gradientColors: [Color(0xFFF76707), Color(0xFFE8590C)],
    ),
    SupportOption(
      icon: Icons.shield_outlined,
      title: "Safety Guide",
      route: SafetyGuidelinesScreen(),
      gradientColors: [Color(0xFF5C7CFA), Color(0xFF364FC7)],
    ),
    SupportOption(
      icon: Icons.play_circle_outline,
      title: "Tutorials",
      route: TrainingTutorialsScreen(),
      gradientColors: [Color(0xFF9775FA), Color(0xFF7048E8)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      title: Text(
        "Driver Support",
        style: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      centerTitle: true,
      backgroundColor: AppColors.blue900,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.blue900, AppColors.black700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color(0xFFF8F9FA)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildSupportGrid(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          "How can we help you today?",
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.grey[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "Choose from our support options below",
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSupportGrid(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        physics: const BouncingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.85,
        ),
        itemCount: supportOptions.length,
        itemBuilder: (context, index) {
          return _buildSupportCard(context, supportOptions[index]);
        },
      ),
    );
  }

  Widget _buildSupportCard(BuildContext context, SupportOption option) {
    return Material(
      borderRadius: BorderRadius.circular(16),
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          if (option.action == 'callpage') {
            _callSupport();
          } else if (option.route != null) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => option.route!),
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 16,
                spreadRadius: 1,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: option.gradientColors,
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: option.gradientColors.last.withOpacity(0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  option.icon,
                  size: 28,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  option.title,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.grey[800],
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _callSupport() async {
    const phoneNumber = 'tel:6200725150';
    if (await canLaunchUrl(Uri.parse(phoneNumber))) {
      await launchUrl(Uri.parse(phoneNumber));
    } else {
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //     content: Text("Could not launch phone dialer"),
      //     backgroundColor: Colors.red,
      //   ),
      // );
    }
  }
}

class SupportOption {
  final IconData icon;
  final String title;
  final Widget? route;
  final String? action;
  final List<Color> gradientColors;

  SupportOption({
  required this.icon,
  required this.title,
  this.route,
  this.action,
  required this.gradientColors,
  });
}
