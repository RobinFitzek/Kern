import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/plugins/plugin_interfaces.dart';
import '../derived/derived_providers.dart';
import '../../ui/theme/app_theme.dart';
import '../../ui/widgets/bouncing_card.dart';

class ChronotypeFeature implements KernPlugin {
  @override
  String get id => 'chronotype';

  @override
  String get name => 'Chronotyp';

  @override
  String get description =>
      'Analysiert deinen Schlafrhythmus über 28 Tage und bestimmt deinen '
      'Chronotyp — vom Frühaufsteher bis zur Nachteule.';

  @override
  List<PluginSlot> get supportedSlots => [PluginSlot.footer, PluginSlot.header];

  @override
  Widget buildDashboardWidget(BuildContext context, PluginSlot slot) {
    return const _ChronotypeWidget();
  }

  @override
  bool get hasDetailPage => true;

  @override
  Widget? buildDetailPage(BuildContext context) => const _ChronotypeDetailScreen();

  @override
  Widget? buildSettingsPage(BuildContext context) => null;
}

// ── Shared helpers ──────────────────────────────────────────────────────────

Color _chrCategoryColor(int category, bool isDark) {
  switch (category) {
    case 0:
      return isDark ? const Color(0xFFFBBC04) : AppTheme.textOrange;
    case 1:
      return isDark ? const Color(0xFF34A853) : AppTheme.textMint;
    case 2:
      return isDark ? const Color(0xFF8AB4F8) : AppTheme.textBlue;
    case 3:
      return isDark ? const Color(0xFFAB69FF) : AppTheme.textPurple;
    case 4:
      return isDark ? const Color(0xFF1A237E) : Colors.deepPurple;
    default:
      return AppTheme.textTertiary;
  }
}

IconData _chrCategoryIcon(int category) {
  switch (category) {
    case 0:
      return Icons.wb_sunny_rounded;
    case 1:
      return Icons.wb_twilight_rounded;
    case 2:
      return Icons.light_mode_rounded;
    case 3:
      return Icons.nightlight_round_rounded;
    case 4:
      return Icons.dark_mode_rounded;
    default:
      return Icons.hourglass_empty_rounded;
  }
}

String _chrTimeStr(double hour) {
  final h = hour.floor();
  final m = ((hour - h) * 60).round();
  final displayH = h >= 24 ? h - 24 : h;
  return '${displayH.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
}

// ── Dashboard widget ────────────────────────────────────────────────────────

class _ChronotypeWidget extends ConsumerWidget {
  const _ChronotypeWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryAsync = ref.watch(chronotypeCategoryProvider());
    final labelAsync = ref.watch(chronotypeCategoryLabelProvider());
    final bedAsync = ref.watch(chronotypeAvgBedtimeProvider());
    final wakeAsync = ref.watch(chronotypeAvgWaketimeProvider());
    final midpointAsync = ref.watch(chronotypeMidpointProvider());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final category = categoryAsync.valueOrNull ?? 5;
    final label = labelAsync.valueOrNull ?? 'Kalibrierung';
    final bed = bedAsync.valueOrNull;
    final wake = wakeAsync.valueOrNull;

    return BouncingCard(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const _ChronotypeDetailScreen()),
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
                      color: _chrCategoryColor(category, isDark).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(_chrCategoryIcon(category), color: _chrCategoryColor(category, isDark), size: 16),
                  ),
                  const SizedBox(width: 8),
                  const Text('Chronotyp', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppTheme.textSecondary)),
                  const Spacer(),
                  Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _chrCategoryColor(category, isDark))),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.nightlight_round_rounded, size: 14, color: AppTheme.textPurple),
                            const SizedBox(width: 4),
                            Text(bed != null ? _chrTimeStr(bed) : '--', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textPurple)),
                            const SizedBox(width: 8),
                            const Icon(Icons.wb_sunny_rounded, size: 14, color: AppTheme.textOrange),
                            const SizedBox(width: 4),
                            Text(wake != null ? _chrTimeStr(wake) : '--', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppTheme.textOrange)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text('Ø Bettzeit  →  Ø Aufstehzeit', style: TextStyle(fontSize: 10, color: isDark ? Colors.white38 : AppTheme.textTertiary)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _chrCategoryColor(category, isDark).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_chrCategoryIcon(category), color: _chrCategoryColor(category, isDark), size: 14),
                        const SizedBox(width: 4),
                        Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _chrCategoryColor(category, isDark))),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Detail screen ───────────────────────────────────────────────────────────

