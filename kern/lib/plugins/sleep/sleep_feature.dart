import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/plugins/plugin_interfaces.dart';
import '../derived/derived_providers.dart';

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

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF16161D),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.bedtime_rounded, color: Color(0xFF8B5CF6)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Sleep', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 4),
                minsAsync.when(
                  data: (m) {
                    final hrs = (m.total / 60).floor();
                    final mins = (m.total % 60).floor();
                    return Text('${hrs}h ${mins}m', style: TextStyle(color: Colors.white.withOpacity(0.6)));
                  },
                  loading: () => const Text('Loading...'),
                  error: (_, __) => const Text('Error'),
                ),
              ],
            ),
          ),
          scoreAsync.when(
            data: (score) => Text(
              score?.toStringAsFixed(0) ?? '--',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF8B5CF6)),
            ),
            loading: () => const CircularProgressIndicator(),
            error: (_, __) => const SizedBox(),
          ),
        ],
      ),
    );
  }
}
