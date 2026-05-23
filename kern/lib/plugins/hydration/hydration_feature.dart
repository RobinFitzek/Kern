import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/plugins/plugin_interfaces.dart';
import '../derived/derived_providers.dart';
import '../../ui/theme/app_theme.dart';

class HydrationFeature implements KernPlugin {
  @override
  String get id => 'hydration';

  @override
  String get name => 'Hydration';

  @override
  String get description => 'Tägliche Wasseraufnahme tracken und Ziel verfolgen.';

  @override
  List<PluginSlot> get supportedSlots => [PluginSlot.footer, PluginSlot.header];

  @override
  Widget buildDashboardWidget(BuildContext context, PluginSlot slot) {
    return const _HydrationWidget();
  }

  @override
  bool get hasDetailPage => true;

  @override
  Widget? buildDetailPage(BuildContext context) => const _HydrationDetailScreen();

  @override
  Widget? buildSettingsPage(BuildContext context) => const _HydrationSettingsScreen();
}

class _HydrationWidget extends ConsumerWidget {
  const _HydrationWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mlAsync = ref.watch(hydrationDailyMlProvider());
    final goalAsync = ref.watch(hydrationGoalPercentProvider());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final ml = mlAsync.valueOrNull ?? 0;
    final goal = goalAsync.valueOrNull ?? 0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.accentBlue,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.water_drop_rounded, color: AppTheme.textBlue, size: 16),
                ),
                const SizedBox(width: 8),
                const Text('Hydration', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppTheme.textSecondary)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${ml.toInt()} ml',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: goal >= 80 ? AppTheme.accentMint : AppTheme.accentOrange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${goal.toInt()}%',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: goal >= 80 ? AppTheme.textMint : AppTheme.textOrange,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: goal.clamp(0.0, 1.0) / 100,
                minHeight: 6,
                backgroundColor: isDark ? Colors.white12 : AppTheme.divider,
                color: goal >= 80 ? AppTheme.textMint : AppTheme.primaryBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HydrationDetailScreen extends StatelessWidget {
  const _HydrationDetailScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hydration')),
      body: const Center(
        child: Text('Hydration-Detailansicht — demnächst verfügbar'),
      ),
    );
  }
}

class _HydrationSettingsScreen extends StatelessWidget {
  const _HydrationSettingsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hydration Einstellungen')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: const Text('Tagesziel'),
            subtitle: const Text('2.500 ml'),
            trailing: const Icon(Icons.chevron_right),
            enabled: false,
          ),
          const ListTile(
            title: Text('Datenquelle'),
            subtitle: Text('Health Connect — Water'),
          ),
        ],
      ),
    );
  }
}
