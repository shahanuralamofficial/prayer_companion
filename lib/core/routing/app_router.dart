import 'package:go_router/go_router.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/quran/presentation/screens/quran_home_screen.dart';
import '../../features/qibla/presentation/screens/qibla_screen.dart';
import '../../features/tasbih/presentation/screens/tasbih_screen.dart';
import '../../features/calendar/presentation/screens/calendar_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../../features/prayer/presentation/screens/jamat_settings_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/quran',
      builder: (context, state) => const QuranHomeScreen(),
    ),
    GoRoute(
      path: '/qibla',
      builder: (context, state) => const QiblaScreen(),
    ),
    GoRoute(
      path: '/tasbih',
      builder: (context, state) => const TasbihScreen(),
    ),
    GoRoute(
      path: '/calendar',
      builder: (context, state) => const CalendarScreen(),
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
