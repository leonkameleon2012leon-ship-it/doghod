/// Dog mood states based on stats
enum DogMood {
  happy,
  content,
  hungry,
  sad,
  dirty,
  critical,
}

/// Dog model representing the pet's state
class DogModel {
  String name;
  int level;
  int xp;
  double hunger;
  double happiness;
  double cleanliness;
  String breed;
  DateTime lastUpdate;

  DogModel({
    required this.name,
    this.level = 1,
    this.xp = 0,
    this.hunger = 80.0,
    this.happiness = 80.0,
    this.cleanliness = 80.0,
    this.breed = 'default',
    DateTime? lastUpdate,
  }) : lastUpdate = lastUpdate ?? DateTime.now();

  /// Get current dog mood based on stats
  DogMood get mood {
    // Critical state - any stat below 30%
    if (hunger < 30 || happiness < 30 || cleanliness < 30) {
      return DogMood.critical;
    }
    
    // Specific mood states
    if (hunger < 50) {
      return DogMood.hungry;
    }
    if (cleanliness < 40) {
      return DogMood.dirty;
    }
    if (happiness < 50) {
      return DogMood.sad;
    }
    if (happiness > 70 && hunger > 60 && cleanliness > 60) {
      return DogMood.happy;
    }
    
    return DogMood.content;
  }

  /// Get mood description
  String getMoodDescription() {
    switch (mood) {
      case DogMood.happy:
        return 'Happy and playful! 🎉';
      case DogMood.content:
        return 'Feeling good! 😊';
      case DogMood.hungry:
        return 'I\'m hungry! 🍖';
      case DogMood.sad:
        return 'Feeling down... 😔';
      case DogMood.dirty:
        return 'Need a bath! 🛁';
      case DogMood.critical:
        return 'Need help urgently! 😰';
    }
  }

  /// Calculate XP needed for next level
  int get xpForNextLevel => level * 100;

  /// Calculate progress to next level (0.0 to 1.0)
  double get levelProgress {
    final xpInCurrentLevel = xp % xpForNextLevel;
    return xpInCurrentLevel / xpForNextLevel;
  }

  /// Add XP and handle level up
  bool addXP(int amount) {
    xp += amount;
    if (xp >= xpForNextLevel && level < 50) {
      level++;
      return true; // Level up occurred
    }
    return false;
  }

  /// Update stats ensuring they stay within bounds
  void updateHunger(double amount) {
    hunger = (hunger + amount).clamp(0.0, 100.0);
  }

  void updateHappiness(double amount) {
    happiness = (happiness + amount).clamp(0.0, 100.0);
  }

  void updateCleanliness(double amount) {
    cleanliness = (cleanliness + amount).clamp(0.0, 100.0);
  }

  /// Apply time-based decay
  void applyDecay(Duration elapsed) {
    final hours = elapsed.inMinutes / 60.0;
    updateHunger(-hours * 1.0);
    updateHappiness(-hours * 0.5);
    updateCleanliness(-hours * 0.3);
    lastUpdate = DateTime.now();
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'level': level,
      'xp': xp,
      'hunger': hunger,
      'happiness': happiness,
      'cleanliness': cleanliness,
      'breed': breed,
      'lastUpdate': lastUpdate.millisecondsSinceEpoch,
    };
  }

  /// Create from JSON
  factory DogModel.fromJson(Map<String, dynamic> json) {
    return DogModel(
      name: json['name'] as String? ?? 'DogHot',
      level: json['level'] as int? ?? 1,
      xp: json['xp'] as int? ?? 0,
      hunger: (json['hunger'] as num?)?.toDouble() ?? 80.0,
      happiness: (json['happiness'] as num?)?.toDouble() ?? 80.0,
      cleanliness: (json['cleanliness'] as num?)?.toDouble() ?? 80.0,
      breed: json['breed'] as String? ?? 'default',
      lastUpdate: json['lastUpdate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['lastUpdate'] as int)
          : DateTime.now(),
    );
  }

  /// Create a default dog
  factory DogModel.createDefault() {
    return DogModel(
      name: 'DogHot',
      level: 1,
      xp: 0,
      hunger: 80.0,
      happiness: 80.0,
      cleanliness: 80.0,
      breed: 'default',
    );
  }

  /// Copy with changes
  DogModel copyWith({
    String? name,
    int? level,
    int? xp,
    double? hunger,
    double? happiness,
    double? cleanliness,
    String? breed,
    DateTime? lastUpdate,
  }) {
    return DogModel(
      name: name ?? this.name,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      hunger: hunger ?? this.hunger,
      happiness: happiness ?? this.happiness,
      cleanliness: cleanliness ?? this.cleanliness,
      breed: breed ?? this.breed,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }
}
