import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PrayerTimesList extends StatelessWidget {
  final Map<String, DateTime> prayerTimes;
  final String activePrayer;

  const PrayerTimesList({
    super.key,
    required this.prayerTimes,
    required this.activePrayer,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: prayerTimes.entries.map((entry) {
        final isActive = entry.key.toLowerCase() == activePrayer.toLowerCase();
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: isActive ? Colors.white.withValues(alpha: 0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
            border: isActive
                ? Border.all(color: Colors.white.withValues(alpha: 0.2))
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                entry.key,
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.white70,
                  fontSize: 18,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              Text(
                DateFormat.jm().format(entry.value),
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.white70,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
