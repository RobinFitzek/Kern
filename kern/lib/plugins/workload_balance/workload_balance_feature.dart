import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/plugins/plugin_interfaces.dart';
import '../derived/derived_providers.dart';
import '../../ui/theme/app_theme.dart';
import '../../ui/widgets/bouncing_card.dart';

class WorkloadBalanceFeature implements KernPlugin {
  @override
  String get id => 'workload_balance';

  @override
  String get name => 'Belastungsbalance';

  @override
  String get description =>
      'TSB-ähnliches Verhältnis von Trainingsbelastung zu Erholung. '
      'Sagt dir, ob du heute hart trainieren oder dich erholen solltest.';

  @override
  List<PluginSlot> get supportedSlots => [PluginSlot.header, PluginSlot.footer, PluginSlot.main];

  @override
  Widget buildDashboardWidget(BuildContext context, PluginSlot slot) {
    return const _WbDashboardWidget();
  }

  @override
  bool get hasDetailPage => true;

  @override
  Widget? buildDetailPage(BuildContext context) => const _WbDetailScreen();

  @override
  Widget? buildSettingsPage(BuildContext context) => const _WbSettingsScreen();
}

// ── Shared helpers ──────────────────────────────────────────────────────────

Color _wbStateColor(int state, bool isDark) {
  switch (state) {
    case 0:
      return AppTheme.textTertiary;
    case 1:
      return isDark ? const Color(0xFF34A853) : AppTheme.textMint;
    case 2:
      return isDark ? const Color(0xFF8AB4F8) : AppTheme.textBlue;
    case 3:
      return isDark ? const Color(0xFFFBBC04) : AppTheme.textOrange;
    case 4:
      return isDark ? const Color(0xFFEA4335) : AppTheme.textPink;
    default:
      return AppTheme.textTertiary;
  }
}

IconData _wbStateIcon(int state) {
  switch (state) {
    case 0:
      return Icons.hourglass_empty_rounded;
    case 1:
      return Icons.fitness_center_rounded;
    case 2:
      return Icons.balance_rounded;
    case 3:
      return Icons.speed_rounded;
    case 4:
      return Icons.warning_rounded;
    default:
      return Icons.hourglass_empty_rounded;
  }
}

String _wbStateLabel(int state) {
  switch (state) {
    case 0:
      return 'Wenig Daten';
    case 1:
      return 'Trainingsbereit';
    case 2:
      return 'Optimal';
    case 3:
      return 'Überlastet';
    case 4:
      return 'Übertrainiert';
    default:
      return 'Kalibrierung';
  }
}

String _wbStateExplainer(int state) {
  switch (state) {
    case 0:
      return 'Noch nicht genug Trainingsdaten für eine aussagekräftige Analyse. '
          'Sammle mindestens 7 Tage Aktivitätsdaten.';
    case 1:
      return 'Deine Erholung übersteigt deine Belastung deutlich. '
          'Du hast Kapazität für ein intensives Training — dein Körper ist bereit.';
    case 2:
      return 'Deine Trainingsbelastung und Erholung sind gut ausbalanciert. '
          'Du trainierst weder zu viel noch zu wenig.';
    case 3:
      return 'Deine Belastung liegt über deiner Erholungskapazität. '
          'Das ist funktionelles Overreaching — kurzfristig okay, aber plane bald einen leichteren Tag ein.';
    case 4:
      return 'Deine Belastung übersteigt deine Erholung kritisch. '
          'Hohes Risiko für Übertraining, Verletzung und Leistungsabfall. Ein Ruhetag ist dringend nötig.';
    default:
      return '';
  }
}

// ── Dashboard widget ────────────────────────────────────────────────────────

class _WbDashboardWidget extends ConsumerWidget {
  const _WbDashboardWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreAsync = ref.watch(workloadBalanceScoreProvider());
    final ratioAsync = ref.watch(workloadBalanceRatioProvider());
    final stateAsync = ref.watch(workloadBalanceStateProvider());
    final trendAsync = ref.watch(workloadBalanceTrendProvider());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final score = scoreAsync.valueOrNull;
    final ratio = ratioAsync.valueOrNull;
    final state = stateAsync.valueOrNull ?? 0;
    final trend = trendAsync.valueOrNull ?? 1;

