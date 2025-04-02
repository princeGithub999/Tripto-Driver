import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';

import '../../utils/globle_widget/buttom.dart';
import '../../view_model/provider/auth_provider_in/auth_provider.dart';
import '../../view_model/provider/permission_handler/permission_provider.dart';

class UserGetOtp extends StatefulWidget {
  const UserGetOtp({super.key});

  @override
  State<UserGetOtp> createState() => _UserGetOtpState();
}

class _UserGetOtpState extends State<UserGetOtp> {
  TextEditingController pinView = TextEditingController();
  int _resendTimer = 30;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    _canResend = false;
    _resendTimer = 30;
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          if (_resendTimer > 0) {
            _resendTimer--;
            _startResendTimer();
          } else {
            _canResend = true;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: GoogleFonts.poppins(
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
    );

    return Consumer<AuthProviderIn>(
      builder: (BuildContext context, authProvider, Widget? child) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("OTP Verification",
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    )),

                const SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                    ),
                    children: [
                      const TextSpan(text: "Please enter the "),
                      TextSpan(
                        text: "6-digit code",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const TextSpan(text: " received from the customer"),
                    ],
                  ),
                ),

                const SizedBox(height: 32),
                Center(
                  child: Pinput(
                    controller: pinView,
                    length: 6,
                    keyboardType: TextInputType.number,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        border: Border.all(color: Colors.blue.shade400),
                      ),
                    ),
                    onCompleted: (pin) {
                      if (!authProvider.isLoding) {
                        authProvider.supaVeryfiOTP(
                          authProvider.inputNumber.text,
                          pinView.text,
                        );
                      }
                    },
                  ),
                ),

                const SizedBox(height: 24),
                Center(
                  child: GestureDetector(
                    onTap: _canResend
                        ? () {
                      setState(() {
                        _startResendTimer();
                      });
                    }
                        : null,
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: _canResend ? Colors.blue : Colors.grey,
                        ),
                        children: [
                          const TextSpan(text: "Didn't receive code? "),
                          TextSpan(
                            text: _canResend
                                ? "Resend OTP"
                                : "Resend in $_resendTimer sec",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: _canResend ? Colors.blue : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),
                Text(
                  "Ride will be cancelled after 3 wrong OTP attempts",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.grey.shade500,
                  ),
                  textAlign: TextAlign.center,
                ),

                const Spacer(),
                Consumer<PermissionProvider>(
                  builder: (BuildContext context, permissionProvider, Widget? child) {
                    return MyButton.verifyOtpButton(
                          () {
                        if (pinView.text.length == 6) {
                          authProvider.supaVeryfiOTP(
                            authProvider.inputNumber.text,
                            pinView.text,
                          );
                        }
                      },
                      'VERIFY OTP',
                      authProvider.isLoding,
                    );
                  },
                ),

                const SizedBox(height: 16),
                Text(
                  "Safety Tip: Never share your OTP with anyone",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.red.shade400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}