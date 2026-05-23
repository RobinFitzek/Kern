import 'package:flutter/material.dart';

import '../../plugins/derived/insight_engine.dart';
import '../theme/app_theme.dart';

class InsightChip extends StatelessWidget {
  final DailyInsight insight;

  const InsightChip({super.key, required this.insight});

  Color _color() {
    switch (insight.sentiment) {
      case InsightSentiment.good:
        return AppTheme.textMint;
      case InsightSentiment.bad:
        return AppTheme.textPink;
      case InsightSentiment.neutral:
        return AppTheme.textOrange;
    }
  }

  Color _bg() {
    switch (insight.sentiment) {
      case InsightSentiment.good:
        return AppTheme.accentMint;
      case InsightSentiment.bad:
        return AppTheme.accentPink;
      case InsightSentiment.neutral:
        return AppTheme.accentOrange;
    }
  }

  IconData _icon() {
    switch (insight.category) {
      case InsightCategory.erholung:
        return Icons.favorite_rounded;
      case InsightCategory.schlaf:
        return Icons.bedtime_rounded;
      case InsightCategory.belastung:
        return Icons.directions_run_rounded;
    }
  }

  String _label() {
    switch (insight.category) {
      case InsightCategory.erholung:
        return 'Erholung';
      case InsightCategory.schlaf:
        return 'Schlaf';
      case InsightCategory.belastung:
        return 'Belastung';
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color();
    final bg = _bg();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(_icon(), size: 18, color: color),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _label(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: color,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  insight.text,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: color.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
