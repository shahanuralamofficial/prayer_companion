import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../db/hive_database.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'dart:io';
import 'package:flutter/foundation.dart';

class SettingsState {
  final bool earlyReminder;
  final bool iqamahAlerts;
  final bool launchAtLogin;
  final bool showFloatingWidget;
  final bool useTrueFullscreen;

  SettingsState({
    required this.earlyReminder,
    required this.iqamahAlerts,
    required this.launchAtLogin,
    required this.showFloatingWidget,
    required this.useTrueFullscreen,
  });

  SettingsState copyWith({
    bool? earlyReminder,
    bool? iqamahAlerts,
    bool? launchAtLogin,
    bool? showFloatingWidget,
    bool? useTrueFullscreen,
  }) {
    return SettingsState(
      earlyReminder: earlyReminder ?? this.earlyReminder,
      iqamahAlerts: iqamahAlerts ?? this.iqamahAlerts,
      launchAtLogin: launchAtLogin ?? this.launchAtLogin,
      showFloatingWidget: showFloatingWidget ?? this.showFloatingWidget,
      useTrueFullscreen: useTrueFullscreen ?? this.useTrueFullscreen,
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
      showFloatingWidget: box.get('showFloatingWidget', defaultValue: false),
      useTrueFullscreen: box.get('useTrueFullscreen', defaultValue: false),
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

  void toggleFloatingWidget(bool val) {
    state = state.copyWith(showFloatingWidget: val);
    HiveDatabase.getSettingsBox().put('showFloatingWidget', val);
  }

  void toggleTrueFullscreen(bool val) {
    state = state.copyWith(useTrueFullscreen: val);
    HiveDatabase.getSettingsBox().put('useTrueFullscreen', val);
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
