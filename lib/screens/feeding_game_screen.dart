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
      ),
      body: Stack(
        children: [
          GameWidget(game: _game),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _InfoChip(
                  label: I18n.trf('scoreLabel', {
                    'score': '$_score',
                  }),
                ),
                _InfoChip(
                  label: I18n.trf('timeLabel', {
                    'seconds': '$_timeLeft',
                  }),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 24,
            left: 16,
            right: 16,
            child: _InfoChip(label: I18n.tr('feedingHint')),
          ),
          if (_completed)
            Center(
              child: Card(
                elevation: 6,
                margin: const EdgeInsets.all(24),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        I18n.tr('gameOver'),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        I18n.trf('rewardHunger', {
                          'amount': '$_reward',
                        }),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(I18n.tr('backHome')),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label),
    );
  }
}
