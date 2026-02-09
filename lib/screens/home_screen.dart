import 'package:flutter/material.dart';

import '../doghog_controller.dart';
import '../i18n.dart';
import 'feeding_game_screen.dart';
import 'pipes_game_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key, required this.controller});

  final DogHogController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Scaffold(
          // Gradient background
          body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFFFE8F5),
                  Color(0xFFFFF5E8),
                  Color(0xFFE8F5FF),
                ],
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  // Custom AppBar
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                            // Coins display
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.star, size: 24, color: Color(0xFFFFAB00)),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${controller.happiness}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Color(0xFFFFAB00),
                                    ),
                                  ),
                                ],
                              ),
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
                                onSelected: (value) => controller.setLanguage(value),
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
                                  borderRadius: BorderRadius.circular(32),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: 20,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(28),
                                child: Column(
                                  children: [
                                    // Dog character - much bigger
                                    Container(
                                      height: 160,
                                      width: 160,
                                      decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xFFFFD8A8),
                                            Color(0xFFFFB88C),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(80),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.orange.withOpacity(0.3),
                                            blurRadius: 16,
                                            offset: const Offset(0, 6),
                                          ),
                                        ],
                                      ),
                                      child: const Icon(
                                        Icons.pets,
                                        size: 90,
                                        color: Color(0xFF8D6E63),
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      I18n.tr('petName'),
                                      style: const TextStyle(
                                        fontSize: 32,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF5D4037),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      I18n.tr('welcome'),
                                      textAlign: TextAlign.center,
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
                              // Stats Section - THICK bars
                              _ThickStatBar(
                                label: I18n.tr('hunger'),
                                value: controller.hunger,
                                startColor: const Color(0xFFFF6B6B),
                                endColor: const Color(0xFFFF8E53),
                                icon: Icons.restaurant,
                              ),
                              const SizedBox(height: 16),
                              _ThickStatBar(
                                label: I18n.tr('happiness'),
                                value: controller.happiness,
                                startColor: const Color(0xFF4ECDC4),
                                endColor: const Color(0xFF44A08D),
                                icon: Icons.sentiment_very_satisfied,
                              ),
                              const SizedBox(height: 16),
                              _ThickStatBar(
                                label: I18n.tr('cleanliness'),
                                value: controller.cleanliness,
                                startColor: const Color(0xFF5DADE2),
                                endColor: const Color(0xFF3498DB),
                                icon: Icons.water_drop,
                              ),
                              const SizedBox(height: 32),
                              // Action Buttons - BIG and rounded
                              _BigGameButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => FeedingGameScreen(controller: controller),
                                    ),
                                  );
                                },
                                label: I18n.tr('playFeeding'),
                                icon: Icons.restaurant,
                                startColor: const Color(0xFFFF6B6B),
                                endColor: const Color(0xFFFF8E53),
                              ),
                              const SizedBox(height: 16),
                              _BigGameButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => PipesGameScreen(controller: controller),
                                    ),
                                  );
                                },
                                label: I18n.tr('playWater'),
                                icon: Icons.water_drop,
                                startColor: const Color(0xFF5DADE2),
                                endColor: const Color(0xFF3498DB),
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

// Thick, rounded progress bar widget for casual game feel
class _ThickStatBar extends StatelessWidget {
  const _ThickStatBar({
    required this.label,
    required this.value,
    required this.startColor,
    required this.endColor,
    required this.icon,
  });

  final String label;
  final int value;
  final Color startColor;
  final Color endColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Icon with gradient background
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [startColor, endColor],
              ),
              borderRadius: BorderRadius.circular(16),
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
          const SizedBox(width: 16),
          // Progress bar and label
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF424242),
                  ),
                ),
                const SizedBox(height: 8),
                Stack(
                  children: [
                    // Background bar
                    Container(
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    // Progress bar with gradient
                    FractionallySizedBox(
                      widthFactor: value / 100,
                      child: Container(
                        height: 24,
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
                      height: 24,
                      alignment: Alignment.center,
                      child: Text(
                        '$value%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: value > 50 ? Colors.white : Colors.grey[800],
                          shadows: value > 50
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

// Big, colorful game button with gradient
class _BigGameButton extends StatelessWidget {
  const _BigGameButton({
    required this.onPressed,
    required this.label,
    required this.icon,
    required this.startColor,
    required this.endColor,
  });

  final VoidCallback onPressed;
  final String label;
  final IconData icon;
  final Color startColor;
  final Color endColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [startColor, endColor],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: startColor.withOpacity(0.5),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 32),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      offset: Offset(1, 1),
                      blurRadius: 2,
                      color: Color(0x55000000),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
