import 'package:ancient_fishin_vault/core/app_constants.dart';
import 'package:ancient_fishin_vault/core/app_colors.dart';
import 'package:ancient_fishin_vault/core/game_preferences_service.dart';
import 'package:ancient_fishin_vault/screens/main/articles_page.dart';
import 'package:ancient_fishin_vault/screens/main/game_page.dart';
import 'package:ancient_fishin_vault/screens/main/settings_page.dart';
import 'package:ancient_fishin_vault/widgets/custom_bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:math';
import 'dart:io' show Platform;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  int? _requestedIndex;
  final GlobalKey<GamePageState> _gamePageKey = GlobalKey<GamePageState>();
  final GlobalKey<_HomeTabState> _homeTabKey = GlobalKey<_HomeTabState>();
  void _refreshAllPages() {
    final articlesState = articlesPageKey.currentState;
    if (articlesState != null) {
      articlesState.refreshFavorites();
    }
    final homeTabState = _homeTabKey.currentState;
    if (homeTabState != null) {
      homeTabState.updateFavoriteStatus();
    }
  }

  void _onTabChanged(int newIndex) {
    if (_currentIndex == 2 && newIndex != 2) {
      final gameState = _gamePageKey.currentState;
      if (gameState != null &&
          !gameState.isGameOver &&
          gameState.isPageActive) {
        _requestedIndex = newIndex;
        gameState.showExitConfirmation();
        return;
      }
    }

    if (newIndex == 2 && _currentIndex != 2) {
      final gameState = _gamePageKey.currentState;
      if (gameState != null) {
        if (!gameState.showInstructions && !gameState.isGameOver) {
          gameState.resumeGame();
        }
      }
    }

    if (_currentIndex == 2 && newIndex != 2) {
      final gameState = _gamePageKey.currentState;
      if (gameState != null) {
        gameState.pauseGame();
      }
    }

    setState(() {
      _currentIndex = newIndex;
    });
    if (newIndex == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final homeTabState = _homeTabKey.currentState;
        if (homeTabState != null) {
          homeTabState.updateFavoriteStatus();
        }
      });
    }
    if (newIndex == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final articlesState = articlesPageKey.currentState;
        if (articlesState != null) {
          articlesState.refreshFavorites();
        }
      });
    }
  }

  void _onGameExitConfirmed() {
    if (_requestedIndex != null) {
      setState(() {
        _currentIndex = _requestedIndex!;
        _requestedIndex = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(AppConstants.assetBackground, fit: BoxFit.cover),
          ),
          Positioned.fill(
            child: SafeArea(
              child: IndexedStack(
                index: _currentIndex,
                children: [
                  _HomeTab(key: _homeTabKey),
                  ArticlesPage(key: articlesPageKey),
                  GamePage(
                    key: _gamePageKey,
                    onExitConfirmed: _onGameExitConfirmed,
                  ),
                  SettingsPage(onDataCleared: _refreshAllPages),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 12,
            child: SafeArea(
              minimum: const EdgeInsets.only(bottom: 12),
              child: CustomBottomNavBar(
                currentIndex: _currentIndex,
                onItemSelected: (i) {
                  _onTabChanged(i);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HomeTab extends StatefulWidget {
  const _HomeTab({super.key});

  @override
  State<_HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<_HomeTab> {
  Map<String, String>? _currentFact;
  Map<String, dynamic>? _currentArticle;
  int? _currentArticleIndex;
  bool _isFavorite = false;
  bool _isArticleExpanded = false;
  bool? _userAnswer;
  bool _answerChecked = false;

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_currentArticleIndex != null) {
      _checkFavoriteStatus();
    }
  }

  Future<void> _loadContent() async {
    final shouldUpdate = await GamePreferencesService.shouldUpdateFacts();

    if (shouldUpdate) {
      _generateNewContent();
      final today = DateTime.now().toIso8601String().split('T')[0];
      await GamePreferencesService.setLastFactUpdateDate(today);
      final factIndex = AppConstants.dailyFacts.indexOf(_currentFact!);
      final articleIndex = AppConstants.articles.indexOf(_currentArticle!);
      await GamePreferencesService.saveCurrentContent(factIndex, articleIndex);

      print(
        'DEBUG: Saved new content - factIndex: $factIndex, articleIndex: $articleIndex',
      );
    } else {
      await _loadSavedContent();
    }
    _checkFavoriteStatus();
  }

  void _generateNewContent() {
    final random = Random();

    final factIndex = random.nextInt(AppConstants.dailyFacts.length);
    final articleIndex = random.nextInt(AppConstants.articles.length);

    print(
      'DEBUG: _generateNewContent - factIndex: $factIndex, articleIndex: $articleIndex',
    );

    setState(() {
      _currentFact = AppConstants.dailyFacts[factIndex];
      _currentArticle = AppConstants.articles[articleIndex];
      _currentArticleIndex = articleIndex;
    });
  }

  Future<void> _loadSavedContent() async {
    final factIndex = await GamePreferencesService.getCurrentFactIndex();
    final articleIndex = await GamePreferencesService.getCurrentArticleIndex();

    print(
      'DEBUG: _loadSavedContent - factIndex: $factIndex, articleIndex: $articleIndex',
    );

    if (factIndex != null &&
        articleIndex != null &&
        factIndex < AppConstants.dailyFacts.length &&
        articleIndex < AppConstants.articles.length) {
      setState(() {
        _currentFact = AppConstants.dailyFacts[factIndex];
        _currentArticle = AppConstants.articles[articleIndex];
        _currentArticleIndex = articleIndex;
      });
    } else {
      print('DEBUG: Invalid saved indices, generating new content');
      _generateNewContent();
    }
  }

  Future<void> _checkFavoriteStatus() async {
    if (_currentArticleIndex != null) {
      final isFav = await GamePreferencesService.isFavorite(
        _currentArticleIndex!,
      );
      print(
        'DEBUG: _checkFavoriteStatus - articleIndex: $_currentArticleIndex, isFavorite: $isFav',
      );
      if (mounted) {
        setState(() {
          _isFavorite = isFav;
        });
      }
    }
  }

  Future<void> updateFavoriteStatus() async {
    await _checkFavoriteStatus();
  }

  Future<void> _toggleFavorite() async {
    if (_currentArticleIndex != null) {
      print(
        'DEBUG: _toggleFavorite - articleIndex: $_currentArticleIndex, currentState: $_isFavorite',
      );
      if (_isFavorite) {
        await GamePreferencesService.removeFromFavorites(_currentArticleIndex!);
        print('DEBUG: Removed from favorites');
      } else {
        await GamePreferencesService.addToFavorites(_currentArticleIndex!);
        print('DEBUG: Added to favorites');
      }

      if (mounted) {
        setState(() {
          _isFavorite = !_isFavorite;
        });
      }
    }
  }

  void _toggleArticleExpansion() {
    setState(() {
      _isArticleExpanded = !_isArticleExpanded;
      if (!_isArticleExpanded) {
        _userAnswer = null;
        _answerChecked = false;
      }
    });
  }

  Future<void> _handleQuizAnswer(bool userAnswer) async {
    final isReal = _currentArticle!['isReal'] as bool? ?? false;
    final isCorrect = userAnswer == isReal;

    setState(() {
      _userAnswer = userAnswer;
      _answerChecked = true;
    });

    if (!isCorrect) {
      GamePreferencesService.isVibrationEnabled()
          .then((vibrationEnabled) async {
            if (vibrationEnabled) {
              try {
                if (Platform.isIOS) {
                  HapticFeedback.heavyImpact();
                } else {
                  HapticFeedback.mediumImpact();
                }
              } catch (e) {}
            }
          })
          .catchError((error) {});
    }
  }

  void _shareContent(String content) {
    Share.share(content);
  }

  @override
  Widget build(BuildContext context) {
    if (_currentFact == null || _currentArticle == null) {
      return const SafeArea(child: Center(child: CircularProgressIndicator()));
    }

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.contentHorizontalPadding,
          ),
          child: Column(
            children: [
              const SizedBox(height: 46),
              if (!_isArticleExpanded) ...[
                _HomeFactCard(
                  fact: _currentFact!,
                  onShare: () => _shareContent(
                    '${_currentFact!['title']}\n\n${_currentFact!['content']}',
                  ),
                ),
                const SizedBox(height: 16),
              ],
              _HomeFishCard(
                article: _currentArticle!,
                isFavorite: _isFavorite,
                isExpanded: _isArticleExpanded,
                userAnswer: _userAnswer,
                answerChecked: _answerChecked,
                onToggleFavorite: _toggleFavorite,
                onShare: () => _shareContent(
                  '${_currentArticle!['title']} — ${_currentArticle!['subtitle']}\n\n${_currentArticle!['content']}',
                ),
                onRead: _toggleArticleExpansion,
                onQuizAnswer: _handleQuizAnswer,
              ),
              const SizedBox(height: 72),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeFactCard extends StatelessWidget {
  final Map<String, String> fact;
  final VoidCallback onShare;

  const _HomeFactCard({required this.fact, required this.onShare});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.overlayBlue.withOpacity(0.9),
        borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
        border: Border.all(
          color: AppColors.accentOrange,
          width: AppConstants.cardBorderWidth,
        ),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow25,
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: 12,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                'Fact of a Day',
                style: GoogleFonts.montserrat(
                  color: const Color(0xFFFEAB0D),
                  fontSize: 21,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                  height: 1.2,
                ),
              ),
            ),
          ),
          Positioned(
            left: -18,
            bottom: 0,
            child: Image.asset(
              AppConstants.assetHomeMan,
              height: 210,
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 44, 0, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(width: MediaQuery.of(context).size.width * 0.33),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        fact['title']!,
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        fact['content']!,
                        style: GoogleFonts.montserrat(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      GestureDetector(
                        onTap: onShare,
                        child: Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            AppConstants.assetShareButton,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ],
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

class _HomeFishCard extends StatelessWidget {
  final Map<String, dynamic> article;
  final bool isFavorite;
  final bool isExpanded;
  final bool? userAnswer;
  final bool answerChecked;
  final VoidCallback onToggleFavorite;
  final VoidCallback onShare;
  final VoidCallback onRead;
  final Function(bool) onQuizAnswer;

  const _HomeFishCard({
    required this.article,
    required this.isFavorite,
    required this.isExpanded,
    this.userAnswer,
    this.answerChecked = false,
    required this.onToggleFavorite,
    required this.onShare,
    required this.onRead,
    required this.onQuizAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.overlayBlue,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0xFFFEAB0D), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: isExpanded
              ? _buildExpandedContent()
              : _buildCollapsedContent(),
        ),
      ),
    );
  }

  Widget _buildCollapsedContent() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(article['image'], width: 100, fit: BoxFit.cover),

        Expanded(
          child: Column(
            children: [
              Text(
                article['title'],
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  color: AppColors.textOnDark,
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 4),
              Text(
                article['subtitle'],
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  color: AppColors.textOnDark,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                  height: 1.2,
                ),
              ),

              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _FishCardActionButton(
                    icon: isFavorite
                        ? AppConstants.assetStarActiveIcon
                        : AppConstants.assetStarIcon,
                    onTap: onToggleFavorite,
                  ),
                  const SizedBox(width: 8),
                  _FishCardActionButton(
                    icon: AppConstants.assetReadButton,
                    onTap: onRead,
                  ),
                  const SizedBox(width: 8),
                  _FishCardActionButton(
                    icon: AppConstants.assetSendIcon,
                    onTap: onShare,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExpandedContent() {
    return GestureDetector(
      onTap: onRead,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(article['image'], height: 120, fit: BoxFit.contain),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        article['title'],
                        textAlign: TextAlign.left,
                        style: GoogleFonts.montserrat(
                          color: AppColors.textOnDark,
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        article['subtitle'],
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        style: GoogleFonts.montserrat(
                          color: AppColors.textOnDark,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(
              article['content'],
              style: GoogleFonts.montserrat(
                color: AppColors.textOnDark,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
                height: 1.2,
              ),
            ),

            const SizedBox(height: 24),
            GestureDetector(
              onTap: () {},
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _FishCardActionButton(
                    icon: isFavorite
                        ? AppConstants.assetStarActiveIcon
                        : AppConstants.assetStarIcon,
                    onTap: onToggleFavorite,
                  ),
                  GestureDetector(
                    onTap: answerChecked ? null : () => onQuizAnswer(true),
                    child: answerChecked
                        ? ((article['isReal'] as bool? ?? false)
                              ? Image.asset('assets/real_green.png')
                              : Image.asset('assets/real_red.png'))
                        : Image.asset('assets/real_yellow.png'),
                  ),
                  GestureDetector(
                    onTap: answerChecked ? null : () => onQuizAnswer(false),
                    child: answerChecked
                        ? ((article['isReal'] as bool? ?? false)
                              ? Image.asset('assets/myth_red.png')
                              : Image.asset('assets/myth_green.png'))
                        : Image.asset('assets/myth_yellow.png'),
                  ),
                  _FishCardActionButton(
                    icon: AppConstants.assetSendIcon,
                    onTap: onShare,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FishCardActionButton extends StatelessWidget {
  const _FishCardActionButton({required this.icon, required this.onTap});
  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(icon, fit: BoxFit.contain),
    );
  }
}
