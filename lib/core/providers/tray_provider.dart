import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/desktop_service.dart';
import '../providers/locale_provider.dart';
import '../../features/prayer/presentation/providers/prayer_provider.dart';
import '../utils/l10n_utils.dart';

final trayUpdateProvider = Provider((ref) {
  final desktopService = ref.watch(desktopServiceProvider);

  final timer = Timer.periodic(const Duration(seconds: 10), (timer) {
    final prayerTimes = ref.read(prayerTimesProvider).value;
    final locale = ref.read(localeProvider);
    final isBn = locale.languageCode == 'bn';

    if (prayerTimes != null) {
      final nextPrayer = prayerTimes.nextPrayer(date: DateTime.now());
      final nextPrayerTime = prayerTimes.timeForPrayer(nextPrayer);
      final remaining = nextPrayerTime.difference(DateTime.now());

      if (!remaining.isNegative) {
        final hours = remaining.inHours;
        final minutes = remaining.inMinutes % 60;
        
        // Handle name and fajrAfter
        String name = nextPrayer.name;
        if (name == 'fajrAfter') name = 'fajr';
        
        final localName = L10nUtils.getPrayerName(name, locale);
        final countdown = L10nUtils.getCountdown(hours, minutes, locale);
        
        final String title;
        if (isBn) {
          title = "🕌 $localName-এর মধ্যে $countdown";
        } else {
          title = "🕌 $localName in $countdown";
        }
        desktopService.updateTrayTitle(title);
      } else {
        // Fallback for late night / transition
        desktopService.updateTrayTitle(isBn ? "🕌 ফজর (আগামীকাল)" : "🕌 Fajr Tomorrow");
      }
    }
  });

  ref.onDispose(() => timer.cancel());
});
