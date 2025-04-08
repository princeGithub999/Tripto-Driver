import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class FloatingActionButtonAapTheme {
  FloatingActionButtonAapTheme._();

  static FloatingActionButtonThemeData floatingActionButtonLiteMode =
      FloatingActionButtonThemeData(backgroundColor: AppColors.lightBlue);

  static FloatingActionButtonThemeData floatingActionButtonDarkMode =
      FloatingActionButtonThemeData(backgroundColor: AppColors.blue900);
}
