import 'package:flutter/material.dart';

import '../core/managers/game_manager.dart';
import '../core/constants/visual_constants.dart';
import '../widgets/stat_bar.dart';
import '../widgets/game_button.dart';
import '../widgets/dog_character.dart';
import '../widgets/coin_display.dart';
import '../widgets/gradient_background.dart';
import '../i18n.dart';
import 'feeding_game_screen.dart';
import 'pipes_game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.gameManager});

  final GameManager gameManager;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: gameManager,
      builder: (context, _) {
        final dog = gameManager.dog;
        final gameState = gameManager.gameState;
        
        return Scaffold(
          body: GradientBackground(
            gradient: GameColors.hubBackground,
            child: SafeArea(
              child: Column(
                children: [
                  // Custom AppBar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Title
                        Text(
                          I18n.tr('appTitle'),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFFF6B9D),
                            shadows: [
                              Shadow(
                                offset: Offset(2, 2),
                                blurRadius: 4,
                                color: Color(0x33000000),
                              ),
                            ],
                          ),
                        ),
                        // Right side controls
                        Row(
                          children: [
                            // Happiness/Stars display
                            CoinDisplay(
                              amount: gameState.stars,
                              icon: Icons.star,
                              color: const Color(0xFFFFAB00),
                            ),
                            const SizedBox(width: 8),
                            // Language selector
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: PopupMenuButton<String>(
                                icon: const Icon(Icons.language, size: 24),
                                onSelected: (value) =>
                                    gameManager.setLanguage(value),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    value: 'en',
                                    child: Text(I18n.tr('english')),
                                  ),
                                  PopupMenuItem(
                                    value: 'pl',
                                    child: Text(I18n.tr('polish')),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Main content
                  Expanded(
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 480),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Dog Card - BIG and prominent
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    GameSizes.borderRadiusLarge,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(
                                  GameSizes.cardPaddingLarge,
                                ),
                                child: Column(
                                  children: [
                                    // Dog character - interactive
                                    DogCharacter(
                                      dog: dog,
                                      size: 160,
                                      onTap: () {
                                        gameManager.petDog();
                                        // Could show +1 animation here
                                      },
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      dog.name,
                                      style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF5D4037),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '${I18n.tr('level')} ${dog.level}',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.grey[600],
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 28),
                              // Stats Section - using new StatBar widget
                              StatBar(
                                label: I18n.tr('hunger'),
                                value: dog.hunger,
                                startColor: GameColors.hungerStart,
                                endColor: GameColors.hungerEnd,
                                icon: Icons.restaurant,
                              ),
                              const SizedBox(height: 16),
                              StatBar(
                                label: I18n.tr('happiness'),
                                value: dog.happiness,
                                startColor: GameColors.happinessStart,
                                endColor: GameColors.happinessEnd,
                                icon: Icons.sentiment_very_satisfied,
                              ),
                              const SizedBox(height: 16),
                              StatBar(
                                label: I18n.tr('cleanliness'),
                                value: dog.cleanliness,
                                startColor: GameColors.cleanlinessStart,
                                endColor: GameColors.cleanlinessEnd,
                                icon: Icons.water_drop,
                              ),
                              const SizedBox(height: 32),
                              // Action Buttons - using new GameButton widget
                              GameButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => FeedingGameScreen(
                                        gameManager: gameManager,
                                      ),
                                    ),
                                  );
                                },
                                label: I18n.tr('playFeeding'),
                                icon: Icons.restaurant,
                                startColor: GameColors.hungerStart,
                                endColor: GameColors.hungerEnd,
                              ),
                              const SizedBox(height: 16),
                              GameButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => PipesGameScreen(
                                        gameManager: gameManager,
                                      ),
                                    ),
                                  );
                                },
                                label: I18n.tr('playWater'),
                                icon: Icons.water_drop,
                                startColor: GameColors.cleanlinessStart,
                                endColor: GameColors.cleanlinessEnd,
                              ),
                              const SizedBox(height: 20),
                            ],
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
      },
    );
  }
}
