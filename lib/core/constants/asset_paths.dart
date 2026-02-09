/// Asset paths for DogHot game
/// Contains paths to images, animations, and sounds
/// Falls back to icons/emoji if assets are missing
class AssetPaths {
  // Dog videos (MP4 videos in mrozek directory)
  static const String dogIdleVideo = 'assets/dogs/mrozek/video/idle.mp4';
  static const String dogHungryVideo = 'assets/dogs/mrozek/video/hungry.mp4';
  static const String dogThirstyVideo = 'assets/dogs/mrozek/video/thirsty.mp4';
  
  // Dog images (PNG images in mrozek directory)
  static const String dogSpriteDefault = 'assets/dogs/mrozek/images/default.png';
  
  // Food sprites (PNGs in food directory)
  static const String foodSausage = 'assets/food/food_sausage.png';
  static const String foodChicken = 'assets/food/food_chicken.png';
  static const String foodCarrot = 'assets/food/food_carrot.png';
  static const String foodBone = 'assets/food/food_bone.png';
  static const String foodFish = 'assets/food/food_fish.png';
  static const String foodChocolate = 'assets/food/food_bad_chocolate.png';
  
  // Bowl sprites (PNGs in bowls directory)
  static const String bowlFoodEmpty = 'assets/bowls/bowl_food_empty.png';
  static const String bowlFoodFull = 'assets/bowls/bowl_food_full.png';
  static const String bowlWaterEmpty = 'assets/bowls/bowl_water_empty.png';
  static const String bowlWaterFull = 'assets/bowls/bowl_water_full.png';
  
  // Sound effects (optional - in audio directory)
  static const String soundTap = 'assets/audio/tap.mp3';
  static const String soundSuccess = 'assets/audio/success.mp3';
  static const String soundFail = 'assets/audio/fail.mp3';
  static const String soundEat = 'assets/audio/eat.mp3';
  
  // Get food asset by type name
  static String getFoodAsset(String foodType) {
    switch (foodType.toLowerCase()) {
      case 'sausage':
        return foodSausage;
      case 'chicken':
        return foodChicken;
      case 'carrot':
        return foodCarrot;
      case 'bone':
        return foodBone;
      case 'fish':
        return foodFish;
      default:
        return foodSausage;
    }
  }
  
  /// Convert full asset path to Flame-compatible path (without 'assets/' prefix)
  /// Flame's image loader automatically prepends 'assets/images/' to paths
  static String toFlameAsset(String fullPath) {
    return fullPath.startsWith('assets/') ? fullPath.substring(7) : fullPath;
  }
}
