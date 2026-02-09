import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'i18n.dart';

class DogHogController extends ChangeNotifier {
  static const int _defaultStatValue = 80;
  static const String _hungerKey = 'hunger';
  static const String _happinessKey = 'happiness';
  static const String _cleanlinessKey = 'cleanliness';
  static const String _languageKey = 'languageCode';
  static const String _lastSavedKey = 'lastSavedMs';

  int hunger = _defaultStatValue;
  int happiness = _defaultStatValue;
  int cleanliness = _defaultStatValue;
  String languageCode = 'en';
  DateTime _lastSaved = DateTime.now();

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    hunger = prefs.getInt(_hungerKey) ?? _defaultStatValue;
    happiness = prefs.getInt(_happinessKey) ?? _defaultStatValue;
    cleanliness = prefs.getInt(_cleanlinessKey) ?? _defaultStatValue;
    languageCode = prefs.getString(_languageKey) ?? 'en';
    I18n.setLanguage(languageCode);
    final lastSavedMs = prefs.getInt(_lastSavedKey);
    if (lastSavedMs != null) {
      _lastSaved = DateTime.fromMillisecondsSinceEpoch(lastSavedMs);
      _applyDecay(DateTime.now());
    } else {
      _lastSaved = DateTime.now();
    }
    await save();
    notifyListeners();
  }

  Future<void> save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_hungerKey, hunger);
    await prefs.setInt(_happinessKey, happiness);
    await prefs.setInt(_cleanlinessKey, cleanliness);
    await prefs.setString(_languageKey, languageCode);
    await prefs.setInt(_lastSavedKey, _lastSaved.millisecondsSinceEpoch);
  }

  void handleLifecycle(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      applyDecayNow();
      save();
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      save();
    }
  }

  void applyDecayNow() {
    _applyDecay(DateTime.now());
    notifyListeners();
  }

  void setLanguage(String code) {
    if (code == languageCode) {
      return;
    }
    languageCode = code;
    I18n.setLanguage(code);
    save();
    notifyListeners();
  }

  void feed(int hungerBoost) {
    hunger = _clamp(hunger + hungerBoost);
    happiness = _clamp(happiness + max(1, hungerBoost ~/ 2));
    save();
    notifyListeners();
  }

  void fixPipes(int reward) {
    cleanliness = _clamp(cleanliness + reward);
    happiness = _clamp(happiness + max(1, reward ~/ 2));
    save();
    notifyListeners();
  }

  void _applyDecay(DateTime now) {
    final minutes = now.difference(_lastSaved).inMinutes;
    if (minutes <= 0) {
      _lastSaved = now;
      return;
    }
    final hours = minutes / 60.0;
    final hungerDecay = (hours * 3).floor();
    final happinessDecay = (hours * 2).floor();
    final cleanlinessDecay = (hours * 1.5).floor();
    if (hungerDecay > 0 || happinessDecay > 0 || cleanlinessDecay > 0) {
      hunger = _clamp(hunger - hungerDecay);
      happiness = _clamp(happiness - happinessDecay);
      cleanliness = _clamp(cleanliness - cleanlinessDecay);
    }
    _lastSaved = now;
  }

  int _clamp(int value) {
    if (value < 0) {
      return 0;
    }
    if (value > 100) {
      return 100;
    }
    return value;
  }
}
