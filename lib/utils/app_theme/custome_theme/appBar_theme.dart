import 'package:flutter/material.dart';
import '../../../utils/constants/colors.dart';
import '../../app_sizes/sizes.dart';

class AppbarThemeC {
  AppbarThemeC._();

  static AppBarTheme lightAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: AppColors.blue900,
    surfaceTintColor: Colors.transparent,
    iconTheme:
        const IconThemeData(color: AppColors.white, size: AppSizes.iconMd),
    actionsIconTheme:
        const IconThemeData(color: AppColors.blackMe, size: AppSizes.iconMd),
    titleTextStyle: const TextStyle(
        fontSize: 18.0, fontWeight: FontWeight.w600, color: AppColors.light),
  );

  static AppBarTheme darkAppBarTheme = const AppBarTheme(
      elevation: 0,
      centerTitle: false,
      scrolledUnderElevation: 0,
      backgroundColor: AppColors.blue900,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: AppColors.white, size: AppSizes.iconMd),
      actionsIconTheme:
          IconThemeData(color: AppColors.white, size: AppSizes.iconMd),
      titleTextStyle: TextStyle(
          fontSize: 18.0, fontWeight: FontWeight.w600, color: AppColors.white));
}
