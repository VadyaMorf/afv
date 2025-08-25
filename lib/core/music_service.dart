import 'package:audioplayers/audioplayers.dart';
import 'package:ancient_fishin_vault/core/game_preferences_service.dart';
import 'package:flutter/foundation.dart';

class MusicService {
  static final MusicService _instance = MusicService._internal();
  factory MusicService() => _instance;
  MusicService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isInitialized = false;
  bool _isPlaying = false;

  Future<void> initialize() async {
    if (_isInitialized) {
      debugPrint('MusicService: Плеер уже инициализирован');
      return;
    }

    debugPrint('MusicService: Инициализирую плеер...');
    try {
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.setVolume(0.5);
      _isInitialized = true;
      debugPrint('MusicService: Плеер инициализирован');
    } catch (e) {
      debugPrint('MusicService: Ошибка инициализации плеера: $e');
    }
  }

  Future<void> playBackgroundMusic() async {
    await _ensureInitialized();

    final isEnabled = await GamePreferencesService.isMusicEnabled();
    debugPrint(
      'MusicService: playBackgroundMusic - настройка музыки: $isEnabled',
    );

    if (isEnabled && !_isPlaying) {
      try {
        debugPrint('MusicService: Запускаю воспроизведение музыки');
        await _audioPlayer.play(AssetSource('music/music.mp3'));
        _isPlaying = true;
        debugPrint('MusicService: Музыка запущена');
      } catch (e) {
        debugPrint('Ошибка воспроизведения музыки: $e');
        _isPlaying = false;
      }
    }
  }

  Future<void> stopBackgroundMusic() async {
    await _ensureInitialized();

    try {
      debugPrint('MusicService: Останавливаю музыку');
      await _audioPlayer.stop();
      _isPlaying = false;
      debugPrint('MusicService: Музыка остановлена');
    } catch (e) {
      debugPrint('Ошибка остановки музыки: $e');
    }
  }

  Future<void> pauseBackgroundMusic() async {
    await _ensureInitialized();

    try {
      debugPrint('MusicService: Ставлю музыку на паузу');
      await _audioPlayer.pause();
      _isPlaying = false;
      debugPrint('MusicService: Музыка на паузе');
    } catch (e) {
      debugPrint('Ошибка паузы музыки: $e');
    }
  }

  Future<void> resumeBackgroundMusic() async {
    await _ensureInitialized();

    final isEnabled = await GamePreferencesService.isMusicEnabled();
    debugPrint(
      'MusicService: resumeBackgroundMusic - настройка музыки: $isEnabled',
    );

    if (isEnabled) {
      try {
        final state = _audioPlayer.state;
        debugPrint('MusicService: Состояние плеера при возобновлении: $state');

        if (state == PlayerState.stopped) {
          debugPrint('MusicService: Плеер остановлен, запускаю заново');
          await _audioPlayer.play(AssetSource('music/music.mp3'));
          _isPlaying = true;
        } else if (state == PlayerState.paused) {
          debugPrint('MusicService: Возобновляю с паузы');
          await _audioPlayer.resume();
          _isPlaying = true;
        }
        debugPrint('MusicService: Музыка возобновлена');
      } catch (e) {
        debugPrint('Ошибка возобновления музыки: $e');
        _isPlaying = false;
      }
    }
  }

  Future<void> updateMusicState() async {
    await _ensureInitialized();

    final isEnabled = await GamePreferencesService.isMusicEnabled();
    debugPrint('MusicService: updateMusicState - настройка музыки: $isEnabled');

    if (isEnabled) {
      try {
        final state = _audioPlayer.state;
        debugPrint(
          'MusicService: Состояние плеера: $state, _isPlaying: $_isPlaying',
        );

        if (state == PlayerState.stopped || !_isPlaying) {
          debugPrint('MusicService: Запускаю музыку заново');
          await _audioPlayer.play(AssetSource('music/music.mp3'));
          _isPlaying = true;
        } else if (state == PlayerState.paused) {
          debugPrint('MusicService: Возобновляю музыку');
          await _audioPlayer.resume();
          _isPlaying = true;
        } else {
          debugPrint('MusicService: Музыка уже играет');
        }
      } catch (e) {
        debugPrint('Ошибка обновления состояния музыки: $e');
        _isPlaying = false;
      }
    } else {
      debugPrint('MusicService: Музыка выключена, ставим на паузу');
      await pauseBackgroundMusic();
    }
  }

  Future<void> _ensureInitialized() async {
    if (!_isInitialized) {
      debugPrint('MusicService: Плеер не инициализирован, инициализирую...');
      await initialize();
    }
  }

  void dispose() {
    debugPrint('MusicService: Освобождаю ресурсы плеера');
    _audioPlayer.dispose();
    _isInitialized = false;
    _isPlaying = false;
  }
}
