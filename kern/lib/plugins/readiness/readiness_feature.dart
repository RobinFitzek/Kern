import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/plugins/plugin_interfaces.dart';
import '../derived/derived_providers.dart';
import '../../ui/theme/app_theme.dart';
import '../../ui/widgets/bouncing_card.dart';
import '../../ui/widgets/readiness_checkin_sheet.dart';
import '../../ui/widgets/calibration_banner.dart';
import '../../ui/widgets/error_state_widget.dart';

class ReadinessFeature implements KernPlugin {
  @override
  String get id => 'readiness';
  @override
  String get name => 'Readiness Score';
  @override
  String get description => 'Bimodaler Physical & Mental Readiness Score basierend auf HRV, Schlaf und Belastung.';
  @override
  List<PluginSlot> get supportedSlots => [PluginSlot.main, PluginSlot.header];
  @override
  Widget buildDashboardWidget(BuildContext context, PluginSlot slot) {
    if (slot == PluginSlot.main) return const _ReadinessMainWidget();
    return const _ReadinessHeaderWidget();
  }
  @override
  Widget? buildDetailPage(BuildContext context) => const ReadinessDetailScreen();
  @override
  bool get hasDetailPage => true;
  @override
  Widget? buildSettingsPage(BuildContext context) => const ReadinessSettingsScreen();
}

// ── Color helpers ─────────────────────────────────────────────────────────────

Color _scoreColor(double score, bool isDark) {
  if (score >= 85) return isDark ? const Color(0xFF34A853) : AppTheme.textMint;
  if (score >= 70) return isDark ? const Color(0xFFFBBC04) : AppTheme.textOrange;
  return isDark ? const Color(0xFFEA4335) : AppTheme.textPink;
}

Color _scoreAccent(double score, bool isDark) {
  if (score >= 85) return isDark ? const Color(0xFF0D3320) : AppTheme.accentMint;
  if (score >= 70) return isDark ? const Color(0xFF3A2C00) : AppTheme.accentOrange;
  return isDark ? const Color(0xFF3C0D0D) : AppTheme.accentPink;
}

String _scoreLabel(double score) {
  if (score >= 85) return 'Optimal';
  if (score >= 70) return 'Gut';
  if (score >= 55) return 'Mittel';
  return 'Niedrig';
}

// ── Dashboard main widget ─────────────────────────────────────────────────────

class _ReadinessMainWidget extends ConsumerWidget {
  const _ReadinessMainWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoresAsync = ref.watch(readinessBimodalScoresProvider());
    final feedbackAsync = ref.watch(todayFeedbackProvider);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hasFeedback = feedbackAsync.valueOrNull != null;

    return BouncingCard(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ReadinessDetailScreen()),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.bolt_rounded, color: AppTheme.textMint, size: 20),
                  const SizedBox(width: 8),
                  const Text('Readiness', style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  if (!hasFeedback)
                    GestureDetector(
                      onTap: () => showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (_) => const ReadinessCheckInSheet(),
                      ),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.accentOrange,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.wb_sunny_rounded, size: 12, color: AppTheme.textOrange),
                            SizedBox(width: 4),
                            Text('Check-in', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppTheme.textOrange)),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              scoresAsync.when(
                data: (scores) {
                  final phys = scores.physical;
                  final ment = scores.mental;
                  if (phys == null && ment == null) {
                    return const CalibrationBanner();
                  }
                  return Row(
                    children: [
                      Expanded(child: _ScoreRingMini(
                        score: phys ?? 50,
                        label: 'Physisch',
                        color: _scoreColor(phys ?? 50, isDark),
                        accent: _scoreAccent(phys ?? 50, isDark),
                        isDark: isDark,
                      )),
                      const SizedBox(width: 12),
                      Expanded(child: _ScoreRingMini(
                        score: ment ?? 50,
                        label: 'Mental',
                        color: isDark ? const Color(0xFF8AB4F8) : AppTheme.textBlue,
                        accent: isDark ? const Color(0xFF1A2744) : AppTheme.accentBlue,
                        isDark: isDark,
                      )),
                    ],
                  );
                },
                loading: () => const SizedBox(height: 100, child: Center(child: CircularProgressIndicator())),
                error: (_, __) => const ErrorStateWidget(
                  type: ErrorDisplayType.error,
                  message: 'Readiness Score konnte nicht geladen werden',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}

class _ScoreRingMini extends StatelessWidget {
  const _ScoreRingMini({required this.score, required this.label, required this.color, required this.accent, required this.isDark});
  final double score;
  final String label;
  final Color color;
  final Color accent;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 84,
              height: 84,
              child: CircularProgressIndicator(
                value: score / 100,
                strokeWidth: 8,
                backgroundColor: isDark ? Colors.white12 : AppTheme.divider,
                color: color,
                strokeCap: StrokeCap.round,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(score.toStringAsFixed(0), style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: color, height: 1)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(8)),
          child: Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
        ),
        const SizedBox(height: 2),
        Text(_scoreLabel(score), style: TextStyle(fontSize: 11, color: isDark ? Colors.white38 : AppTheme.textTertiary)),
      ],
    );
  }
}

