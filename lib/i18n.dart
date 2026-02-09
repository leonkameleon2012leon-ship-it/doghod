class I18n {
  static const Map<String, Map<String, String>> _dict = {
    'en': {
      'appTitle': 'DogHot',
      'petName': 'DogHot',
      'welcome': 'Take care of your DogHot!',
      'language': 'Language',
      'english': 'English',
      'polish': 'Polish',
      'statsTitle': 'Status',
      'hunger': 'Hunger',
      'happiness': 'Happiness',
      'cleanliness': 'Cleanliness',
      'statValue': '{label}: {value}',
      'feedingGame': 'Feeding Game',
      'pipesGame': 'Pipes Game',
      'playFeeding': 'Feed',
      'playPipes': 'Fix Pipes',
      'playWater': 'Water',
      'feedingTitle': 'Feeding Frenzy',
      'feedingHint': 'Tap the falling snacks to feed DogHot.',
      'pipesTitle': 'Pipe Fix',
      'pipesHint': 'Rotate every pipe to match the target.',
      'target': 'Target',
      'scoreLabel': 'Score: {score}',
      'timeLabel': 'Time: {seconds}s',
      'gameOver': 'Round complete!',
      'rewardHunger': 'Hunger +{amount}',
      'rewardClean': 'Cleanliness +{amount}',
      'backHome': 'Back to Home',
      'coins': 'Coins',
      'preferred': 'Preferred Today',
      'disliked': 'Disliked Today',
      'foodSausage': 'Sausage',
      'foodChicken': 'Chicken',
      'foodCarrot': 'Carrot',
      'foodBone': 'Bone',
    },
    'pl': {
      'appTitle': 'Psiak',
      'petName': 'Psiak',
      'welcome': 'Zadbaj o swojego Psiaka!',
      'language': 'Język',
      'english': 'Angielski',
      'polish': 'Polski',
      'statsTitle': 'Status',
      'hunger': 'Głód',
      'happiness': 'Szczęście',
      'cleanliness': 'Czystość',
      'statValue': '{label}: {value}',
      'feedingGame': 'Gra w karmienie',
      'pipesGame': 'Gra w rury',
      'playFeeding': 'Nakarm',
      'playPipes': 'Napraw rury',
      'playWater': 'Napój',
      'feedingTitle': 'Szaleństwo karmienia',
      'feedingHint': 'Dotknij spadających przekąsek, aby nakarmić Psiaka.',
      'pipesTitle': 'Naprawa rur',
      'pipesHint': 'Obróć każdą rurę, aby pasowała do celu.',
      'target': 'Cel',
      'scoreLabel': 'Wynik: {score}',
      'timeLabel': 'Czas: {seconds}s',
      'gameOver': 'Runda zakończona!',
      'rewardHunger': 'Głód +{amount}',
      'rewardClean': 'Czystość +{amount}',
      'backHome': 'Wróć do domu',
      'coins': 'Monety',
      'preferred': 'Preferowane dzisiaj',
      'disliked': 'Nielubiane dzisiaj',
      'foodSausage': 'Kiełbasa',
      'foodChicken': 'Kurczak',
      'foodCarrot': 'Marchewka',
      'foodBone': 'Kość',
    },
  };

  static String _languageCode = 'en';

  static void setLanguage(String code) {
    if (_dict.containsKey(code)) {
      _languageCode = code;
    }
  }

  static String tr(String key) {
    return _dict[_languageCode]?[key] ?? _dict['en']?[key] ?? key;
  }

  static String trf(String key, Map<String, String> params) {
    var text = tr(key);
    for (final entry in params.entries) {
      text = text.replaceAll('{${entry.key}}', entry.value);
    }
    return text;
  }
}
