import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/plugins/plugin_interfaces.dart';
import '../derived/derived_providers.dart';
import '../../ui/theme/app_theme.dart';
import '../../ui/widgets/bouncing_card.dart';

class ConsistencyFeature implements KernPlugin {
  @override
  String get id => 'consistency';

  @override
  String get name => 'Aktivitätskonstanz';

  @override
  String get description =>
      'Bewertet, wie regelmäßig du aktiv bist. Konsistenz ist langfristig '
      'wichtiger als Intensität — mit Streak-Zähler.';

  @override
  List<PluginSlot> get supportedSlots => [PluginSlot.header, PluginSlot.footer];

  @override
  Widget buildDashboardWidget(BuildContext context, PluginSlot slot) {
    return const _ConsistencyWidget();
  }

  @override
  bool get hasDetailPage => true;

  @override
  Widget? buildDetailPage(BuildContext context) => const _ConsistencyDetailScreen();

  @override
  Widget? buildSettingsPage(BuildContext context) => null;
}

// ── Shared helpers ──────────────────────────────────────────────────────────

Color _conStateColor(int state, bool isDark) {
  switch (state) {
    case 3:
      return isDark ? const Color(0xFF34A853) : AppTheme.textMint;
    case 2:
      return isDark ? const Color(0xFF8AB4F8) : AppTheme.textBlue;
    case 1:
      return isDark ? const Color(0xFFFBBC04) : AppTheme.textOrange;
    default:
      return isDark ? const Color(0xFFEA4335) : AppTheme.textPink;
  }
}

String _conLabel(int state) {
  switch (state) {
    case 3:
      return 'Sehr konsistent';
    case 2:
      return 'Konsistent';
    case 1:
      return 'Moderat';
    default:
      return 'Unregelmäßig';
  }
}

// ── Dashboard widget ────────────────────────────────────────────────────────

class _ConsistencyWidget extends ConsumerWidget {
  const _ConsistencyWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreAsync = ref.watch(consistencyOverallScoreProvider());
    final stateAsync = ref.watch(consistencyStateProvider());
    final streakAsync = ref.watch(consistencyStreakProvider());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final score = scoreAsync.valueOrNull;
    final state = stateAsync.valueOrNull ?? 0;
    final streak = streakAsync.valueOrNull;

    return BouncingCard(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const _ConsistencyDetailScreen()),
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
                      color: _conStateColor(state, isDark).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.repeat_rounded, color: _conStateColor(state, isDark), size: 16),
                  ),
                  const SizedBox(width: 8),
                  const Text('Aktivitätskonstanz', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppTheme.textSecondary)),
                  const Spacer(),
                  Text(_conLabel(state), style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _conStateColor(state, isDark))),
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
                  if (streak != null && streak > 0)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppTheme.accentOrange,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.local_fire_department_rounded, color: AppTheme.textOrange, size: 14),
                          const SizedBox(width: 3),
                          Text('${streak.toInt()} Tage', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppTheme.textOrange)),
                        ],
                      ),
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
                  color: _conStateColor(state, isDark),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Detail screen ───────────────────────────────────────────────────────────

class _ConsistencyDetailScreen extends ConsumerWidget {
  const _ConsistencyDetailScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overallAsync = ref.watch(consistencyOverallScoreProvider());
    final stepsAsync = ref.watch(consistencyStepsScoreProvider());
    final energyAsync = ref.watch(consistencyEnergyScoreProvider());
    final stateAsync = ref.watch(consistencyStateProvider());
    final activeAsync = ref.watch(consistencyActiveDaysProvider());
    final streakAsync = ref.watch(consistencyStreakProvider());
    final bestStreakAsync = ref.watch(consistencyBestStreakProvider());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final state = stateAsync.valueOrNull ?? 0;
    final streak = (streakAsync.valueOrNull ?? 0).toInt();
    final bestStreak = (bestStreakAsync.valueOrNull ?? 0).toInt();

