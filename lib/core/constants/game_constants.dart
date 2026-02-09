/// Game constants for DogHot casual mobile game
/// Contains all numerical values for stats, decay rates, rewards, and game mechanics
class GameConstants {
  // Stat decay rates (per hour)
  static const double hungerDecayPerHour = 1.0;
  static const double happinessDecayPerHour = 0.5;
  static const double cleanlinessDecayPerHour = 0.3;

  // Default stat values
  static const int defaultStatValue = 80;
  static const int maxStatValue = 100;
  static const int minStatValue = 0;

  // Stat thresholds for dog mood
  static const int criticalStatThreshold = 30;
  static const int lowStatThreshold = 50;
  static const int goodStatThreshold = 70;
  static const int excellentStatThreshold = 90;

  // Feeding Frenzy game settings
  static const double feedingGameDuration = 30.0;
  static const double feedingSpawnInterval = 0.5;
  static const int feedingPreferredFoodPoints = 3;
  static const int feedingNormalFoodPoints = 1;
  static const int feedingDislikedFoodPenalty = -2;
  
  // Feeding Frenzy rewards
  static const int feedingMinReward = 5;
  static const int feedingMaxReward = 40;
  static const double feedingRewardMultiplier = 2.0;

  // Pipe Fix game settings
  static const int pipeGameGridSize = 4;
  static const int pipeGameMoveLimit = 30;
  static const int pipeGameParMoves = 16;
  
  // Pipe Fix rewards
  static const int pipeFixBaseReward = 15;
  static const int pipeFixBonusReward = 5;

  // Game cooldowns (in minutes)
  static const int gameCooldownMinutes = 5;

  // Dog level and XP
  static const int xpPerLevel = 100;
  static const int maxDogLevel = 50;

  // Currency
  static const int coinsPerGameScore = 10;
  static const int starsPerLevel = 3;

  // Auto-save interval (in seconds)
  static const int autoSaveInterval = 30;

  // Storage keys
  static const String hungerKey = 'hunger';
  static const String happinessKey = 'happiness';
  static const String cleanlinessKey = 'cleanliness';
  static const String languageKey = 'languageCode';
  static const String lastSavedKey = 'lastSavedMs';
  static const String coinsKey = 'coins';
  static const String starsKey = 'stars';
  static const String dogLevelKey = 'dogLevel';
  static const String dogXPKey = 'dogXP';
  static const String dogNameKey = 'dogName';
  static const String preferredFoodKey = 'preferredFood';
  static const String dislikedFoodKey = 'dislikedFood';
  static const String dailyDateKey = 'dailyDate';

  // Food types
  static const List<String> foodTypes = [
    'Sausage',
    'Chicken',
    'Carrot',
    'Bone',
    'Fish',
  ];

  // Default dog name
  static const String defaultDogName = 'DogHot';
}
