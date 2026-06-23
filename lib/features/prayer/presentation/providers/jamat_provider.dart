import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/db/hive_database.dart';

class JamatSettings {
  final Map<String, String> jamatTimes;
  final int warningMinutes;
  final int earlyAdhanMinutes;
  final bool isOverlayEnabled;
  final bool isListeningModeEnabled;

  JamatSettings({
    required this.jamatTimes,
    required this.warningMinutes,
    required this.earlyAdhanMinutes,
    required this.isOverlayEnabled,
    required this.isListeningModeEnabled,
  });

  JamatSettings copyWith({
    Map<String, String>? jamatTimes,
    int? warningMinutes,
    int? earlyAdhanMinutes,
    bool? isOverlayEnabled,
    bool? isListeningModeEnabled,
  }) {
    return JamatSettings(
      jamatTimes: jamatTimes ?? this.jamatTimes,
      warningMinutes: warningMinutes ?? this.warningMinutes,
      earlyAdhanMinutes: earlyAdhanMinutes ?? this.earlyAdhanMinutes,
      isOverlayEnabled: isOverlayEnabled ?? this.isOverlayEnabled,
      isListeningModeEnabled: isListeningModeEnabled ?? this.isListeningModeEnabled,
    );
  }
}

class JamatNotifier extends StateNotifier<JamatSettings> {
  JamatNotifier() : super(_loadSettings());

  static JamatSettings _loadSettings() {
    final box = HiveDatabase.getSettingsBox();
    final Map<String, String> jamatTimes = {
      'Fajr': box.get('jamatFajr', defaultValue: '05:30'),
      'Dhuhr': box.get('jamatDhuhr', defaultValue: '13:30'),
      'Asr': box.get('jamatAsr', defaultValue: '17:15'),
      'Maghrib': box.get('jamatMaghrib', defaultValue: '18:50'),
      'Isha': box.get('jamatIsha', defaultValue: '20:30'),
    }.map((key, value) => MapEntry(key, value.toString()));

    return JamatSettings(
      jamatTimes: jamatTimes,
      warningMinutes: box.get('jamatWarningMinutes', defaultValue: 5),
      earlyAdhanMinutes: box.get('earlyAdhanMinutes', defaultValue: 15),
      isOverlayEnabled: box.get('isOverlayEnabled', defaultValue: true),
      isListeningModeEnabled: box.get('isListeningModeEnabled', defaultValue: true),
    );
  }

  void updateJamatTime(String prayer, String time) {
    final box = HiveDatabase.getSettingsBox();
    final newTimes = Map<String, String>.from(state.jamatTimes);
    newTimes[prayer] = time;
    box.put('jamat$prayer', time);
    state = state.copyWith(jamatTimes: newTimes);
  }

  void updateWarningMinutes(int minutes) {
    HiveDatabase.getSettingsBox().put('jamatWarningMinutes', minutes);
    state = state.copyWith(warningMinutes: minutes);
  }

  void updateEarlyAdhanMinutes(int minutes) {
    HiveDatabase.getSettingsBox().put('earlyAdhanMinutes', minutes);
    state = state.copyWith(earlyAdhanMinutes: minutes);
  }

  void toggleOverlay(bool value) {
    HiveDatabase.getSettingsBox().put('isOverlayEnabled', value);
    state = state.copyWith(isOverlayEnabled: value);
  }

  void toggleListeningMode(bool value) {
    HiveDatabase.getSettingsBox().put('isListeningModeEnabled', value);
    state = state.copyWith(isListeningModeEnabled: value);
  }
}

final jamatProvider = StateNotifierProvider<JamatNotifier, JamatSettings>((ref) {
  return JamatNotifier();
});
