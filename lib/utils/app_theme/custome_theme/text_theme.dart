import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants/colors.dart';


class TextThemeApp {
  TextThemeApp._();

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: GoogleFonts.aBeeZee(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.black),
    headlineMedium: GoogleFonts.aBeeZee(fontSize: 24.0, fontWeight: FontWeight.bold, color: AppColors.lightBlue),
    headlineSmall: GoogleFonts.aBeeZee(fontSize: 18.0, fontWeight: FontWeight.w600, color: AppColors.blackMe),
    titleLarge: GoogleFonts.aBeeZee(fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.lightBlue),
    titleMedium: GoogleFonts.aBeeZee(fontSize: 16.0, fontWeight: FontWeight.w500, color: AppColors.lightBlue),
    titleSmall: GoogleFonts.aBeeZee(fontSize: 12.0, fontWeight: FontWeight.w500, color: AppColors.blackMe),
    bodyLarge: const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.w500, color: Colors.black),
    bodyMedium: const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.black),
    bodySmall: const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.w500, color: Colors.black),
    labelLarge: const TextStyle().copyWith(fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.black),
    labelMedium: const TextStyle().copyWith(fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.black.withOpacity(0.5)),
  );

  static TextTheme darkTextTheme = TextTheme(
    headlineLarge: const TextStyle().copyWith(fontSize: 32.0, fontWeight: FontWeight.bold, color: Colors.white),
    headlineMedium: GoogleFonts.aBeeZee(fontSize: 24.0, fontWeight: FontWeight.w600, color: AppColors.lightBlue),
    headlineSmall: GoogleFonts.aBeeZee(fontSize: 18.0, fontWeight: FontWeight.w600, color: AppColors.white),
    titleLarge: GoogleFonts.aBeeZee(fontSize: 16.0, fontWeight: FontWeight.w600, color: Colors.lightBlue),
    titleMedium: const TextStyle().copyWith(fontSize: 16.0, fontWeight: FontWeight.w500, color: Colors.lightBlue),
    titleSmall: GoogleFonts.aBeeZee(fontSize: 12.0, fontWeight: FontWeight.w500, color: AppColors.white),
    bodyLarge: const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.w500, color: Colors.white),
    bodyMedium: const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.normal, color: Colors.white),
    bodySmall: const TextStyle().copyWith(fontSize: 14.0, fontWeight: FontWeight.w500, color: Colors.white.withOpacity(0.5)),
    labelLarge: const TextStyle().copyWith(fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.white),
    labelMedium: const TextStyle().copyWith(fontSize: 12.0, fontWeight: FontWeight.normal, color: Colors.white.withOpacity(0.5)),
  );
}
