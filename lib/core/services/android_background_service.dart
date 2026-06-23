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

  // Initialize notifications
  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ),
  );

  final audioPlayer = AudioPlayer();
  final Set<String> respondedPrayers = {};
  String lastTodayStr = DateFormat('yyyy-MM-dd').format(DateTime.now());

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    audioPlayer.dispose();
    service.stopSelf();
  });

  if (service is AndroidServiceInstance) {
    service.setAsForegroundService();
  }

  Timer.periodic(const Duration(seconds: 15), (timer) async {
    final now = DateTime.now();
    final todayStr = DateFormat('yyyy-MM-dd').format(now);
    
    // Day change reset
    if (todayStr != lastTodayStr) {
      respondedPrayers.clear();
      lastTodayStr = todayStr;
    }

    final box = HiveDatabase.getSettingsBox();
    final methodIndex = box.get('calculationMethod', defaultValue: CalculationMethod.muslimWorldLeague.index);
    final method = CalculationMethod.values[methodIndex];
    final madhabIndex = box.get('madhab', defaultValue: Madhab.hanafi.index);
    final madhab = Madhab.values[madhabIndex];

    final lat = box.get('latitude', defaultValue: 23.8103);
    final lon = box.get('longitude', defaultValue: 90.4125);
    final lang = box.get('languageCode', defaultValue: 'bn');

    final params = _getParametersForMethod(method);
    params.madhab = madhab;
    
    final prayerTimes = PrayerTimes(
      coordinates: Coordinates(lat, lon),
      date: now,
      calculationParameters: params,
      precision: true,
    );

    var nextPrayer = prayerTimes.nextPrayer();
    var nextTime = prayerTimes.timeForPrayer(nextPrayer).toLocal();

    // Guard against 'none' (night time) or past time
    if (nextPrayer == Prayer.none || nextTime.isBefore(now)) {
      final tmrw = now.add(const Duration(days: 1));
      final t2 = PrayerTimes(
        coordinates: Coordinates(lat, lon),
        date: tmrw,
        calculationParameters: params,
        precision: true,
      );
      nextPrayer = Prayer.fajr;
      nextTime = t2.fajr.toLocal();
    }
    
    final diff = nextTime.difference(now);
    final countdown = _formatShortCountdown(diff, lang);
    final nextPrayerName = _getLocalizedPrayerName(nextPrayer.name, lang);

    if (service is AndroidServiceInstance) {
      service.setForegroundNotificationInfo(
        title: lang == 'bn' ? "নামাজ সঙ্গী সক্রিয়" : "Prayer Companion Active",
        content: lang == 'bn' ? "পরবর্তী: $nextPrayerName — $countdown পর" : "Next: $nextPrayerName in $countdown",
      );
    }

    final Map<String, DateTime> times = {
      'Fajr': prayerTimes.fajr.toLocal(),
      'Dhuhr': prayerTimes.dhuhr.toLocal(),
      'Asr': prayerTimes.asr.toLocal(),
      'Maghrib': prayerTimes.maghrib.toLocal(),
      'Isha': prayerTimes.isha.toLocal(),
    };

    final earlyReminderEnabled = box.get('earlyReminder', defaultValue: true);
    final iqamahAlertsEnabled = box.get('iqamahAlerts', defaultValue: true);

    times.forEach((prayer, time) {
      // 1. Adhan Alert
      final adhanKey = "${prayer}_adhan_$todayStr";
      if (!respondedPrayers.contains(adhanKey)) {
        if (now.isAfter(time) && now.isBefore(time.add(const Duration(seconds: 45)))) {
          _triggerAndroidNotification(
            flutterLocalNotificationsPlugin, 
            audioPlayer, 
            prayer, 
            lang, 
            isAdhan: true
          );
          respondedPrayers.add(adhanKey);
        }
      }

      // 2. Early Reminder (15 mins before)
      if (earlyReminderEnabled) {
        final earlyKey = "${prayer}_early_$todayStr";
        final earlyTime = time.subtract(const Duration(minutes: 15));
        if (!respondedPrayers.contains(earlyKey)) {
          if (now.isAfter(earlyTime) && now.isBefore(earlyTime.add(const Duration(seconds: 45)))) {
            _triggerAndroidNotification(
              flutterLocalNotificationsPlugin, 
              audioPlayer, 
              prayer, 
              lang, 
              isEarly: true
            );
            respondedPrayers.add(earlyKey);
          }
        }
      }

      // 3. Iqamah Alert (15 mins after)
      if (iqamahAlertsEnabled) {
        final iqamahKey = "${prayer}_iqamah_$todayStr";
        final iqamahTime = time.add(const Duration(minutes: 15));
        if (!respondedPrayers.contains(iqamahKey)) {
          if (now.isAfter(iqamahTime) && now.isBefore(iqamahTime.add(const Duration(seconds: 45)))) {
             _triggerAndroidNotification(
              flutterLocalNotificationsPlugin, 
              audioPlayer, 
              prayer, 
              lang, 
              isIqamah: true
            );
            respondedPrayers.add(iqamahKey);
          }
        }
      }
    });
  });
}

