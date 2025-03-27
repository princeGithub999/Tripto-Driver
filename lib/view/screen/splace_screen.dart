import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tripto_driver/utils/constants/app_string.dart';
import 'package:tripto_driver/utils/constants/colors.dart';
import 'package:tripto_driver/utils/helpers/helper_functions.dart';

class SplaceScreen extends StatefulWidget {
  const SplaceScreen({super.key});

  @override
  State<SplaceScreen> createState() => _SplaceScreenState();
}

class _SplaceScreenState extends State<SplaceScreen> {

  @override
  void initState() {
    super.initState();
    AppHelperFunctions.splaceController(context);
  }

  @override
  Widget build(BuildContext context) {

    var sizes = MediaQuery.of(context).size;
    return Scaffold(
          body: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppString.goWithTripto,style: GoogleFonts.montserrat(fontSize: 80,fontWeight: FontWeight.bold,letterSpacing: -5,color: AppColors.blue900)),
                Image.asset('assets/images/splace_image.jpg',width: sizes.width * 0.9 + 20),

              ],
            ),
          ),
    );
  }
}
