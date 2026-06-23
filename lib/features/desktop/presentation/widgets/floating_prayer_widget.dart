import 'dart:async';
import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:window_manager/window_manager.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import '../../../../shared/widgets/liquid_glass_container.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/desktop_service.dart';
import '../../../../core/providers/floating_bar_provider.dart';
import '../../../prayer/presentation/providers/prayer_provider.dart';
import '../../../../l10n/app_localizations.dart';

class FloatingPrayerWidget extends ConsumerStatefulWidget {
  const FloatingPrayerWidget({super.key});

  @override
  ConsumerState<FloatingPrayerWidget> createState() => _FloatingPrayerWidgetState();
}

class _FloatingPrayerWidgetState extends ConsumerState<FloatingPrayerWidget> {
  Timer? _ticker;
  bool _expandUpwards = false;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Future<void> _toggleExpansion() async {
    final isExpanded = ref.read(floatingBarExpansionProvider);
    final desktopService = ref.read(desktopServiceProvider);
    
    // Read screen height BEFORE any async calls
    final screenHeight = MediaQuery.of(context).size.height;
    
    final currentPos = await windowManager.getPosition();
    const collapsedSize = Size(350, 80);
    const expandedSize = Size(400, 280); // Reduced height to remove extra space
    final diff = expandedSize.height - collapsedSize.height;

    if (isExpanded) {
      // Collapsing
      if (_expandUpwards) {
        final newY = currentPos.dy + diff;
        await desktopService.setWindowPosition(Offset(currentPos.dx, newY));
      }
      if (!mounted) return;
      ref.read(floatingBarExpansionProvider.notifier).state = false;
      await desktopService.setWindowSize(collapsedSize);
    } else {
      // Expanding
      // Expand UP only if we are in the lower 60% of the screen AND have enough space
      final canExpandUp = currentPos.dy > diff + 50; 
      final shouldExpandUp = canExpandUp && currentPos.dy > (screenHeight * 0.6); 
      
      if (!mounted) return;
      setState(() {
        _expandUpwards = shouldExpandUp; 
      });

      if (shouldExpandUp) {
        final newY = currentPos.dy - diff;
        await desktopService.setWindowPosition(Offset(currentPos.dx, newY));
      }

      if (!mounted) return;
      ref.read(floatingBarExpansionProvider.notifier).state = true;
      await desktopService.setWindowSize(expandedSize);
    }
  }

