import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../l10n/app_localizations.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildActionItem(context, Icons.explore_outlined, l10n.qibla, '/qibla'),
        _buildActionItem(context, Icons.menu_book_outlined, l10n.quran, '/quran'),
        _buildActionItem(context, Icons.fingerprint, l10n.tasbih, '/tasbih'),
        _buildActionItem(context, Icons.calendar_month_outlined, l10n.calendar, '/calendar'),
      ],
    );
  }

  Widget _buildActionItem(BuildContext context, IconData icon, String label, String route) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
