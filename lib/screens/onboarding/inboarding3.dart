import 'package:ancient_fishin_vault/core/app_colors.dart';
import 'package:ancient_fishin_vault/core/app_constants.dart';
import 'package:ancient_fishin_vault/core/app_text_styles.dart';
import 'package:ancient_fishin_vault/widgets/next_button.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:ancient_fishin_vault/core/video_cache.dart';

class OnboardingScreen3 extends StatefulWidget {
  const OnboardingScreen3({super.key});

  @override
  State<OnboardingScreen3> createState() => _OnboardingScreen3State();
}

class _OnboardingScreen3State extends State<OnboardingScreen3> {
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoCache.instance.getController(
      AppConstants.assetVideo2,
    );
    if (_videoController == null) {
      VideoCache.instance.preload(AppConstants.assetVideo2);
      _videoController = VideoCache.instance.getController(
        AppConstants.assetVideo2,
      );
    }
    final init = VideoCache.instance.getInitialization(
      AppConstants.assetVideo2,
    );
    if (init != null) {
      init.then((_) {
        if (!mounted) return;
        setState(() {});
        _videoController?.play();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
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
                  alignment: const Alignment(0, -0.95),
                  child: SizedBox(
                    width: AppConstants.getVideoWidth(context),
                    height: AppConstants.getVideoHeight(context),
                    child:
                        (_videoController != null &&
                            _videoController!.value.isInitialized)
                        ? AspectRatio(
                            aspectRatio: _videoController!.value.aspectRatio,
                            child: VideoPlayer(_videoController!),
                          )
                        : const SizedBox.shrink(),
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
                            'One Fishy Fact a\nDay',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.titleLarge,
                          ),
                          SizedBox(height: 24),
                          SizedBox(
                            height: AppConstants.getTitleSpacing(context),
                          ),
                          Text(
                            'Every day brings a \nnew surprise from the vault — bite-sized, weird, or wonderful.  Don\'t miss your daily deep-sea discovery.',
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
                      Navigator.pushNamed(context, '/onboarding4');
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
