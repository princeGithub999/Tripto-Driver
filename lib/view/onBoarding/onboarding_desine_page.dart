import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
      padding: const EdgeInsets.all(AppSizes.defaultSpacing),
      child: Column(
        children: [


          Image.asset(
            onBoardingImage,
            width: sizes.width * 0.6 + 50,
            height: sizes.height * 0.6 + 50,
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20,),
          Text(
            subTitle,
            style: GoogleFonts.aBeeZee(fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: AppSizes.spaceBetweenItems,
          ),

        ],
      ),
    );
  }
}
