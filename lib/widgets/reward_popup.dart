import 'package:flutter/material.dart';
import '../models/minigame_result.dart';
import '../core/constants/visual_constants.dart';

/// Reward popup shown after completing a minigame
class RewardPopup extends StatelessWidget {
  const RewardPopup({
    super.key,
    required this.result,
    required this.onContinue,
  });

  final MinigameResult result;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.6),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 32),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFFFFFF),
                Color(0xFFFFF8E1),
              ],
            ),
            borderRadius: BorderRadius.circular(GameSizes.borderRadiusLarge),
            boxShadow: [
              BoxShadow(
                color: GameColors.shadowDark,
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          padding: const EdgeInsets.all(GameSizes.cardPaddingLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Celebration icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFFFFD54F), Color(0xFFFFB300)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withOpacity(0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.celebration,
                  size: 56,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: GameSizes.spacingLarge),
              
              // Title
              const Text(
                'Round Complete!',
                style: TextStyle(
                  fontSize: GameSizes.fontSizeTitle,
                  fontWeight: FontWeight.w900,
                  color: GameColors.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: GameSizes.spacingMedium),
              
              // Score
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFFD54F), Color(0xFFFFB300)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Score: ${result.score}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: GameSizes.spacingMedium),
              
              // Stars
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (index) {
                  return Icon(
                    index < result.stars ? Icons.star : Icons.star_border,
                    size: 40,
                    color: const Color(0xFFFFAB00),
                  );
                }),
              ),
              const SizedBox(height: GameSizes.spacingMedium),
              
              // Rewards summary
              Text(
                result.getRewardSummary(),
                style: const TextStyle(
                  fontSize: GameSizes.fontSizeLarge,
                  fontWeight: FontWeight.bold,
                  color: GameColors.successColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: GameSizes.spacingLarge + 4),
              
              // Continue button
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onContinue,
                  borderRadius: BorderRadius.circular(GameSizes.borderRadius),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [GameColors.primary, Color(0xFFFF8E53)],
                      ),
                      borderRadius: BorderRadius.circular(GameSizes.borderRadius),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 18,
                      horizontal: 48,
                    ),
                    child: const Text(
                      'Back to Home',
                      style: TextStyle(
                        fontSize: GameSizes.fontSizeLarge,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
