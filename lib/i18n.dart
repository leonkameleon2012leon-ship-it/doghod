class I18n {
  static const Map<String, Map<String, String>> _dict = {
    'en': {
      'appTitle': 'DogHog',
      'petName': 'DogHog',
      'welcome': 'Take care of your DogHog!',
      'language': 'Language',
      'english': 'English',
      'spanish': 'Spanish',
      'statsTitle': 'Status',
      'hunger': 'Hunger',
      'happiness': 'Happiness',
      'cleanliness': 'Cleanliness',
      'statValue': '{label}: {value}',
      'feedingGame': 'Feeding Game',
      'pipesGame': 'Pipes Game',
      'playFeeding': 'Play Feeding',
      'playPipes': 'Fix Pipes',
      'feedingTitle': 'Feeding Frenzy',
      'feedingHint': 'Tap the falling snacks to feed DogHog.',
      'pipesTitle': 'Pipe Fix',
      'pipesHint': 'Rotate every pipe to match the target.',
      'target': 'Target',
      'scoreLabel': 'Score: {score}',
      'timeLabel': 'Time: {seconds}s',
      'gameOver': 'Round complete!',
      'rewardHunger': 'Hunger +{amount}',
      'rewardClean': 'Cleanliness +{amount}',
      'backHome': 'Back to Home',
    },
    'es': {
      'appTitle': 'DogHog',
      'petName': 'DogHog',
      'welcome': '¡Cuida a tu DogHog!',
      'language': 'Idioma',
      'english': 'Inglés',
      'spanish': 'Español',
      'statsTitle': 'Estado',
      'hunger': 'Hambre',
      'happiness': 'Felicidad',
      'cleanliness': 'Limpieza',
      'statValue': '{label}: {value}',
      'feedingGame': 'Juego de comida',
      'pipesGame': 'Juego de tuberías',
      'playFeeding': 'Jugar comida',
      'playPipes': 'Arreglar tuberías',
      'feedingTitle': 'Frenesí de comida',
      'feedingHint': 'Toca los bocados que caen para alimentar a DogHog.',
      'pipesTitle': 'Arreglo de tuberías',
      'pipesHint': 'Gira cada tubería para que coincida con el objetivo.',
      'target': 'Objetivo',
      'scoreLabel': 'Puntaje: {score}',
      'timeLabel': 'Tiempo: {seconds}s',
      'gameOver': '¡Ronda completa!',
      'rewardHunger': 'Hambre +{amount}',
      'rewardClean': 'Limpieza +{amount}',
      'backHome': 'Volver al inicio',
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
