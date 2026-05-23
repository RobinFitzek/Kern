import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../plugins/derived/derived_providers.dart';
import '../theme/app_theme.dart';
import 'insight_chip.dart';

class DailyInsightsCard extends ConsumerWidget {
  const DailyInsightsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightsAsync = ref.watch(dailyInsightsProvider());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return insightsAsync.when(
      data: (insights) {
        if (insights.isEmpty) return const SizedBox.shrink();

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTheme.divider),
            boxShadow: AppTheme.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Heutige Insights',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              for (int i = 0; i < insights.length; i++) ...[
                if (i > 0) const SizedBox(height: 8),
                InsightChip(insight: insights[i]),
              ],
            ],
          ),
        );
      },
      loading: () {
        return Container(
          height: 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppTheme.divider),
            boxShadow: AppTheme.cardShadow,
          ),
          child: const Center(
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}
