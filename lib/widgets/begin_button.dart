import 'package:ancient_fishin_vault/core/app_colors.dart';
import 'package:ancient_fishin_vault/core/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BeginButton extends StatelessWidget {
  const BeginButton({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            "assets/begin_button.png",
            width: AppConstants.getButtonWidth(context),
          ),
          Text(
            "BEGIN",
            style: GoogleFonts.montserrat(
              color: AppColors.textOnDark,
              fontSize: AppConstants.getAdaptiveSize(context, 34),
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
