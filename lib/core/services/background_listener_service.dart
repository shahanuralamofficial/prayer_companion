import 'dart:async';
import 'package:record/record.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/prayer/presentation/providers/jamat_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:window_manager/window_manager.dart';
import '../routing/app_router.dart';

class BackgroundListenerService {
  final AudioRecorder _recorder = AudioRecorder();
  Timer? _jamatCheckTimer;
  final Set<String> _respondedPrayers = {}; // To prevent multiple responses per prayer

  void startListening(Ref ref) {
    _startJamatCheck(ref);
    _startAudioCapture(ref);
  }

  void _startJamatCheck(Ref ref) {
    _jamatCheckTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      final settings = ref.read(jamatProvider);
      if (!settings.isOverlayEnabled) return;

      final now = DateTime.now();
      final todayStr = DateFormat('yyyy-MM-dd').format(now);
      
      settings.jamatTimes.forEach((prayer, jamatTime) {
        final dedupKey = "${prayer}_jamat_$todayStr";
        if (_respondedPrayers.contains(dedupKey)) return;

        final jamatDateTime = _parseTimeString(jamatTime);
        final warningTime = jamatDateTime.subtract(Duration(minutes: settings.warningMinutes));
        
        // Check if now is within the warning window
        if (now.isAfter(warningTime) && now.isBefore(jamatDateTime)) {
          _triggerOverlay(ref, prayer, "Jamat in ${settings.warningMinutes} minutes");
          _respondedPrayers.add(dedupKey);
        }
      });
      
      // Reset at midnight
      if (DateFormat('HH:mm').format(now) == '00:00') _respondedPrayers.clear();
    });
  }

  void _startAudioCapture(Ref ref) async {
    final settings = ref.read(jamatProvider);
    if (!settings.isListeningModeEnabled) return;

    try {
      if (await _recorder.hasPermission()) {
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

  void _triggerOverlay(Ref ref, String prayer, String message) async {
    debugPrint("TRIGGER OVERLAY: $prayer - $message");
    
    try {
      // Show and focus the window
      await windowManager.show();
      await windowManager.focus();
      
      // Navigate to the fullscreen overlay
      ref.read(appRouterProvider).push('/fullscreen-prayer', extra: {
        'prayerName': prayer,
        'quranVerse': 'Indeed, prayer has been decreed upon the believers a decree of specified times.',
        'quranReference': 'Quran 4:103',
        'subtext': message,
      });
    } catch (e) {
      debugPrint("Failed to trigger overlay: $e");
    }
  }

  void stop() {
    _jamatCheckTimer?.cancel();
    _recorder.dispose();
  }
}

final backgroundListenerProvider = Provider((ref) {
  final service = BackgroundListenerService();
  service.startListening(ref);
  ref.onDispose(() => service.stop());
  return service;
});
