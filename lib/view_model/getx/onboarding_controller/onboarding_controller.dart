import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:tripto_driver/view/auth_screen/send_otp_page.dart';

import '../../../view/home_page.dart';


class OnboardingController extends GetxController {
  static OnboardingController get instance => Get.find();

  final pageController = PageController();
  Rx<int> currentPageIndicator = 0.obs;

  RxBool isGetStarted = false.obs;

  @override
  void onInit() {
    super.onInit();
    ever(currentPageIndicator, (int index) {
      isGetStarted.value = index == 2;
    });
  }

  void updatePageIndicator(int index) => currentPageIndicator.value = index;

  void dotNavigationClick(index) {
    currentPageIndicator.value = index;
    pageController.jumpToPage(index);
  }

  void nextPage() {
    if (currentPageIndicator.value == 2) {
      Get.offAll(const SendOtpPage());
     } else {
      int page = currentPageIndicator.value + 1;
      pageController.jumpToPage(page);
    }
  }

  void skipPage() {
    currentPageIndicator.value = 2;
    pageController.animateToPage(
      2,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
