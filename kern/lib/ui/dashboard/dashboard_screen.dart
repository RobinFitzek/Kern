import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/plugins/plugin_interfaces.dart';
import '../../core/plugins/plugin_registry.dart';
import '../../core/sync/sync_notifier.dart';
import '../theme/app_theme.dart';
import '../widgets/stale_data_badge.dart';
import '../widgets/error_state_widget.dart';
import 'dashboard_skeleton.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pluginStateAsync = ref.watch(activePluginsProvider);

    return Scaffold(
      body: SafeArea(
        child: pluginStateAsync.when(
          data: (state) => _buildContent(context, state, ref),
          loading: () => const DashboardSkeleton(),
          error: (e, st) => Center(
            child: ErrorStateWidget(
              type: ErrorDisplayType.error,
              message: 'Dashboard konnte nicht geladen werden',
              onRetry: () => ref.invalidate(activePluginsProvider),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, PluginRegistryState state, WidgetRef ref) {
    final syncState = ref.watch(syncNotifierProvider);

    final mainPlugins = state.getForSlot(PluginSlot.main);
    final headerPlugins = state.getForSlot(PluginSlot.header);
    final footerPlugins = state.getForSlot(PluginSlot.footer);

    return RefreshIndicator(
      onRefresh: () => ref.read(syncNotifierProvider.notifier).resync(),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          _buildStatusBar(context, ref, syncState),
          const SizedBox(height: 24),

          // Main zone — each plugin gets its full widget, stacked vertically
          for (final plugin in mainPlugins) ...[
            StaleDataBadge(
              showDetail: false,
              child: plugin.buildDashboardWidget(context, PluginSlot.main),
            ),
            const SizedBox(height: 24),
          ],

          // Header zone — compact cards in a horizontal row (max 2 per row)
          if (headerPlugins.isNotEmpty) ...[
            for (var i = 0; i < headerPlugins.length; i += 2)
              Padding(
                padding: EdgeInsets.only(bottom: i + 2 < headerPlugins.length ? 12 : 0),
                child: Row(
                  children: [
                    Expanded(
                      child: StaleDataBadge(
                        showDetail: false,
                        child: headerPlugins[i].buildDashboardWidget(context, PluginSlot.header),
                      ),
                    ),
                    if (i + 1 < headerPlugins.length) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: StaleDataBadge(
                          showDetail: false,
                          child: headerPlugins[i + 1].buildDashboardWidget(context, PluginSlot.header),
                        ),
                      ),
                    ] else
                      const Spacer(),
                  ],
                ),
              ),
            const SizedBox(height: 24),
          ],

          // Footer zone — widgets stacked vertically
          for (final plugin in footerPlugins)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: plugin.buildDashboardWidget(context, PluginSlot.footer),
            ),

          if (footerPlugins.isNotEmpty || headerPlugins.isNotEmpty || mainPlugins.isNotEmpty)
            const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildStatusBar(BuildContext context, WidgetRef ref, HealthSyncState syncState) {
    final isConnected = syncState.status != SyncStatus.permissionDenied && syncState.status != SyncStatus.error;
    final isSyncing = syncState.status == SyncStatus.syncing || syncState.status == SyncStatus.checkingPermissions;
    final lastSync = syncState.lastSyncTime;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isConnected ? AppTheme.accentMint : AppTheme.accentOrange,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSyncing)
                const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.textMint))
              else
                Icon(isConnected ? Icons.check_circle_rounded : Icons.warning_amber_rounded, size: 14, color: isConnected ? AppTheme.textMint : AppTheme.textOrange),
              const SizedBox(width: 6),
              Text(
                isConnected ? 'Health Connect aktiv' : 'Health Connect getrennt',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: isConnected ? AppTheme.textMint : AppTheme.textOrange),
              ),
              if (lastSync != null && isConnected) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(color: AppTheme.textMint.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                  child: Text(DateFormat('HH:mm').format(lastSync), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: AppTheme.textMint)),
                ),
              ],
              if (!isConnected) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => ref.read(syncNotifierProvider.notifier).resync(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: AppTheme.textOrange.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
                    child: const Text('Verbinden', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.textOrange)),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
