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

 static Widget buildCustomTextField(
      String hint, TextEditingController controller, IconData icon,
      {String? Function(String?)? validator, TextInputType type = TextInputType.text, bool isDateField = false, required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: type,
        readOnly: isDateField, // Date field editable nahi hoga
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColors.blue900),
          suffixIcon: isDateField
              ? IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.blue),
            onPressed: () async {
              DateTime? pickedDate = await showDatePicker(
                context: context,
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                initialDate: DateTime.now(),
              );
              if (pickedDate != null) {
                String formattedDate = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                controller.text = formattedDate;
              }
            },
          )
              : null,
          hintText: hint,
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}