/// Result from a minigame
class MinigameResult {
  final String gameName;
  final int score;
  final int stars;
  final int coinsEarned;
  final int xpEarned;
  final Map<String, double> statChanges;
  final Duration timePlayed;

  MinigameResult({
    required this.gameName,
    required this.score,
    required this.stars,
    required this.coinsEarned,
    required this.xpEarned,
    required this.statChanges,
    required this.timePlayed,
  });

  /// Calculate star rating (1-3 stars) based on score and thresholds
  static int calculateStars(int score, int oneStar, int twoStars, int threeStars) {
    if (score >= threeStars) return 3;
    if (score >= twoStars) return 2;
    if (score >= oneStar) return 1;
    return 0;
  }

  /// Create result for Feeding Frenzy game
  factory MinigameResult.feedingFrenzy({
    required int score,
    required Duration timePlayed,
  }) {
    // Calculate stars based on score thresholds
    final stars = calculateStars(score, 10, 20, 35);
    
    // Calculate rewards
    final coinsEarned = (score / 2).floor();
    final xpEarned = score + (stars * 5);
    final hungerBoost = (score * 2.0).clamp(5.0, 40.0);
    final happinessBoost = (stars * 5.0);

    return MinigameResult(
      gameName: 'Feeding Frenzy',
      score: score,
      stars: stars,
      coinsEarned: coinsEarned,
      xpEarned: xpEarned,
      statChanges: {
        'hunger': hungerBoost,
        'happiness': happinessBoost,
      },
      timePlayed: timePlayed,
    );
  }

  /// Create result for Pipe Fix game
  factory MinigameResult.pipeFix({
    required int moves,
    required int parMoves,
    required Duration timePlayed,
  }) {
    // Calculate stars based on moves compared to par
    int stars;
    if (moves <= parMoves) {
      stars = 3;
    } else if (moves <= parMoves + 5) {
      stars = 2;
    } else {
      stars = 1;
    }

    // Calculate rewards
    final baseScore = 50;
    final moveBonus = (parMoves - moves).clamp(0, 20);
    final score = baseScore + moveBonus;
    final coinsEarned = 10 + (stars * 5);
    final xpEarned = 20 + (stars * 10);
    final cleanlinessBoost = 15.0 + (stars * 5.0);
    final happinessBoost = (stars * 5.0);

    return MinigameResult(
      gameName: 'Pipe Fix',
      score: score,
      stars: stars,
      coinsEarned: coinsEarned,
      xpEarned: xpEarned,
      statChanges: {
        'cleanliness': cleanlinessBoost,
        'happiness': happinessBoost,
      },
      timePlayed: timePlayed,
    );
  }

  /// Get reward summary text
  String getRewardSummary() {
    final parts = <String>[];
    
    if (coinsEarned > 0) {
      parts.add('$coinsEarned coins');
    }
    if (xpEarned > 0) {
      parts.add('$xpEarned XP');
    }
    if (statChanges.isNotEmpty) {
      statChanges.forEach((stat, value) {
        if (value > 0) {
          parts.add('${stat.capitalize()} +${value.toInt()}');
        }
      });
    }
    
    return parts.join(', ');
  }
}

extension _StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
