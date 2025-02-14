import 'package:flutter/material.dart';

import '../../utils/app_sizes/sizes.dart';

class OnBoardingPage extends StatelessWidget {
  OnBoardingPage(
      {super.key,
      required this.title,
      required this.subTitle,
      required this.onBoardingImage});

  final String title, subTitle;
  String onBoardingImage;

  @override
  Widget build(BuildContext context) {
    final sizes = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.all(AppSizes.defaultSpacing),
      child: Column(
        children: [
          Image.asset(
            onBoardingImage,
            width: sizes.width * 0.4,
            height: sizes.height * 0.4,
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: AppSizes.spaceBetweenItems,
          ),
          // Text(
          //   subTitle,
          //   style: Theme.of(context).textTheme.headlineSmall,
          //   textAlign: TextAlign.center,
          // ),
        ],
      ),
    );
  }
}
