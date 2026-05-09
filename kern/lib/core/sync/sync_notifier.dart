import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/service_providers.dart';
import '../../plugins/plugin_runner.dart';

part 'sync_notifier.g.dart';

// ---------------------------------------------------------------------------
// SyncState — describes the current sync lifecycle
// ---------------------------------------------------------------------------

enum SyncStatus {
  /// Initial state — nothing has happened yet.
  idle,

  /// Checking whether Health Connect permissions are already granted.
  checkingPermissions,

  /// All permissions granted; fetching data from Health Connect.
  syncing,

  /// Sync completed successfully.
  done,

  /// Health Connect permissions were not granted by the user.
  permissionDenied,

  /// An unexpected error occurred during sync. See [SyncState.error].
  error,
}

/// Describes the current state of a Health Connect sync lifecycle.
class HealthSyncState {
  const HealthSyncState({
    this.status = SyncStatus.idle,
    this.error,
    this.lastSyncTime,
  });

  final SyncStatus status;

  /// Non-null when [status] is [SyncStatus.error].
  final Object? error;

  /// Time of last successful sync attempt.
  final DateTime? lastSyncTime;

  bool get isLoading =>
      status == SyncStatus.checkingPermissions ||
      status == SyncStatus.syncing;

  HealthSyncState copyWith({SyncStatus? status, Object? error, DateTime? lastSyncTime}) => HealthSyncState(
        status: status ?? this.status,
        error: error,
        lastSyncTime: lastSyncTime ?? this.lastSyncTime,
      );

  @override
  String toString() => 'HealthSyncState($status, error: $error)';
}

// ---------------------------------------------------------------------------
// SyncNotifier — orchestrates permission check + sync on every app open
// ---------------------------------------------------------------------------

@Riverpod(keepAlive: true)
class SyncNotifier extends _$SyncNotifier {
  @override
  HealthSyncState build() => const HealthSyncState();

  /// Called once on app open (from main.dart via ref.listen or initState).
  ///
  /// Flow:
  ///   1. Check if permissions are already granted.
  ///   2a. Granted → run syncAll (delta fetch only, fast on subsequent opens).
  ///   2b. Not granted → request permissions → if granted, sync; else deny.
  Future<void> initialize() async {
    if (state.isLoading) return; // already running

    final prefs = await SharedPreferences.getInstance();
    final isExplicitlyDisabled = prefs.getBool('health_connect_disabled') ?? false;

    if (isExplicitlyDisabled) {
      state = const HealthSyncState(status: SyncStatus.permissionDenied);
      return;
    }

    final service = ref.read(healthConnectServiceProvider);

    // Step 1: check existing permissions
    state = const HealthSyncState(status: SyncStatus.checkingPermissions);

    final bool hasPerms;
    try {
      hasPerms = await service.hasPermissions();
    } catch (e) {
      state = HealthSyncState(status: SyncStatus.error, error: e);
      return;
    }

    // Step 2a: request if not yet granted
    if (!hasPerms) {
      // It might return false if the user only granted *some* permissions,
      // or if their phone doesn't support a specific metric.
      // We do not block sync if it returns false, because they might have 
      // granted partial permissions.
      await service.requestPermissions();
    }

    // Step 3: delta sync (only fetches data newer than last watermark)
    state = const HealthSyncState(status: SyncStatus.syncing);
    try {
      await service.syncAll();
      state = HealthSyncState(status: SyncStatus.done, lastSyncTime: DateTime.now());
      // Step 4: run plugins — compute derived scores from fresh raw data.
      // Fire-and-forget: plugin errors don't affect the sync status shown in UI.
      ref
          .read(pluginRunnerProvider.notifier)
          .runAll(todayDateString())
          .ignore();
    } catch (e) {
      state = HealthSyncState(status: SyncStatus.error, error: e);
    }
  }

  /// Manually re-triggers a sync (e.g. after the user grants permissions
  /// from the settings screen or pulls to refresh on the dashboard).
  Future<void> resync() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('health_connect_disabled', false);
    
    state = state.copyWith(status: SyncStatus.idle);
    await initialize();
  }

  /// Explicitly disconnects Health Connect sync
  Future<void> disconnect() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('health_connect_disabled', true);
    
    state = const HealthSyncState(status: SyncStatus.permissionDenied);
  }
}
