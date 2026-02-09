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
  
  // Food types with labels and colors
  static const List<String> _foodTypes = ['Sausage', 'Chicken', 'Carrot', 'Bone'];
  static const List<Color> _foodColors = [
    Color(0xFFE76F51), // Sausage - red/orange
    Color(0xFFF4A261), // Chicken - light orange
    Color(0xFFE9C46A), // Carrot - yellow
    Color(0xFFFFFFFF), // Bone - white
  ];
  
  late String preferredFood;
  late String dislikedFood;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Pick random preferred and disliked foods
    preferredFood = _foodTypes[_random.nextInt(_foodTypes.length)];
    do {
      dislikedFood = _foodTypes[_random.nextInt(_foodTypes.length)];
    } while (dislikedFood == preferredFood);
  }

  @override
  Color backgroundColor() => const Color(0xFFF5F5DC);

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;
    _spawnTimer += dt;
    
    // Increase spawn rate based on screen size (more items on larger screens)
    final spawnInterval = size.x > 600 ? 0.4 : 0.5;
    
    if (_spawnTimer >= spawnInterval) {
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
        // Bonus points for preferred food
        final points = snack.foodType == preferredFood ? 3 : 1;
        _score += points;
        onScore(_score);
        break;
      }
    }
  }

  void _spawnSnack() {
    // Scale snack size based on screen size
    final baseRadius = size.x > 600 ? 28.0 : 22.0;
    final radius = baseRadius + _random.nextDouble() * 8;
    
    final x = _random.nextDouble() * (size.x - radius * 2) + radius;
    final speed = 100 + _random.nextDouble() * 140;
    
    final foodType = _foodTypes[_random.nextInt(_foodTypes.length)];
    final colorIndex = _foodTypes.indexOf(foodType);
    
    add(_SnackComponent(
      position: Vector2(x, -radius - 10),
      speed: speed,
      radius: radius,
      foodType: foodType,
      color: _foodColors[colorIndex],
    ));
  }
}

class _SnackComponent extends CircleComponent with HasGameRef<FeedingGame> {
  _SnackComponent({
    required Vector2 position,
    required this.speed,
    required double radius,
    required this.foodType,
    required Color color,
  }) : super(
          position: position,
          radius: radius,
          anchor: Anchor.center,
          paint: Paint()..color = color,
        );

  final double speed;
  final String foodType;
  late TextComponent _label;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Add food label
    _label = TextComponent(
      text: foodType,
      textRenderer: TextPaint(
        style: TextStyle(
          color: Colors.black87,
          fontSize: radius * 0.4,
          fontWeight: FontWeight.bold,
        ),
      ),
      anchor: Anchor.center,
    );
    add(_label);
  }

  bool containsPoint(Vector2 point) {
    // Increase hitbox slightly for better tap reliability
    return point.distanceTo(position) <= radius * 1.3;
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
