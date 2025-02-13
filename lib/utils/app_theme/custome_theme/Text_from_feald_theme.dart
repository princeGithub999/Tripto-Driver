import 'package:flutter/material.dart';

import '../../app_sizes/sizes.dart';
import '../../constants/colors.dart';


class TextFromFealdCustome {
  TextFromFealdCustome._();

  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 3,
    prefixIconColor: AppColors.lightBlue,
    suffixIconColor: AppColors.darkGrey,
    labelStyle: const TextStyle().copyWith(fontSize: AppSizes.fontSizeMd, color: Colors.red), hintStyle: const TextStyle().copyWith(fontSize: AppSizes.fontSizeLg, color: Colors.black),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.normal, color: AppColors.error),
    floatingLabelStyle: const TextStyle().copyWith(color: Colors.black.withOpacity(0.8)),
    border: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
        borderSide: BorderSide(width: 1.5, color: AppColors.lightBlue)),
    enabledBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
        borderSide: BorderSide(width: 1.5, color: AppColors.lightBlue)),
    focusedBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
        borderSide: BorderSide(width: 1.5, color: AppColors.lightBlue)),
    errorBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
        borderSide: const BorderSide(width: 1.5, color: AppColors.error)),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
        borderSide: const BorderSide(width: 2, color: AppColors.error)),
  );

  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 2,
    prefixIconColor: AppColors.white,
    suffixIconColor: AppColors.darkGrey,
    errorStyle: const TextStyle()
        .copyWith(fontStyle: FontStyle.normal, color: AppColors.error),
    labelStyle: const TextStyle()
        .copyWith(fontSize: AppSizes.fontSizeMd, color: AppColors.white),
    hintStyle: const TextStyle().copyWith(
      fontSize: AppSizes.fontSizeLg,
      color: AppColors.white,
    ),
    floatingLabelStyle:
        const TextStyle().copyWith(color: AppColors.white.withOpacity(0.8)),
    border: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(AppSizes.borderRadiusMd),
        borderSide: const BorderSide(width: 1.5, color: AppColors.darkGrey)),
    enabledBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
        borderSide: const BorderSide(width: 1.5, color: Colors.grey)),
    focusedBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
        borderSide: const BorderSide(width: 1.5, color: AppColors.white)),
    errorBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
        borderSide: const BorderSide(width: 1.5, color: AppColors.error)),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
        borderRadius: BorderRadius.circular(AppSizes.inputFieldRadius),
        borderSide: const BorderSide(width: 1.5, color: AppColors.error)),
  );
}
