import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../l10n/app_localizations.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settings),
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
            _buildSectionHeader('Prayer Calculation'), // Should be localized too if added to arb
            _buildSettingTile(Icons.calculate, 'Method', 'Muslim World League'),
            _buildSettingTile(Icons.book, 'Asr Madhab', 'Hanafi'),
            _buildSettingTile(
              Icons.timer_outlined,
              'Jamat & Overlay',
              'Manual Times & Alerts',
              onTap: () => context.push('/jamat-settings'),
            ),
            const SizedBox(height: 20),
            _buildSectionHeader('Notifications'),
            _buildSettingTile(Icons.notifications_active, 'Adhan Sound', 'Makkah'),
            _buildSettingTile(Icons.timer, 'Early Reminder', '10 minutes before'),
            const SizedBox(height: 20),
            _buildSectionHeader('Appearance'),
            _buildSettingTile(
              Icons.language,
              'Language',
              currentLocale.languageCode == 'en' ? 'English' : 'বাংলা (Bengali)',
              onTap: () => _showLanguageDialog(context, ref),
            ),
            _buildSettingTile(Icons.color_lens, 'Theme', 'Crystal Glass (Dark)'),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(const Locale('en'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Bengali (বাংলা)'),
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(const Locale('bn'));
                Navigator.pop(context);
              },
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

  Widget _buildSettingTile(IconData icon, String title, String value, {VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.white70),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        trailing: Text(value, style: const TextStyle(color: Colors.white54)),
        onTap: onTap,
      ),
    );
  }
}
