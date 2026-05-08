import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/plugins/plugin_interfaces.dart';
import '../derived/derived_providers.dart';
import '../../ui/theme/app_theme.dart';

class ReadinessFeature implements KernPlugin {
  @override
  String get id => 'readiness';

  @override
  String get name => 'Readiness Score';

  @override
  String get description => 'Daily readiness score based on HRV, Sleep, and Strain.';

  @override
  List<PluginSlot> get supportedSlots => [PluginSlot.main, PluginSlot.header];

  @override
  Widget buildDashboardWidget(BuildContext context, PluginSlot slot) {
    if (slot == PluginSlot.main) {
      return const _ReadinessMainWidget();
    }
    return const _ReadinessHeaderWidget();
  }

  @override
  Widget? buildDetailPage(BuildContext context) => null; // Future: Readiness detail page

  @override
  bool get hasDetailPage => false;

  @override
  Widget? buildSettingsPage(BuildContext context) => null;
}

class _ReadinessMainWidget extends ConsumerWidget {
  const _ReadinessMainWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreAsync = ref.watch(readinessScoreProvider());
    final calibratingAsync = ref.watch(readinessIsCalibratingProvider());

    return Card(
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
                const Icon(Icons.more_horiz, color: AppTheme.textTertiary),
              ],
            ),
            const SizedBox(height: 24),
            scoreAsync.when(
              data: (score) {
                final isCalibrating = calibratingAsync.value ?? false;
                if (isCalibrating || score == null) {
                  return _buildScoreRing('--', 'Calibrating...');
                }
                return _buildScoreRing(score.toStringAsFixed(0), 'Good');
              },
              loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primaryBlue)),
              error: (_, __) => const Text('Error', style: TextStyle(color: AppTheme.textPink)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreRing(String score, String label) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: CircularProgressIndicator(
                value: score == '--' ? 0 : double.parse(score) / 100,
                strokeWidth: 12,
                backgroundColor: AppTheme.divider,
                color: AppTheme.primaryBlue,
                strokeCap: StrokeCap.round,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  score,
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: AppTheme.textPrimary, height: 1),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.accentMint,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(label, style: const TextStyle(color: AppTheme.textMint, fontWeight: FontWeight.w600, fontSize: 12)),
        ),
      ],
    );
  }
}

class _ReadinessHeaderWidget extends ConsumerWidget {
  const _ReadinessHeaderWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreAsync = ref.watch(readinessScoreProvider());
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.accentMint,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.bolt_rounded, color: AppTheme.textMint, size: 16),
              SizedBox(width: 6),
              Text('Readiness', style: TextStyle(color: AppTheme.textMint, fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          scoreAsync.when(
            data: (score) => Text(
              score?.toStringAsFixed(0) ?? '--',
              style: const TextStyle(color: AppTheme.textPrimary, fontSize: 28, fontWeight: FontWeight.bold),
            ),
            loading: () => const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
            error: (_, __) => const Text('!'),
          ),
        ],
      ),
    );
  }
}