// ── Header widget ─────────────────────────────────────────────────────────────

class _ReadinessHeaderWidget extends ConsumerWidget {
  const _ReadinessHeaderWidget();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoresAsync = ref.watch(readinessBimodalScoresProvider());
    return Container(
      width: 150,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppTheme.accentMint, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(children: [
            Icon(Icons.bolt_rounded, color: AppTheme.textMint, size: 14),
            SizedBox(width: 4),
            Text('Readiness', style: TextStyle(color: AppTheme.textMint, fontSize: 11, fontWeight: FontWeight.w600)),
          ]),
          const SizedBox(height: 8),
          scoresAsync.when(
            data: (s) => Row(
              children: [
                Text(s.physical?.toStringAsFixed(0) ?? '--', style: const TextStyle(color: AppTheme.textMint, fontSize: 22, fontWeight: FontWeight.bold)),
                const Text(' / ', style: TextStyle(color: AppTheme.textMint, fontSize: 14)),
                Text(s.mental?.toStringAsFixed(0) ?? '--', style: const TextStyle(color: AppTheme.textBlue, fontSize: 22, fontWeight: FontWeight.bold)),
              ],
            ),
            loading: () => const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)),
            error: (_, __) => const Text('!'),
          ),
        ],
      ),
    );
  }
}

// ── Detail Screen ─────────────────────────────────────────────────────────────

