import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/plugins/plugin_interfaces.dart';
import '../derived/derived_providers.dart';
import '../../ui/theme/app_theme.dart';
import '../../ui/widgets/bouncing_card.dart';

class StressLoadFeature implements KernPlugin {
  @override
  String get id => 'stress_load';

  @override
  String get name => 'Stresslast';

  @override
  String get description =>
      'Misst die autonome Stressbelastung über das Verhältnis '
      'von Tages-HRV zur Nacht-HRV. Erkennt Stress, bevor du ihn fühlst.';

  @override
  List<PluginSlot> get supportedSlots => [PluginSlot.header, PluginSlot.footer, PluginSlot.main];

  @override
  Widget buildDashboardWidget(BuildContext context, PluginSlot slot) {
    return const _StressLoadWidget();
  }

  @override
  bool get hasDetailPage => true;

  @override
  Widget? buildDetailPage(BuildContext context) => const _StressLoadDetailScreen();

  @override
  Widget? buildSettingsPage(BuildContext context) => const _StressLoadSettingsScreen();
}

// ── Shared helpers ──────────────────────────────────────────────────────────

Color _slCategoryColor(int category, bool isDark) {
  switch (category) {
    case 0:
      return isDark ? const Color(0xFF34A853) : AppTheme.textMint;
    case 1:
      return isDark ? const Color(0xFF8AB4F8) : AppTheme.textBlue;
    case 2:
      return isDark ? const Color(0xFFFBBC04) : AppTheme.textOrange;
    case 3:
      return isDark ? const Color(0xFFEA4335) : AppTheme.textPink;
    case 4:
      return isDark ? const Color(0xFFB71C1C) : const Color(0xFFC62828);
    default:
      return AppTheme.textTertiary;
  }
}

IconData _slCategoryIcon(int category) {
  switch (category) {
    case 0:
      return Icons.self_improvement_rounded;
    case 1:
      return Icons.sentiment_satisfied_rounded;
    case 2:
      return Icons.sentiment_neutral_rounded;
    case 3:
      return Icons.sentiment_dissatisfied_rounded;
    case 4:
      return Icons.sentiment_very_dissatisfied_rounded;
    default:
      return Icons.hourglass_empty_rounded;
  }
}

String _slCategoryLabel(int category) {
  switch (category) {
    case 0:
      return 'Entspannt';
    case 1:
      return 'Leichter Stress';
    case 2:
      return 'Moderat';
    case 3:
      return 'Hoch';
    case 4:
      return 'Extrem';
    default:
      return 'Keine Daten';
  }
}

// ── Dashboard widget ────────────────────────────────────────────────────────

class _StressLoadWidget extends ConsumerWidget {
  const _StressLoadWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreAsync = ref.watch(stressLoadScoreProvider());
    final categoryAsync = ref.watch(stressLoadCategoryProvider());
    final ratioAsync = ref.watch(stressLoadRatioProvider());
    final dayAsync = ref.watch(stressLoadDaytimeHrvProvider());
    final nightAsync = ref.watch(stressLoadNighttimeBaselineProvider());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final score = scoreAsync.valueOrNull;
    final category = categoryAsync.valueOrNull ?? 5;
    final ratio = ratioAsync.valueOrNull;
    final dayHrv = dayAsync.valueOrNull;
    final nightHrv = nightAsync.valueOrNull;

    return BouncingCard(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const _StressLoadDetailScreen()),
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
                      color: _slCategoryColor(category, isDark).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(_slCategoryIcon(category), color: _slCategoryColor(category, isDark), size: 16),
                  ),
                  const SizedBox(width: 8),
                  const Text('Stresslast', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppTheme.textSecondary)),
                  const Spacer(),
                  Text(_slCategoryLabel(category), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _slCategoryColor(category, isDark))),
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
                  if (ratio != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: _slCategoryColor(category, isDark).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(_slCategoryLabel(category), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _slCategoryColor(category, isDark))),
                        ),
                        const SizedBox(height: 4),
                        Text('Ratio ${ratio.toStringAsFixed(2)}x', style: TextStyle(fontSize: 10, color: isDark ? Colors.white38 : AppTheme.textTertiary)),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 6),
              if (dayHrv != null && nightHrv != null)
                Row(
                  children: [
                    _slMiniMetric('Tag', dayHrv, AppTheme.textOrange, isDark),
                    const SizedBox(width: 12),
                    _slMiniMetric('Nacht', nightHrv, AppTheme.textPurple, isDark),
                  ],
                ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (score ?? 50) / 100,
                  minHeight: 4,
                  backgroundColor: isDark ? Colors.white12 : AppTheme.divider,
                  color: _slCategoryColor(category, isDark),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _slMiniMetric(String label, double value, Color color, bool isDark) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Text('$label: ', style: TextStyle(fontSize: 10, color: isDark ? Colors.white38 : AppTheme.textTertiary)),
            Text('${value.toInt()} ms', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }
}

