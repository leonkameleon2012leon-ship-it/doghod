import 'package:flutter/material.dart';
import '../models/dog_model.dart';
import '../core/constants/visual_constants.dart';
import '../core/constants/asset_paths.dart';
import 'dog_video_widget.dart';

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
          // Dog character circle with video
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size / 2),
              boxShadow: [
                BoxShadow(
                  color: _getDogColor().withOpacity(0.3),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: DogVideoWidget(
              videoPath: _getVideoPath(),
              size: size,
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

  /// Get video path based on dog mood
  String _getVideoPath() {
    switch (dog.mood) {
      case DogMood.hungry:
      case DogMood.critical:
        return AssetPaths.dogHungryVideo;
      case DogMood.dirty:
      case DogMood.sad:
        return AssetPaths.dogThirstyVideo;
      case DogMood.happy:
      case DogMood.content:
      default:
        return AssetPaths.dogIdleVideo;
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
}
