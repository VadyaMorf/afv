import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get titleLarge => GoogleFonts.montserrat(
    color: AppColors.textOnDark,
    fontSize: 30,
    fontWeight: FontWeight.w700,
    height: 1.2,
    letterSpacing: 2.0,
  );

  static TextStyle get bodyLarge => GoogleFonts.montserrat(
    color: AppColors.textOnDark,
    fontWeight: FontWeight.w400,
    fontSize: 25,
    height: 1.2,
    letterSpacing: 2.0,
  );
}
