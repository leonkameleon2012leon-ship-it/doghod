# Safe Asset Loading Guide

This document explains how to safely load assets in the DogHog app.

## Overview

The app uses the `AssetLoader` utility class to safely load images and provide fallbacks when assets are missing.

## Using Safe Image Loading

Instead of using `Image.asset()` directly, use `AssetLoader.safeImage()`:

```dart
import 'package:doghog/core/utils/asset_loader.dart';
import 'package:doghog/core/constants/asset_paths.dart';

// Instead of this (which crashes on missing asset):
// Image.asset(AssetPaths.foodSausage)

// Use this (which shows a placeholder on missing asset):
AssetLoader.safeImage(
  AssetPaths.foodSausage,
  width: 100,
  height: 100,
  fit: BoxFit.contain,
)
```

## Examples

### Loading Food Images

```dart
// Load a food image safely
Widget foodImage = AssetLoader.safeImage(
  AssetPaths.foodSausage,
  width: 80,
  height: 80,
  placeholderSize: 80,
  placeholderColor: Colors.orange,
);
```

### Loading Bowl Images

```dart
// Load bowl images
Widget emptyBowl = AssetLoader.safeImage(
  AssetPaths.bowlEmpty,
  width: 120,
  height: 120,
);

Widget fullBowl = AssetLoader.safeImage(
  AssetPaths.bowlFull,
  width: 120,
  height: 120,
);
```

### Loading Dog Images

```dart
// Load dog sprite
Widget dogSprite = AssetLoader.safeImage(
  AssetPaths.dogSpriteDefault,
  width: 200,
  height: 200,
  fit: BoxFit.contain,
);
```

## Asset Paths

All asset paths are defined in `lib/core/constants/asset_paths.dart`:

- **Dog Videos**: `assets/dogs/mrozek/video/` (MP4 files)
- **Dog Images**: `assets/dogs/mrozek/images/` (PNG files)
- **Food Images**: `assets/food/` (PNG files)
- **Bowl Images**: `assets/bowls/` (PNG files)
- **Audio**: `assets/audio/` (MP3 files)

## Error Handling

If an asset fails to load, `AssetLoader.safeImage()` will:
1. Show a gray placeholder icon (📷 image_not_supported)
2. Log error to console for debugging
3. Continue running the app without crashing

## Benefits

✅ **No Crashes**: Missing assets won't break the app
✅ **User-Friendly**: Users see placeholders instead of error screens
✅ **Developer-Friendly**: Easy to spot missing assets during development
✅ **Consistent**: Same behavior across all asset loading

## Migration Guide

To update existing code:

### Before (Unsafe)
```dart
Image.asset('assets/food/sausage.png')
```

### After (Safe)
```dart
import 'package:doghog/core/utils/asset_loader.dart';
import 'package:doghog/core/constants/asset_paths.dart';

AssetLoader.safeImage(AssetPaths.foodSausage)
```
