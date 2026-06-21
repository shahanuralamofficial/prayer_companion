import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/providers/theme_provider.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/db/hive_database.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../shared/widgets/liquid_glass_container.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../prayer/presentation/providers/prayer_provider.dart';
import 'package:adhan_dart/adhan_dart.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);
    final currentThemeMode = ref.watch(themeProvider);
    final currentMethod = ref.watch(calculationMethodProvider);
    final currentMadhab = ref.watch(madhabProvider);
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent, // Allow glass to show
      appBar: AppBar(
        title: Text(l10n.settings, style: TextStyle(
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
          borderRadius: 0, // Full screen glass
          blur: AppTheme.glassBlur,
          surfaceColor: isDark ? null : AppTheme.glassyTeal.withValues(alpha: 0.95),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 20),
              children: [
                _buildSectionHeader(context, l10n.prayerCalculation, isDark),
                const SizedBox(height: 12),
                LiquidGlassContainer(
                  blur: 10, // Nested glass should be less blurred
                  surfaceColor: Colors.white.withValues(alpha: isDark ? 0.05 : 0.4),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      _buildDropdownTile<CalculationMethod>(
                        context, 
                        Icons.calculate_outlined, 
                        l10n.method, 
                        currentMethod,
                        CalculationMethod.values,
                        (val) {
                          if (val != null) {
                            ref.read(calculationMethodProvider.notifier).state = val;
                            HiveDatabase.getSettingsBox().put('calculationMethod', val.index);
                          }
                        },
                        isDark,
                        l10n,
                      ),
                      const Divider(indent: 70, endIndent: 20, color: Colors.black12),
                      _buildDropdownTile<Madhab>(
                        context, 
                        Icons.book_outlined, 
                        l10n.asrMadhab, 
                        currentMadhab,
                        [Madhab.shafi, Madhab.hanafi],
                        (val) {
                          if (val != null) {
                            ref.read(madhabProvider.notifier).state = val;
                            HiveDatabase.getSettingsBox().put('madhab', val.index);
                          }
                        },
                        isDark,
                        l10n,
                      ),
                      const Divider(indent: 70, endIndent: 20, color: Colors.black12),
                      _buildNavigationTile(
                        context,
                        Icons.timer_outlined,
                        l10n.jamatAndOverlay,
                        l10n.manualTimesAndAlerts,
                        isDark,
                        onTap: () => context.push('/jamat-settings'),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),
                
                const SizedBox(height: 32),
                _buildSectionHeader(context, l10n.notifications, isDark),
                const SizedBox(height: 12),
                LiquidGlassContainer(
                  blur: 10,
                  surfaceColor: Colors.white.withValues(alpha: isDark ? 0.05 : 0.4),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      _buildSwitchTile(context, Icons.notifications_active_outlined, l10n.earlyReminder, true, (val) {}, isDark),
                      const Divider(indent: 70, endIndent: 20, color: Colors.black12),
                      _buildSwitchTile(context, Icons.mosque_outlined, l10n.iqamahAlerts, true, (val) {}, isDark),
                    ],
                  ),
                ).animate().fadeIn(delay: 200.ms, duration: 400.ms).slideY(begin: 0.1),
                
                const SizedBox(height: 32),
                _buildSectionHeader(context, l10n.appearance, isDark),
                const SizedBox(height: 12),
                LiquidGlassContainer(
                  blur: 10,
                  surfaceColor: Colors.white.withValues(alpha: isDark ? 0.05 : 0.4),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Column(
                    children: [
                      _buildNavigationTile(
                        context,
                        Icons.language_rounded,
                        l10n.language,
                        currentLocale.languageCode == 'en' ? l10n.english : l10n.bengali,
                        isDark,
                        onTap: () => _showLanguageDialog(context, ref),
                      ),
                      const Divider(indent: 70, endIndent: 20, color: Colors.black12),
                      _buildSwitchTile(
                        context, 
                        Icons.color_lens_outlined, 
                        l10n.theme, 
                        currentThemeMode == ThemeMode.dark, 
                        (val) => ref.read(themeProvider.notifier).toggleTheme(),
                        isDark,
                        subtitle: currentThemeMode == ThemeMode.dark ? l10n.dark : l10n.light,
                      ),
                      const Divider(indent: 70, endIndent: 20, color: Colors.black12),
                      _buildSwitchTile(context, Icons.launch_outlined, l10n.launchAtLogin, true, (val) {}, isDark),
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

  Widget _buildNavigationTile(BuildContext context, IconData icon, String title, String value, bool isDark, {required VoidCallback onTap}) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.activePrayerGreen.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppTheme.activePrayerGreen, size: 22),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isDark ? Colors.white : AppTheme.textPrimaryLight,
          fontWeight: FontWeight.w800,
          fontSize: 16,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              color: isDark ? Colors.white38 : AppTheme.textSecondaryLight,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.arrow_forward_ios_rounded, size: 14, color: isDark ? Colors.white12 : Colors.black12),
        ],
      ),
    );
  }

  Widget _buildDropdownTile<T>(BuildContext context, IconData icon, String title, T value, List<T> items, ValueChanged<T?> onChanged, bool isDark, AppLocalizations l10n) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.activePrayerGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppTheme.activePrayerGreen, size: 22),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: isDark ? Colors.white : AppTheme.textPrimaryLight,
                fontWeight: FontWeight.w800,
                fontSize: 16,
              ),
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 150),
            child: DropdownButton<T>(
              value: value,
              isExpanded: true, // Fill the constrained space
              underline: const SizedBox(),
              alignment: Alignment.centerRight,
              icon: const Icon(Icons.arrow_drop_down_rounded),
              dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
              items: items.map((T item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      _getLocalizedItemName(item, l10n).toUpperCase(),
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        color: isDark ? Colors.white : AppTheme.textPrimaryLight,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  String _getLocalizedItemName(dynamic item, AppLocalizations l10n) {
    if (item is CalculationMethod) {
      switch (item) {
        case CalculationMethod.dubai: return l10n.method_dubai;
        case CalculationMethod.egyptian: return l10n.method_egyptian;
        case CalculationMethod.karachi: return l10n.method_karachi;
        case CalculationMethod.kuwait: return l10n.method_kuwait;
        case CalculationMethod.moonsightingCommittee: return l10n.method_moonsightingCommittee;
        case CalculationMethod.morocco: return l10n.method_morocco;
        case CalculationMethod.muslimWorldLeague: return l10n.method_muslimWorldLeague;
        case CalculationMethod.northAmerica: return l10n.method_northAmerica;
        case CalculationMethod.qatar: return l10n.method_qatar;
        case CalculationMethod.singapore: return l10n.method_singapore;
        case CalculationMethod.tehran: return l10n.method_tehran;
        case CalculationMethod.turkiye: return l10n.method_turkiye;
        case CalculationMethod.ummAlQura: return l10n.method_ummAlQura;
        case CalculationMethod.other: return "OTHER";
      }
    } else if (item is Madhab) {
      switch (item) {
        case Madhab.shafi: return l10n.madhab_standard;
        case Madhab.hanafi: return l10n.madhab_hanafi;
      }
    }
    return item.name;
  }

  Widget _buildSwitchTile(BuildContext context, IconData icon, String title, bool value, ValueChanged<bool> onChanged, bool isDark, {String? subtitle}) {
    return SwitchListTile(
      value: value,
      onChanged: onChanged,
      activeTrackColor: AppTheme.activePrayerGreen.withValues(alpha: 0.3),
      activeThumbColor: AppTheme.activePrayerGreen,
      title: Text(
        title,
        style: TextStyle(
          color: isDark ? Colors.white : AppTheme.textPrimaryLight,
          fontWeight: FontWeight.w800,
          fontSize: 16,
        ),
      ),
      subtitle: subtitle != null ? Text(subtitle, style: TextStyle(
        fontSize: 12,
        color: isDark ? Colors.white38 : AppTheme.textSecondaryLight,
      )) : null,
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

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1E293B) : Colors.white,
        title: Text(l10n.language, style: const TextStyle(fontWeight: FontWeight.w900)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text("English", style: TextStyle(fontWeight: FontWeight.w700)),
              onTap: () {
                ref.read(localeProvider.notifier).setLocale(const Locale('en'));
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text("বাংলা", style: TextStyle(fontWeight: FontWeight.w700)),
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
}
