import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_sizes/sizes.dart';
import '../../utils/constants/colors.dart';
import '../../utils/device/device_utility.dart';
import '../../utils/helpers/helper_functions.dart';
import '../../view_model/getx/onboarding_controller/onboarding_controller.dart';
import 'onboarding_next_button.dart';

class OnboardingGetstarted extends StatelessWidget {
  const OnboardingGetstarted({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = OnboardingController.instance;
    final dark = AppHelperFunctions.isDarkMode(context);

    return Obx(() {
      return controller.isGetStarted.value
          ? Positioned(
              right: AppSizes.defaultSpacing,
              bottom: AppDeviceUtility.getBottomNavigationBarHeight() - 30,
              child: ElevatedButton(
                onPressed: () => controller.nextPage(),
                style: ElevatedButton.styleFrom(
                    backgroundColor:
                    dark ? AppColors.blue900 : AppColors.blue900,
                    padding: const EdgeInsets.symmetric(horizontal: 40)),
                child: const Text(
                  'Get Started',
                  style: TextStyle(color: AppColors.white,fontWeight: FontWeight.bold),
                ),
              ),
            )
          : const OnBoardNextButton();
    });
  }
}
