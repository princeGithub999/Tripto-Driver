import 'package:flutter/cupertino.dart';

import '../../constants/colors.dart';

class AppIconTheme {
  AppIconTheme._();

  static IconThemeData iconLiteModeTheme =
      IconThemeData(color: AppColors.blackMe);

  static IconThemeData iconDarkModeTheme =
      IconThemeData(color: AppColors.white);
}
