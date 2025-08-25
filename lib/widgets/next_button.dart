import 'package:flutter/material.dart';
import 'package:ancient_fishin_vault/core/app_constants.dart';

class NextButton extends StatelessWidget {
  const NextButton({super.key, required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        AppConstants.assetNextButton,
        width: AppConstants.getButtonWidth(context),
      ),
    );
  }
}
