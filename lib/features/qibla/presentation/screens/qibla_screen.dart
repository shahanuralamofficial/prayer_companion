import 'package:flutter/material.dart';
import 'dart:math' as math;

class QiblaScreen extends StatelessWidget {
  const QiblaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Qibla Finder'),
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F172A),
              Color(0xFF1E293B),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Align your phone to find the Qibla',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 50),
            Stack(
              alignment: Alignment.center,
              children: [
                // Compass Circle
                Container(
                  width: 300,
                  height: 300,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24, width: 2),
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
                // Kaaba Icon at the top (North placeholder)
                const Positioned(
                  top: 20,
                  child: Icon(Icons.mosque, color: Colors.orangeAccent, size: 32),
                ),
                // Needle
                Transform.rotate(
                  angle: math.pi / 4, // Placeholder angle
                  child: Container(
                    width: 4,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),
            const Text(
              'Distance to Kaaba: 4,500 km',
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
