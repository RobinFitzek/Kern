import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/plugins/plugin_interfaces.dart';
import '../derived/derived_providers.dart';
import '../../ui/theme/app_theme.dart';

class ActiveEnergyFeature implements KernPlugin {
  @override
  String get id => 'active_energy';

  @override
  String get name => 'Aktivenergie';

  @override
  String get description => 'Aktive Kalorien-Analyse und Aktivitätslevel-Klassifikation.';

  @override
  List<PluginSlot> get supportedSlots => [PluginSlot.footer, PluginSlot.header];

  @override
  Widget buildDashboardWidget(BuildContext context, PluginSlot slot) {
    return const _ActiveEnergyWidget();
  }

  @override
  bool get hasDetailPage => true;

  @override
  Widget? buildDetailPage(BuildContext context) => const _ActiveEnergyDetailScreen();

  @override
  Widget? buildSettingsPage(BuildContext context) => const _ActiveEnergySettingsScreen();
}

class _ActiveEnergyWidget extends ConsumerWidget {
  const _ActiveEnergyWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kcalAsync = ref.watch(activeEnergyDailyKcalProvider());
    final levelAsync = ref.watch(activeEnergyLevelProvider());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final kcal = kcalAsync.valueOrNull;
    final level = levelAsync.valueOrNull;

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
                    color: isDark ? const Color(0xFF2E243A) : AppTheme.accentOrange,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.local_fire_department_rounded,
                    color: AppTheme.textOrange,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Aktivenergie',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppTheme.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  kcal != null ? '${kcal.toInt()} kcal' : '--',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                if (level != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _levelColor(level, isDark).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _levelLabel(level),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _levelColor(level, isDark),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _levelColor(String level, bool isDark) {
    switch (level) {
      case 'Sehr aktiv':
        return isDark ? const Color(0xFF34A853) : AppTheme.textMint;
      case 'Aktiv':
        return isDark ? const Color(0xFF8AB4F8) : AppTheme.textBlue;
      case 'Moderat':
        return isDark ? const Color(0xFFFBBC04) : AppTheme.textOrange;
      case 'Leicht':
        return isDark ? const Color(0xFFEA4335) : AppTheme.textPink;
      default:
        return AppTheme.textTertiary;
    }
  }

  String _levelLabel(String level) {
    switch (level) {
      case 'Sehr aktiv':
        return 'Sehr aktiv';
      case 'Aktiv':
        return 'Aktiv';
      case 'Moderat':
        return 'Moderat';
      case 'Leicht':
        return 'Leicht';
      case 'Sitzend':
        return 'Sitzend';
      default:
        return '--';
    }
  }
}

class _ActiveEnergyDetailScreen extends ConsumerWidget {
  const _ActiveEnergyDetailScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kcalAsync = ref.watch(activeEnergyDailyKcalProvider());
    final weeklyAvgAsync = ref.watch(activeEnergyWeeklyAvgProvider());
    final levelAsync = ref.watch(activeEnergyLevelProvider());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Aktivenergie'),
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
                kcalAsync.when(
                  data: (kcal) {
                    final k = kcal ?? 0;
                    return Column(
                      children: [
                        Icon(
                          Icons.local_fire_department_rounded,
                          size: 48,
                          color: AppTheme.textOrange,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '${k.toInt()}',
                          style: const TextStyle(fontSize: 52, fontWeight: FontWeight.bold, color: AppTheme.textOrange),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Aktive Kalorien heute',
                          style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.6)),
                        ),
                      ],
                    );
                  },
                  loading: () => const SizedBox(height: 120, child: Center(child: CircularProgressIndicator())),
                  error: (_, __) => const SizedBox(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          levelAsync.when(
            data: (level) => level != null
                ? Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: theme.dividerColor),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppTheme.textOrange.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.speed_rounded, color: AppTheme.textOrange, size: 20),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Aktivitätslevel', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                              Text(
                                '7-Tage Durchschnitt: ${weeklyAvgAsync.valueOrNull?.toStringAsFixed(0) ?? "--"} kcal/Tag',
                                style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppTheme.accentOrange,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(level, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppTheme.textOrange)),
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
}

class _ActiveEnergySettingsScreen extends StatelessWidget {
  const _ActiveEnergySettingsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aktivenergie Einstellungen')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ListTile(
            title: Text('Datenquelle'),
            subtitle: Text('Health Connect — Active Energy Burned'),
          ),
          SwitchListTile(
            title: const Text('Ziel-Benachrichtigung'),
            subtitle: const Text('Demnächst verfügbar'),
            value: false,
            onChanged: null,
          ),
        ],
      ),
    );
  }
}
