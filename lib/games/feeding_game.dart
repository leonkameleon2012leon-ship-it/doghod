import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../core/constants/asset_paths.dart';

class FeedingGame extends FlameGame with TapCallbacks {
  FeedingGame({
    required this.onScore,
    required this.onTimeChanged,
    required this.onGameOver,
    String? preferredFood,
    String? dislikedFood,
  })  : preferredFood = preferredFood ?? 'Sausage',
        dislikedFood = dislikedFood ?? 'Carrot';

  final void Function(int score) onScore;
  final void Function(int secondsLeft) onTimeChanged;
  final void Function(int score) onGameOver;

  static const double _durationSeconds = 30;
  final Random _random = Random();
  double _elapsed = 0;
  double _spawnTimer = 0;
  int _score = 0;
  int _lastTimeLeft = _durationSeconds.toInt();
  
  // Food types with labels, colors, and image paths
  static const List<String> _foodTypes = ['Sausage', 'Chicken', 'Carrot', 'Bone'];
  static const List<Color> _foodColors = [
    Color(0xFFE76F51), // Sausage - red/orange
    Color(0xFFF4A261), // Chicken - light orange
    Color(0xFFE9C46A), // Carrot - yellow
    Color(0xFFFFFFFF), // Bone - white
  ];
  
  static final List<String> _foodImages = [
    AssetPaths.foodSausage,
    AssetPaths.foodChicken,
    AssetPaths.foodBone, // Using bone for carrot since carrot image doesn't exist
    AssetPaths.foodBone,
  ];
  
  // Initialize with safe defaults to prevent crashes
  final String preferredFood;
  final String dislikedFood;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Preload food images
    await images.loadAll([
      AssetPaths.foodSausage,
      AssetPaths.foodChicken,
      AssetPaths.foodBone,
      AssetPaths.foodChocolate,
    ]);
  }

  @override
  Color backgroundColor() => const Color(0xFFFFF8E1);

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
  void onTapDown(TapDownEvent event) {
    final tapPosition = event.localPosition;
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
    // Much larger snacks for mobile game feel
    final baseRadius = size.x > 600 ? 40.0 : 32.0;
    final radius = baseRadius + _random.nextDouble() * 10;
    
    final x = _random.nextDouble() * (size.x - radius * 2) + radius;
    final speed = 100 + _random.nextDouble() * 140;
    
    final foodIndex = _random.nextInt(_foodTypes.length);
    final foodType = _foodTypes[foodIndex];
    final colorIndex = _foodTypes.indexOf(foodType);
    
    add(_SnackComponent(
      position: Vector2(x, -radius - 10),
      speed: speed,
      radius: radius,
      foodType: foodType,
      color: _foodColors[colorIndex],
      imagePath: _foodImages[foodIndex],
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
    required this.imagePath,
  }) : _baseColor = color,
        super(
          position: position,
          radius: radius,
          anchor: Anchor.center,
          paint: Paint()..color = color,
        );

  final double speed;
  final String foodType;
  final Color _baseColor;
  final String imagePath;
  late TextComponent _label;
  late CircleComponent _shadow;
  SpriteComponent? _imageSprite;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Add shadow underneath
    _shadow = CircleComponent(
      radius: radius * 0.9,
      paint: Paint()..color = Colors.black.withOpacity(0.2),
      position: Vector2(0, radius * 0.15),
      anchor: Anchor.center,
    );
    add(_shadow);
    
    // Try to load and display the image
    try {
      final image = gameRef.images.fromCache(imagePath);
      _imageSprite = SpriteComponent(
        sprite: Sprite(image),
        size: Vector2.all(radius * 1.8),
        anchor: Anchor.center,
      );
      add(_imageSprite!);
      
      // Make background more transparent when image is loaded
      paint = Paint()..color = _baseColor.withOpacity(0.3);
    } catch (e) {
      // If image fails to load, use the original gradient circle design
      // Create gradient effect with multiple layers
      final highlightCircle = CircleComponent(
        radius: radius * 0.4,
        paint: Paint()..color = Colors.white.withOpacity(0.3),
        position: Vector2(-radius * 0.2, -radius * 0.2),
        anchor: Anchor.center,
      );
      add(highlightCircle);
      
      // Add food label with better styling
      _label = TextComponent(
        text: foodType,
        textRenderer: TextPaint(
          style: TextStyle(
            color: Colors.white,
            fontSize: radius * 0.35,
            fontWeight: FontWeight.w900,
            shadows: [
              const Shadow(
                offset: Offset(1, 1),
                blurRadius: 2,
                color: Color(0x88000000),
              ),
            ],
          ),
        ),
        anchor: Anchor.center,
      );
      add(_label);
      
      // Make the main circle have a gradient-like appearance
      paint = Paint()
        ..shader = RadialGradient(
          colors: [
            _baseColor.withOpacity(1.0),
            _baseColor.withOpacity(0.8),
          ],
          stops: const [0.6, 1.0],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: radius));
    }
  }

  bool containsPoint(Vector2 point) {
    // Increase hitbox for better tap reliability
    return point.distanceTo(position) <= radius * 1.4;
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
