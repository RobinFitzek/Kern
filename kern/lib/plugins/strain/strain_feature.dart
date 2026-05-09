import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/plugins/plugin_interfaces.dart';
import '../derived/derived_providers.dart';
import '../../ui/theme/app_theme.dart';
import '../../ui/widgets/bouncing_card.dart';

class StrainFeature implements KernPlugin {
  @override
  String get id => 'strain';

  @override
  String get name => 'Strain';

  @override
  String get description => 'Daily physical exertion based on steps.';

  @override
  List<PluginSlot> get supportedSlots => [PluginSlot.footer, PluginSlot.header];

  @override
  Widget buildDashboardWidget(BuildContext context, PluginSlot slot) {
    if (slot == PluginSlot.header) {
      return const _StrainHeaderWidget();
    }
    return const _StrainFooterWidget();
  }

  @override
  Widget? buildDetailPage(BuildContext context) => const StrainDetailScreen();

  @override
  bool get hasDetailPage => true;

  @override
  Widget? buildSettingsPage(BuildContext context) => const StrainSettingsScreen();
}

class _StrainFooterWidget extends ConsumerWidget {
  const _StrainFooterWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreAsync = ref.watch(strainScoreProvider());

    return BouncingCard(
      onTap: () {},
      child: Card(
        child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: AppTheme.accentBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.directions_run_rounded, color: AppTheme.textBlue),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Strain', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: AppTheme.textPrimary)),
                  Text('Daily exertion', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary)),
                ],
              ),
            ),
            scoreAsync.when(
              data: (score) => Text(
                score?.toStringAsFixed(0) ?? '--',
                style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
              ),
              loading: () => const CircularProgressIndicator(),
              error: (_, __) => const SizedBox(),
            ),
          ],
        ),
      ),
    ));
  }
}
class _StrainHeaderWidget extends ConsumerWidget {
  const _StrainHeaderWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreAsync = ref.watch(strainScoreProvider());

    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.accentBlue,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.directions_run_rounded, color: AppTheme.textBlue, size: 16),
              SizedBox(width: 6),
              Text('Strain', style: TextStyle(color: AppTheme.textBlue, fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          scoreAsync.when(
            data: (score) => Text(
              score?.toStringAsFixed(0) ?? '--',
              style: const TextStyle(color: AppTheme.textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            loading: () => const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
            error: (_, __) => const Text('!'),
          ),
        ],
      ),
    );
  }
}

class StrainDetailScreen extends ConsumerWidget {
  const StrainDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreAsync = ref.watch(strainScoreProvider());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Strain'),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E2835) : AppTheme.accentBlue,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Daily exertion',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.black26 : Colors.white54,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.directions_run_rounded, color: isDark ? Colors.white : AppTheme.textBlue),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                scoreAsync.when(
                  data: (score) => Text(
                    score?.toStringAsFixed(0) ?? '--',
                    style: TextStyle(fontSize: 64, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface, height: 1),
                  ),
                  loading: () => const CircularProgressIndicator(),
                  error: (_, __) => const Text('--'),
                ),
                const SizedBox(height: 8),
                Text(
                  'Cardiovascular load',
                  style: TextStyle(fontSize: 16, color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(color: isDark ? AppTheme.textBlue : Colors.white, borderRadius: BorderRadius.circular(16)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.trending_up_rounded, color: isDark ? Colors.white : AppTheme.textBlue, size: 20),
                      const SizedBox(width: 8),
                      Text('Optimal building', style: TextStyle(color: isDark ? Colors.white : AppTheme.textBlue, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Recent activities',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildActivityCard(context, 'Running', '10:30 AM • 45 min', 'High impact', Icons.directions_run_rounded, Colors.orangeAccent),
          const SizedBox(height: 12),
          _buildActivityCard(context, 'Walking', '8:00 AM • 20 min', 'Recovery', Icons.directions_walk_rounded, Colors.greenAccent),
        ],
      ),
    );
  }

  Widget _buildActivityCard(BuildContext context, String title, String subtitle, String tag, IconData icon, Color color) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 14)),
              ],
            ),
          ),
          Text(tag, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: theme.colorScheme.primary)),
        ],
      ),
    );
  }
}

class StrainSettingsScreen extends StatelessWidget {
  const StrainSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Strain Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: const Text('Daily Goal'),
            subtitle: const Text('10,000 steps'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          SwitchListTile(
            title: const Text('Include Workouts'),
            subtitle: const Text('Sync external workout data'),
            value: true,
            onChanged: (val) {},
          ),
          SwitchListTile(
            title: const Text('High Strain Alerts'),
            subtitle: const Text('Notify when overreaching'),
            value: true,
            onChanged: (val) {},
          ),
        ],
      ),
    );
  }
}
