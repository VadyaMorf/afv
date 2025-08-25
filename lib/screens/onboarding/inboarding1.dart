import 'package:ancient_fishin_vault/core/app_colors.dart';
import 'package:ancient_fishin_vault/core/app_constants.dart';
import 'package:ancient_fishin_vault/core/app_text_styles.dart';
import 'package:ancient_fishin_vault/widgets/next_button.dart';
import 'package:flutter/material.dart';
import 'package:ancient_fishin_vault/core/video_cache.dart';

class OnboardingScreen1 extends StatefulWidget {
  const OnboardingScreen1({super.key});

  @override
  State<OnboardingScreen1> createState() => _OnboardingScreen1State();
}

class _OnboardingScreen1State extends State<OnboardingScreen1> {
  @override
  void initState() {
    super.initState();
    VideoCache.instance.preload(AppConstants.assetVideo1);
    VideoCache.instance.preload(AppConstants.assetVideo2);
    VideoCache.instance.preload(AppConstants.assetVideo3);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppConstants.assetBackground, fit: BoxFit.cover),
          ),
          SafeArea(
            child: Stack(
              children: [
                Align(
                  alignment: const Alignment(0, -0.9),
                  child: Image.asset(
                    AppConstants.assetFirstMan,
                    width: AppConstants.getImageWidth(context),
                    fit: BoxFit.contain,
                  ),
                ),
                Align(
                  alignment: const Alignment(0, 0.4),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppConstants.getContentHorizontalPadding(
                        context,
                      ),
                    ),
                    child: Container(
                      height: AppConstants.getCardHeight(context),
                      padding: EdgeInsets.symmetric(
                        horizontal: AppConstants.getContentHorizontalPadding(
                          context,
                        ),
                        vertical: AppConstants.getContentVerticalPadding(
                          context,
                        ),
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.overlayBlue.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(
                          AppConstants.getCardBorderRadius(context),
                        ),
                        border: Border.all(
                          color: AppColors.accentOrange,
                          width: AppConstants.getCardBorderWidth(context),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadow25,
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Welcome to\nAncient Fishin\' Vault',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.titleLarge,
                          ),
                          SizedBox(
                            height: AppConstants.getTitleSpacing(context),
                          ),
                          Text(
                            'Explore a sunken world of ancient fish — real and imagined.  Swipe, read, play, and collect the rarest underwater legends.',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: NextButton(
                    onTap: () {
                      Navigator.pushNamed(context, '/onboarding2');
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
