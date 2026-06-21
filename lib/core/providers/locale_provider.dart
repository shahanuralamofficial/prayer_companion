import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../db/hive_database.dart';

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('bn')) {
    _loadLocale();
  }

  void _loadLocale() {
    final box = HiveDatabase.getSettingsBox();
    final String? languageCode = box.get('languageCode');
    if (languageCode != null) {
      state = Locale(languageCode);
    }
  }

  void setLocale(Locale locale) {
    debugPrint("Changing locale to: ${locale.languageCode}");
    state = locale;
    final box = HiveDatabase.getSettingsBox();
    box.put('languageCode', locale.languageCode);
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});
