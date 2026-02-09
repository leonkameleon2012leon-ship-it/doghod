import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

class FeedingGame extends FlameGame with TapDetector {
  FeedingGame({
    required this.onScore,
    required this.onTimeChanged,
    required this.onGameOver,
  });

  final void Function(int score) onScore;
  final void Function(int secondsLeft) onTimeChanged;
  final void Function(int score) onGameOver;

  static const double _durationSeconds = 20;
  final Random _random = Random();
  double _elapsed = 0;
  double _spawnTimer = 0;
  int _score = 0;
  int _lastTimeLeft = _durationSeconds.toInt();

  @override
  Color backgroundColor() => const Color(0xFFFAF6EF);

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;
    _spawnTimer += dt;
    if (_spawnTimer >= 0.7) {
      _spawnTimer = 0;
      _spawnSnack();
    }
    final timeLeft = max(0, (_durationSeconds - _elapsed).ceil());
    if (timeLeft != _lastTimeLeft) {
      _lastTimeLeft = timeLeft;
      onTimeChanged(timeLeft);
    }
    if (_elapsed >= _durationSeconds) {
      onGameOver(_score);
      pauseEngine();
    }
  }

  @override
  void onTapDown(TapDownInfo info) {
    final tapPosition = info.eventPosition.game;
    final snacks = children.whereType<_SnackComponent>().toList();
    for (final snack in snacks) {
      if (snack.containsPoint(tapPosition)) {
        snack.removeFromParent();
        _score += 1;
        onScore(_score);
        break;
      }
    }
  }

  void _spawnSnack() {
    final x = _random.nextDouble() * (size.x - 30) + 15;
    final speed = 80 + _random.nextDouble() * 120;
    add(_SnackComponent(position: Vector2(x, -10), speed: speed));
  }
}

class _SnackComponent extends CircleComponent with HasGameRef<FeedingGame> {
  _SnackComponent({required Vector2 position, required this.speed})
      : super(
          position: position,
          radius: 12,
          anchor: Anchor.center,
          paint: Paint()..color = const Color(0xFFF4A261),
        );

  final double speed;

  bool containsPoint(Vector2 point) {
    return point.distanceTo(position) <= radius;
  }

  @override
  void update(double dt) {
    super.update(dt);
    position += Vector2(0, speed * dt);
    if (position.y - radius > gameRef.size.y) {
      removeFromParent();
    }
  }
}