    return BouncingCard(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const _WbDetailScreen()),
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
                      color: _wbStateColor(state, isDark).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(_wbStateIcon(state), color: _wbStateColor(state, isDark), size: 16),
                  ),
                  const SizedBox(width: 8),
                  const Text('Belastungsbalance', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppTheme.textSecondary)),
                  const Spacer(),
                  _WbTrendChip(trend: trend, isDark: isDark),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    score?.toStringAsFixed(0) ?? '--',
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface, height: 1),
                  ),
                  const SizedBox(width: 6),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Text('Punkte', style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
                  ),
                  const Spacer(),
                  if (state != 0 && ratio != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _wbStateColor(state, isDark).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(_wbStateLabel(state), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _wbStateColor(state, isDark))),
                        ),
                        const SizedBox(height: 4),
                        Text('Ratio ${ratio.toStringAsFixed(1)}x', style: TextStyle(fontSize: 10, color: isDark ? Colors.white38 : AppTheme.textTertiary)),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (score ?? 50) / 100,
                  minHeight: 4,
                  backgroundColor: isDark ? Colors.white12 : AppTheme.divider,
                  color: _wbStateColor(state, isDark),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WbTrendChip extends StatelessWidget {
  const _WbTrendChip({required this.trend, required this.isDark});
  final int trend;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    IconData icon;
    String label;
    Color color;
    switch (trend) {
      case 2:
        icon = Icons.trending_up_rounded;
        label = 'Entlastend';
        color = AppTheme.textMint;
        break;
      case 0:
        icon = Icons.trending_down_rounded;
        label = 'Steigend';
        color = AppTheme.textPink;
        break;
      default:
        icon = Icons.trending_flat_rounded;
        label = 'Stabil';
        color = AppTheme.textTertiary;
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 3),
        Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: color)),
      ],
    );
  }
}

// ── Detail screen ───────────────────────────────────────────────────────────

