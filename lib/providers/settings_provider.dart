import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

class SettingsProvider with ChangeNotifier {
  bool _darkMode = false;
  bool _soundEnabled = true;
  bool _vibrationEnabled = true;

  late AudioPlayer _audioPlayer;

  SettingsProvider() {
    _audioPlayer = AudioPlayer();
  }

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

  Future<void> playSound(String soundFile) async {
    if (!_soundEnabled) return;
    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('sounds/$soundFile'));
    } catch (e) {
      debugPrint('Error playing sound: $e');
    }
  }

  Future<void> playVibration() async {
    if (!_vibrationEnabled) return;
    try {
      // Use vibration package for Android/iOS
      if (defaultTargetPlatform == TargetPlatform.android || 
          defaultTargetPlatform == TargetPlatform.iOS) {
        // Check if device has vibration capability
        final hasVibrator = await Vibration.hasVibrator();
        if (hasVibrator == true) {
          // Use vibration package for actual vibration
          await Vibration.vibrate(duration: 50);
        } else {
          // Fallback to haptic feedback
          await HapticFeedback.mediumImpact();
        }
      } else {
        debugPrint('Vibration not supported on this platform');
      }
    } catch (e) {
      debugPrint('Error playing vibration: $e');
      // Fallback to haptic feedback on error
      try {
        await HapticFeedback.mediumImpact();
      } catch (e2) {
        debugPrint('Haptic feedback also failed: $e2');
      }
    }
  }

  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}

