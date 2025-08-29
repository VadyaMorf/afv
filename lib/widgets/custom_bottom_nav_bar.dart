import 'package:flutter/material.dart';
import 'package:ancient_fishin_vault/core/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  static const double _barHeight = 84;
  static const double _barRadius = 42;
  static const double _horizontalMargin = 16;
  static const double _iconCircleDiameter = _barHeight;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenWidth = constraints.maxWidth;
        final double barWidth = screenWidth - (_horizontalMargin * 2);
        final double itemWidth = barWidth / 4;

        // Адаптивное позиционирование кружка с точным выравниванием по краям
        late final double circleLeft;

        if (currentIndex == 0) {
          // Первый элемент - кружок начинается с левого края
          circleLeft = 0.0;
        } else if (currentIndex == 3) {
          // Последний элемент - кружок заканчивается у правого края
          circleLeft = barWidth - _iconCircleDiameter;
        } else {
          // Средние элементы - точное центрирование
          final double itemCenterOffset =
              (itemWidth * currentIndex) + (itemWidth / 2);
          circleLeft = itemCenterOffset - (_iconCircleDiameter / 2);
        }

        return SizedBox(
          height: _barHeight + 20,
          width: constraints.maxWidth,
          child: Center(
            child: SizedBox(
              width: barWidth,
              height: _barHeight + 20,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      height: _barHeight,
                      decoration: BoxDecoration(
                        color: AppColors.overlayBlue,
                        borderRadius: BorderRadius.circular(_barRadius),
                        border: Border.all(
                          color: AppColors.accentOrange,
                          width: 2,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: AppColors.shadow25,
                            blurRadius: 10,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                    ),
                  ),

                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 380),
                    curve: Curves.easeInOut,
                    left: circleLeft,
                    bottom: 0,
                    child: Container(
                      width: _iconCircleDiameter,
                      height: _iconCircleDiameter,
                      decoration: const BoxDecoration(
                        color: AppColors.accentOrange,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),

                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: SizedBox(
                      height: _barHeight,
                      child: Row(
                        children: [
                          _NavItem(
                            assetPath: 'assets/home_icon.png',
                            index: 0,
                            currentIndex: currentIndex,
                            onTap: onItemSelected,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(right: 15),
                          ),
                          _NavItem(
                            assetPath: 'assets/articles_icon.png',
                            index: 1,
                            currentIndex: currentIndex,
                            onTap: onItemSelected,
                            alignment: Alignment.center,
                          ),
                          _NavItem(
                            assetPath: 'assets/game_icon.png',
                            index: 2,
                            currentIndex: currentIndex,
                            onTap: onItemSelected,
                            alignment: Alignment.center,
                          ),
                          _NavItem(
                            assetPath: 'assets/settings_icon.png',
                            index: 3,
                            currentIndex: currentIndex,
                            onTap: onItemSelected,
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(left: 15),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.assetPath,
    required this.index,
    required this.currentIndex,
    required this.onTap,
    this.alignment = Alignment.center,
    this.padding = EdgeInsets.zero,
  });

  final String assetPath;
  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;
  final Alignment alignment;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: padding,
        child: Align(
          alignment: alignment,
          child: InkResponse(
            onTap: () => onTap(index),
            radius: 32,
            child: Image.asset(
              assetPath,
              width: 60,
              height: 60,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
