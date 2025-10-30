import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const _showExpiredBannerKey = 'show_expired_banner';
  static const _themeModeKey = 'theme_mode'; // system|light|dark
  static const _lastFilterKey = 'last_filter'; // all|active|completed

  static Future<bool> getShowExpiredBanner() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_showExpiredBannerKey) ?? true;
    
  }

  static Future<void> setShowExpiredBanner(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_showExpiredBannerKey, value);
  }

  // Theme mode
  static Future<ThemeMode> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final val = prefs.getString(_themeModeKey) ?? 'system';
    switch (val) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  static Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    final val = switch (mode) {
      ThemeMode.light => 'light',
      ThemeMode.dark => 'dark',
      _ => 'system',
    };
    await prefs.setString(_themeModeKey, val);
  }

  // Last selected filter (as string). The UI maps to enum.
  static Future<String?> getLastFilter() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastFilterKey);
  }

  static Future<void> setLastFilter(String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastFilterKey, value);
  }
}
