import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../db/hive_database.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(_loadTheme());

  static ThemeMode _loadTheme() {
    final box = HiveDatabase.getSettingsBox();
    final String? themeStr = box.get('themeMode');
    if (themeStr == 'dark') return ThemeMode.dark;
    if (themeStr == 'light') return ThemeMode.light;
    return ThemeMode.light; // Default to Light as requested
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
    final box = HiveDatabase.getSettingsBox();
    if (mode == ThemeMode.dark) box.put('themeMode', 'dark');
    if (mode == ThemeMode.light) box.put('themeMode', 'light');
    if (mode == ThemeMode.system) box.put('themeMode', 'system');
  }

  void toggleTheme() {
    if (state == ThemeMode.light) {
      setThemeMode(ThemeMode.dark);
    } else {
      setThemeMode(ThemeMode.light);
    }
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});
