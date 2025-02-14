import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tripto_driver/utils/helpers/helper_functions.dart';
import 'package:tripto_driver/view/auth_screen/send_otp_page.dart';

import '../../../utils/globle_widget/alert_dailog.dart';

class PermissionProvider extends ChangeNotifier {

  Future<void> checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      AlertDailog.showAlertDailog("Location services are disabled. Please enable them.");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        AlertDailog.showAlertDailog("Location permission is required to proceed.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      AlertDailog.showAlertDailog("Location permissions are permanently denied. Please enable them in settings.");
      return;
    }


    AppHelperFunctions.navigateToScreen(Get.context!, const SendOtpPage());
  }


}