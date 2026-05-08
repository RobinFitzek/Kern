import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/plugins/plugin_interfaces.dart';
import '../../core/plugins/plugin_registry.dart';
import '../../core/sync/sync_notifier.dart';

// ---------------------------------------------------------------------------
// DashboardScreen
// ---------------------------------------------------------------------------
// A dynamic shell that renders plugins into three zones: header, main, footer.
// If multiple plugins share a zone (e.g. header), it renders them in a carousel
// or scrollable list.
// ---------------------------------------------------------------------------

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch active plugins configuration. Rebuilds when user changes slots/order.
    final pluginStateAsync = ref.watch(activePluginsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: SafeArea(
        child: pluginStateAsync.when(
          data: (state) => _buildZones(context, state, ref),
          loading: () => const Center(
            child: CircularProgressIndicator(color: Color(0xFF00D4FF)),
          ),
          error: (e, st) => Center(child: Text('Error loading dashboard: $e')),
        ),
      ),
    );
  }

  Widget _buildZones(BuildContext context, PluginRegistryState state, WidgetRef ref) {
    final headerPlugins = state.getForSlot(PluginSlot.header);
    final mainPlugins = state.getForSlot(PluginSlot.main);
    final footerPlugins = state.getForSlot(PluginSlot.footer);

    return RefreshIndicator(
      color: const Color(0xFF00D4FF),
      backgroundColor: const Color(0xFF1E1E24),
      onRefresh: () => ref.read(syncNotifierProvider.notifier).resync(),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'kern',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF00D4FF),
                  letterSpacing: -1,
                ),
              ),
              _SyncStatusBadge(state: ref.watch(syncNotifierProvider)),
            ],
          ),
          const SizedBox(height: 32),

          // Header Zone (Carousel if multiple)
          if (headerPlugins.isNotEmpty)
            SizedBox(
              height: 100,
              child: PageView.builder(
                controller: PageController(viewportFraction: 0.9),
                padEnds: false,
                itemCount: headerPlugins.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: headerPlugins[index].buildDashboardWidget(context, PluginSlot.header),
                  );
                },
              ),
            ),
          
          if (headerPlugins.isNotEmpty) const SizedBox(height: 32),

          // Main Zone (Usually one large widget, e.g. Readiness Ring)
          if (mainPlugins.isNotEmpty)
            ...mainPlugins.map((p) => Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: p.buildDashboardWidget(context, PluginSlot.main),
                )),

          // Footer Zone (List of smaller widgets, e.g. Sleep details, Strain)
          if (footerPlugins.isNotEmpty)
            ...footerPlugins.map((p) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: p.buildDashboardWidget(context, PluginSlot.footer),
                )),
        ],
      ),
    );
  }
}

class _SyncStatusBadge extends StatelessWidget {
  const _SyncStatusBadge({required this.state});
  final HealthSyncState state;

  @override
  Widget build(BuildContext context) {
    if (state.status == SyncStatus.syncing) {
      return const SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF00D4FF)),
      );
    }
    if (state.status == SyncStatus.error) {
      return const Icon(Icons.warning_amber_rounded, color: Colors.redAccent, size: 20);
    }
    return const SizedBox.shrink(); // Hidden when done/idle
  }
}
