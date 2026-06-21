import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bn.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bn'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Prayer Companion'**
  String get appTitle;

  /// No description provided for @assalamuAlaikum.
  ///
  /// In en, this message translates to:
  /// **'Assalamu Alaikum'**
  String get assalamuAlaikum;

  /// No description provided for @nextPrayer.
  ///
  /// In en, this message translates to:
  /// **'Next Prayer'**
  String get nextPrayer;

  /// No description provided for @prayerTimes.
  ///
  /// In en, this message translates to:
  /// **'Prayer Times'**
  String get prayerTimes;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @qibla.
  ///
  /// In en, this message translates to:
  /// **'Qibla'**
  String get qibla;

  /// No description provided for @quran.
  ///
  /// In en, this message translates to:
  /// **'Quran'**
  String get quran;

  /// No description provided for @tasbih.
  ///
  /// In en, this message translates to:
  /// **'Tasbih'**
  String get tasbih;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @fajr.
  ///
  /// In en, this message translates to:
  /// **'Fajr'**
  String get fajr;

  /// No description provided for @sunrise.
  ///
  /// In en, this message translates to:
  /// **'Sunrise'**
  String get sunrise;

  /// No description provided for @dhuhr.
  ///
  /// In en, this message translates to:
  /// **'Dhuhr'**
  String get dhuhr;

  /// No description provided for @asr.
  ///
  /// In en, this message translates to:
  /// **'Asr'**
  String get asr;

  /// No description provided for @maghrib.
  ///
  /// In en, this message translates to:
  /// **'Maghrib'**
  String get maghrib;

  /// No description provided for @isha.
  ///
  /// In en, this message translates to:
  /// **'Isha'**
  String get isha;

  /// No description provided for @tahajjud.
  ///
  /// In en, this message translates to:
  /// **'Tahajjud'**
  String get tahajjud;

  /// No description provided for @prayerCalculation.
  ///
  /// In en, this message translates to:
  /// **'Prayer Calculation'**
  String get prayerCalculation;

  /// No description provided for @method.
  ///
  /// In en, this message translates to:
  /// **'Method'**
  String get method;

  /// No description provided for @asrMadhab.
  ///
  /// In en, this message translates to:
  /// **'Asr Madhab'**
  String get asrMadhab;

  /// No description provided for @jamatAndOverlay.
  ///
  /// In en, this message translates to:
  /// **'Jamat & Overlay'**
  String get jamatAndOverlay;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @adhanSound.
  ///
  /// In en, this message translates to:
  /// **'Adhan Sound'**
  String get adhanSound;

  /// No description provided for @earlyReminder.
  ///
  /// In en, this message translates to:
  /// **'Early Reminder'**
  String get earlyReminder;

  /// No description provided for @iqamahAlerts.
  ///
  /// In en, this message translates to:
  /// **'Iqamah Alerts'**
  String get iqamahAlerts;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @bengali.
  ///
  /// In en, this message translates to:
  /// **'বাংলা'**
  String get bengali;

  /// No description provided for @launchAtLogin.
  ///
  /// In en, this message translates to:
  /// **'Launch at Login'**
  String get launchAtLogin;

  /// No description provided for @jamatSettings.
  ///
  /// In en, this message translates to:
  /// **'Jamat Settings'**
  String get jamatSettings;

  /// No description provided for @fullscreenOverlay.
  ///
  /// In en, this message translates to:
  /// **'Fullscreen Overlay'**
  String get fullscreenOverlay;

  /// No description provided for @immersiveScreen.
  ///
  /// In en, this message translates to:
  /// **'Immersive screen at prayer time'**
  String get immersiveScreen;

  /// No description provided for @listeningMode.
  ///
  /// In en, this message translates to:
  /// **'Listening Mode'**
  String get listeningMode;

  /// No description provided for @detectAdhan.
  ///
  /// In en, this message translates to:
  /// **'Detect external Adhan automatically'**
  String get detectAdhan;

  /// No description provided for @warningSettings.
  ///
  /// In en, this message translates to:
  /// **'Warning Settings'**
  String get warningSettings;

  /// No description provided for @manualJamatTimes.
  ///
  /// In en, this message translates to:
  /// **'Manual Jamat Times'**
  String get manualJamatTimes;

  /// No description provided for @overlayControls.
  ///
  /// In en, this message translates to:
  /// **'Overlay Controls'**
  String get overlayControls;

  /// No description provided for @warningBeforeJamat.
  ///
  /// In en, this message translates to:
  /// **'Warning Before Jamat'**
  String get warningBeforeJamat;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'Minutes'**
  String get minutes;

  /// No description provided for @manualTimesAndAlerts.
  ///
  /// In en, this message translates to:
  /// **'Manual Times & Alerts'**
  String get manualTimesAndAlerts;

  /// No description provided for @checkForUpdates.
  ///
  /// In en, this message translates to:
  /// **'Check for Updates'**
  String get checkForUpdates;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @localDetectionActive.
  ///
  /// In en, this message translates to:
  /// **'Local Detection Active'**
  String get localDetectionActive;

  /// No description provided for @madhab_standard.
  ///
  /// In en, this message translates to:
  /// **'Standard'**
  String get madhab_standard;

  /// No description provided for @madhab_hanafi.
  ///
  /// In en, this message translates to:
  /// **'Hanafi'**
  String get madhab_hanafi;

  /// No description provided for @method_dubai.
  ///
  /// In en, this message translates to:
  /// **'Dubai'**
  String get method_dubai;

  /// No description provided for @method_egyptian.
  ///
  /// In en, this message translates to:
  /// **'Egyptian'**
  String get method_egyptian;

  /// No description provided for @method_karachi.
  ///
  /// In en, this message translates to:
  /// **'Karachi'**
  String get method_karachi;

  /// No description provided for @method_kuwait.
  ///
  /// In en, this message translates to:
  /// **'Kuwait'**
  String get method_kuwait;

  /// No description provided for @method_moonsightingCommittee.
  ///
  /// In en, this message translates to:
  /// **'Moonsighting Committee'**
  String get method_moonsightingCommittee;

  /// No description provided for @method_morocco.
  ///
  /// In en, this message translates to:
  /// **'Morocco'**
  String get method_morocco;

  /// No description provided for @method_muslimWorldLeague.
  ///
  /// In en, this message translates to:
  /// **'Muslim World League'**
  String get method_muslimWorldLeague;

  /// No description provided for @method_northAmerica.
  ///
  /// In en, this message translates to:
  /// **'North America'**
  String get method_northAmerica;

  /// No description provided for @method_qatar.
  ///
  /// In en, this message translates to:
  /// **'Qatar'**
  String get method_qatar;

  /// No description provided for @method_singapore.
  ///
  /// In en, this message translates to:
  /// **'Singapore'**
  String get method_singapore;

  /// No description provided for @method_tehran.
  ///
  /// In en, this message translates to:
  /// **'Tehran'**
  String get method_tehran;

  /// No description provided for @method_turkiye.
  ///
  /// In en, this message translates to:
  /// **'Turkiye'**
  String get method_turkiye;

  /// No description provided for @method_ummAlQura.
  ///
  /// In en, this message translates to:
  /// **'Umm Al-Qura'**
  String get method_ummAlQura;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['bn', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bn':
      return AppLocalizationsBn();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