  @override
  Widget build(BuildContext context) {
    final enhancedTimes = ref.watch(enhancedPrayerTimesProvider);
    final isExpanded = ref.watch(floatingBarExpansionProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    
    if (enhancedTimes == null) {
       return Center(
         child: Container(
           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
           decoration: BoxDecoration(
             color: Colors.redAccent.withValues(alpha: 0.8),
             borderRadius: BorderRadius.circular(20),
           ),
           child: const Icon(Icons.gps_off_rounded, color: Colors.white, size: 20),
         ),
       );
    }

    final prayerTimes = enhancedTimes.base;
    final now = DateTime.now();
    var nextPrayer = prayerTimes.nextPrayer(date: now);
    var nextPrayerTime = prayerTimes.timeForPrayer(nextPrayer).toLocal();

    if (nextPrayerTime.isBefore(now)) {
      final tomorrow = now.add(const Duration(days: 1));
      final tomorrowTimes = PrayerTimes(
        coordinates: prayerTimes.coordinates,
        date: tomorrow,
        calculationParameters: prayerTimes.calculationParameters,
        precision: true,
      );
      nextPrayer = Prayer.fajr;
      nextPrayerTime = tomorrowTimes.fajr.toLocal();
    }
    final remaining = nextPrayerTime.difference(now);
    
    final hours = remaining.inHours;
    final minutes = remaining.inMinutes % 60;
    
    final localizedName = _getLocalizedName(nextPrayer.name, l10n);
    final isBn = l10n.localeName == 'bn';
    final countdown = isBn
      ? '${hours > 0 ? "$hours ঘণ্টা " : ""}$minutesমি'
      : '${hours > 0 ? "${hours}h " : ""}${minutes}m';

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onPanStart: (_) => windowManager.startDragging(),
      onTap: _toggleExpansion,
      child: Material(
        color: Colors.transparent,
        child: Align(
          alignment: isExpanded 
              ? (_expandUpwards ? Alignment.bottomCenter : Alignment.topCenter)
              : Alignment.center,
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              verticalDirection: _expandUpwards ? VerticalDirection.up : VerticalDirection.down,
              children: [
                // The main "Pill"
                _buildPrayerPill(localizedName, l10n.inCountdown(countdown), isExpanded, nextPrayer.name),
                
                // The Expanded "Dashboard"
                if (isExpanded)
                  _buildExpandedView(enhancedTimes, isDark, l10n)
                      .animate()
                      .fadeIn(duration: 200.ms)
                      .slideY(
                        begin: _expandUpwards ? 0.05 : -0.05, 
                        end: 0, 
                        curve: Curves.easeOutQuad
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrayerPill(String name, String countdownText, bool isExpanded, String prayerKey) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF3498DB).withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getIconForPrayer(prayerKey), color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Text(
            '$name $countdownText',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          if (isExpanded) ...[
            const SizedBox(width: 12),
            const Icon(Icons.keyboard_arrow_up_rounded, color: Colors.white70, size: 20),
          ],
        ],
      ),
    );
  }

  Widget _buildExpandedView(EnhancedPrayerTimes enhanced, bool isDark, AppLocalizations l10n) {
    return Container(
      width: 400,
      constraints: const BoxConstraints(maxHeight: 230), // Reduced height constraint
      margin: EdgeInsets.only(
        top: _expandUpwards ? 0 : 4, 
        bottom: _expandUpwards ? 4 : 0
      ),
      child: LiquidGlassContainer(
        borderRadius: 20,
        blur: 15,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        surfaceColor: isDark ? null : AppTheme.glassyTeal.withValues(alpha: 0.98),
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(), // Content should fit now
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                 children: [
                   Text(
                     DateFormat('EEEE, d MMMM', l10n.localeName).format(DateTime.now()).toUpperCase(),
                     style: TextStyle(
                       letterSpacing: 1.2,
                       fontSize: 10,
                       fontWeight: FontWeight.w900,
                       color: isDark ? Colors.white38 : AppTheme.textSecondaryLight.withValues(alpha: 0.7),
                     ),
                   ),
                   IconButton(
                     icon: const Icon(Icons.close_rounded, size: 18),
                     padding: EdgeInsets.zero,
                     constraints: const BoxConstraints(),
                     onPressed: _toggleExpansion,
                   ),
                 ],
               ),
               const SizedBox(height: 6),
               _buildMiniPrayerList(enhanced, isDark, l10n),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMiniPrayerList(EnhancedPrayerTimes enhanced, bool isDark, AppLocalizations l10n) {
    final prayerTimes = enhanced.base;
    final now = DateTime.now();
    final nextPrayer = prayerTimes.nextPrayer(date: now);
    
    final List<Map<String, dynamic>> items = [
      {'key': 'fajr', 'name': l10n.fajr, 'time': prayerTimes.fajr},
      {'key': 'dhuhr', 'name': l10n.dhuhr, 'time': prayerTimes.dhuhr},
      {'key': 'asr', 'name': l10n.asr, 'time': prayerTimes.asr},
      {'key': 'maghrib', 'name': l10n.maghrib, 'time': prayerTimes.maghrib},
      {'key': 'isha', 'name': l10n.isha, 'time': prayerTimes.isha},
    ];

    return Column(
      children: items.map((item) {
        final key = item['key'] as String;
        final name = item['name'] as String;
        final time = (item['time'] as DateTime).toLocal();
        final nextName = nextPrayer.name.toLowerCase();
        final isActive = key.toLowerCase() == nextName || 
                        (key == 'fajr' && nextName == 'fajrafter');
        
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: isActive 
                      ? AppTheme.activePrayerGreen 
                      : (isDark ? Colors.white70 : AppTheme.textPrimaryLight),
                  fontWeight: isActive ? FontWeight.w900 : FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                DateFormat('h:mm a').format(time),
                style: TextStyle(
                  color: isActive 
                      ? AppTheme.activePrayerGreen 
                      : (isDark ? Colors.white38 : AppTheme.textSecondaryLight),
                  fontWeight: isActive ? FontWeight.w900 : FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  IconData _getIconForPrayer(String prayer) {
    switch (prayer.toLowerCase()) {
      case 'fajr':
        return Icons.wb_twilight_rounded;
      case 'sunrise': return Icons.wb_sunny_outlined;
      case 'sunset': return Icons.wb_sunny_rounded;
      case 'dhuhr': return Icons.wb_sunny_rounded;
      case 'asr': return Icons.wb_cloudy_rounded;
      case 'maghrib': return Icons.wb_twilight_outlined;
      case 'isha': 
        return Icons.nightlight_round;
      case 'tahajjud': return Icons.mosque_rounded;
      default: return Icons.wb_sunny_rounded;
    }
  }

  String _getLocalizedName(String prayer, AppLocalizations l10n) {
    switch (prayer.toLowerCase()) {
      case 'fajr':
        return l10n.fajr;
      case 'sunrise': return l10n.sunrise;
      case 'sunset': return l10n.sunset;
      case 'dhuhr': return l10n.dhuhr;
      case 'asr': return l10n.asr;
      case 'maghrib': return l10n.maghrib;
      case 'isha': 
        return l10n.isha;
      case 'tahajjud': return l10n.tahajjud;
      default: return prayer;
    }
  }
}
