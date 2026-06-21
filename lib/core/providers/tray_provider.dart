import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/desktop_service.dart';
import '../../features/prayer/presentation/providers/prayer_provider.dart';

final trayUpdateProvider = Provider((ref) {
  final desktopService = ref.watch(desktopServiceProvider);

  final timer = Timer.periodic(const Duration(seconds: 10), (timer) {
    final prayerTimes = ref.read(prayerTimesProvider).value;
    if (prayerTimes != null) {
      final nextPrayer = prayerTimes.nextPrayer(date: DateTime.now());
      final nextPrayerTime = prayerTimes.timeForPrayer(nextPrayer);
      final remaining = nextPrayerTime.difference(DateTime.now());

      if (!remaining.isNegative) {
        final hours = remaining.inHours;
        final minutes = remaining.inMinutes % 60;
        final title = "🕌 ${nextPrayer.name} in ${hours}h ${minutes}m";
        desktopService.updateTrayTitle(title);
      }
    }
  });

  ref.onDispose(() => timer.cancel());
});
