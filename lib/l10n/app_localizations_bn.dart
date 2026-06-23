// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get appTitle => 'প্রার্থনা সঙ্গী';

  @override
  String get assalamuAlaikum => 'আসসালামু আলাইকুম';

  @override
  String get nextPrayer => 'পরবর্তী নামাজ';

  @override
  String get prayerTimes => 'নামাজের সময়সূচী';

  @override
  String get quickActions => 'দ্রুত কাজ';

  @override
  String get settings => 'সেটিংস';

  @override
  String get qibla => 'কিবলা';

  @override
  String get quran => 'কুরআন';

  @override
  String get tasbih => 'তাসবিহ';

  @override
  String get calendar => 'ক্যালেন্ডার';

  @override
  String get fajr => 'ফজর';

  @override
  String get sunrise => 'সূর্যোদয়';

  @override
  String get sunset => 'সূর্যাস্ত';

  @override
  String get dhuhr => 'যোহর';

  @override
  String get asr => 'আসর';

  @override
  String get maghrib => 'মাগরিব';

  @override
  String get isha => 'এশা';

  @override
  String get tahajjud => 'তাহাজ্জুদ';

  @override
  String get forbiddenSunrise => 'নিষিদ্ধ (সূর্যোদয়)';

  @override
  String get forbiddenZenith => 'নিষিদ্ধ (মধ্যাহ্ন)';

  @override
  String get forbiddenSunset => 'নিষিদ্ধ (সূর্যাস্ত)';

  @override
  String get prayerCalculation => 'নামাজের হিসাব';

  @override
  String get method => 'পদ্ধতি';

  @override
  String get asrMadhab => 'আসরের মাযহাব';

  @override
  String get jamatAndOverlay => 'জামাত ও ওভারলে';

  @override
  String get notifications => 'নোটিফিকেশন';

  @override
  String get adhanSound => 'আযানের শব্দ';

  @override
  String get earlyReminder => 'আগাম সতর্কতা';

  @override
  String get iqamahAlerts => 'ইকামত সতর্কতা';

  @override
  String get floatingBar => 'ফ্লোটিং বার';

  @override
  String get appearance => 'প্রদর্শন';

  @override
  String get language => 'ভাষা';

  @override
  String get theme => 'থিম';

  @override
  String get dark => 'ডার্ক';

  @override
  String get light => 'লাইট';

  @override
  String get english => 'English';

  @override
  String get bengali => 'বাংলা';

  @override
  String get launchAtLogin => 'পিসি চালুর সময় শুরু করুন';

  @override
  String get jamatSettings => 'জামাত সেটিংস';

  @override
  String get fullscreenOverlay => 'ফুলস্ক্রিন ওভারলে';

  @override
  String get immersiveScreen => 'নামাজের সময় ইমারসিভ স্ক্রিন';

  @override
  String get listeningMode => 'লিসেনিং মোড';

  @override
  String get detectAdhan => 'স্বয়ংক্রিয়ভাবে আযান সনাক্ত করুন';

  @override
  String get warningSettings => 'সতর্কবার্তা সেটিংস';

  @override
  String get manualJamatTimes => 'ম্যানুয়াল জামাতের সময়';

  @override
  String get overlayControls => 'ওভারলে নিয়ন্ত্রণ';

  @override
  String get warningBeforeJamat => 'জামাতের আগে সতর্কতা';

  @override
  String get earlyAdhanWarning => 'আযানের আগে সতর্কতা';

  @override
  String get minutes => 'মিনিট';

  @override
  String get manualTimesAndAlerts => 'ম্যানুয়াল সময় ও সতর্কতা';

  @override
  String get checkForUpdates => 'আপডেট চেক করুন';

  @override
  String get close => 'বন্ধ করুন';

  @override
  String get localDetectionActive => 'লোকাল ডিটেকশন সক্রিয়';

  @override
  String itsTimeFor(Object prayer) {
    return '$prayer-এর সময় হয়েছে';
  }

  @override
  String inCountdown(Object countdown) {
    return '$countdown-এর মধ্যে';
  }

  @override
  String get madhab_standard => 'স্ট্যান্ডার্ড';

  @override
  String get madhab_hanafi => 'হানাফি';

  @override
  String get method_dubai => 'দুবাই';

  @override
  String get method_egyptian => 'মিশরীয়';

  @override
  String get method_karachi => 'করাচি';

  @override
  String get method_kuwait => 'কুয়েত';

  @override
  String get method_moonsightingCommittee => 'মুনসাইটিং কমিটি';

  @override
  String get method_morocco => 'মরক্কো';

  @override
  String get method_muslimWorldLeague => 'মুসলিম ওয়ার্ল্ড লীগ';

  @override
  String get method_northAmerica => 'উত্তর আমেরিকা';

  @override
  String get method_qatar => 'কাতার';

  @override
  String get method_singapore => 'সিঙ্গাপুর';

  @override
  String get method_tehran => 'তেহরান';

  @override
  String get method_turkiye => 'তুরস্ক';

  @override
  String get method_ummAlQura => 'উম্মুল কুরা';
}
