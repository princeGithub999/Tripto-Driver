import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF4b68ff);
  static const Color secondary = Color(0xFFFFE24b);
  static const Color accent = Color(0xFFb0c7ff);

  static const Gradient linearGradient = LinearGradient(
      begin: Alignment(0.0, 0.0),
      end: Alignment(0.707, -0.707),
      colors: [
        Color(0xffff9a9e),
        Color(0xfffad0c4),
        Color(0xfffad0c4),
      ]);

  static const Color textPrimary = Color(0xFFF6F6F6);
  static const Color textSecondary = Color(0xFF272727);
  static const Color textWhite = Colors.white;

  static const Color light = Color(0xFFF6F6F6);
  static const Color dark = Color(0xFF272727);
  static const Color primaryBackground = Color(0xFFF3F5FF);

  static const Color lightContainer = Color(0xFFF6F6F6);
  static Color darkContainer = Colors.white.withOpacity(0.1);

  static const Color buttonPrimary = Color(0xFF4b68ff);
  static const Color buttonSecondary = Color(0xFF6C757D);
  static const Color buttonDisabled = Color(0xFFC4C4C4);

  static const borderPrimary = Color(0xFFD9D9D9);
  static const borderSecondary = Color(0xFFE6E6E6);

  static const error = Color(0xFFD32F2F);
  static const success = Color(0xFF388E3C);
  static const warning = Color(0xFFF57C00);
  static const info = Color(0xFF1976D2);

  static const Color blackMe = Color(0xFF232323);
  static const Color darkerGrey = Color(0xFF4F4F4F);
  static const Color darkGrey = Color(0xFF939393);
  static const Color grey = Color(0xFFE0E0E0);
  static const Color softGrey = Color(0xFFE0E0E0);
  static const Color lightGrey = Color(0xFFE0E0E0);
  static const Color white = Color(0xFFE0E0E0);
  static const Color blue900 = Color(0xFF092A51);
  static const Color blue300 = Color(0xFFC4EDFF);
  static const Color gradientBlue = Color(0xFF0F4888);
  static Color lightBlue = Color(0xFF3AB2E8);
  static Color blue100 = Color(0xFFC4EDFF);
  static Color black700 = Color(0xFF2C2D3A);

}
