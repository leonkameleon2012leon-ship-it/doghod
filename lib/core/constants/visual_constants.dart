import 'package:flutter/material.dart';

/// Visual constants for DogHot casual mobile game
/// Contains colors, gradients, sizes, and visual styling
class GameColors {
  // Primary theme colors
  static const Color primary = Color(0xFFFF6B6B);
  static const Color secondary = Color(0xFF4ECDC4);
  static const Color accent = Color(0xFFFFE66D);
  
  // Stat colors
  static const Color hungerColor = Color(0xFFFF6B6B);
  static const Color happinessColor = Color(0xFFFFD93D);
  static const Color cleanlinessColor = Color(0xFF6BCB77);
  
  // Stat gradient colors
  static const Color hungerStart = Color(0xFFFF6B6B);
  static const Color hungerEnd = Color(0xFFFF8E53);
  
  static const Color happinessStart = Color(0xFF4ECDC4);
  static const Color happinessEnd = Color(0xFF44A08D);
  
  static const Color cleanlinessStart = Color(0xFF5DADE2);
  static const Color cleanlinessEnd = Color(0xFF3498DB);
  
  // Background gradients
  static const LinearGradient hubBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFE8F5),
      Color(0xFFFFF5E8),
      Color(0xFFE8F5FF),
    ],
  );
  
  static const LinearGradient feedingBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFFFFF4E6),
      Color(0xFFFFE5CC),
      Color(0xFFFFF8E1),
    ],
  );
  
  static const LinearGradient pipesBackground = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF89CFF0),
      Color(0xFF5DADE2),
      Color(0xFF3498DB),
    ],
  );
  
  // Dog character gradient
  static const LinearGradient dogGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFD8A8),
      Color(0xFFFFB88C),
    ],
  );
  
  // Food colors
  static const Color sausageColor = Color(0xFFE76F51);
  static const Color chickenColor = Color(0xFFF4A261);
  static const Color carrotColor = Color(0xFFE9C46A);
  static const Color boneColor = Color(0xFFFFFFFF);
  static const Color fishColor = Color(0xFF4DD0E1);
  
  // UI colors
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF2C3E50);
  static const Color textSecondary = Color(0xFF7F8C8D);
  static const Color successColor = Color(0xFF66BB6A);
  static const Color errorColor = Color(0xFFEF5350);
  static const Color warningColor = Color(0xFFFFAB00);
  
  // Shadow colors
  static Color shadowLight = Colors.black.withOpacity(0.1);
  static Color shadowMedium = Colors.black.withOpacity(0.2);
  static Color shadowDark = Colors.black.withOpacity(0.3);
}

/// Size constants for consistent UI elements
class GameSizes {
  // Dog character
  static const double dogSize = 200.0;
  static const double dogSizeSmall = 120.0;
  static const double dogIconSize = 90.0;
  
  // Buttons
  static const double buttonHeight = 60.0;
  static const double buttonHeightSmall = 48.0;
  static const double iconButtonSize = 56.0;
  
  // Stat bars
  static const double statBarHeight = 40.0;
  static const double statBarIconSize = 56.0;
  
  // Cards and containers
  static const double cardPadding = 20.0;
  static const double cardPaddingLarge = 28.0;
  static const double borderRadius = 24.0;
  static const double borderRadiusSmall = 16.0;
  static const double borderRadiusLarge = 32.0;
  
  // Spacing
  static const double spacingSmall = 8.0;
  static const double spacingMedium = 16.0;
  static const double spacingLarge = 24.0;
  static const double spacingXLarge = 32.0;
  
  // Food items (Feeding Frenzy)
  static const double foodItemMinRadius = 32.0;
  static const double foodItemMaxRadius = 42.0;
  static const double foodItemRadiusVariation = 10.0;
  
  // Pipe tiles (Pipe Fix)
  static const double pipeTileMinSize = 60.0;
  static const double pipeTileMaxSize = 100.0;
  static const double pipeWidth = 0.45; // Relative to tile size
  
  // Typography
  static const double fontSizeSmall = 14.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeLarge = 20.0;
  static const double fontSizeXLarge = 24.0;
  static const double fontSizeTitle = 32.0;
  static const double fontSizeHuge = 40.0;
}

/// Animation durations and curves
class GameAnimations {
  static const Duration fast = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  
  static const Curve easeIn = Curves.easeIn;
  static const Curve easeOut = Curves.easeOut;
  static const Curve easeInOut = Curves.easeInOut;
  static const Curve bounce = Curves.bounceOut;
}
