import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/plugins/plugin_interfaces.dart';
import '../derived/derived_providers.dart';
import '../../ui/theme/app_theme.dart';
import '../../ui/widgets/bouncing_card.dart';

class RecoveryFeature implements KernPlugin {
  @override
  String get id => 'recovery';

  @override
  String get name => 'Erholung';

  @override
  String get description => 'Erholungsstatus basierend auf HRV- und Ruhepuls-Trends.';

  @override
  List<PluginSlot> get supportedSlots => [PluginSlot.header, PluginSlot.footer];

  @override
  Widget buildDashboardWidget(BuildContext context, PluginSlot slot) {
    return const _RecoveryWidget();
  }

  @override
  bool get hasDetailPage => true;

  @override
  Widget? buildDetailPage(BuildContext context) => const _RecoveryDetailScreen();

  @override
  Widget? buildSettingsPage(BuildContext context) => const _RecoverySettingsScreen();
}

class _RecoveryWidget extends ConsumerWidget {
  const _RecoveryWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreAsync = ref.watch(recoveryScoreProvider());
    final stateAsync = ref.watch(recoveryStateProvider());
    final hrvTrendAsync = ref.watch(recoveryHrvTrendProvider());
    final rhrTrendAsync = ref.watch(recoveryRhrTrendProvider());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final score = scoreAsync.valueOrNull;
    final stateLabel = stateAsync.valueOrNull ?? 'Kalibrierung';
    final hrvTrend = hrvTrendAsync.valueOrNull;
    final rhrTrend = rhrTrendAsync.valueOrNull;

