import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/plugins/plugin_interfaces.dart';
import '../derived/derived_providers.dart';
import '../../ui/theme/app_theme.dart';
import '../../ui/widgets/bouncing_card.dart';

class ForecastFeature implements KernPlugin {
  @override
  String get id => 'forecast';

  @override
  String get name => 'Readiness Prognose';

  @override
  String get description =>
      'Prognostiziert deine morgige Readiness anhand des 7-Tage-Trends '
      'mit linearer Regression. Inklusive Konfidenz und Erholungsschulden.';

  @override
  List<PluginSlot> get supportedSlots => [PluginSlot.header, PluginSlot.footer, PluginSlot.main];

  @override
  Widget buildDashboardWidget(BuildContext context, PluginSlot slot) {
    return const _ForecastWidget();
  }

  @override
  bool get hasDetailPage => true;

  @override
  Widget? buildDetailPage(BuildContext context) => const _ForecastDetailScreen();

  @override
  Widget? buildSettingsPage(BuildContext context) => const _ForecastSettingsScreen();
}

// ── Shared helpers ──────────────────────────────────────────────────────────

Color _fcCategoryColor(int category, bool isDark) {
  switch (category) {
    case 4:
      return isDark ? const Color(0xFF34A853) : AppTheme.textMint;
    case 3:
      return isDark ? const Color(0xFF8AB4F8) : AppTheme.textBlue;
    case 2:
      return isDark ? const Color(0xFFFBBC04) : AppTheme.textOrange;
    case 1:
      return isDark ? const Color(0xFFEA4335) : AppTheme.textPink;
    case 0:
      return isDark ? const Color(0xFFB71C1C) : const Color(0xFFC62828);
    default:
      return AppTheme.textTertiary;
  }
}

IconData _fcCategoryIcon(int category) {
  switch (category) {
    case 4:
      return Icons.rocket_launch_rounded;
    case 3:
      return Icons.trending_up_rounded;
    case 2:
      return Icons.trending_flat_rounded;
    case 1:
      return Icons.trending_down_rounded;
    case 0:
      return Icons.warning_rounded;
    default:
      return Icons.hourglass_empty_rounded;
  }
}

String _fcCategoryLabel(int category) {
  switch (category) {
    case 4:
      return 'Sehr gut';
    case 3:
      return 'Gut';
    case 2:
      return 'Mittel';
    case 1:
      return 'Niedrig';
    case 0:
      return 'Kritisch';
    default:
      return 'Kalibrierung';
  }
}

String _fcTrendLabel(double slope) {
  if (slope > 1.0) return 'Steigend';
  if (slope < -1.0) return 'Fallend';
  return 'Stabil';
}

IconData _fcTrendIcon(double slope) {
  if (slope > 1.0) return Icons.trending_up_rounded;
  if (slope < -1.0) return Icons.trending_down_rounded;
  return Icons.trending_flat_rounded;
}

Color _fcTrendColor(double slope, bool isDark) {
  if (slope > 1.0) return isDark ? const Color(0xFF34A853) : AppTheme.textMint;
  if (slope < -1.0) return isDark ? const Color(0xFFEA4335) : AppTheme.textPink;
  return AppTheme.textTertiary;
}

// ── Dashboard widget ────────────────────────────────────────────────────────

class _ForecastWidget extends ConsumerWidget {
  const _ForecastWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final physAsync = ref.watch(forecastPredictedReadinessProvider());
    final categoryAsync = ref.watch(forecastCategoryProvider());
    final slopeAsync = ref.watch(forecastTrendSlopeProvider());
    final confidenceAsync = ref.watch(forecastConfidenceProvider());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final phys = physAsync.valueOrNull;
    final category = categoryAsync.valueOrNull ?? 5;
    final slope = slopeAsync.valueOrNull ?? 0;
    final confidence = confidenceAsync.valueOrNull ?? 0;

