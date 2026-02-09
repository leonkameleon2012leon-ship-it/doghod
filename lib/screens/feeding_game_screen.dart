import 'package:flame/game.dart';
import 'package:flutter/material.dart';

import '../doghog_controller.dart';
import '../games/feeding_game.dart';
import '../i18n.dart';

class FeedingGameScreen extends StatefulWidget {
  const FeedingGameScreen({super.key, required this.controller});

  final DogHogController controller;

  @override
  State<FeedingGameScreen> createState() => _FeedingGameScreenState();
}

class _FeedingGameScreenState extends State<FeedingGameScreen> {
  late FeedingGame _game;
  int _score = 0;
  int _timeLeft = 20;
  bool _completed = false;
  bool _rewarded = false;
  int _reward = 0;

  @override
  void initState() {
    super.initState();
    _game = FeedingGame(
      onScore: (score) {
        setState(() {
          _score = score;
        });
      },
      onTimeChanged: (secondsLeft) {
        setState(() {
          _timeLeft = secondsLeft;
        });
      },
      onGameOver: (score) {
        if (_completed) {
          return;
        }
        final reward = (score * 2).clamp(2, 40).toInt();
        setState(() {
          _completed = true;
          _reward = reward;
        });
        if (!_rewarded) {
          widget.controller.feed(reward);
          _rewarded = true;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Kitchen/table gradient background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFF4E6),
              Color(0xFFFFE5CC),
              Color(0xFFFFF8E1),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Game canvas
            GameWidget(game: _game),
            // Top HUD Bar - rounded and colorful
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Score and Time
                      Row(
                        children: [
                          Expanded(
                            child: _RoundedHUDItem(
                              icon: Icons.star,
                              label: '$_score',
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFFD54F), Color(0xFFFFB300)],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _RoundedHUDItem(
                              icon: Icons.timer,
                              label: '${_timeLeft}s',
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF7043), Color(0xFFD84315)],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Food preferences
                      Row(
                        children: [
                          Expanded(
                            child: _FoodPreferenceBanner(
                              label: I18n.tr('food${_game.preferredFood}'),
                              icon: Icons.favorite,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF66BB6A), Color(0xFF43A047)],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _FoodPreferenceBanner(
                              label: I18n.tr('food${_game.dislikedFood}'),
                              icon: Icons.close,
                              gradient: const LinearGradient(
                                colors: [Color(0xFFEF5350), Color(0xFFE53935)],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Back button
            Positioned(
              top: 0,
              left: 0,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Material(
                    color: Colors.white,
                    shape: const CircleBorder(),
                    elevation: 4,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Color(0xFFFF6B6B)),
                      onPressed: () => Navigator.of(context).pop(),
                      iconSize: 28,
                    ),
                  ),
                ),
              ),
            ),
            // Game completion dialog
            if (_completed)
              Container(
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
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 30,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(32),
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
                        const SizedBox(height: 24),
                        Text(
                          I18n.tr('gameOver'),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFFF6B6B),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFFD54F), Color(0xFFFFB300)],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            I18n.trf('scoreLabel', {'score': '$_score'}),
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          I18n.trf('rewardHunger', {'amount': '$_reward'}),
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFF6B6B),
                          ),
                        ),
                        const SizedBox(height: 28),
                        // Back home button
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => Navigator.of(context).pop(),
                            borderRadius: BorderRadius.circular(24),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                                ),
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.red.withOpacity(0.4),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 48),
                              child: Text(
                                I18n.tr('backHome'),
                                style: const TextStyle(
                                  fontSize: 20,
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
              ),
          ],
        ),
      ),
    );
  }
}

// Rounded HUD item for score/time display
class _RoundedHUDItem extends StatelessWidget {
  const _RoundedHUDItem({
    required this.icon,
    required this.label,
    required this.gradient,
  });

  final IconData icon;
  final String label;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(width: 10),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
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
    );
  }
}

// Food preference banner
class _FoodPreferenceBanner extends StatelessWidget {
  const _FoodPreferenceBanner({
    required this.label,
    required this.icon,
    required this.gradient,
  });

  final String label;
  final IconData icon;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
