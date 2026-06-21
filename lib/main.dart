import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';
import 'package:launch_at_startup/launch_at_startup.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/db/hive_database.dart';
import 'core/providers/locale_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/providers/tray_provider.dart';
import 'core/services/desktop_service.dart';
import 'core/services/background_listener_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Local Database
  await HiveDatabase.init();

  // Desktop window & Auto-start initialization
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();
    
    // Auto-start configuration (Respect User Setting)
    final box = HiveDatabase.getSettingsBox();
    final bool shouldLaunchAtLogin = box.get('launchAtLogin', defaultValue: true);

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    launchAtStartup.setup(
      appName: packageInfo.appName,
      appPath: Platform.resolvedExecutable,
    );
    
    if (shouldLaunchAtLogin) {
      await launchAtStartup.enable();
    } else {
      await launchAtStartup.disable();
    }

    WindowOptions windowOptions = const WindowOptions(
      size: Size(440, 780), // Slightly larger to allow for shadows
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: true,
      titleBarStyle: TitleBarStyle.hidden,
      alwaysOnTop: false,
    );
    
    await windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.hide(); // Start hidden in tray
    });
  }

  runApp(
    const ProviderScope(
      child: PrayerCompanionApp(),
    ),
  );
}

class PrayerCompanionApp extends ConsumerStatefulWidget {
  const PrayerCompanionApp({super.key});

  @override
  ConsumerState<PrayerCompanionApp> createState() => _PrayerCompanionAppState();
}

class _PrayerCompanionAppState extends ConsumerState<PrayerCompanionApp> {
  @override
  void initState() {
    super.initState();
    // Initialize Desktop Services
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(desktopServiceProvider).initSystemTray();
        ref.read(trayUpdateProvider);
        // backgroundListenerProvider automatically starts listening when accessed
        ref.read(backgroundListenerProvider);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeProvider);
    final router = ref.watch(appRouterProvider);
    
    debugPrint("App rebuilding with locale: ${locale.languageCode}");

    return MaterialApp.router(
      key: ValueKey(locale.languageCode),
      title: 'Prayer Companion',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      locale: locale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('bn'),
      ],
    );
  }
}
