import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../utils/app_sizes/sizes.dart';
import '../../utils/constants/colors.dart';
import '../../utils/device/device_utility.dart';
import '../../utils/helpers/helper_functions.dart';
import '../../view_model/getx/onboarding_controller/onboarding_controller.dart';

class OnBoardNextButton extends StatelessWidget {
  const OnBoardNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dark = AppHelperFunctions.isDarkMode(context);

    return Positioned(
      right: AppSizes.borderRadiusSm,
      bottom: AppDeviceUtility.getBottomNavigationBarHeight() - 30,
      child: ElevatedButton(
        onPressed: () => OnboardingController.instance.nextPage(),
        style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: dark ? AppColors.white : AppColors.white),
        child: Icon(
          Iconsax.arrow_right_3,
          color: dark ? AppColors.white : AppColors.blue900,
        ),
      ),
    );
  }
}
