import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/plugins/plugin_interfaces.dart';
import '../derived/derived_providers.dart';
import '../../ui/theme/app_theme.dart';
import '../../ui/widgets/bouncing_card.dart';

class SleepDebtFeature implements KernPlugin {
  @override
  String get id => 'sleep_debt';

  @override
  String get name => 'Schlafkonto';

  @override
  String get description =>
      'Kumulatives Schlafdefizit als Bank-Modell. '
      'Zeigt ob du genug schläfst und wie lange es dauert, '
      'dein Defizit auszugleichen.';

  @override
  List<PluginSlot> get supportedSlots => [PluginSlot.header, PluginSlot.footer];

  @override
  Widget buildDashboardWidget(BuildContext context, PluginSlot slot) {
    return const _SleepDebtWidget();
  }

  @override
  bool get hasDetailPage => true;

  @override
  Widget? buildDetailPage(BuildContext context) => const _SleepDebtDetailScreen();

  @override
  Widget? buildSettingsPage(BuildContext context) => const _SleepDebtSettingsScreen();
}

// ── Shared helpers ──────────────────────────────────────────────────────────

Color _sdSeverityColor(int severity, bool isDark) {
  switch (severity) {
    case 0:
      return isDark ? const Color(0xFF34A853) : AppTheme.textMint;
    case 1:
    case 2:
      return isDark ? const Color(0xFFFBBC04) : AppTheme.textOrange;
    case 3:
    case 4:
      return isDark ? const Color(0xFFEA4335) : AppTheme.textPink;
    default:
      return AppTheme.textTertiary;
  }
}

IconData _sdSeverityIcon(int severity) {
  switch (severity) {
    case 0:
      return Icons.check_circle_rounded;
    case 1:
      return Icons.info_rounded;
    case 2:
      return Icons.notifications_rounded;
    case 3:
      return Icons.warning_rounded;
    case 4:
      return Icons.dangerous_rounded;
    default:
      return Icons.hourglass_empty_rounded;
  }
}

String _sdSeverityLabel(int severity) {
  switch (severity) {
    case 0:
      return 'Ausgeglichen';
    case 1:
      return 'Leichtes Defizit';
    case 2:
      return 'Moderates Defizit';
    case 3:
      return 'Deutliches Defizit';
    case 4:
      return 'Kritisches Defizit';
    default:
      return 'Kalibrierung';
  }
}

String _sdBankBalanceLabel(double balance) {
  if (balance >= -15) return '±0 — Ausgeglichen';
  final absMin = balance.abs();
  final hrs = (absMin / 60).floor();
  final mins = (absMin % 60).floor();
  if (hrs > 0) return '-${hrs}h ${mins}m Defizit';
  return '-${mins}m Defizit';
}

String _sdFormatMinutes(double mins) {
  final h = (mins / 60).floor();
  final m = (mins % 60).floor();
  if (h > 0) return '${h}h ${m}m';
  return '${m}m';
}

