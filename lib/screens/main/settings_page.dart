import 'package:flutter/material.dart';
import 'package:ancient_fishin_vault/core/app_colors.dart';
import 'package:ancient_fishin_vault/core/app_constants.dart';
import 'package:ancient_fishin_vault/core/game_preferences_service.dart';
import 'package:ancient_fishin_vault/core/music_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';

class SettingsPage extends StatefulWidget {
  final VoidCallback? onDataCleared;

  const SettingsPage({super.key, this.onDataCleared});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isMusicEnabled = true;
  bool isVibrationEnabled = true;
  bool _showClearNotification = false;
  final MusicService _musicService = MusicService();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() async {
    final musicEnabled = await GamePreferencesService.isMusicEnabled();
    final vibrationEnabled = await GamePreferencesService.isVibrationEnabled();
    print(
      'DEBUG: _loadSettings - musicEnabled: $musicEnabled, vibrationEnabled: $vibrationEnabled',
    );
    setState(() {
      isMusicEnabled = musicEnabled;
      isVibrationEnabled = vibrationEnabled;
    });
    await _musicService.updateMusicState();
  }

  void _toggleMusic() async {
    debugPrint(
      'SettingsPage: Переключаю музыку с $isMusicEnabled на ${!isMusicEnabled}',
    );
    setState(() {
      isMusicEnabled = !isMusicEnabled;
    });
    await GamePreferencesService.setMusicEnabled(isMusicEnabled);
    debugPrint(
      'SettingsPage: Настройка сохранена, обновляю состояние музыки...',
    );
    await _musicService.updateMusicState();
    debugPrint('SettingsPage: Состояние музыки обновлено');
  }

  void _toggleVibration() async {
    final newValue = !isVibrationEnabled;
    print(
      'DEBUG: _toggleVibration - changing from $isVibrationEnabled to $newValue',
    );
    setState(() {
      isVibrationEnabled = newValue;
    });
    await GamePreferencesService.setVibrationEnabled(isVibrationEnabled);
  }

  void _shareApp() {
    Share.share(
      'Попробуй Ancient Fishing Vault - увлекательная игра о рыбалке! 🎣',
      subject: 'Ancient Fishing Vault',
    );
  }

  void _clearSavedFish() async {
    await GamePreferencesService.clearFavorites();
    widget.onDataCleared?.call();
    setState(() {
      _showClearNotification = true;
    });
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showClearNotification = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 66),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.contentHorizontalPadding,
                    vertical: AppConstants.contentVerticalPadding + 20,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.overlayBlue.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(
                      AppConstants.cardBorderRadius,
                    ),
                    border: Border.all(
                      color: AppColors.accentOrange,
                      width: AppConstants.cardBorderWidth,
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
                      GestureDetector(
                        onTap: _toggleMusic,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Image.asset(
                            isMusicEnabled
                                ? "assets/music_on.png"
                                : "assets/music_off.png",
                            key: ValueKey(isMusicEnabled),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: _toggleVibration,
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 200),
                          child: Image.asset(
                            isVibrationEnabled
                                ? "assets/vibration_on.png"
                                : "assets/vibration_off.png",
                            key: ValueKey(isVibrationEnabled),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: _clearSavedFish,
                        child: Image.asset("assets/clear_saved.png"),
                      ),
                      const SizedBox(height: 16),
                      GestureDetector(
                        onTap: _shareApp,
                        child: Image.asset("assets/share_app.png"),
                      ),
                      const SizedBox(height: 20),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: _showClearNotification ? 1.0 : 0.0,
                        child: Text(
                          textAlign: TextAlign.center,
                          "Your saved species have been successfully deleted.",
                          style: GoogleFonts.montserrat(
                            color: AppColors.textOnDark,
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            letterSpacing: 2,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
