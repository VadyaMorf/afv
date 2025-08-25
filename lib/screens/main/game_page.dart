import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';
import 'dart:async';
import '../../core/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/game_preferences_service.dart';

class Fish {
  final String imagePath;
  final bool isPredator;
  final int points;
  double speed;
  double x;
  double y;
  bool isVisible;
  double rotation;
  double yOffset;

  Fish({
    required this.imagePath,
    required this.isPredator,
    required this.points,
    required this.speed,
    required this.x,
    required this.y,
    this.isVisible = true,
    this.rotation = 0.0,
    this.yOffset = 0.0,
  });
}

class _FishStatRow extends StatelessWidget {
  final String image;
  final int count;

  const _FishStatRow({required this.image, required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(image, height: 35, fit: BoxFit.cover),
        const SizedBox(width: 8),
        Text(
          'X $count',
          style: GoogleFonts.montserrat(
            color: AppColors.textOnDark,
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class Bubble {
  final double x;
  final double y;
  final int value;
  double opacity;
  double yOffset;

  Bubble({
    required this.x,
    required this.y,
    required this.value,
    this.opacity = 1.0,
    this.yOffset = 0.0,
  });
}

class GamePage extends StatefulWidget {
  final VoidCallback? onExitConfirmed;

  const GamePage({super.key, this.onExitConfirmed});

  @override
  State<GamePage> createState() => GamePageState();
}

class GamePageState extends State<GamePage> with TickerProviderStateMixin {
  int score = 0;
  int topScore = 0;
  bool showExitDialog = false;
  bool isPageActive =
      true;
  bool isGameActive =
      false;
  bool hasGameStarted =
      false;
  double gameSpeed = 2.5;
  List<Fish> fishes = [];
  List<Bubble> bubbles = [];
  Timer? gameTimer;
  Random random = Random();
  final GamePreferencesService _preferencesService = GamePreferencesService();
  final Map<String, int> predatorCounts = {
    '1_fish.png': 0,
    '2_fish.png': 0,
    '3_fish.png': 0,
  };
  final List<Map<String, dynamic>> fishTypes = [
    {'path': '1_fish.png', 'isPredator': true, 'points': 3},
    {'path': '2_fish.png', 'isPredator': true, 'points': 2},
    {'path': '3_fish.png', 'isPredator': true, 'points': 3},
    {'path': '4_fish.png', 'isPredator': false, 'points': 0},
    {'path': '5_fish.png', 'isPredator': false, 'points': 0},
    {'path': '6_fish.png', 'isPredator': false, 'points': 0},
    {'path': '7_fish.png', 'isPredator': false, 'points': 0},
    {'path': '8_fish.png', 'isPredator': false, 'points': 0},
    {'path': '9_fish.png', 'isPredator': false, 'points': 0},
    {'path': '10_fish.png', 'isPredator': false, 'points': 0},
    {'path': '11_fish.png', 'isPredator': false, 'points': 0},
    {'path': '12_fish.png', 'isPredator': false, 'points': 0},
  ];

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  Future<void> _initializeGame() async {
    await _preferencesService.init();
    _loadTopScore();
  }

  void _loadTopScore() {
    try {
      topScore = _preferencesService.getMaxScore();
    } catch (e) {
      print('Ошибка загрузки топ скора: $e');
      topScore = 0;
    }
  }
  void pauseGame() {
    setState(() {
      isPageActive = false;
    });
    gameTimer?.cancel();
  }
  void resumeGame() {
    if (!_isGameOver && !isPageActive) {
      setState(() {
        isPageActive = true;
      });
      startGameTimer();
    }
  }
  void startGameTimer() {
    gameTimer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (!_isGameOver && isPageActive) {
        updateGame();
      }
    });
  }
  bool get showInstructions => _showInstructions;
  bool _showInstructions = true;
  bool get isGameOver => _isGameOver;
  bool _isGameOver = false;

  void startGame() {
    setState(() {
      score = 0;
      _isGameOver = false;
      showExitDialog = false;
      _showInstructions = false;
      isPageActive = true;
      isGameActive = true;
      hasGameStarted = true;
      gameSpeed = 2.5;
      fishes.clear();
      bubbles.clear();
      predatorCounts.updateAll((key, value) => 0);
    });

    spawnFish();
    startGameTimer();
  }

  void spawnFish() {
    if (_isGameOver || !isPageActive) {
      print(
        'Спавн остановлен: isGameOver = $_isGameOver, isPageActive = $isPageActive',
      );
      return;
    }
    Map<String, dynamic> fishType;
    if (random.nextDouble() < 0.6) {
      fishType = fishTypes[random.nextInt(3)];
    } else {
      fishType = fishTypes[random.nextInt(fishTypes.length)];
    }
    const double fishVisualHeight = 70.0;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double usableHeight = (screenHeight - fishVisualHeight).clamp(
      0.0,
      screenHeight,
    );
    final double spawnMinY = usableHeight * 0.24;
    final double spawnMaxY = usableHeight * 0.75;
    final fish = Fish(
      imagePath: fishType['path'],
      isPredator: fishType['isPredator'],
      points: fishType['points'],
      speed: gameSpeed,
      x: -100.0,
      y: spawnMinY + random.nextDouble() * (spawnMaxY - spawnMinY),
    );

    print('Создана рыба со скоростью: $gameSpeed');

    setState(() {
      fishes.add(fish);
    });
    Future.delayed(
      Duration(
        milliseconds: 1200 + random.nextInt(2000),
      ),
      spawnFish,
    );
  }

  void updateGame() {
    if (!isPageActive) return;

    setState(() {
      for (int i = fishes.length - 1; i >= 0; i--) {
        fishes[i].x += fishes[i].speed;
        fishes[i].rotation += 0.1;
        if (fishes[i].rotation > 2 * 3.14159) {
          fishes[i].rotation = 0.0;
        }
        fishes[i].yOffset =
            3 * sin(fishes[i].rotation);
        if (fishes[i].x > MediaQuery.of(context).size.width + 100) {
          fishes.removeAt(i);
        }
      }
      for (int i = bubbles.length - 1; i >= 0; i--) {
        bubbles[i].yOffset -= 1.5;
        bubbles[i].opacity -= 0.025;
        if (bubbles[i].opacity <= 0) {
          bubbles.removeAt(i);
        }
      }
    });
  }

  Future<void> onFishTap(Fish fish) async {
    if (_isGameOver || !isPageActive || showExitDialog) return;

    if (fish.isPredator) {
      final newScore = score + fish.points;
      final shouldIncreaseSpeed =
          newScore % 10 == 0 && newScore > 0 && score % 10 != 0;

      setState(() {
        score = newScore;
        if (predatorCounts.containsKey(fish.imagePath)) {
          predatorCounts[fish.imagePath] =
              (predatorCounts[fish.imagePath] ?? 0) + 1;
        }
        bubbles.add(Bubble(x: fish.x, y: fish.y, value: fish.points));
        fishes.remove(fish);
        if (shouldIncreaseSpeed) {
          print(
            'Увеличиваем скорость! Текущий счет: $score, новая скорость: ${gameSpeed + 0.5}',
          );
          gameSpeed += 0.5;
          for (var fish in fishes) {
            fish.speed = gameSpeed;
          }
        }
      });
    } else {
      setState(() {
        _isGameOver = true;
        isGameActive = false;
        fishes.clear();
        bubbles.clear();
        if (score > topScore) {
          topScore = score;
        }
      });
      try {
        await _preferencesService.updateMaxScoreIfHigher(score);
        if (score > topScore) {
          topScore = score;
        }
      } catch (e) {
        print('Ошибка сохранения топ скора: $e');
      }

      final isVibrationEnabled =
          await GamePreferencesService.isVibrationEnabled();
      if (isVibrationEnabled) {
        try {
          HapticFeedback.heavyImpact();
        } catch (e) {
        }
      }
    }
  }

  void showExitConfirmation() {
    setState(() {
      showExitDialog = true;
      isPageActive = false;
    });
    gameTimer?.cancel();
  }

  void hideExitDialog() {
    setState(() {
      showExitDialog = false;
      if (isGameActive) {
        isPageActive = true;
      }
    });
    if (isGameActive && isPageActive) {
      startGameTimer();
    }
  }

  void confirmExit() {
    setState(() {
      _isGameOver = true;
      isGameActive = false;
      _showInstructions = false;
      isPageActive = false;
      fishes.clear();
      bubbles.clear();
    });
    gameTimer?.cancel();
    hideExitDialog();
    widget.onExitConfirmed?.call();
  }

  @override
  void dispose() {
    gameTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Build: isGameOver = $_isGameOver, fishes count = ${fishes.length}');
    return WillPopScope(
      onWillPop: () async {
        if (hasGameStarted &&
            isGameActive &&
            !_showInstructions &&
            !showExitDialog) {
          showExitConfirmation();
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            if (isPageActive && !_showInstructions) ...[
              Positioned(
                top: 10,
                left: 20,
                child: Text(
                  'SCORE: $score',
                  style: GoogleFonts.montserrat(
                    color: AppColors.textOnDark,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              Positioned(
                top: 10,
                right: 20,
                child: Text(
                  'TOP SCORE: $topScore',
                  style: GoogleFonts.montserrat(
                    color: AppColors.textOnDark,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],

            if (!_isGameOver &&
                isPageActive &&
                !_showInstructions &&
                !showExitDialog) ...[
              ...fishes
                  .map(
                    (fish) => Positioned(
                      left: fish.x,
                      top: fish.y + fish.yOffset,
                      child: GestureDetector(
                        onTap: () async => await onFishTap(fish),
                        child: SizedBox(
                          width: 100,
                          height: 70,
                          child: Image.asset(
                            'assets/${fish.imagePath}',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
              ...bubbles
                  .map(
                    (bubble) => Positioned(
                      left: bubble.x,
                      top: bubble.y + bubble.yOffset,
                      child: Opacity(
                        opacity: bubble.opacity,
                        child: SizedBox(
                          width: 72,
                          height: 72,
                          child: Image.asset(
                            'assets/buble_${bubble.value}.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ],

            if (_showInstructions && !isGameOver)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.86,
                      height: 475,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.overlayBlue,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.accentOrange,
                          width: 3,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.shadow25,
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            left: 10,
                            top: 10,
                            child: Text(
                              'Game On: Tap to\nCatch!',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                color: Color(0xFFFEAB0D),
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 2,
                                height: 1.2,
                              ),
                            ),
                          ),
                          Positioned(
                            left: 10,
                            top: 60,
                            child: SizedBox(
                              width:
                                  MediaQuery.of(context).size.width *
                                  0.38,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 26),
                                  Text(
                                    "Some fish are predators. Others are peaceful plant-eaters on the edge of extinction. Tap to catch only the carnivorous fish! Every predator you catch earns you points: +1, +2, or even +3! But be careful — Herbivorous fish must survive. Catch one by mistake and the game ends.",
                                    textAlign: TextAlign.left,
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      height: 1.2,
                                      letterSpacing: 2,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Positioned(
                            right: -90,
                            bottom: -23,
                            child: SizedBox(
                              width: 300,
                              height: 440,
                              child: Image.asset(
                                'assets/first_men.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: startGame,
                      child: Image.asset(
                        "assets/start_button.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 40),
                  ],
                ),
              ),
            if (showExitDialog && isGameActive)
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.86,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    color: Color(0xFF042F7D),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.accentOrange, width: 3),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.shadow25,
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Oh no! You've fallen\noverboard from our\ngame. Grab the\nlifebuoy and get\nback in!\nGrab it?",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          color: Color(0xFFFEAB0D),
                          fontSize: 25,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                          letterSpacing: 2,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Image.asset("assets/rug.png", height: 170),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: confirmExit,
                            child: Image.asset("assets/yes_button.png"),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: hideExitDialog,
                            child: Image.asset("assets/no_button.png"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            if (_isGameOver)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.86,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.overlayBlue,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.accentOrange,
                          width: 3,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.shadow25,
                            blurRadius: 12,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'Game Over',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                        color: Color(0xFFFEAB0D),
                                        fontSize: 30,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "You caught a\nherbivorous fish!\nThey’re already\nendangered — be\ncareful next time.\nWant to know which fish are predators?\nRead the articles\nmore closely and try\nagain!",
                                      style: GoogleFonts.montserrat(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        height: 1.2,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 30,
                                          ),
                                          child: Row(
                                            children: [
                                              _FishStatRow(
                                                image: 'assets/1_fish.png',
                                                count:
                                                    predatorCounts['1_fish.png'] ??
                                                    0,
                                              ),
                                              const SizedBox(width: 20),
                                              _FishStatRow(
                                                image: 'assets/2_fish.png',
                                                count:
                                                    predatorCounts['2_fish.png'] ??
                                                    0,
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 70,
                                          ),
                                          child: Row(
                                            children: [
                                              _FishStatRow(
                                                image: 'assets/3_fish.png',
                                                count:
                                                    predatorCounts['3_fish.png'] ??
                                                    0,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Text(
                                          'Score: ',
                                          style: GoogleFonts.montserrat(
                                            color: Color(0xFFFEAB0D),
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          '$score',
                                          style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Text(
                                          'Best score: ',
                                          style: GoogleFonts.montserrat(
                                            color: Color(0xFFFEAB0D),
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        Text(
                                          '$topScore',
                                          style: GoogleFonts.montserrat(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Positioned(
                            right: -82,
                            bottom: -100,
                            child: SizedBox(
                              width: 220,
                              height: 480,
                              child: Image.asset(
                                'assets/game_men.png',
                                fit: BoxFit.contain,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    GestureDetector(
                      onTap: startGame,
                      child: Image.asset(
                        "assets/try_again_button.png",
                        fit: BoxFit.cover,
                      ),
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
