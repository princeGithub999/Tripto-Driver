import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../helpers/helper_functions.dart';

class TextFromPage {

  final GlobalKey<FormState> fromKey = GlobalKey<FormState>();

  static Widget buildTextField(
      {required TextEditingController controller,
        required String hintText,
        required String? Function(String?)? validator,
        required BuildContext context,
        Widget? icons,
        TextInputType? inputType}) {
    var isDark = AppHelperFunctions.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.only(left: 1),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: icons,
          contentPadding: const EdgeInsets.only(left: 10),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: isDark ? AppColors.white : AppColors.lightBlue)),
        ),
        validator: validator,
      ),
    );
  }
}