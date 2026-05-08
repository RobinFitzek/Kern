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
  Widget? buildDetailPage(BuildContext context) => null;

  @override
  bool get hasDetailPage => false;

  @override
  Widget? buildSettingsPage(BuildContext context) => null;
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
