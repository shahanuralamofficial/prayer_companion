import 'dart:async';
import 'package:record/record.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/prayer/presentation/providers/jamat_provider.dart';
import '../../features/prayer/presentation/providers/prayer_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import '../routing/app_router.dart';
import '../providers/settings_provider.dart';
import '../providers/locale_provider.dart';
import './hadith_service.dart';
import '../utils/l10n_utils.dart';

class BackgroundListenerService {
  AudioRecorder? _recorder;
  Timer? _jamatCheckTimer;
  Timer? _prayerCheckTimer;
  final Set<String> _respondedPrayers = {}; // To prevent multiple responses per prayer

  void startListening(Ref ref) {
    _startJamatCheck(ref);
    _startPrayerCheck(ref);
    unawaited(_startAudioCapture(ref));
  }

  void _startPrayerCheck(Ref ref) {
    _prayerCheckTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      final settings = ref.read(settingsProvider);
      if (!settings.earlyReminder) return;

      final enhancedTimes = ref.read(enhancedPrayerTimesProvider);
      if (enhancedTimes == null) return;

      final now = DateTime.now();
      final todayStr = DateFormat('yyyy-MM-dd').format(now);
      final prayerTimes = enhancedTimes.base;

      final Map<String, DateTime> times = {
        'Fajr': prayerTimes.fajr.toLocal(),
        'Dhuhr': prayerTimes.dhuhr.toLocal(),
        'Asr': prayerTimes.asr.toLocal(),
        'Maghrib': prayerTimes.maghrib.toLocal(),
        'Isha': prayerTimes.isha.toLocal(),
      };

      times.forEach((prayer, time) {
        final dedupKey = "${prayer}_adhan_$todayStr";
        if (_respondedPrayers.contains(dedupKey)) return;

        // Trigger adhan exactly at prayer time (or within 30s)
        if (now.isAfter(time) && now.isBefore(time.add(const Duration(seconds: 45)))) {
          _triggerAdhan(ref, prayer);
          _respondedPrayers.add(dedupKey);
        }
      });
    });
  }

  void _triggerAdhan(Ref ref, String prayer) async {
    final todayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final activeKey = "${prayer}_active_$todayStr";
    if (_respondedPrayers.contains(activeKey)) return;
    _respondedPrayers.add(activeKey);

    debugPrint("AUTO ADHAN TRIGGERED: $prayer");
    
    try {
      final settings = ref.read(settingsProvider);
      final locale = ref.read(localeProvider);
      final subtext = L10nUtils.getAdhanSubtext(prayer, locale);
      
      final hadithData = ref.read(hadithServiceProvider).getRandomHadith(locale.languageCode);

      if (settings.useTrueFullscreen) {
        await windowManager.setAlwaysOnTop(true); // Ensure it overlaps even taskbar
        await windowManager.setFullScreen(true);
      } else {
        await windowManager.setSize(const Size(440, 720));
        await windowManager.center();
      }
      
      await windowManager.show();
      await windowManager.focus();
      
      ref.read(appRouterProvider).push('/fullscreen-prayer', extra: {
        'prayerName': prayer,
        'quranVerse': hadithData['text'],
        'quranReference': hadithData['reference'],
        'subtext': subtext,
      });
    } catch (e) {
      debugPrint("Failed to trigger Adhan: $e");
    }
  }

  void _startJamatCheck(Ref ref) {
    _jamatCheckTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      final globalSettings = ref.read(settingsProvider);
      if (!globalSettings.iqamahAlerts) return;

      final settings = ref.read(jamatProvider);
      if (!settings.isOverlayEnabled) return;

      final now = DateTime.now();
      final todayStr = DateFormat('yyyy-MM-dd').format(now);
      
      settings.jamatTimes.forEach((prayer, jamatTime) {
        // Skip all warnings for Maghrib as requested
        if (prayer.toLowerCase() == 'maghrib') return;

        final jamatDateTime = _parseTimeString(jamatTime);
        final warningTime = jamatDateTime.subtract(Duration(minutes: settings.warningMinutes));
        final earlyAdhanTime = jamatDateTime.subtract(Duration(minutes: settings.warningMinutes + settings.earlyAdhanMinutes));

        // 0. Early Adhan Overlay
        final earlyAdhanKey = "${prayer}_early_adhan_$todayStr";
        if (!_respondedPrayers.contains(earlyAdhanKey)) {
          if (now.isAfter(earlyAdhanTime) && now.isBefore(earlyAdhanTime.add(const Duration(seconds: 45)))) {
            _triggerAdhan(ref, prayer); // Use _triggerAdhan for audio
            _respondedPrayers.add(earlyAdhanKey);
          }
        }

        // 1. Warning Adhan Overlay (Now just an overlay since Adhan played earlier)
        final warningKey = "${prayer}_jamat_warning_$todayStr";
        if (now.isAfter(warningTime) && now.isBefore(warningTime.add(const Duration(seconds: 45)))) {
          _triggerOverlay(ref, prayer, "Jamat in ${settings.warningMinutes} minutes", 
              dedupKey: warningKey);
        }

        // 2. Final Jamat Overlay (exactly at jamat time)
        final finalKey = "${prayer}_jamat_final_$todayStr";
        if (now.isAfter(jamatDateTime) && now.isBefore(jamatDateTime.add(const Duration(seconds: 45)))) {
          _triggerOverlay(ref, prayer, "It is time for $prayer Jamat", 
              dedupKey: finalKey);
        }
      });
      
      // Reset at midnight
      if (DateFormat('HH:mm').format(now) == '00:00') _respondedPrayers.clear();
    });
  }

  Future<void> _startAudioCapture(Ref ref) async {
    final settings = ref.read(jamatProvider);
    if (!settings.isListeningModeEnabled) return;

    _recorder ??= AudioRecorder();
    try {
      if (await _recorder!.hasPermission()) {
        // Implementation for Adhan detection would go here
      }
    } catch (e) {
      debugPrint("Audio capture init failed: $e");
    }
  }

  DateTime _parseTimeString(String timeStr) {
    try {
      final parts = timeStr.split(':');
      if (parts.length < 2) throw const FormatException("Invalid time format");
      final now = DateTime.now();
      return DateTime(now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
    } catch (e) {
      // Fallback to a far future date to prevent immediate trigger
      return DateTime.now().add(const Duration(days: 1));
    }
  }

  void _triggerOverlay(Ref ref, String prayer, String message, {required String dedupKey}) async {
    if (_respondedPrayers.contains(dedupKey)) return;
    _respondedPrayers.add(dedupKey);

    debugPrint("TRIGGER OVERLAY: $prayer - $message");
    
    try {
      final settings = ref.read(settingsProvider);
      final locale = ref.read(localeProvider);
      
      String localizedMessage = message;
      if (message.contains('Jamat in')) {
        final mins = message.split(' ')[2];
        localizedMessage = L10nUtils.getJamatWarning(prayer, mins, locale);
      } else if (message.contains('It is time for')) {
        localizedMessage = L10nUtils.getJamatTime(prayer, locale);
      }

      final hadithData = ref.read(hadithServiceProvider).getRandomHadith(locale.languageCode);

      if (settings.useTrueFullscreen) {
        await windowManager.setAlwaysOnTop(true);
        await windowManager.setFullScreen(true);
      } else {
        await windowManager.setSize(const Size(440, 720));
        await windowManager.center();
      }

      await windowManager.show();
      await windowManager.focus();
      
      // Navigate to the fullscreen overlay
      ref.read(appRouterProvider).push('/fullscreen-prayer', extra: {
        'prayerName': prayer,
        'quranVerse': hadithData['text'],
        'quranReference': hadithData['reference'],
        'subtext': localizedMessage,
      });
    } catch (e) {
      debugPrint("Failed to trigger overlay: $e");
    }
  }

  void stop() {
    _jamatCheckTimer?.cancel();
    _prayerCheckTimer?.cancel();
    _recorder?.dispose();
  }
}

final backgroundListenerProvider = Provider((ref) {
  final service = BackgroundListenerService();
  service.startListening(ref);
  ref.onDispose(() => service.stop());
  return service;
});
