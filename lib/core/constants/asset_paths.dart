/// Asset paths for DogHot game
/// Contains paths to images, animations, and sounds
/// Falls back to icons/emoji if assets are missing
class AssetPaths {
  // Dog videos (MP4 videos in mrozek directory)
  static const String dogIdleVideo = 'assets/dogs/mrozek/video/idle.mp4';
  static const String dogHappyVideo = 'assets/dogs/mrozek/video/happy.mp4';
  static const String dogSadVideo = 'assets/dogs/mrozek/video/sad.mp4';
  static const String dogEatingVideo = 'assets/dogs/mrozek/video/eating.mp4';
  static const String dogSleepingVideo = 'assets/dogs/mrozek/video/sleeping.mp4';
  
  // Dog images (PNG images in mrozek directory)
  static const String dogSpriteDefault = 'assets/dogs/mrozek/images/default.png';
  
  // Food sprites (PNGs in food directory)
  static const String foodSausage = 'assets/food/sausage.png';
  static const String foodChicken = 'assets/food/chicken.png';
  static const String foodCarrot = 'assets/food/carrot.png';
  static const String foodBone = 'assets/food/bone.png';
  static const String foodFish = 'assets/food/fish.png';
  
  // Bowl sprites (PNGs in bowls directory)
  static const String bowlEmpty = 'assets/bowls/empty.png';
  static const String bowlFull = 'assets/bowls/full.png';
  
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
}