// ── Detail screen ───────────────────────────────────────────────────────────

class _StressLoadDetailScreen extends ConsumerWidget {
  const _StressLoadDetailScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreAsync = ref.watch(stressLoadScoreProvider());
    final categoryAsync = ref.watch(stressLoadCategoryProvider());
    final ratioAsync = ref.watch(stressLoadRatioProvider());
    final dayAsync = ref.watch(stressLoadDaytimeHrvProvider());
    final nightAsync = ref.watch(stressLoadNighttimeBaselineProvider());
    final trendAsync = ref.watch(stressLoadBaselineTrendProvider());
    final recAsync = ref.watch(stressLoadRecommendationProvider());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final category = categoryAsync.valueOrNull ?? 5;
    final trend = trendAsync.valueOrNull ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Stresslast'), backgroundColor: Colors.transparent),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          _buildScoreRing(scoreAsync, category, ratioAsync, isDark, theme),
          const SizedBox(height: 24),
          _buildHrvComparison(dayAsync, nightAsync, ratioAsync, trend, isDark, theme),
          const SizedBox(height: 24),
          _buildRecommendation(recAsync, category, isDark, theme),
          const SizedBox(height: 24),
          _buildExplainer(category, isDark, theme),
        ],
      ),
    );
  }

  Widget _buildScoreRing(AsyncValue<double?> scoreAsync, int category, AsyncValue<double?> ratioAsync, bool isDark, ThemeData theme) {
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
                  color: _slCategoryColor(category, isDark),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  scoreAsync.when(
                    data: (s) => Text(s?.toStringAsFixed(0) ?? '50', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: _slCategoryColor(category, isDark), height: 1)),
                    loading: () => const SizedBox(width: 30, height: 30, child: CircularProgressIndicator(strokeWidth: 2)),
                    error: (_, __) => const Text('--'),
                  ),
                  const SizedBox(height: 4),
                  Text(_slCategoryLabel(category), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _slCategoryColor(category, isDark).withValues(alpha: 0.8))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('Stresslast', style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
          const SizedBox(height: 4),
          ratioAsync.when(
            data: (r) => r != null ? Text('Tag/Nacht Ratio: ${r.toStringAsFixed(2)}x', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: _slCategoryColor(category, isDark))) : const SizedBox(),
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildHrvComparison(AsyncValue<double?> dayAsync, AsyncValue<double?> nightAsync, AsyncValue<double?> ratioAsync, int trend, bool isDark, ThemeData theme) {
    final ratio = ratioAsync.valueOrNull ?? 1.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: isDark ? const Color(0xFF1E1E1E) : Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: theme.dividerColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('HRV-Analyse (14 Tage)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _slHrvCard(
                  icon: Icons.wb_sunny_rounded,
                  label: 'Tages-HRV',
                  value: dayAsync.valueOrNull,
                  color: AppTheme.textOrange,
                  isDark: isDark,
                  subtitle: '6:00 – 18:00 Uhr',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _slHrvCard(
                  icon: Icons.nightlight_round_rounded,
                  label: 'Nacht-HRV',
                  value: nightAsync.valueOrNull,
                  color: AppTheme.textPurple,
                  isDark: isDark,
                  subtitle: '22:00 – 06:00 Uhr',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.trending_up_rounded, size: 16, color: AppTheme.textTertiary),
              const SizedBox(width: 8),
              Text('Nacht-Baseline Trend: ', style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
              Text(
                trend == 1 ? 'Verbessert' : trend == -1 ? 'Verschlechtert' : 'Stabil',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: trend == 1 ? AppTheme.textMint : trend == -1 ? AppTheme.textPink : AppTheme.textTertiary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: ratio.clamp(0.0, 2.0) / 2.0,
                    minHeight: 8,
                    backgroundColor: isDark ? Colors.white12 : AppTheme.divider,
                    color: ratio >= 1.0 ? AppTheme.textMint : ratio >= 0.6 ? AppTheme.textOrange : AppTheme.textPink,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text('${(ratio * 100).toInt()}%', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _slHrvCard({required IconData icon, required String label, double? value, required Color color, required bool isDark, required String subtitle}) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.06), borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 6),
          Text(value != null ? '${value.toInt()}' : '--', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
          Text('ms', style: TextStyle(fontSize: 11, color: color.withValues(alpha: 0.7))),
          const SizedBox(height: 2),
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
          Text(subtitle, style: TextStyle(fontSize: 9, color: isDark ? Colors.white38 : AppTheme.textTertiary)),
        ],
      ),
    );
  }

  Widget _buildRecommendation(AsyncValue<String?> recAsync, int category, bool isDark, ThemeData theme) {
    return recAsync.when(
      data: (rec) => rec != null
          ? Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _slCategoryColor(category, isDark).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: _slCategoryColor(category, isDark).withValues(alpha: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [Icon(Icons.lightbulb_rounded, color: _slCategoryColor(category, isDark), size: 20), const SizedBox(width: 8), Text('Empfehlung', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _slCategoryColor(category, isDark)))]),
                  const SizedBox(height: 12),
                  Text(rec, style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.85), height: 1.5)),
                ],
              ),
            )
          : const SizedBox(),
      loading: () => const SizedBox(),
      error: (_, __) => const SizedBox(),
    );
  }

  Widget _buildExplainer(int category, bool isDark, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Was ist HRV-Stresslast?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(
            'Die Herzratenvariabilität (HRV) spiegelt das Gleichgewicht deines '
            'autonomen Nervensystems wider.\n\n'
            '• Hohe Nacht-HRV = gute Erholung, Parasympathikus aktiv\n'
            '• Niedrige Tages-HRV = Sympathikus dominant, Stressmodus\n\n'
            'Die Stresslast misst, wie stark deine Tages-HRV im Vergleich '
            'zu deiner persönlichen Nacht-Baseline abfällt. '
            'Ein Wert nahe 1.0 bedeutet: Du bist im Gleichgewicht. '
            'Werte unter 0.6 zeigen deutlichen physiologischen Stress.',
            style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurface.withValues(alpha: 0.7), height: 1.5),
          ),
        ],
      ),
    );
  }
}

