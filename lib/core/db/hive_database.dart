import 'package:hive_flutter/hive_flutter.dart';

class HiveDatabase {
  static const String settingsBox = 'settings_box';
  static const String prayersBox = 'prayers_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    final settings = await Hive.openBox(settingsBox);
    await Hive.openBox(prayersBox);

    // Set default values if not exists
    if (settings.get('isOverlayEnabled') == null) {
      settings.put('isOverlayEnabled', true);
    }
    if (settings.get('jamatWarningMinutes') == null) {
      settings.put('jamatWarningMinutes', 5);
    }
    if (settings.get('isListeningModeEnabled') == null) {
      settings.put('isListeningModeEnabled', true);
    }
  }

  static Box getSettingsBox() => Hive.box(settingsBox);
  static Box getPrayersBox() => Hive.box(prayersBox);
}
