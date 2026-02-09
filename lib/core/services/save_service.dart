import '../../models/game_state.dart';
import 'storage_service.dart';

/// Save service for persisting game state
/// Handles loading and saving complete game state
class SaveService {
  final StorageService _storage;
  static const String _gameStateKey = 'game_state_v1';

  SaveService(this._storage);

  /// Load game state from storage
  Future<GameState> loadGameState() async {
    try {
      final json = await _storage.getJson(_gameStateKey);
      if (json != null) {
        final state = GameState.fromJson(json);
        
        // Apply time-based decay
        final now = DateTime.now();
        final elapsed = now.difference(state.dog.lastUpdate);
        if (elapsed.inMinutes > 0) {
          state.dog.applyDecay(elapsed);
        }
        
        // Check if new day and reset preferences if needed
        if (state.isNewDay()) {
          state.resetDailyPreferences(['Sausage', 'Chicken', 'Carrot', 'Bone', 'Fish']);
        }
        
        return state;
      }
    } catch (e) {
      print('SaveService loadGameState error: $e');
    }
    
    // Return default state if load fails
    return GameState.createDefault();
  }

  /// Save game state to storage
  Future<bool> saveGameState(GameState state) async {
    try {
      final json = state.toJson();
      return await _storage.setJson(_gameStateKey, json);
    } catch (e) {
      print('SaveService saveGameState error: $e');
      return false;
    }
  }

  /// Check if save data exists
  Future<bool> hasSaveData() async {
    try {
      return await _storage.containsKey(_gameStateKey);
    } catch (e) {
      print('SaveService hasSaveData error: $e');
      return false;
    }
  }

  /// Delete save data (reset game)
  Future<bool> deleteSaveData() async {
    try {
      return await _storage.remove(_gameStateKey);
    } catch (e) {
      print('SaveService deleteSaveData error: $e');
      return false;
    }
  }

  /// Create backup of current save
  Future<bool> backupSaveData() async {
    try {
      final json = await _storage.getJson(_gameStateKey);
      if (json != null) {
        final backupKey = '${_gameStateKey}_backup';
        return await _storage.setJson(backupKey, json);
      }
      return false;
    } catch (e) {
      print('SaveService backupSaveData error: $e');
      return false;
    }
  }

  /// Restore from backup
  Future<bool> restoreFromBackup() async {
    try {
      final backupKey = '${_gameStateKey}_backup';
      final json = await _storage.getJson(backupKey);
      if (json != null) {
        return await _storage.setJson(_gameStateKey, json);
      }
      return false;
    } catch (e) {
      print('SaveService restoreFromBackup error: $e');
      return false;
    }
  }
}
