import 'package:ancient_fishin_vault/core/app_colors.dart';
import 'package:ancient_fishin_vault/core/app_constants.dart';
import 'package:ancient_fishin_vault/core/app_text_styles.dart';
import 'package:ancient_fishin_vault/widgets/next_button.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:ancient_fishin_vault/core/video_cache.dart';

class OnboardingScreen2 extends StatefulWidget {
  const OnboardingScreen2({super.key});

  @override
  State<OnboardingScreen2> createState() => _OnboardingScreen2State();
}

class _OnboardingScreen2State extends State<OnboardingScreen2> {
  VideoPlayerController? _videoController;

  @override
  void initState() {
    super.initState();
    _videoController = VideoCache.instance.getController(
      'assets/videos/1st.mp4',
    );
    if (_videoController == null) {
      VideoCache.instance.preload('assets/videos/1st.mp4');
      _videoController = VideoCache.instance.getController(
        'assets/videos/1st.mp4',
      );
    }
    final init = VideoCache.instance.getInitialization('assets/videos/1st.mp4');
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
                            'Fish Files\nUnlocked',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.titleLarge,
                          ),
                          SizedBox(height: 24),
                          SizedBox(
                            height: AppConstants.getTitleSpacing(context),
                          ),
                          Text(
                            'From fossil records to wild myths — each entry dives deep into prehistoric life.  Learn how these creatures swam, hunted, and survived.',
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
                      Navigator.pushNamed(context, '/onboarding3');
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
