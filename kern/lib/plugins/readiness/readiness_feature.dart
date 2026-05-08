import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/plugins/plugin_interfaces.dart';
import '../derived/derived_providers.dart';

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

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF00D4FF).withOpacity(0.15),
            Colors.transparent,
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF00D4FF).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text('Readiness', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 16)),
          const SizedBox(height: 16),
          scoreAsync.when(
            data: (score) {
              final isCalibrating = calibratingAsync.value ?? false;
              if (isCalibrating || score == null) {
                return _buildScoreRing('--', 'Calibrating...');
              }
              return _buildScoreRing(score.toStringAsFixed(0), 'Good to go');
            },
            loading: () => const CircularProgressIndicator(color: Color(0xFF00D4FF)),
            error: (_, __) => const Text('Error', style: TextStyle(color: Colors.red)),
          ),
        ],
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
              width: 140,
              height: 140,
              child: CircularProgressIndicator(
                value: score == '--' ? 0 : double.parse(score) / 100,
                strokeWidth: 8,
                backgroundColor: Colors.white.withOpacity(0.05),
                color: const Color(0xFF00D4FF),
                strokeCap: StrokeCap.round,
              ),
            ),
            Text(
              score,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(label, style: const TextStyle(color: Color(0xFF00D4FF), fontWeight: FontWeight.w500)),
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
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16161D),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Readiness', style: TextStyle(color: Colors.white70, fontSize: 16)),
          scoreAsync.when(
            data: (score) => Text(
              score?.toStringAsFixed(0) ?? '--',
              style: const TextStyle(color: Color(0xFF00D4FF), fontSize: 24, fontWeight: FontWeight.bold),
            ),
            loading: () => const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(strokeWidth: 2)),
            error: (_, __) => const Text('!'),
          ),
        ],
      ),
    );
  }
}
