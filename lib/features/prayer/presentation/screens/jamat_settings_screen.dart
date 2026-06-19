import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/jamat_provider.dart';

class JamatSettingsScreen extends ConsumerWidget {
  const JamatSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jamatSettings = ref.watch(jamatProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Jamat & Overlay Settings'),
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
        child: ListView(
          padding: const EdgeInsets.only(top: 100, left: 20, right: 20),
          children: [
            _buildSectionHeader('Manual Jamat Times'),
            ...jamatSettings.jamatTimes.entries.map((entry) {
              return _buildJamatTile(context, ref, entry.key, entry.value);
            }),
            const SizedBox(height: 30),
            _buildSectionHeader('Overlay Controls'),
            SwitchListTile(
              title: const Text('Fullscreen Overlay', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Show immersive screen at prayer time', style: TextStyle(color: Colors.white70)),
              value: jamatSettings.isOverlayEnabled,
              onChanged: (val) => ref.read(jamatProvider.notifier).toggleOverlay(val),
              activeThumbColor: Colors.blueAccent,
            ),
            SwitchListTile(
              title: const Text('Listening Mode (Siri-like)', style: TextStyle(color: Colors.white)),
              subtitle: const Text('Detect external Adhan automatically', style: TextStyle(color: Colors.white70)),
              value: jamatSettings.isListeningModeEnabled,
              onChanged: (val) => ref.read(jamatProvider.notifier).toggleListeningMode(val),
              activeThumbColor: Colors.blueAccent,
            ),
            const SizedBox(height: 20),
            _buildSectionHeader('Warning Settings'),
            ListTile(
              title: const Text('Warning Before Jamat', style: TextStyle(color: Colors.white)),
              trailing: DropdownButton<int>(
                dropdownColor: const Color(0xFF1E293B),
                value: jamatSettings.warningMinutes,
                items: [2, 5, 10, 15].map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text('$value Minutes', style: const TextStyle(color: Colors.white)),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    ref.read(jamatProvider.notifier).updateWarningMinutes(val);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  Widget _buildJamatTile(BuildContext context, WidgetRef ref, String prayer, String time) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        title: Text(prayer, style: const TextStyle(color: Colors.white)),
        trailing: Text(time, style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold)),
        onTap: () async {
          final TimeOfDay? picked = await showTimePicker(
            context: context,
            initialTime: TimeOfDay(
              hour: int.parse(time.split(':')[0]),
              minute: int.parse(time.split(':')[1]),
            ),
          );
          if (picked != null) {
            final formattedTime = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
            ref.read(jamatProvider.notifier).updateJamatTime(prayer, formattedTime);
          }
        },
      ),
    );
  }
}