    return BouncingCard(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const _ForecastDetailScreen()),
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
                      color: _fcCategoryColor(category, isDark).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(_fcCategoryIcon(category), color: _fcCategoryColor(category, isDark), size: 16),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text('Readiness Prognose', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppTheme.textSecondary)),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_fcTrendIcon(slope), size: 12, color: _fcTrendColor(slope, isDark)),
                      const SizedBox(width: 3),
                      Text(_fcTrendLabel(slope), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _fcTrendColor(slope, isDark))),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    phys?.toStringAsFixed(0) ?? '--',
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface, height: 1),
                  ),
                  const SizedBox(width: 6),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('morgen', style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
                        Text(_fcCategoryLabel(category), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: _fcCategoryColor(category, isDark))),
                      ],
                    ),
                  ),
                  const Spacer(),
                  if (confidence > 0)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('${confidence.toInt()}%', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
                        Text('Konfidenz', style: TextStyle(fontSize: 9, color: isDark ? Colors.white38 : AppTheme.textTertiary)),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: (phys ?? 50) / 100,
                  minHeight: 4,
                  backgroundColor: isDark ? Colors.white12 : AppTheme.divider,
                  color: _fcCategoryColor(category, isDark),
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

class _ForecastDetailScreen extends ConsumerWidget {
  const _ForecastDetailScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final physAsync = ref.watch(forecastPredictedReadinessProvider());
    final mentAsync = ref.watch(forecastPredictedMentalProvider());
    final categoryAsync = ref.watch(forecastCategoryProvider());
    final slopeAsync = ref.watch(forecastTrendSlopeProvider());
    final mentSlopeAsync = ref.watch(forecastMentalTrendProvider());
    final confidenceAsync = ref.watch(forecastConfidenceProvider());
    final debtAsync = ref.watch(forecastRecoveryDebtProvider());
    final recAsync = ref.watch(forecastRecommendationProvider());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final category = categoryAsync.valueOrNull ?? 5;
    final slope = slopeAsync.valueOrNull ?? 0;
    final confidence = confidenceAsync.valueOrNull ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Readiness Prognose'), backgroundColor: Colors.transparent),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          _buildForecastRing(physAsync, mentAsync, category, slope, confidence, isDark, theme),
          const SizedBox(height: 24),
          _buildTrendDetail(slope, mentSlopeAsync, confidence, isDark, theme),
          const SizedBox(height: 24),
          _buildDebtIndicator(debtAsync, isDark, theme),
          const SizedBox(height: 24),
          _buildRecommendation(recAsync, category, isDark, theme),
        ],
      ),
    );
  }

  Widget _buildForecastRing(AsyncValue<double?> physAsync, AsyncValue<double?> mentAsync, int category, double slope, double confidence, bool isDark, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.calendar_today_rounded, size: 16, color: AppTheme.textTertiary),
              const SizedBox(width: 6),
              Text('Prognose für morgen', style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: CircularProgressIndicator(
                            value: (physAsync.valueOrNull ?? 50) / 100,
                            strokeWidth: 12,
                            backgroundColor: isDark ? Colors.white12 : AppTheme.divider,
                            color: _fcCategoryColor(category, isDark),
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            physAsync.when(
                              data: (p) => Text(p?.toStringAsFixed(0) ?? '50', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: _fcCategoryColor(category, isDark), height: 1)),
                              loading: () => const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
                              error: (_, __) => const Text('--'),
                            ),
                            Text('Physisch', style: TextStyle(fontSize: 10, color: _fcCategoryColor(category, isDark).withValues(alpha: 0.7))),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 120,
                          child: CircularProgressIndicator(
                            value: (mentAsync.valueOrNull ?? 50) / 100,
                            strokeWidth: 12,
                            backgroundColor: isDark ? Colors.white12 : AppTheme.divider,
                            color: isDark ? const Color(0xFFAB69FF) : AppTheme.textPurple,
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            mentAsync.when(
                              data: (m) => Text(m?.toStringAsFixed(0) ?? '50', style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFFAB69FF) : AppTheme.textPurple, height: 1)),
                              loading: () => const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
                              error: (_, __) => const Text('--'),
                            ),
                            Text('Mental', style: TextStyle(fontSize: 10, color: (isDark ? const Color(0xFFAB69FF) : AppTheme.textPurple).withValues(alpha: 0.7))),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_fcTrendIcon(slope), size: 14, color: _fcTrendColor(slope, isDark)),
              const SizedBox(width: 4),
              Text(_fcTrendLabel(slope), style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _fcTrendColor(slope, isDark))),
              const SizedBox(width: 16),
              Text('Konfidenz: ${confidence.toInt()}%', style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrendDetail(double physSlope, AsyncValue<double?> mentSlopeAsync, double confidence, bool isDark, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: isDark ? const Color(0xFF1E1E1E) : Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: theme.dividerColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Trend-Analyse (7 Tage)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          _FcTrendRow(
            icon: Icons.directions_run_rounded,
            label: 'Physischer Trend',
            slope: physSlope,
            isDark: isDark,
          ),
          const SizedBox(height: 10),
          mentSlopeAsync.when(
            data: (mSlope) => mSlope != null
                ? _FcTrendRow(icon: Icons.psychology_rounded, label: 'Mentaler Trend', slope: mSlope, isDark: isDark)
                : const SizedBox(),
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(confidence >= 60 ? Icons.check_circle_rounded : Icons.info_rounded, size: 14, color: confidence >= 60 ? AppTheme.textMint : AppTheme.textOrange),
              const SizedBox(width: 6),
              Text(
                confidence >= 60 ? 'Prognose zuverlässig' : confidence >= 30 ? 'Prognose mäßig sicher' : 'Prognose unsicher',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: confidence >= 60 ? AppTheme.textMint : AppTheme.textOrange),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDebtIndicator(AsyncValue<double?> debtAsync, bool isDark, ThemeData theme) {
    return debtAsync.when(
      data: (debt) {
        if (debt == null) return const SizedBox();
        return Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: isDark ? const Color(0xFF1E1E1E) : Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: theme.dividerColor)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.account_balance_wallet_rounded, size: 18, color: AppTheme.textOrange),
                  const SizedBox(width: 8),
                  const Text('Erholungsschulden', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(debt > 5 ? 'Du baust Erholungsschulden auf' : debt < -5 ? 'Erholungs-Überschuss' : 'Ausgeglichen', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 4),
                        Text(debt > 5 ? 'Reduziere die Trainingslast für 2–3 Tage' : debt < -5 ? 'Du könntest die Intensität steigern' : 'Deine Belastung und Erholung sind im Gleichgewicht',
                            style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: debt > 10 ? AppTheme.accentPink : debt < -10 ? AppTheme.accentMint : AppTheme.accentOrange,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      debt > 0 ? '+${debt.toInt()}' : '${debt.toInt()}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: debt > 10 ? AppTheme.textPink : debt < -10 ? AppTheme.textMint : AppTheme.textOrange,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox(),
      error: (_, __) => const SizedBox(),
    );
  }

  Widget _buildRecommendation(AsyncValue<String?> recAsync, int category, bool isDark, ThemeData theme) {
    return recAsync.when(
      data: (rec) => rec != null
          ? Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: _fcCategoryColor(category, isDark).withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: _fcCategoryColor(category, isDark).withValues(alpha: 0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [Icon(Icons.lightbulb_rounded, color: _fcCategoryColor(category, isDark), size: 20), const SizedBox(width: 8), Text('Empfehlung für morgen', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: _fcCategoryColor(category, isDark)))]),
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
}

class _FcTrendRow extends StatelessWidget {
  const _FcTrendRow({required this.icon, required this.label, required this.slope, required this.isDark});
  final IconData icon;
  final String label;
  final double slope;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final absSlope = slope.abs();
    return Row(
      children: [
        Container(width: 32, height: 32, decoration: BoxDecoration(color: _fcTrendColor(slope, isDark).withValues(alpha: 0.10), shape: BoxShape.circle), child: Icon(icon, color: _fcTrendColor(slope, isDark), size: 16)),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurface.withValues(alpha: 0.7)))),
        Icon(_fcTrendIcon(slope), size: 16, color: _fcTrendColor(slope, isDark)),
        const SizedBox(width: 4),
        Text(
          slope > 0 ? '+${absSlope.toStringAsFixed(1)}/Tag' : slope < 0 ? '${slope.toStringAsFixed(1)}/Tag' : '0/Tag',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: _fcTrendColor(slope, isDark)),
        ),
      ],
    );
  }
}

