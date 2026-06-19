import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:adhan_dart/adhan_dart.dart';
import '../../data/services/prayer_service.dart';
import '../../../../core/services/location_service.dart';

final prayerTimesProvider = FutureProvider<PrayerTimes?>((ref) async {
  final locationService = ref.watch(locationServiceProvider);
  final prayerService = ref.watch(prayerServiceProvider);

  // For now, using Dhaka coordinates as default if GPS fails
  final position = await locationService.getCurrentPosition();
  final lat = position?.latitude ?? 23.8103;
  final lon = position?.longitude ?? 90.4125;

  return prayerService.getPrayerTimes(latitude: lat, longitude: lon);
});

final currentPrayerProvider = Provider<String?>((ref) {
  final prayerTimes = ref.watch(prayerTimesProvider).value;
  if (prayerTimes == null) return null;
  return prayerTimes.currentPrayer(date: DateTime.now()).name;
});

final nextPrayerProvider = Provider<String?>((ref) {
  final prayerTimes = ref.watch(prayerTimesProvider).value;
  if (prayerTimes == null) return null;
  return prayerTimes.nextPrayer(date: DateTime.now()).name;
});
