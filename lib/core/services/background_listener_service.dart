import 'dart:async';
import 'package:record/record.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/prayer/presentation/providers/jamat_provider.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

class BackgroundListenerService {
  final AudioRecorder _recorder = AudioRecorder();
  Timer? _jamatCheckTimer;
  final Set<String> _respondedPrayers = {}; // To prevent multiple responses per prayer

  void startListening(WidgetRef ref) {
    _startJamatCheck(ref);
    _startAudioCapture(ref);
  }

  void _startJamatCheck(WidgetRef ref) {
    _jamatCheckTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      final settings = ref.read(jamatProvider);
      if (!settings.isOverlayEnabled) return;

      final now = DateTime.now();
      final currentTimeStr = DateFormat('HH:mm').format(now);
      
      settings.jamatTimes.forEach((prayer, jamatTime) {
        if (_respondedPrayers.contains("${prayer}_jamat_$currentTimeStr")) return;

        final jamatDateTime = _parseTimeString(jamatTime);
        final warningTime = jamatDateTime.subtract(Duration(minutes: settings.warningMinutes));
        
        // Check if now is within the warning window
        if (now.isAfter(warningTime) && now.isBefore(jamatDateTime)) {
          _triggerOverlay(prayer, "Jamat in ${settings.warningMinutes} minutes");
          _respondedPrayers.add("${prayer}_jamat_$currentTimeStr");
        }
      });
      
      // Reset responded prayers at midnight
      if (currentTimeStr == '00:00') _respondedPrayers.clear();
    });
  }

  void _startAudioCapture(WidgetRef ref) async {
    final settings = ref.read(jamatProvider);
    if (!settings.isListeningModeEnabled) return;

    if (await _recorder.hasPermission()) {
      // Logic for stream-based Adhan detection would go here
      // For now, we simulate background presence
    }
  }

  DateTime _parseTimeString(String timeStr) {
    final parts = timeStr.split(':');
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, int.parse(parts[0]), int.parse(parts[1]));
  }

  void _triggerOverlay(String prayer, String message) {
    // This would call windowManager to show the overlay
    debugPrint("TRIGGER OVERLAY: $prayer - $message");
  }

  void stop() {
    _jamatCheckTimer?.cancel();
    _recorder.dispose();
  }
}

final backgroundListenerProvider = Provider((ref) => BackgroundListenerService());
