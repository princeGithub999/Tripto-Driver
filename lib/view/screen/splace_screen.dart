import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tripto_driver/utils/constants/app_image.dart';
import 'package:tripto_driver/utils/constants/app_string.dart';
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
                Image.asset(AppImage.tripToLogo,width: sizes.width * 0.5),
                Text(AppString.goWithTripto,style: Theme.of(context).textTheme.headlineSmall,)
              ],
            ),
          ),
    );
  }
}
