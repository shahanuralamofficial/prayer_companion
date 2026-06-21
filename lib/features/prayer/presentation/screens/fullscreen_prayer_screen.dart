import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/liquid_glass_container.dart';
import '../../../adhan/data/services/adhan_audio_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  @override
  void initState() {
    super.initState();
    // Start Adhan audio when overlay appears
    _startAdhan();
  }

  void _startAdhan() {
    ref.read(adhanAudioServiceProvider).playAdhan('adhan/makkah.mp3');
  }

  @override
  Widget build(BuildContext context) {
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
          
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.mosque_rounded, size: 80, color: AppTheme.luxuryGold),
                const SizedBox(height: 48),
                Text(
                  'It\'s time for ${widget.prayerName}'.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 52,
                        letterSpacing: -1.0,
                        color: Colors.white,
                        shadows: [
                          Shadow(color: AppTheme.luxuryGold.withValues(alpha: 0.5), blurRadius: 30),
                        ],
                      ),
                ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2),
                if (widget.subtext != null) ...[
                  const SizedBox(height: 16),
                  Text(
                    widget.subtext!,
                    style: const TextStyle(color: AppTheme.luxuryGold, fontSize: 28, fontWeight: FontWeight.w600),
                  ).animate().fadeIn(delay: 400.ms),
                ],
                const SizedBox(height: 60),
                LiquidGlassContainer(
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 40),
                  borderRadius: 32,
                  child: Column(
                    children: [
                      Text(
                        '"${widget.quranVerse}"',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontSize: 22,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '— ${widget.quranReference}',
                        style: const TextStyle(color: AppTheme.luxuryGold, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 600.ms, duration: 1000.ms).scale(begin: const Offset(0.9, 0.9)),
                const SizedBox(height: 60),
                const Text(
                  '7:03', // Placeholder
                  style: TextStyle(
                    fontSize: 48,
                    color: Colors.white38,
                    letterSpacing: 8,
                    fontWeight: FontWeight.w200,
                  ),
                ).animate().fadeIn(delay: 1000.ms),
                const SizedBox(height: 80),
                ElevatedButton(
                  onPressed: () {
                    ref.read(adhanAudioServiceProvider).stopAdhan();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                      side: const BorderSide(color: Colors.white24, width: 1),
                    ),
                    elevation: 0,
                  ),
                  child: const Text('DISMISS', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, letterSpacing: 2.0)),
                ).animate().fadeIn(delay: 1200.ms).slideY(begin: 0.2),
              ],
            ),
          ),
        ],
      ),
    );
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
