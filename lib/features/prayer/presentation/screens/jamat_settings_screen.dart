import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/widgets/liquid_glass_container.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/jamat_provider.dart';
import 'package:go_router/go_router.dart';

class JamatSettingsScreen extends ConsumerWidget {
  const JamatSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jamatSettings = ref.watch(jamatProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;
    final dividerColor = isDark ? Colors.white10 : Colors.black12;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(l10n.jamatAndOverlay, style: TextStyle(
          fontSize: 22, 
          fontWeight: FontWeight.w900, 
          color: isDark ? Colors.white : AppTheme.textPrimaryLight
        )),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: isDark ? Colors.white : AppTheme.textPrimaryLight),
          onPressed: () => context.pop(),
        ),
      ),
      body: Center(
        child: LiquidGlassContainer(
          width: double.infinity,
          height: double.infinity,
          borderRadius: 0,
          blur: AppTheme.glassBlur,
          surfaceColor: isDark ? null : AppTheme.glassyTeal.withValues(alpha: AppTheme.glassOpacity),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              children: [
                _buildSectionHeader(context, l10n.manualJamatTimes, isDark),
                const SizedBox(height: 12),
                LiquidGlassContainer(
                  blur: 10,
                  surfaceColor: Colors.white.withValues(alpha: isDark ? 0.05 : 0.4),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: jamatSettings.jamatTimes.entries.map((entry) {
                      final index = jamatSettings.jamatTimes.keys.toList().indexOf(entry.key);
                      return Column(
                        children: [
                          _buildJamatTile(context, ref, entry.key, _getLocalizedPrayerName(entry.key, l10n), entry.value, isDark),
                          if (index < jamatSettings.jamatTimes.length - 1)
                            Divider(indent: 70, endIndent: 20, color: dividerColor),
                        ],
                      );
                    }).toList(),
                  ),
                ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),
                
                const SizedBox(height: 32),
                _buildSectionHeader(context, l10n.overlayControls, isDark),
                const SizedBox(height: 12),
                LiquidGlassContainer(
                  blur: 10,
                  surfaceColor: Colors.white.withValues(alpha: isDark ? 0.05 : 0.4),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    children: [
                      _buildSwitchTile(
                        context, 
                        Icons.fullscreen_rounded, 
                        l10n.fullscreenOverlay, 
                        l10n.immersiveScreen, 
                        jamatSettings.isOverlayEnabled, 
                        (val) => ref.read(jamatProvider.notifier).toggleOverlay(val), 
                        isDark
                      ),
                      Divider(indent: 70, endIndent: 20, color: dividerColor),
                      _buildSwitchTile(
                        context, 
                        Icons.hearing_rounded, 
                        l10n.listeningMode, 
                        l10n.detectAdhan, 
                        jamatSettings.isListeningModeEnabled, 
                        (val) => ref.read(jamatProvider.notifier).toggleListeningMode(val), 
                        isDark
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: 0.1),
                
                const SizedBox(height: 32),
                _buildSectionHeader(context, l10n.warningSettings, isDark),
                const SizedBox(height: 12),
                LiquidGlassContainer(
                  blur: 10,
                  surfaceColor: Colors.white.withValues(alpha: isDark ? 0.05 : 0.4),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.activePrayerGreen.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.timer_outlined, color: AppTheme.activePrayerGreen, size: 22),
                        ),
                        title: Text(l10n.warningBeforeJamat, style: TextStyle(
                          fontWeight: FontWeight.w800, 
                          fontSize: 16,
                          color: isDark ? Colors.white : AppTheme.textPrimaryLight,
                        )),
                        trailing: DropdownButton<int>(
                          underline: const SizedBox(),
                          borderRadius: BorderRadius.circular(16),
                          dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                          value: jamatSettings.warningMinutes,
                          items: [5, 10, 15, 20, 30].map((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text('$value ${l10n.minutes}', style: TextStyle(
                                color: isDark ? Colors.white : AppTheme.textPrimaryLight,
                                fontWeight: FontWeight.w700,
                              )),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              ref.read(jamatProvider.notifier).updateWarningMinutes(val);
                            }
                          },
                        ),
                      ),
                      Divider(indent: 50, color: dividerColor),
                      ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppTheme.activePrayerGreen.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.notification_important_outlined, color: AppTheme.activePrayerGreen, size: 22),
                        ),
                        title: Text(l10n.earlyAdhanWarning, style: TextStyle(
                          fontWeight: FontWeight.w800, 
                          fontSize: 16,
                          color: isDark ? Colors.white : AppTheme.textPrimaryLight,
                        )),
                        trailing: DropdownButton<int>(
                          underline: const SizedBox(),
                          borderRadius: BorderRadius.circular(16),
                          dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                          value: jamatSettings.earlyAdhanMinutes,
                          items: [5, 10, 15, 20, 25, 30].map((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text('$value ${l10n.minutes}', style: TextStyle(
                                color: isDark ? Colors.white : AppTheme.textPrimaryLight,
                                fontWeight: FontWeight.w700,
                              )),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              ref.read(jamatProvider.notifier).updateEarlyAdhanMinutes(val);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 400.ms, duration: 400.ms).slideY(begin: 0.1),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getLocalizedPrayerName(String prayer, AppLocalizations l10n) {
    switch (prayer.toLowerCase()) {
      case 'fajr': return l10n.fajr;
      case 'dhuhr': return l10n.dhuhr;
      case 'asr': return l10n.asr;
      case 'maghrib': return l10n.maghrib;
      case 'isha': return l10n.isha;
      default: return prayer;
    }
  }

  Widget _buildSectionHeader(BuildContext context, String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          letterSpacing: 1.5,
          fontSize: 12,
          fontWeight: FontWeight.w900,
          color: isDark ? Colors.white38 : AppTheme.textSecondaryLight,
        ),
      ),
    );
  }

  Widget _buildSwitchTile(BuildContext context, IconData icon, String title, String subtitle, bool value, ValueChanged<bool> onChanged, bool isDark) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeTrackColor: AppTheme.activePrayerGreen.withValues(alpha: 0.3),
      activeThumbColor: AppTheme.activePrayerGreen,
      title: Text(title, style: TextStyle(
        fontWeight: FontWeight.w800, 
        fontSize: 16,
        color: isDark ? Colors.white : AppTheme.textPrimaryLight,
      )),
      subtitle: Text(subtitle, style: TextStyle(
        fontSize: 12, 
        fontWeight: FontWeight.w500,
        color: isDark ? Colors.white38 : AppTheme.textSecondaryLight,
      )),
      secondary: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.activePrayerGreen.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppTheme.activePrayerGreen, size: 22),
      ),
    );
  }

  Widget _buildJamatTile(BuildContext context, WidgetRef ref, String prayerKey, String localizedName, String time, bool isDark) {
    // Convert 24h string (HH:mm) to TimeOfDay for formatting
    final parts = time.split(':');
    final tod = TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    
    // Explicitly format to 12h with AM/PM to avoid locale-specific 24h digits
    final hour = tod.hourOfPeriod == 0 ? 12 : tod.hourOfPeriod;
    final minute = tod.minute.toString().padLeft(2, '0');
    final period = tod.period == DayPeriod.am ? 'AM' : 'PM';
    final formattedDisplayTime = "$hour:$minute $period";

    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.activePrayerGreen.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.access_time_rounded, color: AppTheme.activePrayerGreen, size: 22),
      ),
      title: Text(localizedName, style: TextStyle(
        fontWeight: FontWeight.w800, 
        fontSize: 17,
        color: isDark ? Colors.white : AppTheme.textPrimaryLight,
      )),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(formattedDisplayTime, style: const TextStyle(color: AppTheme.activePrayerGreen, fontWeight: FontWeight.w900, fontSize: 18)),
          const SizedBox(width: 12),
          Icon(Icons.edit_calendar_rounded, size: 18, color: isDark ? Colors.white24 : Colors.black12),
        ],
      ),
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialEntryMode: TimePickerEntryMode.input, // Digital input by default
          initialTime: tod,
          builder: (context, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                timePickerTheme: TimePickerThemeData(
                  entryModeIconColor: AppTheme.activePrayerGreen,
                  dialHandColor: AppTheme.activePrayerGreen,
                  dialBackgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                  hourMinuteColor: AppTheme.activePrayerGreen.withValues(alpha: 0.1),
                  hourMinuteTextColor: isDark ? Colors.white : AppTheme.textPrimaryLight,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          final formattedTime = '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
          ref.read(jamatProvider.notifier).updateJamatTime(prayerKey, formattedTime);
        }
      },
    );
  }
}
