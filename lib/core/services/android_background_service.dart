import 'dart:async';
import 'dart:ui';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:adhan_dart/adhan_dart.dart';
import 'package:intl/intl.dart';
import '../db/hive_database.dart';
import 'package:audioplayers/audioplayers.dart';

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  await HiveDatabase.init();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final audioPlayer = AudioPlayer();
  final Set<String> respondedPrayers = {};

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  if (service is AndroidServiceInstance) {
    service.setAsForegroundService();
  }

  Timer.periodic(const Duration(seconds: 15), (timer) async {
    final now = DateTime.now();
    final todayStr = DateFormat('yyyy-MM-dd').format(now);

    final box = HiveDatabase.getSettingsBox();
    final methodIndex = box.get('calculationMethod', defaultValue: CalculationMethod.muslimWorldLeague.index);
    final method = CalculationMethod.values[methodIndex];
    final madhabIndex = box.get('madhab', defaultValue: Madhab.hanafi.index);
    final madhab = Madhab.values[madhabIndex];

    final lat = box.get('latitude', defaultValue: 23.8103);
    final lon = box.get('longitude', defaultValue: 90.4125);

    final params = _getParametersForMethod(method);
    params.madhab = madhab;
    
    final prayerTimes = PrayerTimes(
      coordinates: Coordinates(lat, lon),
      date: now,
      calculationParameters: params,
      precision: true,
    );

    final nextPrayer = prayerTimes.nextPrayer();
    final nextTime = prayerTimes.timeForPrayer(nextPrayer).toLocal();
    final diff = nextTime.difference(now);

    final countdown = _formatShortCountdown(diff);

    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: "Prayer Companion Active",
        content: "Next: ${nextPrayer.name.toUpperCase()} in $countdown",
      );
    }

    final Map<String, DateTime> times = {
      'Fajr': prayerTimes.fajr.toLocal(),
      'Dhuhr': prayerTimes.dhuhr.toLocal(),
      'Asr': prayerTimes.asr.toLocal(),
      'Maghrib': prayerTimes.maghrib.toLocal(),
      'Isha': prayerTimes.isha.toLocal(),
    };

    times.forEach((prayer, time) {
      final dedupKey = "${prayer}_adhan_$todayStr";
      if (respondedPrayers.contains(dedupKey)) return;

      if (now.isAfter(time) && now.isBefore(time.add(const Duration(seconds: 45)))) {
        _triggerAndroidAdhan(flutterLocalNotificationsPlugin, audioPlayer, prayer);
        respondedPrayers.add(dedupKey);
      }
    });

    if (DateFormat('HH:mm').format(now) == '00:00') respondedPrayers.clear();
  });
}

@pragma('vm:entry-point')
Future<bool> onIosStart(ServiceInstance service) async {
  onStart(service);
  return true;
}

CalculationParameters _getParametersForMethod(CalculationMethod method) {
  switch (method) {
    case CalculationMethod.dubai: return CalculationMethodParameters.dubai();
    case CalculationMethod.egyptian: return CalculationMethodParameters.egyptian();
    case CalculationMethod.karachi: return CalculationMethodParameters.karachi();
    case CalculationMethod.kuwait: return CalculationMethodParameters.kuwait();
    case CalculationMethod.moonsightingCommittee: return CalculationMethodParameters.moonsightingCommittee();
    case CalculationMethod.morocco: return CalculationMethodParameters.morocco();
    case CalculationMethod.muslimWorldLeague: return CalculationMethodParameters.muslimWorldLeague();
    case CalculationMethod.northAmerica: return CalculationMethodParameters.northAmerica();
    case CalculationMethod.qatar: return CalculationMethodParameters.qatar();
    case CalculationMethod.singapore: return CalculationMethodParameters.singapore();
    case CalculationMethod.tehran: return CalculationMethodParameters.tehran();
    case CalculationMethod.turkiye: return CalculationMethodParameters.turkiye();
    case CalculationMethod.ummAlQura: return CalculationMethodParameters.ummAlQura();
    default: return CalculationMethodParameters.muslimWorldLeague();
  }
}

void _triggerAndroidAdhan(
    FlutterLocalNotificationsPlugin notifications, 
    AudioPlayer player, 
    String prayer) async {
  
  await player.play(AssetSource('adhan/makkah.mp3'));

  const AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(
    'prayer_alerts',
    'Prayer Alerts',
    channelDescription: 'Notifications for prayer times',
    importance: Importance.max,
    priority: Priority.high,
    fullScreenIntent: true,
  );
  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  
  await notifications.show(
    0,
    'Time for $prayer',
    'It is time for $prayer prayer.',
    platformChannelSpecifics,
  );
}

String _formatShortCountdown(Duration d) {
  final hours = d.inHours;
  final minutes = d.inMinutes % 60;
  return '${hours > 0 ? '${hours}h ' : ''}${minutes}m';
}

Future<void> initializeBackgroundService() async {
  final service = FlutterBackgroundService();

  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'prayer_companion_service',
    'Prayer Companion Service',
    description: 'This channel is used for the persistent prayer time service.',
    importance: Importance.low,
  );

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
      notificationChannelId: 'prayer_companion_service',
      initialNotificationTitle: 'Prayer Companion',
      initialNotificationContent: 'Initializing prayer service...',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onIosStart,
      onBackground: onIosStart,
    ),
  );
}
