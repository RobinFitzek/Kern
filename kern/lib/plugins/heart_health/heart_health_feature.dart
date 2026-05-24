import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/plugins/plugin_interfaces.dart';
import '../derived/derived_providers.dart';
import '../../ui/theme/app_theme.dart';
import '../../ui/widgets/bouncing_card.dart';

class HeartHealthFeature implements KernPlugin {
  @override
  String get id => 'heart_health';

  @override
  String get name => 'Herzgesundheit';

  @override
  String get description => 'Kardiovaskuläre Fitness-Analyse basierend auf Ruhepuls- und HRV-Trends.';

  @override
  List<PluginSlot> get supportedSlots => [PluginSlot.header, PluginSlot.footer];

  @override
  Widget buildDashboardWidget(BuildContext context, PluginSlot slot) {
    return const _HeartHealthWidget();
  }

  @override
  bool get hasDetailPage => true;

  @override
  Widget? buildDetailPage(BuildContext context) => const _HeartHealthDetailScreen();

  @override
  Widget? buildSettingsPage(BuildContext context) => const _HeartHealthSettingsScreen();
}

class _HeartHealthWidget extends ConsumerWidget {
  const _HeartHealthWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rhrAsync = ref.watch(heartHealthRestingHrProvider());
    final fitnessAsync = ref.watch(heartHealthCvFitnessProvider());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final rhr = rhrAsync.valueOrNull;
    final fitness = fitnessAsync.valueOrNull;

    return BouncingCard(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const _HeartHealthDetailScreen()),
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
                    decoration: const BoxDecoration(
                      color: AppTheme.accentPink,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.favorite_rounded,
                      color: AppTheme.textPink,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Herzgesundheit',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppTheme.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        rhr != null ? '${rhr.toInt()} bpm' : '--',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Ruhepuls',
                        style: TextStyle(
                          fontSize: 11,
                          color: isDark ? Colors.white38 : AppTheme.textTertiary,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _fitnessColor(fitness ?? 50, isDark).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          fitness != null ? '${fitness.toInt()} Punkte' : '--',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _fitnessColor(fitness ?? 50, isDark),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _fitnessLabel(fitness ?? 50),
                        style: TextStyle(
                          fontSize: 11,
                          color: _fitnessColor(fitness ?? 50, isDark).withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _fitnessColor(double score, bool isDark) {
    if (score >= 75) return isDark ? const Color(0xFF34A853) : AppTheme.textMint;
    if (score >= 50) return isDark ? const Color(0xFF8AB4F8) : AppTheme.textBlue;
    if (score >= 25) return isDark ? const Color(0xFFFBBC04) : AppTheme.textOrange;
    return isDark ? const Color(0xFFEA4335) : AppTheme.textPink;
  }

  String _fitnessLabel(double score) {
    if (score >= 75) return 'Exzellent';
    if (score >= 50) return 'Gut';
    if (score >= 25) return 'Verbesserbar';
    return 'Achtung';
  }
}

class _HeartHealthDetailScreen extends ConsumerWidget {
  const _HeartHealthDetailScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rhrAsync = ref.watch(heartHealthRestingHrProvider());
    final rhrTrendAsync = ref.watch(heartHealthRestingHrTrendProvider());
    final hrvAsync = ref.watch(heartHealthHrvBaselineProvider());
    final fitnessAsync = ref.watch(heartHealthCvFitnessProvider());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Herzgesundheit'),
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
                fitnessAsync.when(
                  data: (fitness) {
                    final f = fitness ?? 50;
                    return Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 140,
                              height: 140,
                              child: CircularProgressIndicator(
                                value: f / 100,
                                strokeWidth: 14,
                                backgroundColor: isDark ? Colors.white12 : AppTheme.divider,
                                color: _fitnessColor(f, isDark),
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  f.toStringAsFixed(0),
                                  style: TextStyle(
                                    fontSize: 42,
                                    fontWeight: FontWeight.bold,
                                    color: _fitnessColor(f, isDark),
                                  ),
                                ),
                                Text(
                                  _fitnessLabel(f),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: _fitnessColor(f, isDark).withValues(alpha: 0.8),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'CV Fitness Schätzung',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Basiert auf Ruhepuls-Trends und HRV-Werten',
                          style: TextStyle(
                            fontSize: 12,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => const SizedBox(height: 160, child: Center(child: CircularProgressIndicator())),
                  error: (_, __) => const SizedBox(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          rhrAsync.when(
            data: (rhr) => rhr != null
                ? _MetricCard(
                    icon: Icons.monitor_heart_rounded,
                    label: 'Ruhepuls (28-Tage Ø)',
                    value: '${rhr.toInt()} bpm',
                    color: AppTheme.textPink,
                    isDark: isDark,
                  )
                : const SizedBox(),
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          ),
          const SizedBox(height: 8),
          rhrTrendAsync.when(
            data: (trend) => trend != null && trend > 0
                ? _MetricCard(
                    icon: Icons.trending_up_rounded,
                    label: 'RHR Trend',
                    value: trend < 1.0
                        ? 'Verbessert (${((1 - trend) * 100).toStringAsFixed(0)}%)'
                        : 'Verschlechtert (${((trend - 1) * 100).toStringAsFixed(0)}%)',
                    color: trend < 1.0 ? AppTheme.textMint : AppTheme.textOrange,
                    isDark: isDark,
                  )
                : const SizedBox(),
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          ),
          const SizedBox(height: 8),
          hrvAsync.when(
            data: (hrv) => hrv != null && hrv > 0
                ? _MetricCard(
                    icon: Icons.favorite_rounded,
                    label: 'HRV Baseline (28-Tage)',
                    value: '${hrv.toInt()} ms',
                    color: AppTheme.textBlue,
                    isDark: isDark,
                  )
                : const SizedBox(),
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          ),
        ],
      ),
    );
  }

  Color _fitnessColor(double score, bool isDark) {
    if (score >= 75) return isDark ? const Color(0xFF34A853) : AppTheme.textMint;
    if (score >= 50) return isDark ? const Color(0xFF8AB4F8) : AppTheme.textBlue;
    if (score >= 25) return isDark ? const Color(0xFFFBBC04) : AppTheme.textOrange;
    return isDark ? const Color(0xFFEA4335) : AppTheme.textPink;
  }

  String _fitnessLabel(double score) {
    if (score >= 75) return 'Exzellent';
    if (score >= 50) return 'Gut';
    if (score >= 25) return 'Verbesserbar';
    return 'Achtung';
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14))),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: color)),
        ],
      ),
    );
  }
}

class _HeartHealthSettingsScreen extends StatelessWidget {
  const _HeartHealthSettingsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Herzgesundheit Einstellungen')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ListTile(
            title: Text('Analyse-Zeitraum'),
            subtitle: Text('28 Tage'),
            trailing: Icon(Icons.chevron_right),
            enabled: false,
          ),
          SwitchListTile(
            title: const Text('Langzeit-Trend'),
            subtitle: const Text('Demnächst verfügbar'),
            value: false,
            onChanged: null,
          ),
        ],
      ),
    );
  }
}
