import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class TabBarAppTheme {
  TabBarAppTheme._();

  static TabBarTheme tabBarLiteMode = TabBarTheme(
    dividerColor: AppColors.lightBlue,
    labelColor: AppColors.light,
    dividerHeight: BorderSide.strokeAlignOutside,
    indicatorColor: AppColors.blue900,
    indicatorSize: TabBarIndicatorSize.tab,
    unselectedLabelColor: AppColors.darkGrey,
  );

  static TabBarTheme tabBarDarkMode = TabBarTheme(
    dividerColor: AppColors.light,
    labelColor: AppColors.light,
    dividerHeight: BorderSide.strokeAlignOutside,
    indicatorSize: TabBarIndicatorSize.tab,
    indicatorColor: AppColors.lightBlue,
    unselectedLabelColor: AppColors.darkGrey,
  );
}