class _WbDetailScreen extends ConsumerWidget {
  const _WbDetailScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreAsync = ref.watch(workloadBalanceScoreProvider());
    final ratioAsync = ref.watch(workloadBalanceRatioProvider());
    final stateAsync = ref.watch(workloadBalanceStateProvider());
    final acuteAsync = ref.watch(workloadBalanceAcuteLoadProvider());
    final chronicAsync = ref.watch(workloadBalanceChronicLoadProvider());
    final recoveryAsync = ref.watch(workloadBalanceRecoveryLevelProvider());
    final readinessAsync = ref.watch(workloadBalanceReadinessLevelProvider());
    final adviceAsync = ref.watch(workloadBalanceTrainingAdviceProvider());
    final trendAsync = ref.watch(workloadBalanceTrendProvider());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final state = stateAsync.valueOrNull ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Belastungsbalance'), backgroundColor: Colors.transparent),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          _buildScoreRing(scoreAsync, ratioAsync, state, isDark, theme),
          const SizedBox(height: 24),
          _buildMetricsGrid(acuteAsync, chronicAsync, recoveryAsync, readinessAsync, isDark, theme),
          const SizedBox(height: 24),
          _buildStateExplainer(state, isDark, theme),
          const SizedBox(height: 24),
          _buildAdvice(adviceAsync, state, isDark, theme),
        ],
      ),
    );
  }

  Widget _buildScoreRing(AsyncValue<double?> scoreAsync, AsyncValue<double?> ratioAsync, int state, bool isDark, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: CircularProgressIndicator(
                  value: (scoreAsync.valueOrNull ?? 50) / 100,
                  strokeWidth: 14,
                  backgroundColor: isDark ? Colors.white12 : AppTheme.divider,
                  color: _wbStateColor(state, isDark),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  scoreAsync.when(
                    data: (s) => Text(s?.toStringAsFixed(0) ?? '50', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: _wbStateColor(state, isDark), height: 1)),
                    loading: () => const SizedBox(width: 30, height: 30, child: CircularProgressIndicator(strokeWidth: 2)),
                    error: (_, __) => const Text('--', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: AppTheme.textTertiary)),
                  ),
                  const SizedBox(height: 4),
                  Text(_wbStateLabel(state), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _wbStateColor(state, isDark).withValues(alpha: 0.8))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('Belastungs-Balance', style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
          const SizedBox(height: 4),
          ratioAsync.when(
            data: (r) => r != null ? Text('Ratio: ${r.toStringAsFixed(2)}x', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _wbStateColor(state, isDark))) : const SizedBox(),
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(AsyncValue<double?> acuteAsync, AsyncValue<double?> chronicAsync, AsyncValue<double?> recoveryAsync, AsyncValue<double?> readinessAsync, bool isDark, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: isDark ? const Color(0xFF1E1E1E) : Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: theme.dividerColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Kennzahlen (7-Tage Ø)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _WbMetricRow(
            icon: Icons.trending_up_rounded,
            label: 'Akute Belastung',
            value: acuteAsync.valueOrNull,
            suffix: 'Punkte',
            color: AppTheme.textOrange,
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          _WbMetricRow(
            icon: Icons.history_rounded,
            label: 'Chronische Belastung (28d)',
            value: chronicAsync.valueOrNull,
            suffix: 'Punkte',
            color: AppTheme.textPink,
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          _WbMetricRow(
            icon: Icons.healing_rounded,
            label: 'Erholung',
            value: recoveryAsync.valueOrNull,
            suffix: 'Punkte',
            color: AppTheme.textMint,
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          _WbMetricRow(
            icon: Icons.bolt_rounded,
            label: 'Readiness',
            value: readinessAsync.valueOrNull,
            suffix: 'Punkte',
            color: AppTheme.textBlue,
            isDark: isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildStateExplainer(int state, bool isDark, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _wbStateColor(state, isDark).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _wbStateColor(state, isDark).withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(_wbStateIcon(state), color: _wbStateColor(state, isDark), size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              _wbStateExplainer(state),
              style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.85), height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvice(AsyncValue<String?> adviceAsync, int state, bool isDark, ThemeData theme) {
    return adviceAsync.when(
      data: (advice) => advice != null
          ? Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb_rounded, color: _wbStateColor(state, isDark), size: 20),
                      const SizedBox(width: 8),
                      Text('Trainingsempfehlung', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _wbStateColor(state, isDark))),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(advice, style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.85), height: 1.5)),
                ],
              ),
            )
          : const SizedBox(),
      loading: () => const SizedBox(),
      error: (_, __) => const SizedBox(),
    );
  }
}

// ── Reusable metric row ─────────────────────────────────────────────────────

class _WbMetricRow extends StatelessWidget {
  const _WbMetricRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.suffix,
    required this.color,
    required this.isDark,
  });
  final IconData icon;
  final String label;
  final double? value;
  final String suffix;
  final Color color;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(color: color.withValues(alpha: 0.10), shape: BoxShape.circle),
          child: Icon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label, style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurface.withValues(alpha: 0.7))),
        ),
        Text(
          value != null ? '${value!.toStringAsFixed(0)} $suffix' : '--',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface),
        ),
      ],
    );
  }
}

// ── Settings screen ─────────────────────────────────────────────────────────

class _WbSettingsScreen extends StatelessWidget {
  const _WbSettingsScreen();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Belastungsbalance Einstellungen')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ListTile(
            title: Text('Analyse-Zeiträume'),
            subtitle: Text('Akut: 7 Tage  ·  Chronisch: 28 Tage'),
            trailing: Icon(Icons.chevron_right),
            enabled: false,
          ),
          SwitchListTile(
            title: const Text('Übertraining-Warnung'),
            subtitle: const Text('Demnächst verfügbar'),
            value: false,
            onChanged: null,
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Die Belastungsbalance vergleicht deine kurzfristige Trainingsbelastung '
              '(7-Tage Strain Score) mit deiner Erholungskapazität '
              '(Recovery Score) und gibt eine Trainingsempfehlung.\n\n'
              'Ratio < 0.4 → Trainingsbereit  '
              'Ratio 0.4–1.2 → Optimal  '
              'Ratio 1.2–1.8 → Überlastet  '
              'Ratio > 1.8 → Übertrainiert',
              style: TextStyle(fontSize: 13, height: 1.5, color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
            ),
          ),
        ],
      ),
    );
  }
}
