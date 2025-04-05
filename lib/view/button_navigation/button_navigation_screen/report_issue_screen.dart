import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tripto_driver/utils/constants/colors.dart';

class ReportIssueScreen extends StatefulWidget {
  @override
  _ReportIssueScreenState createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  String? selectedIssue;
  TextEditingController issueDescriptionController = TextEditingController();
  bool _isSubmitting = false;

  final List<String> issues = [
    "Payment Issue",
    "App Crashing",
    "Rider Misbehavior",
    "Navigation Issue",
    "Trip Cancellation Problem",
    "Vehicle Breakdown",
    "Other"
  ];

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;
    if (selectedIssue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select an issue")),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("User not logged in")),
        );
        return;
      }

      await FirebaseFirestore.instance.collection("driver_reports").doc(user.uid).set(

          {
            "driverId": user.uid,
            "driverEmail": user.email,
            "name":user.displayName,
            "issue": selectedIssue,
            "description": issueDescriptionController.text,
            "status": "Pending",
            "timestamp": FieldValue.serverTimestamp(),
          });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Issue reported successfully"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to submit report: ${e.toString()}"),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Report an Issue",
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          backgroundColor: AppColors.blue900,
          elevation: 0,
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.blue900, AppColors.black700],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Let us know what's wrong",
                    style: GoogleFonts.poppins(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: AppColors.blue900,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "We'll help you resolve your issue quickly",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 32),

                  // Issue Type Selection
                  Text(
                    "Issue Type*",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: InputBorder.none,
                        hintText: "Select your issue",
                        hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                      ),
                      items: issues.map((issue) => DropdownMenuItem(
                        value: issue,
                        child: Text(
                          issue,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            color: Colors.grey[800],
                          ),
                        ),
                      )).toList(),
                      onChanged: (value) => setState(() => selectedIssue = value),
                      validator: (value) => value == null ? 'Please select an issue type' : null,
                      icon: Icon(Icons.keyboard_arrow_down, color: AppColors.blue900),
                      dropdownColor: Colors.white,
                      style: GoogleFonts.poppins(fontSize: 15),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Description Field
                  Text(
                    "Description",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: issueDescriptionController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.all(16),
                      hintText: "Provide details about your issue...",
                      hintStyle: GoogleFonts.poppins(color: Colors.grey[500]),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: AppColors.blue900, width: 1.5),
                      ),

                    ),
                  ),
                  SizedBox(height: 40),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitReport,
                      child: _isSubmitting
                          ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      )
                          : Text(
                        "Submit Report",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue900,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shadowColor: Colors.transparent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ),
        );
  }
}