class _ChronotypeDetailScreen extends ConsumerWidget {
  const _ChronotypeDetailScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoryAsync = ref.watch(chronotypeCategoryProvider());
    final labelAsync = ref.watch(chronotypeCategoryLabelProvider());
    final bedAsync = ref.watch(chronotypeAvgBedtimeProvider());
    final wakeAsync = ref.watch(chronotypeAvgWaketimeProvider());
    final midpointAsync = ref.watch(chronotypeMidpointProvider());
    final variabilityAsync = ref.watch(chronotypeVariabilityProvider());
    final durationAsync = ref.watch(chronotypeAvgDurationProvider());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final category = categoryAsync.valueOrNull ?? 5;

    return Scaffold(
      appBar: AppBar(title: const Text('Chronotyp'), backgroundColor: Colors.transparent),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          _buildHeader(category, labelAsync, isDark, theme),
          const SizedBox(height: 24),
          _buildSleepWindow(bedAsync, wakeAsync, midpointAsync, isDark, theme),
          const SizedBox(height: 24),
          _buildMetrics(variabilityAsync, durationAsync, isDark, theme),
          const SizedBox(height: 24),
          _buildExplainer(category, isDark, theme),
        ],
      ),
    );
  }

  Widget _buildHeader(int category, AsyncValue<String?> labelAsync, bool isDark, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        children: [
          Icon(_chrCategoryIcon(category), color: _chrCategoryColor(category, isDark), size: 64),
          const SizedBox(height: 12),
          labelAsync.when(
            data: (label) => Text(label ?? '--', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: _chrCategoryColor(category, isDark))),
            loading: () => const CircularProgressIndicator(),
            error: (_, __) => const Text('--'),
          ),
          const SizedBox(height: 8),
          Text('Dein Schlaf-Chronotyp', style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
        ],
      ),
    );
  }

  Widget _buildSleepWindow(AsyncValue<double?> bedAsync, AsyncValue<double?> wakeAsync, AsyncValue<double?> midpointAsync, bool isDark, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: isDark ? const Color(0xFF1E1E1E) : Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: theme.dividerColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Dein Schlaffenster', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    const Icon(Icons.nightlight_round_rounded, color: AppTheme.textPurple, size: 28),
                    const SizedBox(height: 6),
                    Text('Bettzeit', style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
                    const SizedBox(height: 2),
                    bedAsync.when(
                      data: (b) => Text(b != null ? '${_chrTimeStr(b)} Uhr' : '--', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      loading: () => const CircularProgressIndicator(),
                      error: (_, __) => const Text('--'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Icon(Icons.wb_sunny_rounded, color: AppTheme.textOrange, size: 28),
                    const SizedBox(height: 6),
                    Text('Aufstehzeit', style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
                    const SizedBox(height: 2),
                    wakeAsync.when(
                      data: (w) => Text(w != null ? '${_chrTimeStr(w)} Uhr' : '--', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      loading: () => const CircularProgressIndicator(),
                      error: (_, __) => const Text('--'),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  children: [
                    const Icon(Icons.trip_origin_rounded, color: AppTheme.textBlue, size: 28),
                    const SizedBox(height: 6),
                    Text('Mittelpunkt', style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
                    const SizedBox(height: 2),
                    midpointAsync.when(
                      data: (m) => Text(m != null ? '${_chrTimeStr(m)} Uhr' : '--', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppTheme.textBlue)),
                      loading: () => const CircularProgressIndicator(),
                      error: (_, __) => const Text('--'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetrics(AsyncValue<double?> variabilityAsync, AsyncValue<double?> durationAsync, bool isDark, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: isDark ? const Color(0xFF1E1E1E) : Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: theme.dividerColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Schlaf-Metriken (28-Tage Ø)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _ChrMetricRow(
            icon: Icons.shuffle_rounded,
            label: 'Variabilität',
            value: variabilityAsync.valueOrNull,
            suffix: 'min',
            detail: 'Standardabweichung der Schlafmittelpunkte — niedrig ist besser',
            color: AppTheme.textBlue,
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          _ChrMetricRow(
            icon: Icons.bedtime_rounded,
            label: 'Ø Schlafdauer',
            value: durationAsync.valueOrNull,
            suffix: 'h',
            detail: 'Durchschnittliche Schlafdauer pro Nacht',
            color: AppTheme.textPurple,
            isDark: isDark,
            isHours: true,
          ),
        ],
      ),
    );
  }

  Widget _buildExplainer(int category, bool isDark, ThemeData theme) {
    final map = {
      0: 'Als extremer Frühaufsteher liegt dein natürlicher Rhythmus sehr früh. '
          'Deine produktivsten Stunden sind am frühen Morgen. Plane intensives '
          'Training zwischen 6–10 Uhr.',
      1: 'Als Frühaufsteher bist du morgens am leistungsfähigsten. '
          'Dein optimales Trainingsfenster liegt zwischen 7–11 Uhr. '
          'Vermeide späte Trainingseinheiten — sie können deinen Schlafrhythmus stören.',
      2: 'Als Normaltyp hast du einen ausgeglichenen Rhythmus. '
          'Deine Leistungsfähigkeit ist über den Tag verteilt stabil. '
          'Trainiere am besten zwischen 10–14 Uhr oder am späten Nachmittag.',
      3: 'Als Spättyp läuft deine innere Uhr etwas später. '
          'Deine kognitive und körperliche Leistungsfähigkeit erreicht ihren '
          'Höhepunkt am Nachmittag und frühen Abend. Optimales Training: 15–19 Uhr.',
      4: 'Als extremer Spättyp bist du nachts am produktivsten. '
          'Plane dein Training am späten Nachmittag oder frühen Abend (16–20 Uhr). '
          'Frühe Trainingseinheiten fühlen sich für dich deutlich härter an.',
    };
    final msg = map[category] ?? 'Sammle mindestens 7 Nächte Schlafdaten für eine Chronotyp-Analyse.';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _chrCategoryColor(category, isDark).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _chrCategoryColor(category, isDark).withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_rounded, color: _chrCategoryColor(category, isDark), size: 20),
              const SizedBox(width: 8),
              Text('Was das für dich bedeutet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _chrCategoryColor(category, isDark))),
            ],
          ),
          const SizedBox(height: 12),
          Text(msg, style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.85), height: 1.5)),
        ],
      ),
    );
  }
}

class _ChrMetricRow extends StatelessWidget {
  const _ChrMetricRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.suffix,
    required this.detail,
    required this.color,
    required this.isDark,
    this.isHours = false,
  });
  final IconData icon;
  final String label;
  final double? value;
  final String suffix;
  final String detail;
  final Color color;
  final bool isDark;
  final bool isHours;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final display = value != null
        ? (isHours ? '${(value! / 60).toStringAsFixed(1)} $suffix' : '${value!.toInt()} $suffix')
        : '--';
    return Row(
      children: [
        Container(width: 32, height: 32, decoration: BoxDecoration(color: color.withValues(alpha: 0.10), shape: BoxShape.circle), child: Icon(icon, color: color, size: 16)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              Text(detail, style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurface.withValues(alpha: 0.4))),
            ],
          ),
        ),
        Text(display, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface)),
      ],
    );
  }
}
