import 'package:shared_preferences/shared_preferences.dart';

class GamePreferencesService {
  static const String _musicKey = 'music_enabled';
  static const String _vibrationKey = 'vibration_enabled';
  static const String _favoritesKey = 'favorite_articles';
  static const String _maxScoreKey = 'max_score';
  static const String _lastFactUpdateKey = 'last_fact_update';
  static const String _currentFactIndexKey = 'current_fact_index';
  static const String _currentArticleIndexKey = 'current_article_index';
  static const String _onboardingShownKey = 'onboarding_shown';

  static final GamePreferencesService _instance =
      GamePreferencesService._internal();
  factory GamePreferencesService() => _instance;
  GamePreferencesService._internal();

  late SharedPreferences _prefs;

  Future<void> init() async {
    print('DEBUG: GamePreferencesService.init - starting initialization');
    _prefs = await SharedPreferences.getInstance();
    print('DEBUG: GamePreferencesService.init - SharedPreferences initialized');
  }
  Future<void> setMaxScore(int score) async {
    await _prefs.setInt(_maxScoreKey, score);
  }

  int getMaxScore() {
    return _prefs.getInt(_maxScoreKey) ?? 0;
  }
  static Future<bool> isMusicEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_musicKey) ?? true;
  }

  static Future<void> setMusicEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_musicKey, enabled);
  }
  static Future<bool> isVibrationEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    final vibrationEnabled = prefs.getBool(_vibrationKey) ?? true;
    print('DEBUG: isVibrationEnabled - vibrationEnabled: $vibrationEnabled');
    return vibrationEnabled;
  }

  static Future<void> setVibrationEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_vibrationKey, enabled);
    print('DEBUG: setVibrationEnabled - set to: $enabled');
  }
  Future<void> updateMaxScoreIfHigher(int currentScore) async {
    final maxScore = getMaxScore();
    if (currentScore > maxScore) {
      await setMaxScore(currentScore);
    }
  }
  Future<void> clearAllData() async {
    await _prefs.clear();
  }
  static Future<List<int>> getFavoriteArticles() async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = prefs.getStringList(_favoritesKey) ?? [];
    return favorites.map((e) => int.parse(e)).toList();
  }

  static Future<void> addToFavorites(int articleId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavoriteArticles();
    print(
      'DEBUG: addToFavorites - articleId: $articleId, current favorites: $favorites',
    );
    if (!favorites.contains(articleId)) {
      favorites.add(articleId);
      await prefs.setStringList(
        _favoritesKey,
        favorites.map((e) => e.toString()).toList(),
      );
      print('DEBUG: addToFavorites - added, new favorites: $favorites');
    }
  }

  static Future<void> removeFromFavorites(int articleId) async {
    final prefs = await SharedPreferences.getInstance();
    final favorites = await getFavoriteArticles();
    print(
      'DEBUG: removeFromFavorites - articleId: $articleId, current favorites: $favorites',
    );
    favorites.remove(articleId);
    await prefs.setStringList(
      _favoritesKey,
      favorites.map((e) => e.toString()).toList(),
    );
    print('DEBUG: removeFromFavorites - removed, new favorites: $favorites');
  }

  static Future<bool> isFavorite(int articleId) async {
    final favorites = await getFavoriteArticles();
    return favorites.contains(articleId);
  }

  static Future<void> clearFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_favoritesKey);
  }
  static Future<String> getLastFactUpdateDate() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastFactUpdateKey) ?? '';
  }

  static Future<void> setLastFactUpdateDate(String date) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastFactUpdateKey, date);
  }

  static Future<bool> shouldUpdateFacts() async {
    final lastUpdate = await getLastFactUpdateDate();
    final today = DateTime.now().toIso8601String().split('T')[0];

    print(
      'DEBUG: shouldUpdateFacts - lastUpdate: "$lastUpdate", today: "$today", shouldUpdate: ${lastUpdate != today}',
    );

    return lastUpdate != today;
  }
  static Future<void> saveCurrentContent(
    int factIndex,
    int articleIndex,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_currentFactIndexKey, factIndex);
    await prefs.setInt(_currentArticleIndexKey, articleIndex);
  }

  static Future<int?> getCurrentFactIndex() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_currentFactIndexKey);
  }

  static Future<int?> getCurrentArticleIndex() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_currentArticleIndexKey);
  }
  static Future<bool> isOnboardingShown() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingShownKey) ?? false;
  }

  static Future<void> setOnboardingShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingShownKey, true);
  }
}
