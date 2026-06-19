import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class TrayPopup extends StatelessWidget {
  const TrayPopup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GlassmorphicContainer(
        width: 350,
        height: 500,
        borderRadius: 20,
        blur: 30,
        alignment: Alignment.center,
        border: 1,
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
            Colors.white.withValues(alpha: 0.3),
            Colors.white.withValues(alpha: 0.1),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'MONDAY, 8 JUNE, 2026',
                style: TextStyle(color: Colors.white60, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.wb_sunny, color: Colors.greenAccent, size: 24),
                          SizedBox(width: 8),
                          Text('Dhuhr', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Text('in 1:24:42', style: TextStyle(color: Colors.white70, fontSize: 14)),
                    ],
                  ),
                  Text('1:08 PM', style: TextStyle(fontSize: 22, color: Colors.greenAccent, fontWeight: FontWeight.bold)),
                ],
              ),
              const Divider(height: 32, color: Colors.white24),
              _buildPrayerRow('Fajr', '3:27 AM'),
              _buildPrayerRow('Sunrise', '5:25 AM'),
              _buildPrayerRow('Dhuhr', '1:08 PM', isActive: true, duration: '1h 24m'),
              _buildPrayerRow('Asr', '5:08 PM'),
              _buildPrayerRow('Maghrib', '8:41 PM'),
              _buildPrayerRow('Isha', '10:31 PM'),
              const Spacer(),
              const Text('Diyanet İşleri (Türkiye)', style: TextStyle(color: Colors.white60, fontSize: 11)),
              const Text('41.0198, 28.9499 · Europe/Istanbul', style: TextStyle(color: Colors.white60, fontSize: 11)),
              const Divider(height: 24, color: Colors.white24),
              _buildMenuItem(Icons.settings, 'Settings...'),
              _buildMenuItem(Icons.refresh, 'Check for Updates...'),
              _buildMenuItem(Icons.power_settings_new, 'Quit'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrayerRow(String name, String time, {bool isActive = false, String? duration}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isActive ? Colors.green.withValues(alpha: 0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.wb_sunny_outlined, color: isActive ? Colors.greenAccent : Colors.white60, size: 18),
              const SizedBox(width: 12),
              Text(name, style: TextStyle(color: isActive ? Colors.greenAccent : Colors.white70)),
            ],
          ),
          Row(
            children: [
              if (duration != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  margin: const EdgeInsets.only(right: 8),
                  decoration: BoxDecoration(color: Colors.green.withValues(alpha: 0.3), borderRadius: BorderRadius.circular(4)),
                  child: Text(duration, style: const TextStyle(fontSize: 10, color: Colors.greenAccent)),
                ),
              Text(time, style: TextStyle(color: isActive ? Colors.greenAccent : Colors.white70, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.white70),
          const SizedBox(width: 12),
          Text(title, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }
}
