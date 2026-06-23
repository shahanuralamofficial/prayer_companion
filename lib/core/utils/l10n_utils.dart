import 'package:flutter/material.dart';

class L10nUtils {
  static String getPrayerName(String prayer, Locale locale) {
    final isBn = locale.languageCode == 'bn';
    final Map<String, String> names = isBn 
      ? {
          'fajr': 'ফজর',
          'sunrise': 'সূর্যোদয়',
          'dhuhr': 'যোহর',
          'asr': 'আসর',
          'maghrib': 'মাগরিব',
          'isha': 'এশা',
          'tahajjud': 'তাহাজ্জুদ',
          'sunset': 'সূর্যাস্ত',
        }
      : {
          'fajr': 'Fajr',
          'sunrise': 'Sunrise',
          'dhuhr': 'Dhuhr',
          'asr': 'Asr',
          'maghrib': 'Maghrib',
          'isha': 'Isha',
          'tahajjud': 'Tahajjud',
          'sunset': 'Sunset',
        };
    
    return names[prayer.toLowerCase()] ?? prayer;
  }

  static String getAdhanSubtext(String prayer, Locale locale) {
    final name = getPrayerName(prayer, locale);
    return locale.languageCode == 'bn' 
      ? '$name-এর আযানের সময় হয়েছে' 
      : 'It is time for $name Adhan';
  }

  static String getJamatWarning(String prayer, String minutes, Locale locale) {
    final name = getPrayerName(prayer, locale);
    return locale.languageCode == 'bn' 
      ? '$name-এর জামাত $minutes মিনিটের মধ্যে' 
      : 'Jamat in $minutes minutes';
  }

  static String getJamatTime(String prayer, Locale locale) {
    final name = getPrayerName(prayer, locale);
    return locale.languageCode == 'bn' 
      ? '$name-এর জামাতের সময় হয়েছে' 
      : 'It is time for $name Jamat';
  }

  static String getCountdown(int hours, int minutes, Locale locale) {
    final isBn = locale.languageCode == 'bn';
    if (isBn) {
      final h = hours > 0 ? '$hours ঘণ্টা ' : '';
      return '$h$minutes মি';
    }
    final h = hours > 0 ? '${hours}h ' : '';
    return '$h${minutes}m';
  }
}
