import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// Storage service wrapper for SharedPreferences
/// Provides safe, typed access to persistent storage
class StorageService {
  SharedPreferences? _prefs;

  /// Initialize the storage service
  Future<void> init() async {
    try {
      _prefs = await SharedPreferences.getInstance();
    } catch (e) {
      print('StorageService init error: $e');
      // Continue with null prefs, will use in-memory fallback
    }
  }

  /// Ensure preferences are loaded
  Future<SharedPreferences?> _getPrefs() async {
    if (_prefs == null) {
      await init();
    }
    return _prefs;
  }

  /// Save string value
  Future<bool> setString(String key, String value) async {
    try {
      final prefs = await _getPrefs();
      return await prefs?.setString(key, value) ?? false;
    } catch (e) {
      print('StorageService setString error: $e');
      return false;
    }
  }

  /// Get string value
  Future<String?> getString(String key) async {
    try {
      final prefs = await _getPrefs();
      return prefs?.getString(key);
    } catch (e) {
      print('StorageService getString error: $e');
      return null;
    }
  }

  /// Save int value
  Future<bool> setInt(String key, int value) async {
    try {
      final prefs = await _getPrefs();
      return await prefs?.setInt(key, value) ?? false;
    } catch (e) {
      print('StorageService setInt error: $e');
      return false;
    }
  }

  /// Get int value
  Future<int?> getInt(String key) async {
    try {
      final prefs = await _getPrefs();
      return prefs?.getInt(key);
    } catch (e) {
      print('StorageService getInt error: $e');
      return null;
    }
  }

  /// Save double value
  Future<bool> setDouble(String key, double value) async {
    try {
      final prefs = await _getPrefs();
      return await prefs?.setDouble(key, value) ?? false;
    } catch (e) {
      print('StorageService setDouble error: $e');
      return false;
    }
  }

  /// Get double value
  Future<double?> getDouble(String key) async {
    try {
      final prefs = await _getPrefs();
      return prefs?.getDouble(key);
    } catch (e) {
      print('StorageService getDouble error: $e');
      return null;
    }
  }

  /// Save bool value
  Future<bool> setBool(String key, bool value) async {
    try {
      final prefs = await _getPrefs();
      return await prefs?.setBool(key, value) ?? false;
    } catch (e) {
      print('StorageService setBool error: $e');
      return false;
    }
  }

  /// Get bool value
  Future<bool?> getBool(String key) async {
    try {
      final prefs = await _getPrefs();
      return prefs?.getBool(key);
    } catch (e) {
      print('StorageService getBool error: $e');
      return null;
    }
  }

  /// Save JSON object
  Future<bool> setJson(String key, Map<String, dynamic> value) async {
    try {
      final jsonString = jsonEncode(value);
      return await setString(key, jsonString);
    } catch (e) {
      print('StorageService setJson error: $e');
      return false;
    }
  }

  /// Get JSON object
  Future<Map<String, dynamic>?> getJson(String key) async {
    try {
      final jsonString = await getString(key);
      if (jsonString == null) return null;
      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      print('StorageService getJson error: $e');
      return null;
    }
  }

  /// Remove key
  Future<bool> remove(String key) async {
    try {
      final prefs = await _getPrefs();
      return await prefs?.remove(key) ?? false;
    } catch (e) {
      print('StorageService remove error: $e');
      return false;
    }
  }

  /// Clear all data
  Future<bool> clear() async {
    try {
      final prefs = await _getPrefs();
      return await prefs?.clear() ?? false;
    } catch (e) {
      print('StorageService clear error: $e');
      return false;
    }
  }

  /// Check if key exists
  Future<bool> containsKey(String key) async {
    try {
      final prefs = await _getPrefs();
      return prefs?.containsKey(key) ?? false;
    } catch (e) {
      print('StorageService containsKey error: $e');
      return false;
    }
  }

  /// Get all keys
  Future<Set<String>> getKeys() async {
    try {
      final prefs = await _getPrefs();
      return prefs?.getKeys() ?? <String>{};
    } catch (e) {
      print('StorageService getKeys error: $e');
      return <String>{};
    }
  }
}
