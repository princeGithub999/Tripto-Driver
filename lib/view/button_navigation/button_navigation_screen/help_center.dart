import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tripto_driver/utils/constants/colors.dart';

class HelpCenterScreen extends StatelessWidget {
  final List<Map<String, String>> faqs = [
    {'question': 'How do I accept a ride request?', 'answer': 'To accept a ride request, go to the Driver app and tap on the incoming ride request notification.'},
    {'question': 'How do I contact the rider?', 'answer': 'Once you accept a ride, you can call or message the rider using the in-app contact options.'},
    {'question': 'How do I report a problem with a ride?', 'answer': 'Go to your trip history, select the ride, and tap on "Report an Issue" to describe your problem.'},
    {'question': 'How do I receive my earnings?', 'answer': 'Your earnings are transferred to your linked bank account on a weekly basis. You can check your balance in the Wallet section.'},
    {'question': 'What should I do in case of an emergency?', 'answer': 'Use the SOS button in the app to contact emergency services or support immediately.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Help Center",
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: AppColors.blue900,
          elevation: 4,
          shadowColor: Colors.black45,
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.white, Colors.blue.shade50],
              ),
            ),
            child: ListView.builder(
              itemCount: faqs.length,
              itemBuilder: (context, index) {
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ExpansionTile(
                    title: Text(
                      faqs[index]['question']!,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                          faqs[index]['answer']!,
                          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            ),
        );
    }
}
