import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/plugins/plugin_interfaces.dart';
import '../../core/plugins/plugin_registry.dart';
import '../../core/sync/sync_notifier.dart';
import '../theme/app_theme.dart';
import 'dashboard_skeleton.dart';

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
      body: SafeArea(
        child: pluginStateAsync.when(
          data: (state) => _buildZones(context, state, ref),
          loading: () => const DashboardSkeleton(),
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
      onRefresh: () => ref.read(syncNotifierProvider.notifier).resync(),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Kern',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: AppTheme.primaryBlue,
                ),
              ),
              const SizedBox(width: 8),
              _SyncStatusBadge(state: ref.watch(syncNotifierProvider)),
            ],
          ),
          const SizedBox(height: 32),

          // Header Zone (Carousel if multiple)
          if (headerPlugins.isNotEmpty)
            SizedBox(
              height: 110,
              child: PageView.builder(
                controller: PageController(viewportFraction: 0.9),
                padEnds: false,
                itemCount: headerPlugins.length,
                itemBuilder: (context, index) {
                  final p = headerPlugins[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 16),
                    child: _wrapWithNavigation(context, p, p.buildDashboardWidget(context, PluginSlot.header)),
                  );
                },
              ),
            ),
          
          if (headerPlugins.isNotEmpty) const SizedBox(height: 32),

          // Main Zone (Usually one large widget, e.g. Readiness Ring)
          if (mainPlugins.isNotEmpty)
            ...mainPlugins.map((p) => Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: _wrapWithNavigation(context, p, p.buildDashboardWidget(context, PluginSlot.main)),
                )),

          // Footer Zone (List of smaller widgets, e.g. Sleep details, Strain)
          if (footerPlugins.isNotEmpty)
            ...footerPlugins.map((p) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _wrapWithNavigation(context, p, p.buildDashboardWidget(context, PluginSlot.footer)),
                )),
        ],
      ),
    );
  }

  Widget _wrapWithNavigation(BuildContext context, KernPlugin plugin, Widget child) {
    if (!plugin.hasDetailPage) return child;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        final detailPage = plugin.buildDetailPage(context);
        if (detailPage != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => detailPage),
          );
        }
      },
      child: IgnorePointer(
        ignoring: false,
        child: child,
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
      return const Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 16);
    }
    return const SizedBox.shrink(); // Hidden when done/idle
  }
}