String _sdDayAbbrev(String dateStr) {
  try {
    final parts = dateStr.split('-');
    final d = DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
    const days = ['Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];
    return days[d.weekday - 1];
  } catch (_) {
    return '';
  }
}

String _sdSuggestedBedtime(double goalMinutes, double extraMinutes) {
  final wakeHour = 7;
  final totalSleepHours = (goalMinutes + extraMinutes) / 60.0;
  final bedtimeHour = wakeHour - totalSleepHours;
  final adjustedHour = (bedtimeHour < 0 ? bedtimeHour + 24 : bedtimeHour).round();
  final adjustedMin = ((bedtimeHour - bedtimeHour.floor()) * 60).round().abs();
  final hour = adjustedHour.clamp(19, 23);
  final min = adjustedMin.clamp(0, 59);
  return '${hour.toString().padLeft(2, '0')}:${min.toString().padLeft(2, '0')}';
}

// ── Dashboard widget ────────────────────────────────────────────────────────

class _SleepDebtWidget extends ConsumerWidget {
  const _SleepDebtWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreAsync = ref.watch(sleepDebtBankScoreProvider());
    final balanceAsync = ref.watch(sleepDebtBankBalanceProvider());
    final severityAsync = ref.watch(sleepDebtSeverityProvider());
    final trendAsync = ref.watch(sleepDebtTrendProvider());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final score = scoreAsync.valueOrNull;
    final balance = balanceAsync.valueOrNull;
    final severity = severityAsync.valueOrNull ?? 0;
    final trend = trendAsync.valueOrNull ?? 1;

    return BouncingCard(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const _SleepDebtDetailScreen()),
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
                      color: _sdSeverityColor(severity, isDark).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(_sdSeverityIcon(severity), color: _sdSeverityColor(severity, isDark), size: 16),
                  ),
                  const SizedBox(width: 8),
                  const Text('Schlafkonto', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppTheme.textSecondary)),
                  const Spacer(),
                  _SdTrendChip(trend: trend, isDark: isDark),
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
                  if (balance != null)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: _sdSeverityColor(severity, isDark).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        balance >= -15 ? 'Ausgeglichen' : '-${_sdFormatMinutes(balance.abs())}',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: _sdSeverityColor(severity, isDark)),
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
                  color: _sdSeverityColor(severity, isDark),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SdTrendChip extends StatelessWidget {
  const _SdTrendChip({required this.trend, required this.isDark});
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
        label = 'Verbessert';
        color = AppTheme.textMint;
        break;
      case 0:
        icon = Icons.trending_down_rounded;
        label = 'Steigt';
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

class _SleepDebtDetailScreen extends ConsumerWidget {
  const _SleepDebtDetailScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreAsync = ref.watch(sleepDebtBankScoreProvider());
    final balanceAsync = ref.watch(sleepDebtBankBalanceProvider());
    final severityAsync = ref.watch(sleepDebtSeverityProvider());
    final shortfallAsync = ref.watch(sleepDebtDailyShortfallProvider());
    final surplusAsync = ref.watch(sleepDebtLastNightSurplusProvider());
    final recoveryAsync = ref.watch(sleepDebtRecoveryDaysProvider());
    final goalAsync = ref.watch(sleepDebtSleepGoalProvider());
    final detailAsync = ref.watch(sleepDebtDetailJsonProvider());
    final weeklyTrendAsync = ref.watch(sleepDebtWeeklyTrendProvider());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final score = scoreAsync.valueOrNull ?? 50;
    final severity = severityAsync.valueOrNull ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Schlafkonto'), backgroundColor: Colors.transparent),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          _buildScoreRing(score, balanceAsync, severity, isDark, theme),
          const SizedBox(height: 16),
          _buildBalanceSummary(context, balanceAsync, shortfallAsync, surplusAsync, recoveryAsync, goalAsync, isDark),
          const SizedBox(height: 24),
          _buildTimeline(detailAsync, isDark, theme),
          const SizedBox(height: 24),
          _buildRecommendation(balanceAsync, severity, recoveryAsync, goalAsync, weeklyTrendAsync, isDark, theme),
        ],
      ),
    );
  }

  Widget _buildScoreRing(double score, AsyncValue<double?> balanceAsync, int severity, bool isDark, ThemeData theme) {
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
                  value: score / 100,
                  strokeWidth: 14,
                  backgroundColor: isDark ? Colors.white12 : AppTheme.divider,
                  color: _sdSeverityColor(severity, isDark),
                  strokeCap: StrokeCap.round,
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(score.toStringAsFixed(0), style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: _sdSeverityColor(severity, isDark), height: 1)),
                  const SizedBox(height: 4),
                  Text(_sdSeverityLabel(severity), style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: _sdSeverityColor(severity, isDark).withValues(alpha: 0.8))),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text('Schlaf-Bank Score', style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.6))),
          const SizedBox(height: 4),
          balanceAsync.when(
            data: (balance) => balance != null
                ? Text(_sdBankBalanceLabel(balance), style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: balance >= -15 ? AppTheme.textMint : _sdSeverityColor(severity, isDark)))
                : const SizedBox(),
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildBalanceSummary(BuildContext context, AsyncValue<double?> balanceAsync, AsyncValue<double?> shortfallAsync, AsyncValue<double?> surplusAsync, AsyncValue<double?> recoveryAsync, AsyncValue<double?> goalAsync, bool isDark) {
    final theme = Theme.of(context);
    final goal = goalAsync.valueOrNull ?? 480;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: isDark ? const Color(0xFF1E1E1E) : Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: theme.dividerColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Heutige Bilanz', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          shortfallAsync.when(
            data: (shortfall) => surplusAsync.when(
              data: (surplus) => Column(
                children: [
                  _SdBalanceRow(icon: Icons.bedtime_rounded, label: 'Schlafziel', value: '${(goal / 60).toStringAsFixed(1)} Stunden', valueColor: AppTheme.textPurple, isDark: isDark),
                  const SizedBox(height: 10),
                  _SdBalanceRow(
                    icon: Icons.nightlight_round_rounded,
                    label: 'Letzte Nacht',
                    value: surplus != null && surplus > 0 ? '+${_sdFormatMinutes(surplus)}' : shortfall != null && shortfall > 0 ? '-${_sdFormatMinutes(shortfall)}' : 'Ausgeglichen',
                    valueColor: surplus != null && surplus > 0 ? AppTheme.textMint : shortfall != null && shortfall > 0 ? AppTheme.textPink : AppTheme.textTertiary,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 10),
                  _SdBalanceRow(
                    icon: Icons.account_balance_wallet_rounded,
                    label: 'Kontostand',
                    value: balanceAsync.valueOrNull != null ? _sdBankBalanceLabel(balanceAsync.value!) : '--',
                    valueColor: _sdSeverityColorFromBalance(balanceAsync.valueOrNull, isDark),
                    isDark: isDark,
                  ),
                  const SizedBox(height: 10),
                  recoveryAsync.when(
                    data: (days) => days != null && days > 0
                        ? _SdBalanceRow(icon: Icons.schedule_rounded, label: 'Erholungszeit', value: days == 1 ? '1 Tag' : '${days.toInt()} Tage', valueColor: AppTheme.textOrange, isDark: isDark)
                        : _SdBalanceRow(icon: Icons.check_circle_rounded, label: 'Erholungszeit', value: 'Kein Defizit', valueColor: AppTheme.textMint, isDark: isDark),
                    loading: () => const SizedBox(),
                    error: (_, __) => const SizedBox(),
                  ),
                ],
              ),
              loading: () => const SizedBox(),
              error: (_, __) => const SizedBox(),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(AsyncValue<Map<String, dynamic>?> detailAsync, bool isDark, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: isDark ? const Color(0xFF1E1E1E) : Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: theme.dividerColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('14-Tage Verlauf', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          detailAsync.when(
            data: (detail) {
              if (detail == null) return const Center(child: Text('Noch keine Daten', style: TextStyle(color: AppTheme.textTertiary)));
              final balances = (detail['daily_balances'] as List<dynamic>?)?.map((e) => (e as num).toDouble()).toList() ?? [];
              final dates = (detail['dates'] as List<dynamic>?)?.cast<String>() ?? [];
              if (balances.isEmpty) return const Center(child: Text('Noch keine Daten', style: TextStyle(color: AppTheme.textTertiary)));

              final recentBalances = balances.length > 14 ? balances.sublist(balances.length - 14) : balances;
              final recentDates = dates.length > 14 ? dates.sublist(dates.length - 14) : dates;

              return Column(
                children: [
                  SizedBox(
                    height: 100,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(recentBalances.length, (i) {
                        final b = recentBalances[i];
                        final fraction = (b.abs() / 480.0).clamp(0.0, 1.0);
                        final isDebt = b < -15;
                        final isSurplus = b > 15;
                        return Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: i < recentBalances.length - 1 ? 3 : 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  height: 60 * fraction,
                                  decoration: BoxDecoration(
                                    color: isSurplus ? AppTheme.textMint.withValues(alpha: 0.7) : isDebt ? AppTheme.textPink.withValues(alpha: 0.7) : (isDark ? Colors.white24 : AppTheme.divider),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                if (recentDates.isNotEmpty) Text(_sdDayAbbrev(recentDates[i]), style: TextStyle(fontSize: 9, color: theme.colorScheme.onSurface.withValues(alpha: 0.4))),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _SdLegendDot(color: AppTheme.textMint, label: 'Überschuss', isDark: isDark),
                      const SizedBox(width: 16),
                      _SdLegendDot(color: AppTheme.textPink, label: 'Defizit', isDark: isDark),
                      const SizedBox(width: 16),
                      _SdLegendDot(color: isDark ? Colors.white38 : AppTheme.divider, label: 'Neutral', isDark: isDark),
                    ],
                  ),
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const SizedBox(),
          ),
        ],
      ),
    );
  }

  Widget _buildRecommendation(AsyncValue<double?> balanceAsync, int severity, AsyncValue<double?> recoveryAsync, AsyncValue<double?> goalAsync, AsyncValue<double?> weeklyTrendAsync, bool isDark, ThemeData theme) {
    final balance = balanceAsync.valueOrNull ?? 0;
    final recoveryDays = recoveryAsync.valueOrNull ?? 0;
    final goal = goalAsync.valueOrNull ?? 480;
    final weeklyTrend = weeklyTrendAsync.valueOrNull ?? 0;

    String title;
    String message;
    String bedtimeMsg = '';
    IconData icon;
    Color color;

    if (severity == 0) {
      title = 'Alles im grünen Bereich';
      message = 'Dein Schlafkonto ist ausgeglichen. Halte deinen Rhythmus bei — Konsistenz ist der Schlüssel zu guter Erholung.';
      icon = Icons.check_circle_rounded;
      color = AppTheme.textMint;
    } else if (severity <= 2) {
      title = 'Leichtes Defizit';
      message = 'Dein Schlafdefizit ist moderat. ${recoveryDays > 0 ? 'Mit ${(goal / 60).toStringAsFixed(0)}h Schlaf pro Nacht ist dein Konto in etwa ${recoveryDays.toInt()} ${recoveryDays == 1 ? "Tag" : "Tagen"} wieder ausgeglichen.' : ''}';
      icon = Icons.info_rounded;
      color = AppTheme.textOrange;
      if (balance < -30) {
        bedtimeMsg = 'Empfohlene Schlafenszeit heute: ${_sdSuggestedBedtime(goal, 0.0)} Uhr';
      }
    } else {
      title = 'Kritisches Defizit';
      message = 'Dein Schlafdefizit ist deutlich. Das beeinträchtigt deine Regeneration, kognitive Leistung und dein Immunsystem. Plane in den nächsten Tagen bewusst mehr Schlaf ein.\n\n${recoveryDays > 0 ? 'Mit ${(goal / 60).toStringAsFixed(0)}h Schlaf pro Nacht brauchst du etwa ${recoveryDays.toInt()} ${recoveryDays == 1 ? "Tag" : "Tage"} zur Erholung.' : ''}';
      icon = Icons.warning_rounded;
      color = AppTheme.textPink;
      if (balance < -60) {
        bedtimeMsg = 'Geh heute spätestens um ${_sdSuggestedBedtime(goal, 30.0)} Uhr ins Bett';
      }
    }

    if (weeklyTrend < -10) {
      message += '\n\nDein Defizit ist in den letzten 7 Tagen um ${weeklyTrend.abs().toInt()} Minuten gewachsen. Kehre diesen Trend um.';
    } else if (weeklyTrend > 10) {
      message += '\n\nDein Defizit hat sich in den letzten 7 Tagen um ${weeklyTrend.toInt()} Minuten verbessert. Weiter so!';
    }

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(24), border: Border.all(color: color.withValues(alpha: 0.2))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: [Icon(icon, color: color, size: 20), const SizedBox(width: 8), Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color))]),
              const SizedBox(height: 12),
              Text(message, style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.85), height: 1.5)),
            ],
          ),
        ),
        if (bedtimeMsg.isNotEmpty) ...[const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: isDark ? const Color(0xFF1E1E1E) : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: theme.dividerColor)),
            child: Row(children: [const Icon(Icons.nightlight_round_rounded, color: AppTheme.textPurple, size: 20), const SizedBox(width: 12), Expanded(child: Text(bedtimeMsg, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)))]),
          ),
        ],
      ],
    );
  }

  Color _sdSeverityColorFromBalance(double? balance, bool isDark) {
    if (balance == null) return AppTheme.textTertiary;
    if (balance >= -30) return isDark ? const Color(0xFF34A853) : AppTheme.textMint;
    if (balance >= -180) return isDark ? const Color(0xFFFBBC04) : AppTheme.textOrange;
    return isDark ? const Color(0xFFEA4335) : AppTheme.textPink;
  }
}