    return BouncingCard(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const _RecoveryDetailScreen()),
        );
      },
      child: Card(
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
                      color: _stateColor(stateLabel, isDark).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _stateIcon(stateLabel),
                      color: _stateColor(stateLabel, isDark),
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Erholung',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    stateLabel,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _stateColor(stateLabel, isDark),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          score?.toStringAsFixed(0) ?? '--',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Erholungs-Score',
                          style: TextStyle(
                            fontSize: 11,
                            color: isDark ? Colors.white38 : AppTheme.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (hrvTrend != null && rhrTrend != null) ...[
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _trendChip('HRV', hrvTrend, isDark),
                        const SizedBox(height: 4),
                        _trendChip('RHR', rhrTrend, isDark),
                      ],
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _trendChip(String label, double trend, bool isDark) {
    final isPositive = (label == 'RHR') ? trend < 1.0 : trend > 1.0;
    final color = isPositive ? AppTheme.textMint : AppTheme.textOrange;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            '$label ${(trend * 100 - 100).toStringAsFixed(0)}%',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }

  Color _stateColor(String state, bool isDark) {
    switch (state) {
      case 'Erholt':
        return isDark ? const Color(0xFF34A853) : AppTheme.textMint;
      case 'Erholt sich':
        return isDark ? const Color(0xFFFBBC04) : AppTheme.textBlue;
      case 'Stabil':
        return isDark ? const Color(0xFF8AB4F8) : AppTheme.textBlue;
      case 'Rückläufig':
        return isDark ? const Color(0xFFFBBC04) : AppTheme.textOrange;
      case 'Ermüdet':
        return isDark ? const Color(0xFFEA4335) : AppTheme.textPink;
      default:
        return AppTheme.textTertiary;
    }
  }

  IconData _stateIcon(String state) {
    switch (state) {
      case 'Erholt':
        return Icons.check_circle_rounded;
      case 'Erholt sich':
        return Icons.trending_up_rounded;
      case 'Stabil':
        return Icons.trending_flat_rounded;
      case 'Rückläufig':
        return Icons.trending_down_rounded;
      case 'Ermüdet':
        return Icons.warning_rounded;
      default:
        return Icons.hourglass_empty_rounded;
    }
  }
}

class _RecoveryDetailScreen extends ConsumerWidget {
  const _RecoveryDetailScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreAsync = ref.watch(recoveryScoreProvider());
    final stateAsync = ref.watch(recoveryStateProvider());
    final hrvTrendAsync = ref.watch(recoveryHrvTrendProvider());
    final rhrTrendAsync = ref.watch(recoveryRhrTrendProvider());
    final recAsync = ref.watch(recoveryRecommendationProvider());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Erholung'),
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
              children: [
                scoreAsync.when(
                  data: (s) => Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 140,
                        height: 140,
                        child: CircularProgressIndicator(
                          value: (s ?? 50) / 100,
                          strokeWidth: 14,
                          backgroundColor: isDark ? Colors.white12 : AppTheme.divider,
                          color: _scoreColor(s ?? 50, isDark),
                          strokeCap: StrokeCap.round,
                        ),
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            s?.toStringAsFixed(0) ?? '--',
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: _scoreColor(s ?? 50, isDark),
                            ),
                          ),
                          stateAsync.when(
                            data: (state) => Text(
                              state ?? '--',
                              style: TextStyle(
                                fontSize: 13,
                                color: (_scoreColor(s ?? 50, isDark)).withValues(alpha: 0.8),
                              ),
                            ),
                            loading: () => const SizedBox(),
                            error: (_, __) => const SizedBox(),
                          ),
                        ],
                      ),
                    ],
                  ),
                  loading: () => const SizedBox(
                    height: 140,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, __) => const SizedBox(),
                ),
                const SizedBox(height: 24),
                hrvTrendAsync.when(
                  data: (t) => t != null
                      ? _MetricRow(
                          label: 'HRV Trend',
                          value: '${(t * 100 - 100).toStringAsFixed(0)}%',
                          icon: Icons.favorite_rounded,
                          color: t >= 1.0 ? AppTheme.textMint : AppTheme.textOrange,
                          isDark: isDark,
                        )
                      : const SizedBox(),
                  loading: () => const SizedBox(),
                  error: (_, __) => const SizedBox(),
                ),
                const SizedBox(height: 8),
                rhrTrendAsync.when(
                  data: (t) => t != null
                      ? _MetricRow(
                          label: 'Ruhepuls Trend',
                          value: '${(t * 100 - 100).toStringAsFixed(0)}%',
                          icon: Icons.monitor_heart_rounded,
                          color: t <= 1.0 ? AppTheme.textMint : AppTheme.textOrange,
                          isDark: isDark,
                        )
                      : const SizedBox(),
                  loading: () => const SizedBox(),
                  error: (_, __) => const SizedBox(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          recAsync.when(
            data: (rec) => rec != null
                ? Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E1E) : AppTheme.accentBlue,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: isDark ? Colors.white12 : AppTheme.accentBlue),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.lightbulb_rounded, color: AppTheme.textBlue, size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Empfehlung',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.textBlue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          rec,
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.85),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          ),
        ],
      ),
    );
  }

  Color _scoreColor(double score, bool isDark) {
    if (score >= 80) return isDark ? const Color(0xFF34A853) : AppTheme.textMint;
    if (score >= 60) return isDark ? const Color(0xFF8AB4F8) : AppTheme.textBlue;
    if (score >= 40) return isDark ? const Color(0xFFFBBC04) : AppTheme.textOrange;
    return isDark ? const Color(0xFFEA4335) : AppTheme.textPink;
  }
}

class _MetricRow extends StatelessWidget {
  const _MetricRow({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.isDark,
  });
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecoverySettingsScreen extends StatelessWidget {
  const _RecoverySettingsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Erholung Einstellungen')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ListTile(
            title: Text('Analyse-Zeitraum'),
            subtitle: Text('7-Tage vs. 14-Tage Baseline'),
            trailing: Icon(Icons.chevron_right),
            enabled: false,
          ),
          SwitchListTile(
            title: const Text('Erholungs-Benachrichtigung'),
            subtitle: const Text('Demnächst verfügbar'),
            value: false,
            onChanged: null,
          ),
        ],
      ),
    );
  }
}
