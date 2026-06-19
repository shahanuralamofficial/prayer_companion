import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:intl/intl.dart';

class NextPrayerCard extends StatelessWidget {
  final String prayerName;
  final DateTime prayerTime;
  final String nextPrayerName;
  final DateTime nextPrayerTime;

  const NextPrayerCard({
    super.key,
    required this.prayerName,
    required this.prayerTime,
    required this.nextPrayerName,
    required this.nextPrayerTime,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: double.infinity,
      height: 200,
      borderRadius: 30,
      blur: 20,
      alignment: Alignment.center,
      border: 2,
      linearGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.1),
          Colors.white.withValues(alpha: 0.05),
        ],
      ),
      borderGradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.white.withValues(alpha: 0.5),
          Colors.white.withValues(alpha: 0.2),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Next Prayer',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      nextPrayerName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Text(
                  DateFormat.jm().format(nextPrayerTime),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
            const Spacer(),
            const CountdownWidget(),
          ],
        ),
      ),
    );
  }
}

class CountdownWidget extends StatelessWidget {
  const CountdownWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // This will be a real countdown timer later
    return Row(
      children: [
        const Icon(Icons.access_time, color: Colors.white70, size: 20),
        const SizedBox(width: 8),
        Text(
          'Ends in 1h 24m 42s',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
