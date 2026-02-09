import 'package:flutter/material.dart';
import '../core/constants/visual_constants.dart';

/// Thick, rounded stat bar widget for displaying hunger, happiness, cleanliness
class StatBar extends StatelessWidget {
  const StatBar({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.startColor,
    required this.endColor,
  });

  final String label;
  final double value; // 0.0 to 100.0
  final IconData icon;
  final Color startColor;
  final Color endColor;

  @override
  Widget build(BuildContext context) {
    final percentage = value.clamp(0.0, 100.0);
    
    return Container(
      decoration: BoxDecoration(
        color: GameColors.cardBackground,
        borderRadius: BorderRadius.circular(GameSizes.borderRadius),
        boxShadow: [
          BoxShadow(
            color: GameColors.shadowMedium,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(GameSizes.spacingMedium),
      child: Row(
        children: [
          // Icon with gradient background
          Container(
            width: GameSizes.statBarIconSize,
            height: GameSizes.statBarIconSize,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [startColor, endColor],
              ),
              borderRadius: BorderRadius.circular(GameSizes.borderRadiusSmall),
              boxShadow: [
                BoxShadow(
                  color: startColor.withOpacity(0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 32),
          ),
          const SizedBox(width: GameSizes.spacingMedium),
          // Progress bar and label
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: GameSizes.fontSizeMedium,
                    fontWeight: FontWeight.bold,
                    color: GameColors.textPrimary,
                  ),
                ),
                const SizedBox(height: GameSizes.spacingSmall),
                Stack(
                  children: [
                    // Background bar
                    Container(
                      height: GameSizes.statBarHeight / 1.67,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    // Progress bar with gradient
                    FractionallySizedBox(
                      widthFactor: percentage / 100,
                      child: Container(
                        height: GameSizes.statBarHeight / 1.67,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [startColor, endColor],
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: startColor.withOpacity(0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Percentage text
                    Container(
                      height: GameSizes.statBarHeight / 1.67,
                      alignment: Alignment.center,
                      child: Text(
                        '${percentage.toInt()}%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: GameSizes.fontSizeSmall,
                          color: percentage > 50 ? Colors.white : Colors.grey[800],
                          shadows: percentage > 50
                              ? [
                                  const Shadow(
                                    offset: Offset(1, 1),
                                    blurRadius: 2,
                                    color: Color(0x55000000),
                                  ),
                                ]
                              : null,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
