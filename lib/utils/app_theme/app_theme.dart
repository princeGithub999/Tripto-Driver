import 'package:flutter/material.dart';
import 'custome_theme/appBar_theme.dart';
import 'custome_theme/app_icon_theme.dart';
import 'custome_theme/buttom_navigation_theme.dart';
import 'custome_theme/floating_action_button_aap_theme.dart';
import 'custome_theme/tab_bar_app_theme.dart';
import 'custome_theme/text_theme.dart';
import 'custome_theme/Text_from_feald_theme.dart';
import 'custome_theme/chip_theme.dart';
import 'custome_theme/elevated_button_themes.dart';

class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    textTheme: TextThemeApp.lightTextTheme,
    chipTheme: AppChipTheme.lightChipTheme,
    scaffoldBackgroundColor: Colors.white,
    inputDecorationTheme: TextFromFealdCustome.lightInputDecorationTheme,
    elevatedButtonTheme: ElevatedButtonThemes.liteElevatedButtonTheme,
    iconTheme: AppIconTheme.iconLiteModeTheme,
    bottomNavigationBarTheme: ButtomNavigationTheme.buttomNavLiteMode,
    tabBarTheme: TabBarAppTheme.tabBarLiteMode,
    appBarTheme: AppbarThemeC.lightAppBarTheme,
    floatingActionButtonTheme:
        FloatingActionButtonAapTheme.floatingActionButtonLiteMode,
  );

  static ThemeData darkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: Colors.blue,
      textTheme: TextThemeApp.darkTextTheme,
      chipTheme: AppChipTheme.lightChipTheme,
      scaffoldBackgroundColor: Colors.black,
      inputDecorationTheme: TextFromFealdCustome.darkInputDecorationTheme,
      elevatedButtonTheme: ElevatedButtonThemes.darkElevatedButtonTheme,
      iconTheme: AppIconTheme.iconDarkModeTheme,
      bottomNavigationBarTheme: ButtomNavigationTheme.buttomNavDarkMode,
      tabBarTheme: TabBarAppTheme.tabBarDarkMode,
      appBarTheme: AppbarThemeC.darkAppBarTheme,
      floatingActionButtonTheme:
          FloatingActionButtonAapTheme.floatingActionButtonDarkMode);
}
