import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/prayer/presentation/screens/jamat_settings_screen.dart';
import '../../features/desktop/presentation/widgets/tray_popup.dart';

import '../../features/prayer/presentation/screens/fullscreen_prayer_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/tray-popup',
    routes: [
      GoRoute(
        path: '/tray-popup',
        builder: (context, state) => const TrayPopup(),
      ),
      GoRoute(
        path: '/fullscreen-prayer',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return FullscreenPrayerScreen(
            prayerName: extra?['prayerName'] ?? 'Prayer',
            quranVerse: extra?['quranVerse'] ?? 'Remember Allah often.',
            quranReference: extra?['quranReference'] ?? 'General',
            subtext: extra?['subtext'],
          );
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/jamat-settings',
        builder: (context, state) => const JamatSettingsScreen(),
      ),
    ],
  );
});
