import 'package:ancient_fishin_vault/screens/main/articles_page.dart';
import 'package:ancient_fishin_vault/screens/main/game_page.dart';
import 'package:ancient_fishin_vault/screens/main/home_page.dart';
import 'package:ancient_fishin_vault/screens/main/settings_page.dart';
import 'package:ancient_fishin_vault/screens/onboarding/inboarding1.dart';
import 'package:ancient_fishin_vault/screens/onboarding/inboarding2.dart';
import 'package:ancient_fishin_vault/screens/onboarding/inboarding3.dart';
import 'package:ancient_fishin_vault/screens/onboarding/inboarding4.dart';
import 'package:ancient_fishin_vault/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:ancient_fishin_vault/core/app_theme.dart';
import 'package:ancient_fishin_vault/core/game_preferences_service.dart';
import 'package:ancient_fishin_vault/core/music_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GamePreferencesService().init();

  debugPrint('main: Инициализирую MusicService...');
  await MusicService().initialize();
  debugPrint('main: Обновляю состояние музыки...');
  await MusicService().updateMusicState();
  debugPrint('main: Запускаю приложение...');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final MusicService _musicService = MusicService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _musicService.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.paused:
        _musicService.pauseBackgroundMusic();
        break;
      case AppLifecycleState.resumed:
        _musicService.updateMusicState();
        break;
      case AppLifecycleState.detached:
        _musicService.stopBackgroundMusic();
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ancient Fishin Vault',
      theme: AppTheme.light(),
      home: const SplashScreen(),
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/onboarding1': (context) => const OnboardingScreen1(),
        '/onboarding2': (context) => const OnboardingScreen2(),
        '/onboarding3': (context) => const OnboardingScreen3(),
        '/onboarding4': (context) => const OnboardingScreen4(),
        '/home': (context) => const HomePage(),
        '/articles': (context) => const ArticlesPage(),
        '/game': (context) => const GamePage(),
        '/settings': (context) => const SettingsPage(),
      },
    );
  }
}
