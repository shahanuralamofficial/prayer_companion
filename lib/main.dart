import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/db/hive_database.dart';
import 'core/providers/locale_provider.dart';
import 'core/providers/tray_provider.dart';
import 'core/services/desktop_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'dart:io';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Local Database
  await HiveDatabase.init();

  // Desktop window & Tray initialization
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();
    await DesktopService().initSystemTray();
    
    WindowOptions windowOptions = const WindowOptions(
      size: Size(1280, 800),
      center: true,
      backgroundColor: Colors.transparent,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  runApp(
    const ProviderScope(
      child: PrayerCompanionApp(),
    ),
  );
}

class PrayerCompanionApp extends ConsumerWidget {
  const PrayerCompanionApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    
    // Initialize Tray Update (Desktop only)
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      ref.read(trayUpdateProvider);
    }

    return MaterialApp.router(
      title: 'Prayer Companion',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      routerConfig: appRouter,
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
