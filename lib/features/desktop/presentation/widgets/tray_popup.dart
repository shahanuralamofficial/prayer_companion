import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:window_manager/window_manager.dart';
import '../../../../shared/widgets/liquid_glass_container.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../prayer/presentation/providers/prayer_provider.dart';
import '../../../../l10n/app_localizations.dart';

class TrayPopup extends ConsumerStatefulWidget {
  const TrayPopup({super.key});

  @override
  ConsumerState<TrayPopup> createState() => _TrayPopupState();
}

class _TrayPopupState extends ConsumerState<TrayPopup> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => setState(() {}));
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final enhancedTimesAsync = ref.watch(prayerTimesProvider);
    final enhancedTimes = ref.watch(enhancedPrayerTimesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    if (enhancedTimesAsync.hasError) {
      return _buildErrorState(isDark, l10n, "Connection Error");
    }

    if (enhancedTimes == null) {
      return const SizedBox(
        width: 400,
        height: 760,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    final prayerTimes = enhancedTimes.base;
    final now = DateTime.now();
    final nextPrayer = prayerTimes.nextPrayer(date: now);
    final nextPrayerTime = prayerTimes.timeForPrayer(nextPrayer).toLocal();
    final remaining = nextPrayerTime.difference(now);

    final dividerColor = isDark ? Colors.white.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.1);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: LiquidGlassContainer(
          width: 400,
          height: 760,
          borderRadius: 28,
          blur: AppTheme.glassBlur,
          surfaceColor: isDark ? null : AppTheme.glassyTeal.withValues(alpha: 0.95),
          padding: const EdgeInsets.all(28.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Uppercase Date
              Text(
                DateFormat('EEEE, d MMMM, y').format(now).toUpperCase(),
                style: TextStyle(
                  letterSpacing: 1.5,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white38 : AppTheme.textSecondaryLight.withValues(alpha: 0.7),
                ),
              ),
              const SizedBox(height: 20),
              
              // Hero: Active Next Prayer
              _buildActiveHero(context, _getLocalizedName(nextPrayer.name, l10n), remaining, nextPrayerTime, isDark, l10n),
              
              const SizedBox(height: 28),
              Divider(height: 1, color: dividerColor),
              const SizedBox(height: 16),
              
              // Prayer List (Including Tahajjud)
              _buildPrayerList(context, enhancedTimes, isDark, l10n),
              
              const Spacer(),
              
              // Footer: Local Info
              _buildFooter(isDark, l10n),
              
              const SizedBox(height: 20),
              Divider(height: 1, color: dividerColor),
              const SizedBox(height: 16),
              
              // Actions
              _buildActionItem(context, Icons.settings_outlined, '${l10n.settings}...', isDark, onTap: () => context.push('/settings')),
              _buildActionItem(context, Icons.refresh_rounded, '${l10n.checkForUpdates}...', isDark, onTap: () {}),
              _buildActionItem(context, Icons.power_settings_new_rounded, l10n.close, isDark, onTap: () => windowManager.hide()),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).scale(begin: const Offset(0.98, 0.98));
  }

  Widget _buildErrorState(bool isDark, AppLocalizations l10n, String message) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: LiquidGlassContainer(
          width: 400,
          height: 760,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline_rounded, size: 64, color: Colors.redAccent),
              const SizedBox(height: 16),
              Text(message, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 32),
              ElevatedButton(onPressed: () => ref.invalidate(prayerTimesProvider), child: const Text("Retry")),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveHero(BuildContext context, String name, Duration remaining, DateTime time, bool isDark, AppLocalizations l10n) {
    final countdown = _formatCountdown(remaining);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(_getIconForPrayer(name), color: AppTheme.activePrayerGreen, size: 36),
                const SizedBox(width: 12),
                Text(
                  name.toUpperCase(),
                  style: TextStyle(
                    fontSize: 32,
                    letterSpacing: -0.5,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : AppTheme.textPrimaryLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              l10n.inCountdown(countdown),
              style: const TextStyle(
                color: AppTheme.activePrayerGreen,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
        Text(
          DateFormat('h:mm a').format(time),
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: AppTheme.activePrayerGreen,
          ),
        ),
      ],
    );
  }

  Widget _buildPrayerList(BuildContext context, EnhancedPrayerTimes enhanced, bool isDark, AppLocalizations l10n) {
    final prayerTimes = enhanced.base;
    final now = DateTime.now();
    final nextPrayer = prayerTimes.nextPrayer(date: now);
    
    final List<Map<String, dynamic>> items = [
      {'key': 'Fajr', 'time': prayerTimes.fajr},
      {'key': 'Sunrise', 'time': prayerTimes.sunrise},
      {'key': 'Dhuhr', 'time': prayerTimes.dhuhr},
      {'key': 'Asr', 'time': prayerTimes.asr},
      {'key': 'Maghrib', 'time': prayerTimes.maghrib},
      {'key': 'Isha', 'time': prayerTimes.isha},
      {'key': 'Tahajjud', 'time': enhanced.tahajjud},
    ];

    return Column(
      children: items.map((item) {
        final key = item['key'] as String;
        final time = (item['time'] as DateTime).toLocal();
        final isActive = key.toLowerCase() == nextPrayer.name.toLowerCase();
        
        String? durationTag;
        if (isActive) {
          final diff = time.difference(now);
          durationTag = _formatShortCountdown(diff);
        }

        return _buildPrayerRow(
          context, 
          key, 
          _getLocalizedName(key, l10n),
          DateFormat('h:mm a').format(time), 
          isDark, 
          isActive: isActive,
          duration: durationTag,
        );
      }).toList(),
    );
  }

  Widget _buildPrayerRow(BuildContext context, String key, String name, String time, bool isDark, {bool isActive = false, String? duration}) {
    final textColor = isActive ? AppTheme.activePrayerGreen : (isDark ? Colors.white70 : AppTheme.textPrimaryLight.withValues(alpha: 0.85));
    
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? AppTheme.activePrayerGreenLight : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                _getIconForPrayer(key),
                color: isActive ? AppTheme.activePrayerGreen : (isDark ? Colors.white24 : Colors.black12),
                size: 22,
              ),
              const SizedBox(width: 16),
              Text(
                name,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: isActive ? FontWeight.w900 : FontWeight.w700,
                ),
              ),
            ],
          ),
          Row(
            children: [
              if (duration != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: AppTheme.activePrayerGreen.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    duration,
                    style: TextStyle(
                      fontSize: 11, 
                      color: isDark ? Colors.white : const Color(0xFF1B5E20), 
                      fontWeight: FontWeight.w900
                    ),
                  ),
                ),
              Text(
                time,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: isActive ? FontWeight.w900 : FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatCountdown(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes % 60;
    final seconds = d.inSeconds % 60;
    return '${hours > 0 ? '$hours:' : ''}${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String _formatShortCountdown(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes % 60;
    return '${hours > 0 ? '${hours}h ' : ''}${minutes}m';
  }

  String _getLocalizedName(String prayer, AppLocalizations l10n) {
    switch (prayer.toLowerCase()) {
      case 'fajr': return l10n.fajr;
      case 'sunrise': return l10n.sunrise;
      case 'dhuhr': return l10n.dhuhr;
      case 'asr': return l10n.asr;
      case 'maghrib': return l10n.maghrib;
      case 'isha': return l10n.isha;
      case 'tahajjud': return l10n.tahajjud;
      default: return prayer;
    }
  }

  IconData _getIconForPrayer(String prayer) {
    switch (prayer.toLowerCase()) {
      case 'fajr': return Icons.wb_twilight_rounded;
      case 'sunrise': return Icons.wb_sunny_outlined;
      case 'dhuhr': return Icons.wb_sunny_rounded;
      case 'asr': return Icons.wb_cloudy_rounded;
      case 'maghrib': return Icons.wb_twilight_outlined;
      case 'isha': return Icons.nightlight_round;
      case 'tahajjud': return Icons.mosque_rounded;
      default: return Icons.wb_sunny_rounded;
    }
  }

  Widget _buildFooter(bool isDark, AppLocalizations l10n) {
    final timezoneId = ref.watch(timezoneIdProvider).value ?? "...";
    final locationInfo = ref.watch(locationInfoProvider).value ?? "...";
    final coords = ref.watch(coordinatesProvider).value ?? "...";
    final currentMethod = ref.watch(calculationMethodProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
             Icon(Icons.location_on_outlined, size: 14, color: isDark ? Colors.white38 : AppTheme.textSecondaryLight),
             const SizedBox(width: 4),
             Expanded(
               child: Text(
                '$locationInfo (${currentMethod.name.toUpperCase()})',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isDark ? Colors.white38 : AppTheme.textSecondaryLight,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
             ),
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 18),
          child: Text(
            '$coords · $timezoneId',
            style: TextStyle(
              color: isDark ? Colors.white24 : AppTheme.textSecondaryLight.withValues(alpha: 0.6),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionItem(BuildContext context, IconData icon, String title, bool isDark, {required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14),
        child: Row(
          children: [
            Icon(icon, size: 20, color: isDark ? Colors.white54 : AppTheme.textSecondaryLight),
            const SizedBox(width: 16),
            Text(
              title,
              style: TextStyle(
                color: isDark ? Colors.white70 : AppTheme.textPrimaryLight.withValues(alpha: 0.9),
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
