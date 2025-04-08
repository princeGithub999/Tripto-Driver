import 'package:flutter/material.dart';
import 'package:tripto_driver/utils/constants/colors.dart';
import '../../utils/app_sizes/sizes.dart';
import '../../utils/device/device_utility.dart';
import '../../view_model/getx/onboarding_controller/onboarding_controller.dart';

class OnBoardSkip extends StatelessWidget {
  const OnBoardSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: AppDeviceUtility.getAppBarHeight(),
      right: AppSizes.cardElevation,
      child: TextButton(
        onPressed: () {
          OnboardingController.instance.skipPage();
        },
        child: Text('Skip', style: TextStyle(color: Colors.black,fontSize: 16)),
      ),
    );
  }
}
