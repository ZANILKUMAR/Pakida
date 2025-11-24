import 'package:flutter/material.dart';

class SettingsProvider with ChangeNotifier {
  bool _darkMode = false;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  bool get darkMode => _darkMode;
  bool get soundEnabled => _soundEnabled;
  bool get vibrationEnabled => _vibrationEnabled;

  void toggleDarkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }

  void toggleSound(bool value) {
    _soundEnabled = value;
    notifyListeners();
  }

  void toggleVibration(bool value) {
    _vibrationEnabled = value;
    notifyListeners();
  }
}

