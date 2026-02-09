# Asset Setup Guide

This guide explains how to add assets to the DogHog app after the asset loading fixes.

## What Was Fixed

### 1. Updated `pubspec.yaml`

**Changed SDK requirement:**
- From: `sdk: ">=3.1.0 <4.0.0"`
- To: `sdk: ">=3.0.6 <4.0.0"` (matches your Dart version)

**Fixed asset paths:**
```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/
    - assets/food/
    - assets/bowls/
    - assets/dogs/
    - assets/dogs/mrozek/
    - assets/dogs/mrozek/video/
    - assets/dogs/mrozek/images/
    - assets/pipes/
    - assets/backgrounds/
    - assets/audio/
```

### 2. Updated `lib/core/constants/asset_paths.dart`

All asset paths now point to correct directories:
- Dog videos: `assets/dogs/mrozek/video/`
- Dog images: `assets/dogs/mrozek/images/`
- Food images: `assets/food/`
- Bowl images: `assets/bowls/`
- Audio files: `assets/audio/`

### 3. Added Safe Asset Loading

Created `lib/core/utils/asset_loader.dart` with:
- `AssetLoader.safeImage()` - Loads images with error handling
- Shows placeholder icons if assets are missing
- Prevents app crashes from missing files

## How to Add Your Assets

### Directory Structure

Place your files in these directories:

```
assets/
├── food/
│   ├── sausage.png
│   ├── chicken.png
│   ├── carrot.png
│   ├── bone.png
│   └── fish.png
├── bowls/
│   ├── empty.png
│   └── full.png
├── dogs/
│   └── mrozek/
│       ├── video/
│       │   ├── idle.mp4
│       │   ├── happy.mp4
│       │   ├── sad.mp4
│       │   ├── eating.mp4
│       │   └── sleeping.mp4
│       └── images/
│           └── default.png
└── audio/
    ├── tap.mp3
    ├── success.mp3
    ├── fail.mp3
    └── eat.mp3
```

### Steps to Add Assets

1. **Create the directory structure:**
   ```bash
   mkdir -p assets/food
   mkdir -p assets/bowls
   mkdir -p assets/dogs/mrozek/video
   mkdir -p assets/dogs/mrozek/images
   mkdir -p assets/audio
   ```

2. **Copy your asset files** into the appropriate directories

3. **Run Flutter commands:**
   ```bash
   flutter clean
   flutter pub get
   flutter run -d chrome
   ```

## Testing Without Assets

The app will work even if assets are missing:
- ✅ App won't crash
- ✅ Placeholder icons will show instead of images
- ✅ All functionality will work
- ✅ You can add assets later

## Using Assets in Code

See `docs/SAFE_ASSET_LOADING.md` for detailed examples.

Quick example:
```dart
import 'package:doghog/core/utils/asset_loader.dart';
import 'package:doghog/core/constants/asset_paths.dart';

// Safe image loading
AssetLoader.safeImage(
  AssetPaths.foodSausage,
  width: 80,
  height: 80,
)
```

## Troubleshooting

### Assets not showing?
1. Check file names match exactly (case-sensitive)
2. Run `flutter clean && flutter pub get`
3. Restart the app
4. Check `pubspec.yaml` includes the asset directories

### App crashes on asset load?
- This shouldn't happen with `AssetLoader.safeImage()`
- If using `Image.asset()` directly, switch to `AssetLoader.safeImage()`

## Next Steps

1. Add your PNG images to `assets/food/` and `assets/bowls/`
2. Add MP4 videos to `assets/dogs/mrozek/video/`
3. Run the app and see your assets appear!
4. If assets are missing, you'll see placeholder icons (not crashes)