// ── Settings screen ─────────────────────────────────────────────────────────

class _StressLoadSettingsScreen extends StatelessWidget {
  const _StressLoadSettingsScreen();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Stresslast Einstellungen')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ListTile(
            title: Text('Analyse-Fenster'),
            subtitle: Text('Tag: 06:00–18:00  ·  Nacht: 22:00–06:00'),
            trailing: Icon(Icons.chevron_right),
            enabled: false,
          ),
          const ListTile(
            title: Text('Baseline-Zeitraum'),
            subtitle: Text('14 Tage'),
          ),
          SwitchListTile(
            title: const Text('Stress-Warnung'),
            subtitle: const Text('Demnächst verfügbar'),
            value: false,
            onChanged: null,
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Kategorien (Tag/Nacht Ratio):\n'
              '≥ 1.0 → Entspannt  |  0.8–1.0 → Leicht  |  '
              '0.6–0.8 → Moderat  |  0.4–0.6 → Hoch  |  < 0.4 → Extrem\n\n'
              'Die Stresslast benötigt HRV-Daten (RMSSD) von einem kompatiblen '
              'Garmin-Gerät oder einer anderen Health Connect-Quelle.',
              style: TextStyle(fontSize: 13, height: 1.5, color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
            ),
          ),
        ],
      ),
    );
  }
}
