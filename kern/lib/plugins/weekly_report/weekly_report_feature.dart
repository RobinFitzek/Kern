import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/plugins/plugin_interfaces.dart';
import '../derived/derived_providers.dart';
import '../../ui/theme/app_theme.dart';

class WeeklyReportFeature implements KernPlugin {
  @override
  String get id => 'weekly_report';

  @override
  String get name => 'Wochenbericht';

  @override
  String get description => 'Wöchentliche Zusammenfassung aller Gesundheitsmetriken mit Trends.';

  @override
  List<PluginSlot> get supportedSlots => [PluginSlot.footer, PluginSlot.main];

  @override
  Widget buildDashboardWidget(BuildContext context, PluginSlot slot) {
    return const _WeeklyReportWidget();
  }

  @override
  bool get hasDetailPage => true;

  @override
  Widget? buildDetailPage(BuildContext context) => const _WeeklyReportDetailScreen();

  @override
  Widget? buildSettingsPage(BuildContext context) => null;
}

class _WeeklyReportWidget extends ConsumerWidget {
  const _WeeklyReportWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avgReadinessAsync = ref.watch(weeklyAvgReadinessProvider());
    final avgSleepAsync = ref.watch(weeklyAvgSleepProvider());
    final totalStepsAsync = ref.watch(weeklyTotalStepsProvider());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1A2744) : AppTheme.accentBlue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.calendar_view_week_rounded,
                    color: AppTheme.textBlue,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Wochenbericht',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppTheme.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _MiniStat(
                    label: 'Readiness',
                    value: avgReadinessAsync.valueOrNull,
                    suffix: '',
                    color: AppTheme.textMint,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MiniStat(
                    label: 'Schlaf',
                    value: avgSleepAsync.valueOrNull,
                    suffix: '',
                    color: AppTheme.textPurple,
                    isDark: isDark,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _MiniStat(
                    label: 'Schritte',
                    value: totalStepsAsync.valueOrNull,
                    suffix: '',
                    color: AppTheme.textOrange,
                    isDark: isDark,
                    integerValue: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({
    required this.label,
    required this.value,
    required this.suffix,
    required this.color,
    required this.isDark,
    this.integerValue = false,
  });
  final String label;
  final double? value;
  final String suffix;
  final Color color;
  final bool isDark;
  final bool integerValue;

  @override
  Widget build(BuildContext context) {
    final dTheme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value != null
                ? (integerValue ? value!.toInt().toString() : value!.toStringAsFixed(0))
                : '--',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: dTheme.colorScheme.onSurface),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 10, color: dTheme.colorScheme.onSurface.withValues(alpha: 0.6))),
        ],
      ),
    );
  }
}

class _WeeklyReportDetailScreen extends ConsumerWidget {
  const _WeeklyReportDetailScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final avgReadinessAsync = ref.watch(weeklyAvgReadinessProvider());
    final avgSleepAsync = ref.watch(weeklyAvgSleepProvider());
    final avgStrainAsync = ref.watch(weeklyAvgStrainProvider());
    final totalStepsAsync = ref.watch(weeklyTotalStepsProvider());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wochenbericht'),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '7-Tage Übersicht',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Text(
                  'Deine wöchentlichen Durchschnittswerte',
                  style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                ),
                const SizedBox(height: 24),
                _buildRow('Durchschn. Readiness', avgReadinessAsync, null, 'Punkte', AppTheme.textMint, theme, isDark),
                const SizedBox(height: 12),
                _buildRow('Durchschn. Schlafscore', avgSleepAsync, null, 'Punkte', AppTheme.textPurple, theme, isDark),
                const SizedBox(height: 12),
                _buildRow('Durchschn. Belastung', avgStrainAsync, null, 'Punkte', AppTheme.textOrange, theme, isDark),
                const SizedBox(height: 12),
                _buildRow('Gesamtschritte', totalStepsAsync, null, 'Schritte', AppTheme.textBlue, theme, isDark, integerValue: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(
    String label,
    AsyncValue<double?> asyncValue,
    String? subtitle,
    String suffix,
    Color color,
    ThemeData theme,
    bool isDark, {
    bool integerValue = false,
  }) {
    return asyncValue.when(
      data: (val) {
        if (val == null) return const SizedBox();
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.grey.shade50,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(subtitle, style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
                    ],
                  ],
                ),
              ),
              Text(
                integerValue ? '${val.toInt()} $suffix' : '${val.toStringAsFixed(0)} $suffix',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: color),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox(),
      error: (_, __) => const SizedBox(),
    );
  }
}
