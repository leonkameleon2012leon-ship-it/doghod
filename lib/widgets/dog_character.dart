import 'package:flutter/material.dart';
import '../models/dog_model.dart';
import '../core/constants/visual_constants.dart';

/// Dog character widget with animated display based on mood
class DogCharacter extends StatelessWidget {
  const DogCharacter({
    super.key,
    required this.dog,
    this.size = 160.0,
    this.onTap,
  });

  final DogModel dog;
  final double size;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Dog character circle
          Container(
            height: size,
            width: size,
            decoration: BoxDecoration(
              gradient: _getDogGradient(),
              borderRadius: BorderRadius.circular(size / 2),
              boxShadow: [
                BoxShadow(
                  color: _getDogColor().withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                _getDogIcon(),
                size: size * 0.56,
                color: _getDogIconColor(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Mood bubble
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: GameColors.shadowLight,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              dog.getMoodDescription(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Get gradient based on dog mood
  LinearGradient _getDogGradient() {
    switch (dog.mood) {
      case DogMood.happy:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFD8A8), Color(0xFFFFB88C)],
        );
      case DogMood.content:
        return GameColors.dogGradient;
      case DogMood.hungry:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFB3B3), Color(0xFFFF8585)],
        );
      case DogMood.sad:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFB3B3FF), Color(0xFF8585FF)],
        );
      case DogMood.dirty:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFA89070), Color(0xFF8A7256)],
        );
      case DogMood.critical:
        return const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF6B6B), Color(0xFFFF4757)],
        );
    }
  }

  /// Get dog primary color
  Color _getDogColor() {
    switch (dog.mood) {
      case DogMood.happy:
        return Colors.orange;
      case DogMood.content:
        return const Color(0xFFFFB88C);
      case DogMood.hungry:
        return Colors.red;
      case DogMood.sad:
        return Colors.blue;
      case DogMood.dirty:
        return Colors.brown;
      case DogMood.critical:
        return Colors.deepOrange;
    }
  }

  /// Get icon based on mood
  IconData _getDogIcon() {
    switch (dog.mood) {
      case DogMood.happy:
        return Icons.pets;
      case DogMood.content:
        return Icons.pets;
      case DogMood.hungry:
        return Icons.pets;
      case DogMood.sad:
        return Icons.pets;
      case DogMood.dirty:
        return Icons.pets;
      case DogMood.critical:
        return Icons.pets;
    }
  }

  /// Get icon color based on mood
  Color _getDogIconColor() {
    return const Color(0xFF8D6E63);
  }
}
