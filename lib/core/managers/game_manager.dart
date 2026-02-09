import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../models/game_state.dart';
import '../../models/minigame_result.dart';
import '../services/storage_service.dart';
import '../services/save_service.dart';
import '../constants/game_constants.dart';

/// Central game manager that handles game state and operations
class GameManager extends ChangeNotifier {
  final StorageService _storageService;
  late final SaveService _saveService;
  
  GameState _gameState = GameState.createDefault();
  Timer? _autoSaveTimer;
  final Random _random = Random();

  GameManager(this._storageService) {
    _saveService = SaveService(_storageService);
  }

  /// Get current game state
  GameState get gameState => _gameState;

  /// Get current dog
  get dog => _gameState.dog;

  /// Initialize game manager and load saved state
  Future<void> init() async {
    try {
      await _storageService.init();
      _gameState = await _saveService.loadGameState();
      
      // Start auto-save timer
      _startAutoSave();
      
      notifyListeners();
    } catch (e) {
      print('GameManager init error: $e');
      // Continue with default state
    }
  }

  /// Start auto-save timer
  void _startAutoSave() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer.periodic(
      Duration(seconds: GameConstants.autoSaveInterval),
      (_) => save(),
    );
  }

  /// Save game state
  Future<void> save() async {
    try {
      await _saveService.saveGameState(_gameState);
    } catch (e) {
      print('GameManager save error: $e');
    }
  }

  /// Apply time-based decay now
  void applyDecayNow() {
    final now = DateTime.now();
    final elapsed = now.difference(_gameState.dog.lastUpdate);
    if (elapsed.inMinutes > 0) {
      _gameState.dog.applyDecay(elapsed);
      save();
      notifyListeners();
    }
  }

  /// Set language
  void setLanguage(String languageCode) {
    if (_gameState.languageCode != languageCode) {
      _gameState.languageCode = languageCode;
      save();
      notifyListeners();
    }
  }

  /// Apply minigame result
  void applyMinigameResult(MinigameResult result) {
    // Update stats
    result.statChanges.forEach((stat, change) {
      switch (stat.toLowerCase()) {
        case 'hunger':
          _gameState.dog.updateHunger(change);
          break;
        case 'happiness':
          _gameState.dog.updateHappiness(change);
          break;
        case 'cleanliness':
          _gameState.dog.updateCleanliness(change);
          break;
      }
    });

    // Add rewards
    _gameState.addCoins(result.coinsEarned);
    _gameState.addStars(result.stars);
    
    // Add XP and check for level up
    final leveledUp = _gameState.dog.addXP(result.xpEarned);
    if (leveledUp) {
      // Could show level up notification here
      print('Dog leveled up to level ${_gameState.dog.level}!');
    }

    // Update high score
    _gameState.updateHighScore(result.gameName, result.score);
    _gameState.incrementGamesPlayed();

    save();
    notifyListeners();
  }

  /// Feed the dog manually (direct stat boost)
  void feedDog(int amount) {
    _gameState.dog.updateHunger(amount.toDouble());
    _gameState.dog.updateHappiness((amount / 2).toDouble());
    save();
    notifyListeners();
  }

  /// Play with dog (happiness boost)
  void playWithDog(int amount) {
    _gameState.dog.updateHappiness(amount.toDouble());
    save();
    notifyListeners();
  }

  /// Clean the dog (cleanliness boost)
  void cleanDog(int amount) {
    _gameState.dog.updateCleanliness(amount.toDouble());
    _gameState.dog.updateHappiness((amount / 2).toDouble());
    save();
    notifyListeners();
  }

  /// Pet the dog (small happiness boost)
  void petDog() {
    _gameState.dog.updateHappiness(1.0);
    notifyListeners();
    // Don't save immediately for petting, wait for auto-save
  }

  /// Get random preferred and disliked foods for today
  void randomizeDailyFoods() {
    if (_gameState.isNewDay() || _gameState.preferredFood.isEmpty) {
      final foods = List<String>.from(GameConstants.foodTypes);
      foods.shuffle(_random);
      _gameState.preferredFood = foods[0];
      _gameState.dislikedFood = foods.length > 1 ? foods[1] : foods[0];
      _gameState.dailyDate = DateTime.now().toString().split(' ')[0];
      save();
      notifyListeners();
    }
  }

  /// Reset game (delete all progress)
  Future<void> resetGame() async {
    try {
      await _saveService.deleteSaveData();
      _gameState = GameState.createDefault();
      save();
      notifyListeners();
    } catch (e) {
      print('GameManager resetGame error: $e');
    }
  }

  /// Handle app lifecycle changes
  void handleLifecycle(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      applyDecayNow();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      save();
    }
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    save();
    super.dispose();
  }
}
