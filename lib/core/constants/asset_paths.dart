/// Asset paths for DogHot game
/// Contains paths to images, animations, and sounds
/// Falls back to icons/emoji if assets are missing
class AssetPaths {
  // Dog animations (Lottie JSON)
  static const String dogIdleAnimation = 'assets/animations/dog/idle.json';
  static const String dogHappyAnimation = 'assets/animations/dog/happy.json';
  static const String dogSadAnimation = 'assets/animations/dog/sad.json';
  static const String dogEatingAnimation = 'assets/animations/dog/eating.json';
  static const String dogSleepingAnimation = 'assets/animations/dog/sleeping.json';
  
  // Dog sprites (fallback)
  static const String dogSpriteDefault = 'assets/images/dog/default.png';
  
  // Food sprites
  static const String foodSausage = 'assets/images/food/sausage.png';
  static const String foodChicken = 'assets/images/food/chicken.png';
  static const String foodCarrot = 'assets/images/food/carrot.png';
  static const String foodBone = 'assets/images/food/bone.png';
  static const String foodFish = 'assets/images/food/fish.png';
  
  // UI icons (using Material Icons as fallback, so these are optional)
  static const String iconCoin = 'assets/images/ui/coin.png';
  static const String iconStar = 'assets/images/ui/star.png';
  static const String iconHeart = 'assets/images/ui/heart.png';
  
  // Sound effects (optional)
  static const String soundTap = 'assets/sounds/tap.mp3';
  static const String soundSuccess = 'assets/sounds/success.mp3';
  static const String soundFail = 'assets/sounds/fail.mp3';
  static const String soundEat = 'assets/sounds/eat.mp3';
  
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
