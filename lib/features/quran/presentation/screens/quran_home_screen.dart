import 'package:flutter/material.dart';

class QuranHomeScreen extends StatelessWidget {
  const QuranHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Holy Quran'),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
        child: ListView.builder(
          itemCount: 114,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.white12,
                child: Text('${index + 1}', style: const TextStyle(color: Colors.white)),
              ),
              title: Text('Surah ${index + 1}', style: const TextStyle(color: Colors.white)),
              subtitle: const Text('Meccan · 7 Verses', style: TextStyle(color: Colors.white70)),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white24, size: 16),
              onTap: () {
                // Navigate to Surah detail
              },
            );
          },
        ),
      ),
    );
  }
}
