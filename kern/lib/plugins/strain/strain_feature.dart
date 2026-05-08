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
  Widget? buildDetailPage(BuildContext context) => null;

  @override
  bool get hasDetailPage => false;

  @override
  Widget? buildSettingsPage(BuildContext context) => null;
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
