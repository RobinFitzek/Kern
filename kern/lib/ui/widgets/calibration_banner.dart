import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../plugins/derived/derived_providers.dart';
import '../theme/app_theme.dart';

class CalibrationBanner extends ConsumerWidget {
  const CalibrationBanner({super.key});

  static const int _minHrvDays = 7;
  static const int _minSleepNights = 7;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isCalibratingAsync = ref.watch(readinessIsCalibratingProvider());
    final countsAsync = ref.watch(readinessDataCountsProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final calibrating = isCalibratingAsync.valueOrNull ?? true;
    final counts = countsAsync.valueOrNull;

    if (!calibrating) return const SizedBox.shrink();

    final hrvDays = counts?.hrvDays ?? 0;
    final sleepNights = counts?.sleepNights ?? 0;

    final hrvProgress = (hrvDays / _minHrvDays).clamp(0.0, 1.0);
    final sleepProgress = (sleepNights / _minSleepNights).clamp(0.0, 1.0);

    final daysComplete = (hrvProgress + sleepProgress) / 2;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF2A2200) : AppTheme.accentOrange,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.textOrange.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppTheme.textOrange.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.hourglass_top_rounded, color: AppTheme.textOrange, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Baseline wird aufgebaut',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textOrange,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Deine ersten Readiness Scores erscheinen in ${_estimateRemainingDays(daysComplete)} Tagen',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppTheme.textOrange,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.textOrange.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${(daysComplete * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textOrange,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _ProgressRow(
            label: 'HRV-Daten',
            icon: Icons.favorite_rounded,
            days: hrvDays,
            minDays: _minHrvDays,
            progress: hrvProgress,
          ),
          const SizedBox(height: 10),
          _ProgressRow(
            label: 'Schlafdaten',
            icon: Icons.nightlight_rounded,
            days: sleepNights,
            minDays: _minSleepNights,
            progress: sleepProgress,
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: daysComplete,
            minHeight: 4,
            backgroundColor: AppTheme.textOrange.withValues(alpha: 0.15),
            color: AppTheme.textOrange,
            borderRadius: BorderRadius.circular(2),
          ),
        ],
      ),
    );
  }

  int _estimateRemainingDays(double progress) {
    if (progress >= 1.0) return 0;
    if (progress > 0.8) return 1;
    if (progress > 0.5) return 3;
    if (progress > 0.2) return 5;
    return 7;
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({
    required this.label,
    required this.icon,
    required this.days,
    required this.minDays,
    required this.progress,
  });

  final String label;
  final IconData icon;
  final int days;
  final int minDays;
  final double progress;

  @override
  Widget build(BuildContext context) {
    final isComplete = days >= minDays;
    final iconColor = isComplete ? AppTheme.textMint : AppTheme.textOrange;

    return Row(
      children: [
        Icon(icon, size: 14, color: iconColor),
        const SizedBox(width: 8),
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: iconColor,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: iconColor.withValues(alpha: 0.12),
              color: iconColor,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          isComplete ? '✓' : '$days/$minDays',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: iconColor,
          ),
        ),
      ],
    );
  }
}
