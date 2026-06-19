import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/services/background_listener_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../prayer/presentation/providers/prayer_provider.dart';
import '../widgets/next_prayer_card.dart';
import '../widgets/prayer_times_list.dart';
import '../widgets/quick_actions.dart';
import 'package:adhan_dart/adhan_dart.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize background listener
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(backgroundListenerProvider).startListening(ref);
    });
  }

  String _getLocalizedPrayerName(Prayer prayer, AppLocalizations l10n) {
    switch (prayer) {
      case Prayer.fajr:
      case Prayer.fajrAfter:
        return l10n.fajr;
      case Prayer.sunrise:
        return l10n.sunrise;
      case Prayer.dhuhr:
        return l10n.dhuhr;
      case Prayer.asr:
        return l10n.asr;
      case Prayer.maghrib:
        return l10n.maghrib;
      case Prayer.isha:
      case Prayer.ishaBefore:
        return l10n.isha;
      }
  }

  @override
  Widget build(BuildContext context) {
    final prayerTimesAsync = ref.watch(prayerTimesProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF0F172A),
                  Color(0xFF1E293B),
                  Color(0xFF0F172A),
                ],
              ),
            ),
          ),

          SafeArea(
            child: prayerTimesAsync.when(
              data: (times) {
                if (times == null) {
                  return const Center(
                    child: Text('Error loading prayer times'),
                  );
                }

                final prayerMap = {
                  l10n.fajr: times.fajr,
                  l10n.sunrise: times.sunrise,
                  l10n.dhuhr: times.dhuhr,
                  l10n.asr: times.asr,
                  l10n.maghrib: times.maghrib,
                  l10n.isha: times.isha,
                };

                final nextPrayer = times.nextPrayer(date: DateTime.now());
                final currentPrayer = times.currentPrayer(date: DateTime.now());

                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 20,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Monday, 8 June 2026',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                l10n.assalamuAlaikum,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.settings_outlined,
                              color: Colors.white70,
                            ),
                            onPressed: () => context.push('/settings'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      NextPrayerCard(
                        prayerName: l10n.nextPrayer,
                        prayerTime: DateTime.now(), // Placeholder
                        nextPrayerName: _getLocalizedPrayerName(nextPrayer, l10n).toUpperCase(),
                        nextPrayerTime: times.timeForPrayer(nextPrayer),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        l10n.prayerTimes,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      PrayerTimesList(
                        prayerTimes: prayerMap,
                        activePrayer: _getLocalizedPrayerName(currentPrayer, l10n),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        l10n.quickActions,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const QuickActions(),
                      const SizedBox(height: 32),
                    ],
                  ),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
