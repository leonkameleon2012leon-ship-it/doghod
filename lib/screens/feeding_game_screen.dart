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
      appBar: AppBar(
        title: Text(I18n.tr('feedingTitle')),
        backgroundColor: const Color(0xFFE76F51),
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          GameWidget(game: _game),
          // Top HUD Bar with food preferences
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _HUDItem(
                        icon: Icons.star,
                        label: I18n.trf('scoreLabel', {'score': '$_score'}),
                        color: Colors.amber,
                      ),
                      _HUDItem(
                        icon: Icons.timer,
                        label: I18n.trf('timeLabel', {'seconds': '$_timeLeft'}),
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _FoodBanner(
                          label: '${I18n.tr('preferred')}: ${I18n.tr('food${_game.preferredFood}')}',
                          color: Colors.green,
                          icon: Icons.thumb_up,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _FoodBanner(
                          label: '${I18n.tr('disliked')}: ${I18n.tr('food${_game.dislikedFood}')}',
                          color: Colors.red,
                          icon: Icons.thumb_down,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Game completion dialog
          if (_completed)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Card(
                  elevation: 8,
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.celebration,
                          size: 64,
                          color: Color(0xFFE76F51),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          I18n.tr('gameOver'),
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          I18n.trf('scoreLabel', {'score': '$_score'}),
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          I18n.trf('rewardHunger', {'amount': '$_reward'}),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: const Color(0xFFE76F51),
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              backgroundColor: const Color(0xFFE76F51),
                              foregroundColor: Colors.white,
                            ),
                            child: Text(I18n.tr('backHome')),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _HUDItem extends StatelessWidget {
  const _HUDItem({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}

class _FoodBanner extends StatelessWidget {
  const _FoodBanner({
    required this.label,
    required this.color,
    required this.icon,
  });

  final String label;
  final Color color;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          const SizedBox(width: 4),
          Flexible(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
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
