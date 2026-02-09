import 'package:flutter/material.dart';

/// Safe asset loading utilities
/// Provides fallback behavior when assets are missing
class AssetLoader {
  /// Safely load an image asset with error handling
  /// Returns a placeholder icon if the image fails to load
  static Widget safeImage(
    String path, {
    double? width,
    double? height,
    BoxFit? fit,
    Color placeholderColor = Colors.grey,
    double placeholderSize = 100,
  }) {
    return Image.asset(
      path,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        return Icon(
          Icons.image_not_supported,
          size: placeholderSize,
          color: placeholderColor,
        );
      },
    );
  }
}
