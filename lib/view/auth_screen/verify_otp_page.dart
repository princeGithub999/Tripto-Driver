import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pinput/pinput.dart';
import 'package:tripto_driver/view/auth_screen/send_otp_page.dart';

class VerifyOtpPage extends StatefulWidget {
  const VerifyOtpPage({super.key});

  @override
  _VerifyOtpPageState createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  final TextEditingController _otpController = TextEditingController();

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _showDialog("Location services are disabled. Please enable them.");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _showDialog("Location permission is required to proceed.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _showDialog("Location permissions are permanently denied. Please enable them in settings.");
      return;
    }


    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SendOtpPage()),
    );
  }

  void _showDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Permission Required"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SendOtpPage()));
            },
          ),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Phone verification", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                Text("Enter your OTP code", style: TextStyle(fontSize: 16, color: Colors.black)),
                SizedBox(height: 20),
                Center(
                  child: Pinput(
                    controller: _otpController,
                    length: 6,
                    keyboardType: TextInputType.number,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    defaultPinTheme: PinTheme(
                      width: 50,
                      height: 50,
                      textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.black),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: () {},
                    child: Text("Didn’t receive code? Resend again", style: TextStyle(color: Colors.black, fontSize: 14)),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _checkLocationPermission,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    minimumSize: Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Text("Verify", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ],
            ),
            ),
        );
    }
}