import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/plugins/plugin_interfaces.dart';
import '../derived/derived_providers.dart';

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
              color: const Color(0xFFF59E0B).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.directions_run_rounded, color: Color(0xFFF59E0B)),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text('Strain', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          ),
          scoreAsync.when(
            data: (score) => Text(
              score?.toStringAsFixed(0) ?? '--',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFFF59E0B)),
            ),
            loading: () => const CircularProgressIndicator(),
            error: (_, __) => const SizedBox(),
          ),
        ],
      ),
    );
  }
}
