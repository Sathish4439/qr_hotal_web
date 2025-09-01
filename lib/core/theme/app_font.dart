import 'package:ecommerce_flutter/core/theme/app_color.dart';
import 'package:flutter/material.dart';

class AppFonts {
  // Font sizes
  static const double extraSmall = 10;
  static const double small = 12;
  static const double regular = 14;
  static const double large = 18;
  static const double extraLarge = 22;
  static const double huge = 26;

  // Base reusable textStyle
  static TextStyle textStyle({
    double fontSize = regular,
    Color color = Colors.black,
    FontWeight fontWeight = FontWeight.normal,
  }) {
    return TextStyle(
      fontSize: fontSize,
      color: color,
      fontWeight: fontWeight,
    );
  }

  // ✅ Custom Styles with optional dynamic color
  static TextStyle headingStyle({Color? color}) => textStyle(
        fontSize: extraLarge,
        fontWeight: FontWeight.bold,
        color: color ?? AppColors.textWhite,
      );

  static TextStyle subHeadingStyle({Color? color}) => textStyle(
        fontSize: large,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textWhite,
      );

  static TextStyle bodyStyle({Color? color}) => textStyle(
        fontSize: regular,
        fontWeight: FontWeight.normal,
        color: color ?? Colors.black87,
      );

  static TextStyle captionStyle({Color? color}) => textStyle(
        fontSize: small,
        fontWeight: FontWeight.w400,
        color: color ?? Colors.grey,
      );
}
