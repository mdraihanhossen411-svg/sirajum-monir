import 'package:flutter/material.dart';

class ThemeService {
  static ThemeMode _themeMode = ThemeMode.system;

  static ThemeMode get themeMode => _themeMode;

  static void setThemeMode(ThemeMode mode) {
    _themeMode = mode;
  }

  static bool get isDarkMode {
    return _themeMode == ThemeMode.dark;
  }

  static bool get isLightMode {
    return _themeMode == ThemeMode.light;
  }

  static bool get isSystemMode {
    return _themeMode == ThemeMode.system;
  }
}