class ReadinessDetailScreen extends ConsumerWidget {
  const ReadinessDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoresAsync = ref.watch(readinessBimodalScoresProvider());
    final physCompAsync = ref.watch(readinessPhysicalComponentsProvider());
    final mentCompAsync = ref.watch(readinessMentalComponentsProvider());
    final feedbackAsync = ref.watch(todayFeedbackProvider);
    final acwrAsync = ref.watch(readinessAcwrProvider());
    final sriAsync = ref.watch(readinessSriProvider());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Readiness'),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.wb_sunny_rounded),
            tooltip: 'Morgen-Check',
            onPressed: () => showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              builder: (_) => const ReadinessCheckInSheet(),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        children: [
          // Dual score rings
          scoresAsync.when(
            data: (scores) => _buildDualRings(context, scores.physical, scores.mental, isDark),
            loading: () => const SizedBox(height: 200, child: Center(child: CircularProgressIndicator())),
            error: (_, __) => const SizedBox(),
          ),
          const SizedBox(height: 24),

          // Morning check-in CTA
          feedbackAsync.when(
            data: (fb) => fb == null ? _buildCheckInCta(context, isDark) : _buildFeedbackSummary(context, fb, isDark),
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          ),
          const SizedBox(height: 24),

          // Physical components
          _buildSectionHeader(context, 'Physische Bereitschaft', Icons.directions_run_rounded, _scoreColor(scoresAsync.value?.physical ?? 50, isDark)),
          const SizedBox(height: 12),
          physCompAsync.when(
            data: (comp) => comp == null
                ? _buildNoDataCard(context, isDark)
                : _buildPhysicalComponents(context, comp, acwrAsync.value, isDark),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const SizedBox(),
          ),
          const SizedBox(height: 24),

          // Mental components
          _buildSectionHeader(context, 'Mentale Bereitschaft', Icons.psychology_rounded, isDark ? const Color(0xFF8AB4F8) : AppTheme.textBlue),
          const SizedBox(height: 12),
          mentCompAsync.when(
            data: (comp) => comp == null
                ? _buildNoDataCard(context, isDark)
                : _buildMentalComponents(context, comp, sriAsync.value, isDark),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const SizedBox(),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildDualRings(BuildContext context, double? phys, double? ment, bool isDark) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Expanded(child: _buildLargeRing(
            score: phys,
            label: 'Physisch',
            subtitle: 'Erholung & Kraft',
            color: _scoreColor(phys ?? 50, isDark),
            accent: _scoreAccent(phys ?? 50, isDark),
            isDark: isDark,
          )),
          Container(width: 1, height: 140, color: theme.dividerColor),
          Expanded(child: _buildLargeRing(
            score: ment,
            label: 'Mental',
            subtitle: 'Fokus & Resilienz',
            color: isDark ? const Color(0xFF8AB4F8) : AppTheme.textBlue,
            accent: isDark ? const Color(0xFF1A2744) : AppTheme.accentBlue,
            isDark: isDark,
          )),
        ],
      ),
    );
  }

  Widget _buildLargeRing({double? score, required String label, required String subtitle, required Color color, required Color accent, required bool isDark}) {
    final v = score ?? 50;
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: CircularProgressIndicator(
                value: v / 100,
                strokeWidth: 12,
                backgroundColor: isDark ? Colors.white12 : AppTheme.divider,
                color: color,
                strokeCap: StrokeCap.round,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(score != null ? v.toStringAsFixed(0) : '--',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: color, height: 1)),
                Text(_scoreLabel(v), style: TextStyle(fontSize: 11, color: color.withValues(alpha: 0.7))),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(label, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppTheme.textPrimary)),
        Text(subtitle, style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : AppTheme.textTertiary)),
      ],
    );
  }

  Widget _buildCheckInCta(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => const ReadinessCheckInSheet(),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF2A2200) : AppTheme.accentOrange,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppTheme.textOrange.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            Icon(Icons.wb_sunny_rounded, color: AppTheme.textOrange, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Morgen-Check ausstehend', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textOrange)),
                  Text('Dein subjektives Feedback verfeinert den Bayesschen Score', style: TextStyle(fontSize: 12, color: AppTheme.textOrange.withValues(alpha: 0.7))),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: AppTheme.textOrange),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackSummary(BuildContext context, UserFeedbackViewModel fb, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0D2215) : AppTheme.accentMint,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded, color: AppTheme.textMint),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Morgen-Check abgeschlossen', style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.textMint)),
                Text('Muskelkater ${fb.soreness.toStringAsFixed(0)}  ·  Energie ${fb.energy.toStringAsFixed(0)}  ·  Stress ${fb.stress.toStringAsFixed(0)}',
                    style: const TextStyle(fontSize: 12, color: AppTheme.textMint)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 8),
        Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
      ],
    );
  }

  Widget _buildNoDataCard(BuildContext context, bool isDark) {
    return const ErrorStateWidget(
      type: ErrorDisplayType.noData,
      message: 'Noch nicht genug Daten',
    );
  }

  Widget _buildPhysicalComponents(BuildContext context, Map<String, double> comp, double? acwr, bool isDark) {
    return Column(
      children: [
        _ComponentBar(label: 'HRV (RMSSD)', icon: Icons.favorite_rounded, color: AppTheme.textPink, score: comp['hrv_score'] ?? 50, detail: '${comp['today_hrv_ms']?.toStringAsFixed(0) ?? '--'} ms', isDark: isDark),
        const SizedBox(height: 8),
        _ComponentBar(label: 'Ruhepuls', icon: Icons.monitor_heart_rounded, color: AppTheme.textOrange, score: comp['rhr_score'] ?? 50, detail: '${comp['today_rhr_bpm']?.toStringAsFixed(0) ?? '--'} bpm', isDark: isDark),
        const SizedBox(height: 8),
        _ComponentBar(label: 'Tiefschlaf', icon: Icons.nightlight_rounded, color: AppTheme.textPurple, score: comp['deep_score'] ?? 50, detail: '${comp['today_deep_min']?.toStringAsFixed(0) ?? '--'} min', isDark: isDark),
        const SizedBox(height: 8),
        _ComponentBar(label: 'Gesamtschlaf', icon: Icons.bedtime_rounded, color: AppTheme.textBlue, score: comp['tst_score'] ?? 50, detail: '${((comp['today_tst_min'] ?? 0) / 60).toStringAsFixed(1)} h', isDark: isDark),
        if (acwr != null) ...[
          const SizedBox(height: 8),
          _AcwrBar(acwr: acwr, penalty: comp['acwr_penalty'] ?? 0, isDark: isDark),
        ],
      ],
    );
  }

  Widget _buildMentalComponents(BuildContext context, Map<String, double> comp, double? sri, bool isDark) {
    return Column(
      children: [
        _ComponentBar(label: 'REM-Schlaf', icon: Icons.auto_awesome_rounded, color: AppTheme.textPurple, score: comp['rem_score'] ?? 50, detail: '${comp['today_rem_min']?.toStringAsFixed(0) ?? '--'} min', isDark: isDark),
        const SizedBox(height: 8),
        _ComponentBar(label: 'Schlafregularität (SRI)', icon: Icons.schedule_rounded, color: AppTheme.textBlue, score: comp['sri_score'] ?? 50, detail: sri != null ? '${sri.toStringAsFixed(0)} / 100' : 'Kalibrierung', isDark: isDark),
        const SizedBox(height: 8),
        _ComponentBar(label: 'HRV-Stabilität', icon: Icons.ssid_chart_rounded, color: AppTheme.textMint, score: comp['cv_score'] ?? 50, detail: 'CV-Analyse', isDark: isDark),
        const SizedBox(height: 8),
        _ComponentBar(label: 'Schlafeffizienz', icon: Icons.timelapse_rounded, color: AppTheme.textOrange, score: comp['efficiency_score'] ?? 50, detail: '${comp['today_efficiency_pct']?.toStringAsFixed(0) ?? '--'}%', isDark: isDark),
      ],
    );
  }
}

