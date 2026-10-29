
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends ChangeNotifier {
  static const String _themeKey = 'is_dark_mode';

  ThemeMode _themeMode = ThemeMode.dark;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  Future<void> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    final bool isDark = prefs.getBool(_themeKey) ?? true;

    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;

    notifyListeners();
  }

  Future<void> setDarkMode(bool enabled) async {
    final newMode = enabled ? ThemeMode.dark : ThemeMode.light;

    if (_themeMode == newMode) return;

    _themeMode = newMode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, enabled);
  }

  Future<void> toggleTheme() async {
    await setDarkMode(!isDarkMode);
  }
}

final ThemeController themeController = ThemeController();
