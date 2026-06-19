import 'package:flutter/material.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Islamic Calendar'),
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
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
        child: Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Column(
            children: [
              const Card(
                margin: EdgeInsets.all(20),
                color: Colors.white12,
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text('18 Dhul-Hijjah 1447', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Text('Thursday, 20 June 2026', style: TextStyle(color: Colors.white70, fontSize: 16)),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _buildEventItem('Eid al-Adha', '10 Dhul-Hijjah', isPassed: true),
                    _buildEventItem('Islamic New Year', '1 Muharram', date: '7 July 2026'),
                    _buildEventItem('Ashura', '10 Muharram', date: '16 July 2026'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventItem(String title, String hijri, {String? date, bool isPassed = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isPassed ? Colors.white.withValues(alpha: 0.05) : Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: isPassed ? Colors.white38 : Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              Text(hijri, style: TextStyle(color: isPassed ? Colors.white24 : Colors.white70)),
            ],
          ),
          if (date != null) Text(date, style: TextStyle(color: isPassed ? Colors.white24 : Colors.white54)),
        ],
      ),
    );
  }
}