void _triggerAndroidNotification(
    FlutterLocalNotificationsPlugin notifications, 
    AudioPlayer player, 
    String prayer,
    String lang,
    {bool isAdhan = false, bool isEarly = false, bool isIqamah = false}) async {
  
  if (isAdhan) {
    await player.play(AssetSource('adhan/makkah.mp3'));
  }

  final String prayerName = _getLocalizedPrayerName(prayer, lang);
  String title = '';
  String body = '';

  if (isAdhan) {
    title = lang == 'bn' ? "$prayerName-এর সময় হয়েছে" : "Time for $prayerName";
    body = lang == 'bn' ? "নামাজ পড়ার প্রস্তুতি নিন।" : "It is time for $prayerName prayer.";
  } else if (isEarly) {
    title = lang == 'bn' ? "$prayerName-এর ১৫ মিনিট বাকি" : "15 mins left for $prayerName";
    body = lang == 'bn' ? "শীঘ্রই $prayerName-এর ওয়াক্ত শুরু হবে।" : "$prayerName prayer time will start soon.";
  } else if (isIqamah) {
    title = lang == 'bn' ? "$prayerName-এর ১৫ মিনিট অতিবাহিত" : "15 mins passed since $prayerName";
    body = lang == 'bn' ? "আপনি কি জামাতে নামাজ পড়েছেন?" : "Have you prayed $prayerName in congregation?";
  }

  final int notificationId = prayer.hashCode.abs() % 1000 + (isEarly ? 1000 : 0) + (isIqamah ? 2000 : 0);

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
    notificationId,
    title,
    body,
    platformChannelSpecifics,
  );
}

String _getLocalizedPrayerName(String prayer, String lang) {
  final isBn = lang == 'bn';
  switch (prayer.toLowerCase()) {
    case 'fajr':
    case 'fajrafter':
      return isBn ? 'ফজর' : 'Fajr';
    case 'sunrise': return isBn ? 'সূর্যোদয়' : 'Sunrise';
    case 'dhuhr': return isBn ? 'যোহর' : 'Dhuhr';
    case 'asr': return isBn ? 'আসর' : 'Asr';
    case 'maghrib': return isBn ? 'মাগরিব' : 'Maghrib';
    case 'isha':
    case 'ishabefore':
      return isBn ? 'এশা' : 'Isha';
    default: return prayer;
  }
}

String _formatShortCountdown(Duration d, String lang) {
  final hours = d.inHours;
  final minutes = d.inMinutes % 60;
  if (lang == 'bn') {
    return '${hours > 0 ? '$hours ঘণ্টা ' : ''}$minutes মি';
  }
  return '${hours > 0 ? '${hours}h ' : ''}${minutes}m';
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