// ── Reusable widgets ────────────────────────────────────────────────────────

class _SdBalanceRow extends StatelessWidget {
  const _SdBalanceRow({required this.icon, required this.label, required this.value, required this.valueColor, required this.isDark});
  final IconData icon;
  final String label;
  final String value;
  final Color valueColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(width: 32, height: 32, decoration: BoxDecoration(color: valueColor.withValues(alpha: 0.10), shape: BoxShape.circle), child: Icon(icon, color: valueColor, size: 16)),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: TextStyle(fontSize: 13, color: theme.colorScheme.onSurface.withValues(alpha: 0.7)))),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface)),
      ],
    );
  }
}

class _SdLegendDot extends StatelessWidget {
  const _SdLegendDot({required this.color, required this.label, required this.isDark});
  final Color color;
  final String label;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 10, color: isDark ? Colors.white38 : AppTheme.textTertiary)),
      ],
    );
  }
}

// ── Settings screen ─────────────────────────────────────────────────────────

class _SleepDebtSettingsScreen extends ConsumerStatefulWidget {
  const _SleepDebtSettingsScreen();

  @override
  ConsumerState<_SleepDebtSettingsScreen> createState() => _SleepDebtSettingsScreenState();
}

class _SleepDebtSettingsScreenState extends ConsumerState<_SleepDebtSettingsScreen> {
  double _goalMinutes = 480;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _goalMinutes = prefs.getDouble('sleep_debt_goal_minutes') ?? 480;
      _loaded = true;
    });
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('sleep_debt_goal_minutes', _goalMinutes);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Schlafziel gespeichert'), duration: Duration(seconds: 1)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_loaded) return const Scaffold(body: Center(child: CircularProgressIndicator()));

    final goalHours = _goalMinutes / 60.0;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Schlafkonto Einstellungen')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 16, top: 8, bottom: 4),
            child: Text('Tägliches Schlafziel', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text('Die meisten Erwachsenen brauchen 7–9 Stunden Schlaf.', style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.5))),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Text('5h', style: TextStyle(color: AppTheme.textTertiary)),
                Expanded(
                  child: Slider(
                    value: goalHours,
                    min: 5,
                    max: 10,
                    divisions: 20,
                    label: '${goalHours.toStringAsFixed(2)}h',
                    onChanged: (val) => setState(() => _goalMinutes = val * 60),
                    onChangeEnd: (_) => _save(),
                  ),
                ),
                const Text('10h', style: TextStyle(color: AppTheme.textTertiary)),
              ],
            ),
          ),
          Center(child: Text('${goalHours.toStringAsFixed(1)} Stunden (${_goalMinutes.toInt()} Minuten)', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold))),
          const SizedBox(height: 32),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Wie das Schlafkonto funktioniert:\n\n'
              'Das Schlafkonto funktioniert wie ein Bankkonto. Jede Nacht, in der du weniger als dein Ziel schläfst, entsteht ein Defizit. Schläfst du mehr, wird das Konto ausgeglichen.\n\n'
              'Altes Defizit verliert mit der Zeit an Bedeutung — der Körper passt sich teilweise an. Ein Defizit von 1–2 Stunden ist normal und schnell ausgeglichen. Ein Defizit über 6 Stunden braucht mehrere Tage Erholung.',
              style: TextStyle(fontSize: 13, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
