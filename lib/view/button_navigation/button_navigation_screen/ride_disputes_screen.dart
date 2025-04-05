import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tripto_driver/utils/constants/colors.dart';

class RideDisputesScreen extends StatefulWidget {
  @override
  _RideDisputesScreenState createState() => _RideDisputesScreenState();
}

class _RideDisputesScreenState extends State<RideDisputesScreen> {
  final List<Map<String, dynamic>> disputeTypes = [
    {
      'title': "Fare Dispute",
      'icon': Icons.money_off,
      'description': "Disagree with the calculated fare amount",
      'color': Colors.orangeAccent
    },
    {
      'title': "Wrong Charge",
      'icon': Icons.credit_card,
      'description': "Incorrect payment amount was charged",
      'color': Colors.redAccent
    },
    {
      'title': "Route Dispute",
      'icon': Icons.alt_route,
      'description': "Disagree with the taken route or distance",
      'color': Colors.blueAccent
    },
    {
      'title': "Rating Dispute",
      'icon': Icons.star_border,
      'description': "Dispute an unfair rider rating",
      'color': Colors.amber
    },
    {
      'title': "Cancellation Fee",
      'icon': Icons.cancel_outlined,
      'description': "unfair cancellation charge",
      'color': Colors.purpleAccent
    },
    {
      'title': "Other Issue",
      'icon': Icons.help_outline,
      'description': "Other dispute not listed here",
      'color': Colors.greenAccent
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ride Disputes",
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
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.blue.shade50],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16),
                child: Text(
                  "Select the type of dispute you want to report:",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey[700],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.only(bottom: 16), // Added bottom padding
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: disputeTypes.length,
                  itemBuilder: (context, index) {
                    return _buildDisputeCard(disputeTypes[index]);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                child: Text(
                  "Note: Disputes are typically resolved within 3-5 business days. "
                      "We'll notify you via email once a decision is made.",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontStyle: FontStyle.italic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDisputeCard(Map<String, dynamic> dispute) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _handleDisputeSelection(dispute['title']),
        child: Container(
          padding: EdgeInsets.all(12), // Reduced padding
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                dispute['color'].withOpacity(0.2),
                dispute['color'].withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10), // Reduced padding
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dispute['color'].withOpacity(0.2),
                ),
                child: Icon(
                  dispute['icon'],
                  size: 24, // Reduced icon size
                  color: dispute['color'],
                ),
              ),
              SizedBox(height: 8), // Reduced spacing
              Text(
                dispute['title'],
                style: GoogleFonts.poppins(
                  fontSize: 14, // Reduced font size
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 4), // Reduced spacing
              Text(
                dispute['description'],
                style: GoogleFonts.poppins(
                  fontSize: 12, // Reduced font size
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleDisputeSelection(String disputeType) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DisputeFormScreen(disputeType: disputeType),
      ),
    );
  }
}

class DisputeFormScreen extends StatefulWidget {
  final String disputeType;

  const DisputeFormScreen({required this.disputeType});

  @override
  _DisputeFormScreenState createState() => _DisputeFormScreenState();
}

class _DisputeFormScreenState extends State<DisputeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tripIdController = TextEditingController();
  final TextEditingController _detailsController = TextEditingController();
  DateTime? _disputeDate;
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Submit Dispute",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.blue900,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: IntrinsicHeight(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Dispute Type: ${widget.disputeType}",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.blue900,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _tripIdController,
                        decoration: InputDecoration(
                          labelText: "Trip ID",
                          hintText: "Enter the trip ID from your history",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: Icon(Icons.confirmation_number),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the trip ID';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () async {
                          final selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now().subtract(Duration(days: 30)),
                            lastDate: DateTime.now(),
                          );
                          if (selectedDate != null) {
                            setState(() {
                              _disputeDate = selectedDate;
                            });
                          }
                        },
                        child: AbsorbPointer(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText: "Date of Trip",
                              hintText: "Select the trip date",
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              prefixIcon: Icon(Icons.calendar_today),
                              suffixIcon: Icon(Icons.arrow_drop_down),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                            ),
                            controller: TextEditingController(
                              text: _disputeDate != null
                                  ? "${_disputeDate!.day}/${_disputeDate!.month}/${_disputeDate!.year}"
                                  : "",
                            ),
                            validator: (value) {
                              if (_disputeDate == null) {
                                return 'Please select the trip date';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _detailsController,
                        maxLines: 5,
                        minLines: 3,
                        decoration: InputDecoration(
                          labelText: "Dispute Details",
                          hintText: "Explain why you're disputing this trip...",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignLabelWithHint: true,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please provide details about your dispute';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submitDispute,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.blue900,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
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
                            "Submit Dispute",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20), // Extra space at bottom
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _submitDispute() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isSubmitting = true);

      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      setState(() => _isSubmitting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Your dispute has been submitted successfully!"),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  void dispose() {
    _tripIdController.dispose();
    _detailsController.dispose();
    super.dispose();
    }
}
