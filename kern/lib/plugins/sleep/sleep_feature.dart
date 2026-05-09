import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/plugins/plugin_interfaces.dart';
import '../derived/derived_providers.dart';
import '../../ui/theme/app_theme.dart';
import '../../ui/widgets/bouncing_card.dart';

class SleepFeature implements KernPlugin {
  @override
  String get id => 'sleep';

  @override
  String get name => 'Sleep';

  @override
  String get description => 'Sleep quality and duration metrics.';

  @override
  List<PluginSlot> get supportedSlots => [PluginSlot.footer, PluginSlot.header];

  @override
  Widget buildDashboardWidget(BuildContext context, PluginSlot slot) {
    if (slot == PluginSlot.header) {
      return const _SleepHeaderWidget();
    }
    return const _SleepFooterWidget();
  }

  @override
  Widget? buildDetailPage(BuildContext context) => const SleepDetailScreen();

  @override
  bool get hasDetailPage => true;

  @override
  Widget? buildSettingsPage(BuildContext context) => const SleepSettingsScreen();
}

class _SleepFooterWidget extends ConsumerWidget {
  const _SleepFooterWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreAsync = ref.watch(sleepScoreProvider());
    final minsAsync = ref.watch(sleepMinutesProvider());

    return BouncingCard(
      onTap: () {},
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
                  decoration: const BoxDecoration(
                    color: AppTheme.accentPurple,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.bedtime_rounded, color: AppTheme.textPurple, size: 16),
                ),
                const SizedBox(width: 8),
                const Text('Sleep', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppTheme.textSecondary)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Sleep score', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    scoreAsync.when(
                      data: (score) => Text(
                        score?.toStringAsFixed(0) ?? '--',
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                      ),
                      loading: () => const CircularProgressIndicator(),
                      error: (_, __) => const SizedBox(),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: AppTheme.accentMint, borderRadius: BorderRadius.circular(8)),
                      child: const Text('Good', style: TextStyle(color: AppTheme.textMint, fontSize: 11, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
                Container(width: 1, height: 60, color: AppTheme.divider),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Sleep duration', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    minsAsync.when(
                      data: (m) {
                        final hrs = (m.total / 60).floor();
                        final mins = (m.total % 60).floor();
                        return Text('${hrs}h ${mins}m', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.textPrimary));
                      },
                      loading: () => const Text('Loading...'),
                      error: (_, __) => const Text('Error'),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: AppTheme.accentOrange, borderRadius: BorderRadius.circular(8)),
                      child: const Text('Goal not met', style: TextStyle(color: AppTheme.textOrange, fontSize: 11, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
class _SleepHeaderWidget extends ConsumerWidget {
  const _SleepHeaderWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final minsAsync = ref.watch(sleepMinutesProvider());

    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.accentPurple,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.bedtime_rounded, color: AppTheme.textPurple, size: 16),
              SizedBox(width: 6),
              Text('Sleep', style: TextStyle(color: AppTheme.textPurple, fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          minsAsync.when(
            data: (m) {
              final hrs = (m.total / 60).floor();
              final mins = (m.total % 60).floor();
              return Text(
                '${hrs}h ${mins}m',
                style: const TextStyle(color: AppTheme.textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
              );
            },
            loading: () => const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
            error: (_, __) => const Text('!'),
          ),
        ],
      ),
    );
  }
}

class SleepDetailScreen extends ConsumerWidget {
  const SleepDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreAsync = ref.watch(sleepScoreProvider());
    final minsAsync = ref.watch(sleepMinutesProvider());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleep'),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2E243A) : AppTheme.accentPurple,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'A good night\'s sleep',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'You got the quality sleep needed to build a strong foundation for your day',
                  style: TextStyle(
                    fontSize: 15,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Sleep score', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        scoreAsync.when(
                          data: (score) => Text(
                            score?.toStringAsFixed(0) ?? '--',
                            style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                          ),
                          loading: () => const CircularProgressIndicator(),
                          error: (_, __) => const Text('--'),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(color: isDark ? const Color(0xFF1B2E24) : AppTheme.accentMint, borderRadius: BorderRadius.circular(12)),
                          child: const Text('Excellent', style: TextStyle(color: AppTheme.textMint, fontSize: 12, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Sleep duration', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 4),
                        minsAsync.when(
                          data: (m) {
                            final hrs = (m.total / 60).floor();
                            final mins = (m.total % 60).floor();
                            return Text(
                              '${hrs}h ${mins}m',
                              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                            );
                          },
                          loading: () => const CircularProgressIndicator(),
                          error: (_, __) => const Text('--'),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(color: isDark ? const Color(0xFF1B2E24) : AppTheme.accentMint, borderRadius: BorderRadius.circular(12)),
                          child: const Text('Excellent', style: TextStyle(color: AppTheme.textMint, fontSize: 12, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Sleep Stages',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildStageCard(context, 'Awake', '1h 12m', Colors.pinkAccent),
          const SizedBox(height: 12),
          _buildStageCard(context, 'REM', '2h 05m', Colors.purpleAccent),
          const SizedBox(height: 12),
          _buildStageCard(context, 'Light', '4h 15m', Colors.lightBlueAccent),
          const SizedBox(height: 12),
          _buildStageCard(context, 'Deep', '1h 30m', Colors.blueAccent),
        ],
      ),
    );
  }

  Widget _buildStageCard(BuildContext context, String title, String duration, Color color) {
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
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          ),
          Text(duration, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}

class SleepSettingsScreen extends StatelessWidget {
  const SleepSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sleep Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: const Text('Sleep Goal'),
            subtitle: const Text('8 hours 0 minutes'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {},
          ),
          SwitchListTile(
            title: const Text('Bedtime Reminder'),
            subtitle: const Text('Notify me 30 mins before bedtime'),
            value: true,
            onChanged: (val) {},
          ),
          SwitchListTile(
            title: const Text('Smart Alarm'),
            subtitle: const Text('Wake me up in light sleep phase'),
            value: false,
            onChanged: (val) {},
          ),
        ],
      ),
    );
  }
}
