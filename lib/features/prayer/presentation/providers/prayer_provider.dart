import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adhan_dart/adhan_dart.dart';
import '../../data/services/prayer_service.dart';
import '../../../../core/services/location_service.dart';
import '../../../../core/db/hive_database.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

final timezoneIdProvider = FutureProvider<String>((ref) async {
  try {
    return await FlutterTimezone.getLocalTimezone();
  } catch (e) {
    return DateTime.now().timeZoneName;
  }
});

final calculationMethodProvider = StateProvider<CalculationMethod>((ref) {
  final box = HiveDatabase.getSettingsBox();
  final methodIndex = box.get('calculationMethod', defaultValue: CalculationMethod.muslimWorldLeague.index);
  return CalculationMethod.values[methodIndex];
});

final madhabProvider = StateProvider<Madhab>((ref) {
  final box = HiveDatabase.getSettingsBox();
  final madhabIndex = box.get('madhab', defaultValue: Madhab.hanafi.index);
  return Madhab.values[madhabIndex];
});

final locationInfoProvider = FutureProvider<String>((ref) async {
  final locationService = ref.watch(locationServiceProvider);
  final position = await locationService.getCurrentPosition();
  if (position == null) return "Dhaka, Bangladesh";
  
  try {
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    if (placemarks.isNotEmpty) {
      final p = placemarks.first;
      return "${p.locality}, ${p.country}";
    }
  } catch (e) {
    return "Local Detection Active";
  }
  return "Dhaka, Bangladesh";
});

final coordinatesProvider = FutureProvider<String>((ref) async {
  final locationService = ref.watch(locationServiceProvider);
  final position = await locationService.getCurrentPosition();
  if (position == null) return "23.8103, 90.4125";
  return "${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}";
});

final prayerTimesProvider = FutureProvider<PrayerTimes?>((ref) async {
  final locationService = ref.watch(locationServiceProvider);
  final prayerService = ref.watch(prayerServiceProvider);
  final method = ref.watch(calculationMethodProvider);
  final madhab = ref.watch(madhabProvider);

  // Setup midnight refresh
  final now = DateTime.now();
  final tomorrow = DateTime(now.year, now.month, now.day + 1);
  final untilMidnight = tomorrow.difference(now);
  
  final timer = Timer(untilMidnight, () {
    ref.invalidateSelf();
  });
  ref.onDispose(() => timer.cancel());

  try {
    final position = await locationService.getCurrentPosition();
    final lat = position?.latitude ?? 23.8103;
    final lon = position?.longitude ?? 90.4125;

    return prayerService.getPrayerTimes(
      latitude: lat, 
      longitude: lon,
      method: method,
      madhab: madhab,
    );
  } catch (e) {
    debugPrint("Failed to fetch prayer times: $e");
    return null;
  }
});

class EnhancedPrayerTimes {
  final PrayerTimes base;
  final DateTime tahajjud;

  EnhancedPrayerTimes(this.base, this.tahajjud);

  static EnhancedPrayerTimes from(PrayerTimes base) {
    // Ensure all times are local
    final maghrib = base.maghrib.toLocal();
    final fajrToday = base.fajr.toLocal();
    final fajrTomorrow = fajrToday.add(const Duration(days: 1));
    
    final nightDuration = fajrTomorrow.difference(maghrib);
    final oneThird = nightDuration.inSeconds / 3;
    final tahajjudStart = fajrTomorrow.subtract(Duration(seconds: oneThird.toInt()));
    
    return EnhancedPrayerTimes(base, tahajjudStart.toLocal());
  }
}

final enhancedPrayerTimesProvider = Provider<EnhancedPrayerTimes?>((ref) {
  final times = ref.watch(prayerTimesProvider).value;
  if (times == null) return null;
  return EnhancedPrayerTimes.from(times);
});