class _ComponentBar extends StatelessWidget {
  const _ComponentBar({required this.label, required this.icon, required this.color, required this.score, required this.detail, required this.isDark});
  final String label;
  final IconData icon;
  final Color color;
  final double score;
  final String detail;
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
            width: 36, height: 36,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface)),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: score / 100,
                    minHeight: 6,
                    backgroundColor: isDark ? Colors.white12 : AppTheme.divider,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${score.toStringAsFixed(0)}', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color)),
              Text(detail, style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
            ],
          ),
        ],
      ),
    );
  }
}

class _AcwrBar extends StatelessWidget {
  const _AcwrBar({required this.acwr, required this.penalty, required this.isDark});
  final double acwr;
  final double penalty;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isGood = acwr >= 0.8 && acwr <= 1.3;
    final color = isGood ? AppTheme.textMint : AppTheme.textPink;
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
            width: 36, height: 36,
            decoration: BoxDecoration(color: color.withValues(alpha: 0.12), shape: BoxShape.circle),
            child: Icon(Icons.trending_up_rounded, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ACWR Belastung', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface)),
                const SizedBox(height: 2),
                Text(isGood ? 'Sweet Spot (0.8–1.3)' : 'Penalty: -${penalty.toStringAsFixed(0)} Punkte', style: TextStyle(fontSize: 11, color: color)),
              ],
            ),
          ),
          Text(acwr.toStringAsFixed(2), style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }
}

// ── Settings ──────────────────────────────────────────────────────────────────

class ReadinessSettingsScreen extends ConsumerStatefulWidget {
  const ReadinessSettingsScreen({super.key});

  @override
  ConsumerState<ReadinessSettingsScreen> createState() => _ReadinessSettingsScreenState();
}

class _ReadinessSettingsScreenState extends ConsumerState<ReadinessSettingsScreen> {
  bool _includeHrv = true;
  bool _includeSleep = true;
  bool _morningReminder = false;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _includeHrv = prefs.getBool('readiness_include_hrv') ?? true;
      _includeSleep = prefs.getBool('readiness_include_sleep') ?? true;
      _morningReminder = prefs.getBool('readiness_morning_reminder') ?? false;
      _loaded = true;
    });
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('readiness_include_hrv', _includeHrv);
    await prefs.setBool('readiness_include_sleep', _includeSleep);
    await prefs.setBool('readiness_morning_reminder', _morningReminder);
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(title: const Text('Readiness Einstellungen')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('HRV-Daten einbeziehen'),
            subtitle: const Text('RMSSD als primären Biomarker verwenden'),
            value: _includeHrv,
            onChanged: (val) {
              setState(() => _includeHrv = val);
              _save();
            },
          ),
          SwitchListTile(
            title: const Text('Schlafdaten einbeziehen'),
            subtitle: const Text('Tiefschlaf, REM und Schlafregularität'),
            value: _includeSleep,
            onChanged: (val) {
              setState(() => _includeSleep = val);
              _save();
            },
          ),
          SwitchListTile(
            title: const Text('Morgen-Benachrichtigung'),
            subtitle: const Text('Täglichen Check-in erinnern (demnächst verfügbar)'),
            value: false,
            onChanged: null,
          ),
          const Divider(),
          const ListTile(
            title: Text('Algorithmus-Info', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Bimodaler Z-Score Algorithmus mit 28-Tage-Baseline, Sleep Regularity Index (SRI) und Bayesscher Fusion mit täglichem Check-in.'),
          ),
        ],
      ),
    );
  }
}
