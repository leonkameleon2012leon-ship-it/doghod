import 'dog_model.dart';

/// Game state model containing overall progress and daily data
class GameState {
  DogModel dog;
  int coins;
  int stars;
  int gamesPlayed;
  Map<String, int> highScores;
  List<String> achievements;
  String preferredFood;
  String dislikedFood;
  String dailyDate;
  String languageCode;

  GameState({
    required this.dog,
    this.coins = 0,
    this.stars = 0,
    this.gamesPlayed = 0,
    Map<String, int>? highScores,
    List<String>? achievements,
    this.preferredFood = 'Sausage',
    this.dislikedFood = 'Carrot',
    String? dailyDate,
    this.languageCode = 'en',
  })  : highScores = highScores ?? {},
        achievements = achievements ?? [],
        dailyDate = dailyDate ?? _getTodayString();

  /// Check if it's a new day and reset daily preferences
  bool isNewDay() {
    final today = _getTodayString();
    return dailyDate != today;
  }

  /// Reset daily preferences with new random foods
  void resetDailyPreferences(List<String> foodTypes) {
    dailyDate = _getTodayString();
    // Keep current preferences if they're valid, otherwise randomize
    if (!foodTypes.contains(preferredFood)) {
      preferredFood = foodTypes[0];
    }
    if (!foodTypes.contains(dislikedFood)) {
      dislikedFood = foodTypes.length > 1 ? foodTypes[1] : foodTypes[0];
    }
  }

  /// Add coins
  void addCoins(int amount) {
    coins += amount;
    if (coins < 0) coins = 0;
  }

  /// Add stars
  void addStars(int amount) {
    stars += amount;
    if (stars < 0) stars = 0;
  }

  /// Update high score for a game
  void updateHighScore(String gameName, int score) {
    if (!highScores.containsKey(gameName) || highScores[gameName]! < score) {
      highScores[gameName] = score;
    }
  }

  /// Add achievement
  void addAchievement(String achievement) {
    if (!achievements.contains(achievement)) {
      achievements.add(achievement);
    }
  }

  /// Increment games played
  void incrementGamesPlayed() {
    gamesPlayed++;
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'dog': dog.toJson(),
      'coins': coins,
      'stars': stars,
      'gamesPlayed': gamesPlayed,
      'highScores': highScores,
      'achievements': achievements,
      'preferredFood': preferredFood,
      'dislikedFood': dislikedFood,
      'dailyDate': dailyDate,
      'languageCode': languageCode,
    };
  }

  /// Create from JSON
  factory GameState.fromJson(Map<String, dynamic> json) {
    return GameState(
      dog: DogModel.fromJson(json['dog'] as Map<String, dynamic>? ?? {}),
      coins: json['coins'] as int? ?? 0,
      stars: json['stars'] as int? ?? 0,
      gamesPlayed: json['gamesPlayed'] as int? ?? 0,
      highScores: (json['highScores'] as Map<String, dynamic>?)?.map(
            (key, value) => MapEntry(key, value as int),
          ) ??
          {},
      achievements: (json['achievements'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      preferredFood: json['preferredFood'] as String? ?? 'Sausage',
      dislikedFood: json['dislikedFood'] as String? ?? 'Carrot',
      dailyDate: json['dailyDate'] as String? ?? _getTodayString(),
      languageCode: json['languageCode'] as String? ?? 'en',
    );
  }

  /// Create default game state
  factory GameState.createDefault() {
    return GameState(
      dog: DogModel.createDefault(),
      coins: 0,
      stars: 0,
      gamesPlayed: 0,
      preferredFood: 'Sausage',
      dislikedFood: 'Carrot',
      languageCode: 'en',
    );
  }

  /// Get today's date as string
  static String _getTodayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }
}
