import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:window_manager/window_manager.dart';
import '../../../../core/services/desktop_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/liquid_glass_container.dart';
import '../../../adhan/data/services/adhan_audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';

class FullscreenPrayerScreen extends ConsumerStatefulWidget {
  final String prayerName;
  final String quranVerse;
  final String quranReference;
  final String? subtext;

  const FullscreenPrayerScreen({
    super.key,
    required this.prayerName,
    required this.quranVerse,
    required this.quranReference,
    this.subtext,
  });

  @override
  ConsumerState<FullscreenPrayerScreen> createState() => _FullscreenPrayerScreenState();
}

class _FullscreenPrayerScreenState extends ConsumerState<FullscreenPrayerScreen> {
  Timer? _clockTimer;

  @override
  void initState() {
    super.initState();
    _startAdhan();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _clockTimer?.cancel();
    super.dispose();
  }

  void _startAdhan() async {
    try {
      await ref.read(adhanAudioServiceProvider).playAdhan('adhan/makkah.mp3');
    } catch (e) {
      debugPrint("Adhan playback failed: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final currentTime = DateFormat('h:mm').format(DateTime.now());
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Localize prayer name for itsTimeFor
    final String displayPrayerName = _getLocalizedPrayerName(widget.prayerName, l10n);

    return Scaffold(
      body: Stack(
        children: [
          // Background with pattern
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF1E4D8C),
                  Color(0xFF0F2D5E),
                ],
              ),
            ),
            child: CustomPaint(
              painter: GeometricPatternPainter(),
              child: Container(),
            ),
          ),
          
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.mosque_rounded, size: 60, color: AppTheme.luxuryGold),
                    const SizedBox(height: 24),
                    Text(
                      l10n.itsTimeFor(displayPrayerName).toUpperCase(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                            fontSize: 42,
                            letterSpacing: -1.0,
                            color: Colors.white,
                            shadows: [
                              Shadow(color: AppTheme.luxuryGold.withValues(alpha: 0.5), blurRadius: 30),
                            ],
                          ),
                    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2),
                    if (widget.subtext != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        widget.subtext!,
                        style: const TextStyle(color: AppTheme.luxuryGold, fontSize: 24, fontWeight: FontWeight.w600),
                      ).animate().fadeIn(delay: 400.ms),
                    ],
                    const SizedBox(height: 40),
                    LiquidGlassContainer(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                      borderRadius: 32,
                      child: Column(
                        children: [
                          Text(
                            '"${widget.quranVerse}"',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                              color: isDark ? Colors.white : AppTheme.textPrimaryLight,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            '— ${widget.quranReference}',
                            style: TextStyle(color: AppTheme.luxuryGoldDark, fontSize: 13, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: 600.ms, duration: 1000.ms).scale(begin: const Offset(0.9, 0.9)),
                    const SizedBox(height: 40),
                    Text(
                      currentTime, 
                      style: const TextStyle(
                        fontSize: 36,
                        color: Colors.white38,
                        letterSpacing: 8,
                        fontWeight: FontWeight.w200,
                      ),
                    ).animate().fadeIn(delay: 1000.ms),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () async {
                        await windowManager.setFullScreen(false);
                        await windowManager.setAlwaysOnTop(false);
                        ref.read(adhanAudioServiceProvider).stopAdhan();
                        
                        // Restore floating mode if it was active
                        final desktopService = ref.read(desktopServiceProvider);
                        if (desktopService.currentMode == DesktopWindowMode.floating) {
                          await desktopService.switchToFloatingMode(center: false);
                        } else {
                           // If not floating, resize back to popup size
                           await windowManager.setSize(const Size(440, 800));
                           await windowManager.center();
                        }
                        
                        if (mounted) context.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.1),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                          side: const BorderSide(color: Colors.white24, width: 1),
                        ),
                        elevation: 0,
                      ),
                      child: Text(l10n.close.toUpperCase(), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, letterSpacing: 2.0)),
                    ).animate().fadeIn(delay: 1200.ms).slideY(begin: 0.2),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getLocalizedPrayerName(String prayer, AppLocalizations l10n) {
    switch (prayer.toLowerCase()) {
      case 'fajr': return l10n.fajr;
      case 'dhuhr': return l10n.dhuhr;
      case 'asr': return l10n.asr;
      case 'maghrib': return l10n.maghrib;
      case 'isha': return l10n.isha;
      case 'tahajjud': return l10n.tahajjud;
      case 'sunrise': return l10n.sunrise;
      case 'sunset': return l10n.sunset;
      default: return prayer;
    }
  }
}

class GeometricPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.luxuryGold.withValues(alpha: 0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    const spacing = 100.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawRect(Rect.fromLTWH(x, y, spacing, spacing), paint);
        canvas.drawCircle(Offset(x + spacing/2, y + spacing/2), spacing/3, paint);
        canvas.drawLine(Offset(x, y), Offset(x + spacing, y + spacing), paint);
        canvas.drawLine(Offset(x + spacing, y), Offset(x, y + spacing), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