// ── Settings screen ─────────────────────────────────────────────────────────

class _ForecastSettingsScreen extends StatelessWidget {
  const _ForecastSettingsScreen();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Prognose Einstellungen')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ListTile(
            title: Text('Trend-Fenster'),
            subtitle: Text('7 Tage'),
            trailing: Icon(Icons.chevron_right),
            enabled: false,
          ),
          const ListTile(
            title: Text('Prognose-Methode'),
            subtitle: Text('Lineare Regression mit R²-Konfidenz'),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Die Readiness Prognose verwendet eine lineare Regression über '
              'deine letzten 7 Readiness-Werte, um den Trend zu erkennen und '
              'den morgigen Wert vorherzusagen.\n\n'
              'Die Konfidenz basiert auf dem R²-Wert der Regression:\n'
              '• 60–100%: Stabile Werte, zuverlässige Prognose\n'
              '• 30–60%: Mäßige Schwankungen\n'
              '• < 30%: Starke Schwankungen, Prognose unsicher\n\n'
              'Erholungsschulden entstehen, wenn deine Belastung (Strain) '
              'dauerhaft über deiner Erholung (Recovery) liegt.',
              style: TextStyle(fontSize: 13, height: 1.5, color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
            ),
          ),
        ],
      ),
    );
  }
}
