import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService {
  final _storage = GetStorage();
  final _key = 'isDarkMode';

  // Load theme from GetStorage, default to false (light mode) if not set
  bool _loadThemeFromStorage() => _storage.read(_key) ?? false;

  // Save theme to GetStorage and update GetX theme
  void _saveThemeToStorage(bool isDarkMode) {
    _storage.write(_key, isDarkMode);
    Get.changeThemeMode(isDarkMode ? ThemeMode.dark : ThemeMode.light);
  }

  // Get current theme mode
  ThemeMode get theme =>
      _loadThemeFromStorage() ? ThemeMode.dark : ThemeMode.light;

  // Switch theme and save to storage
  void switchTheme() {
    bool isDarkMode = !_loadThemeFromStorage();
    _saveThemeToStorage(isDarkMode);
  }
}
