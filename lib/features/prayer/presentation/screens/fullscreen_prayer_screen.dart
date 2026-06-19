import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
                const Icon(Icons.mosque, size: 60, color: Colors.orangeAccent),
                const SizedBox(height: 40),
                Text(
                  'It\'s time for ${widget.prayerName}',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                if (widget.subtext != null) ...[
                  const SizedBox(height: 12),
                  Text(
                    widget.subtext!,
                    style: const TextStyle(color: Colors.greenAccent, fontSize: 24, fontWeight: FontWeight.w500),
                  ),
                ],
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 100),
                  child: Column(
                    children: [
                      Text(
                        '"${widget.quranVerse}"',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '— ${widget.quranReference}',
                        style: const TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                const Text(
                  '7:03', // Dynamic time placeholder
                  style: TextStyle(
                    fontSize: 32,
                    color: Colors.white,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 60),
                ElevatedButton(
                  onPressed: () {
                    ref.read(adhanAudioServiceProvider).stopAdhan();
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white10,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: const BorderSide(color: Colors.white24),
                    ),
                  ),
                  child: const Text('Dismiss', style: TextStyle(fontSize: 18)),
                ),
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
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    const spacing = 60.0;
    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawRect(Rect.fromLTWH(x, y, spacing, spacing), paint);
        // Add some "geometric" lines
        canvas.drawLine(Offset(x, y), Offset(x + spacing, y + spacing), paint);
        canvas.drawLine(Offset(x + spacing, y), Offset(x, y + spacing), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