    return Scaffold(
      appBar: AppBar(title: const Text('Aktivitätskonstanz'), backgroundColor: Colors.transparent),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          _buildScoreRing(overallAsync, state, isDark, theme),
          const SizedBox(height: 24),
          _buildSubScores(stepsAsync, energyAsync, isDark, theme),
          const SizedBox(height: 24),
          _buildStreaks(streak, bestStreak, activeAsync, isDark, theme),
          const SizedBox(height: 24),
          _buildExplainer(state, isDark, theme),
        ],
      ),
    );
  }

  Widget _buildScoreRing(AsyncValue<double?> overallAsync, int state, bool isDark, ThemeData theme) {
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
                  value: (overallAsync.valueOrNull ?? 50) / 100,
                  strokeWidth: 14,
                  backgroundColor: isDark ? Colors.white12 : AppTheme.divider,
                  color: _conStateColor(state, isDark),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  overallAsync.when(
                    data: (s) => Text(s?.toStringAsFixed(0) ?? '50', style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: _conStateColor(state, isDark), height: 1)),
                    loading: () => const SizedBox(width: 30, height: 30, child: CircularProgressIndicator(strokeWidth: 2)),
                    error: (_, __) => const Text('--'),
                  ),
                  const SizedBox(height: 4),
                  Text(_conLabel(state), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _conStateColor(state, isDark).withValues(alpha: 0.8))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('Konstanz-Score', style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
        ],
      ),
    );
  }

  Widget _buildSubScores(AsyncValue<double?> stepsAsync, AsyncValue<double?> energyAsync, bool isDark, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: isDark ? const Color(0xFF1E1E1E) : Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: theme.dividerColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Teilbereiche', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _SubScoreRow(icon: Icons.directions_walk_rounded, label: 'Schritte', score: stepsAsync.valueOrNull, color: AppTheme.textBlue, isDark: isDark),
          const SizedBox(height: 10),
          _SubScoreRow(icon: Icons.local_fire_department_rounded, label: 'Aktive Kalorien', score: energyAsync.valueOrNull, color: AppTheme.textOrange, isDark: isDark),
        ],
      ),
    );
  }

  Widget _buildStreaks(int streak, int bestStreak, AsyncValue<double?> activeAsync, bool isDark, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: isDark ? const Color(0xFF1E1E1E) : Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: theme.dividerColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Streaks (14 Tage)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _StreakCard(
                  icon: Icons.local_fire_department_rounded,
                  label: 'Aktuell',
                  value: '$streak Tage',
                  color: AppTheme.textOrange,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StreakCard(
                  icon: Icons.emoji_events_rounded,
                  label: 'Bestwert',
                  value: '$bestStreak Tage',
                  color: AppTheme.textMint,
                  isDark: isDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          activeAsync.when(
            data: (active) => active != null
                ? Row(
                    children: [
                      const Icon(Icons.check_circle_rounded, color: AppTheme.textMint, size: 16),
                      const SizedBox(width: 8),
                      Text('${active.toInt()} von 14 Tagen aktiv', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                    ],
                  )
                : const SizedBox(),
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildExplainer(int state, bool isDark, ThemeData theme) {
    String msg;
    if (state >= 3) {
      msg = 'Exzellent! Deine tägliche Aktivität ist sehr regelmäßig. '
          'Diese Konstanz ist der beste Prädiktor für langfristige Gesundheitsverbesserungen. '
          'Weiter so!';
    } else if (state >= 2) {
      msg = 'Gute Konsistenz. Deine Aktivität ist weitgehend regelmäßig '
          'mit nur gelegentlichen Schwankungen. Versuche, die Anzahl deiner '
          'aktiven Tage pro Woche konstant zu halten.';
    } else if (state >= 1) {
      msg = 'Deine Aktivität schwankt stark von Tag zu Tag. '
          'Versuche, eine tägliche Mindestaktivität zu etablieren — '
          'schon 5.000 Schritte pro Tag machen einen großen Unterschied.';
    } else {
      msg = 'Deine Aktivität ist sehr unregelmäßig. '
          'Setze dir ein realistisches Tagesziel und versuche, '
          'jeden Tag mindestens eine kleine Bewegungseinheit einzubauen.';
    }
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _conStateColor(state, isDark).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _conStateColor(state, isDark).withValues(alpha: 0.2)),
      ),
      child: Text(msg, style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.85), height: 1.5)),
    );
  }
}

class _SubScoreRow extends StatelessWidget {
  const _SubScoreRow({required this.icon, required this.label, required this.score, required this.color, required this.isDark});
  final IconData icon;
  final String label;
  final double? score;
  final Color color;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(width: 32, height: 32, decoration: BoxDecoration(color: color.withValues(alpha: 0.10), shape: BoxShape.circle), child: Icon(icon, color: color, size: 16)),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurface.withValues(alpha: 0.7)))),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.10), borderRadius: BorderRadius.circular(10)),
          child: Text(score != null ? '${score!.toInt()} Punkte' : '--', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
        ),
      ],
    );
  }
}

class _StreakCard extends StatelessWidget {
  const _StreakCard({required this.icon, required this.label, required this.value, required this.color, required this.isDark});
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(fontSize: 11, color: color.withValues(alpha: 0.7))),
        ],
      ),
    );
  }
}
