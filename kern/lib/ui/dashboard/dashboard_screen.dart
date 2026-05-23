import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/plugins/plugin_interfaces.dart';
import '../../core/plugins/plugin_registry.dart';
import '../../core/sync/sync_notifier.dart';
import '../../plugins/derived/derived_providers.dart';
import '../theme/app_theme.dart';
import '../widgets/calibration_banner.dart';
import '../widgets/recommendation_card.dart';
import '../widgets/stale_data_badge.dart';
import '../widgets/error_state_widget.dart';
import '../widgets/historical_readiness_chart.dart';
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

    return RefreshIndicator(
      onRefresh: () => ref.read(syncNotifierProvider.notifier).resync(),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        children: [
          _buildStatusBar(context, ref, syncState),
          const SizedBox(height: 24),

          // Main: Calibration or Readiness Score
          if (mainPlugins.isNotEmpty)
            _buildMainZone(context, ref, mainPlugins.first, state)
          else
            const CalibrationBanner(),
          const SizedBox(height: 24),

          // Row of 2 insight cards (Sleep + Strain side by side)
          if (headerPlugins.isNotEmpty) ...[
            _buildInsightRow(context, headerPlugins, ref),
            const SizedBox(height: 24),
          ],

          // Prominent recommendation card
          const RecommendationCard(),
          const SizedBox(height: 24),

          // Historical trend chart
          const _HistoricalChartSection(),
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
            color: isConnected
                ? AppTheme.accentMint
                : AppTheme.accentOrange,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isSyncing)
                const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppTheme.textMint),
                )
              else
                Icon(
                  isConnected ? Icons.check_circle_rounded : Icons.warning_amber_rounded,
                  size: 14,
                  color: isConnected ? AppTheme.textMint : AppTheme.textOrange,
                ),
              const SizedBox(width: 6),
              Text(
                isConnected ? 'Health Connect aktiv' : 'Health Connect getrennt',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isConnected ? AppTheme.textMint : AppTheme.textOrange,
                ),
              ),
              if (lastSync != null && isConnected) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.textMint.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    DateFormat('HH:mm').format(lastSync),
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: AppTheme.textMint),
                  ),
                ),
              ],
              if (!isConnected) ...[
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => ref.read(syncNotifierProvider.notifier).resync(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppTheme.textOrange.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Verbinden',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: AppTheme.textOrange),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMainZone(BuildContext context, WidgetRef ref, KernPlugin mainPlugin, PluginRegistryState state) {
    final isCalibratingAsync = ref.watch(readinessIsCalibratingProvider());
    final isCalibrating = isCalibratingAsync.valueOrNull ?? true;

    if (isCalibrating) {
      return StaleDataBadge(
        showDetail: false,
        child: const CalibrationBanner(),
      );
    }

    return StaleDataBadge(
      child: _wrapWithNavigation(
        context,
        mainPlugin,
        mainPlugin.buildDashboardWidget(context, PluginSlot.main),
      ),
    );
  }

  Widget _buildInsightRow(BuildContext context, List<KernPlugin> headerPlugins, WidgetRef ref) {
    final plugins = headerPlugins.take(2).toList();

    return Row(
      children: [
        for (int i = 0; i < plugins.length; i++) ...[
          if (i > 0) const SizedBox(width: 12),
          Expanded(
            child: StaleDataBadge(
              showDetail: false,
              child: _wrapWithNavigation(
                context,
                plugins[i],
                plugins[i].buildDashboardWidget(context, PluginSlot.header),
              ),
            ),
          ),
        ],
        if (plugins.length < 2) const Spacer(),
      ],
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

class _HistoricalChartSection extends ConsumerWidget {
  const _HistoricalChartSection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoresAsync = ref.watch(historicalReadinessScoresProvider(days: 14));
    final hasData = scoresAsync.valueOrNull != null && scoresAsync.value!.isNotEmpty;

    if (!hasData && !scoresAsync.isLoading) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        const Text(
          'Trend',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        const HistoricalReadinessChart(),
      ],
    );
  }
}
