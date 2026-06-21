import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../db/hive_database.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class SettingsState {
  final bool earlyReminder;
  final bool iqamahAlerts;
  final bool launchAtLogin;

  SettingsState({
    required this.earlyReminder,
    required this.iqamahAlerts,
    required this.launchAtLogin,
  });

  SettingsState copyWith({
    bool? earlyReminder,
    bool? iqamahAlerts,
    bool? launchAtLogin,
  }) {
    return SettingsState(
      earlyReminder: earlyReminder ?? this.earlyReminder,
      iqamahAlerts: iqamahAlerts ?? this.iqamahAlerts,
      launchAtLogin: launchAtLogin ?? this.launchAtLogin,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(_loadSettings());

  static SettingsState _loadSettings() {
    final box = HiveDatabase.getSettingsBox();
    return SettingsState(
      earlyReminder: box.get('earlyReminder', defaultValue: true),
      iqamahAlerts: box.get('iqamahAlerts', defaultValue: true),
      launchAtLogin: box.get('launchAtLogin', defaultValue: true),
    );
  }

  void toggleEarlyReminder(bool val) {
    state = state.copyWith(earlyReminder: val);
    HiveDatabase.getSettingsBox().put('earlyReminder', val);
  }

  void toggleIqamahAlerts(bool val) {
    state = state.copyWith(iqamahAlerts: val);
    HiveDatabase.getSettingsBox().put('iqamahAlerts', val);
  }

  void toggleLaunchAtLogin(bool val) async {
    state = state.copyWith(launchAtLogin: val);
    HiveDatabase.getSettingsBox().put('launchAtLogin', val);
    
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      try {
        if (val) {
          await launchAtStartup.enable();
          debugPrint("Launch at startup enabled");
        } else {
          await launchAtStartup.disable();
          debugPrint("Launch at startup disabled");
        }
      } catch (e) {
        debugPrint("Failed to toggle launch at startup: $e");
      }
    }
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});
