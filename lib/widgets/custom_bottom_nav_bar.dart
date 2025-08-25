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
        final double barWidth = constraints.maxWidth - (_horizontalMargin * 2.5);
        final double contentWidth = barWidth;
        final double itemWidth = contentWidth / 4;
        double baseLeft = _horizontalMargin + (itemWidth * currentIndex) + (itemWidth / 2) - (_iconCircleDiameter / 2);
        double left = baseLeft - (currentIndex == 3 ? 14 : 18);

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
                        border: Border.all(color: AppColors.accentOrange, width: 2),
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
                    left: left,
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
                            padding: const EdgeInsets.only(right: 5),
                          ),
                          _NavItem(
                            assetPath: 'assets/articles_icon.png',
                            index: 1,
                            currentIndex: currentIndex,
                            onTap: onItemSelected,
                          ),
                          _NavItem(
                            assetPath: 'assets/game_icon.png',
                            index: 2,
                            currentIndex: currentIndex,
                            onTap: onItemSelected,
                            padding: const EdgeInsets.only(right: 5),
                          ),
                          _NavItem(
                            assetPath: 'assets/settings_icon.png',
                            index: 3,
                            currentIndex: currentIndex,
                            onTap: onItemSelected,
                            padding: const EdgeInsets.only(left: 5),
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
     this.padding = EdgeInsets.zero,
  });
  final EdgeInsets padding;
  final String assetPath;
  final int index;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: InkResponse(
          onTap: () => onTap(index),
          radius: 32,
          child: Padding(
            padding: padding,
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


