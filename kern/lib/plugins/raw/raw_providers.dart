/// Raw data Riverpod providers.
///
/// These providers expose read-only windows into the Raw Store.
/// Plugins consume these providers to compute derived values.
/// No plugin may write back to the Raw Store — only [HealthConnectService] does.
///
/// ### Source filtering
/// Each provider accepts an optional [sourceName] parameter.
/// Pass the package name of a specific device app (e.g.
/// `"com.garmin.android.apps.connectmobile"`) to get only that device's data.
/// Leave null to get data from all sources (Health Connect's priority order).
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/database/app_database.dart';
import '../../core/database/tables.dart';

part 'raw_providers.g.dart';

// ---------------------------------------------------------------------------
// Database provider — single shared instance injected at ProviderScope
// ---------------------------------------------------------------------------

/// Shared [AppDatabase] instance. Override in tests with a mock.
final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

// ---------------------------------------------------------------------------
// Raw HRV
// ---------------------------------------------------------------------------

/// Returns HRV (RMSSD) entries from the Raw Store for the given [window].
/// Pass [sourceName] to restrict to a specific device/app.
@riverpod
Future<List<RawEntry>> rawHrv(
  Ref ref, {
  Duration window = const Duration(days: 30),
  String? sourceName,
}) async {
  final db = ref.watch(appDatabaseProvider);
  return db.rawEntriesSince(
    type: RawDataType.hrv,
    since: DateTime.now().subtract(window),
    sourceName: sourceName,
  );
}

// ---------------------------------------------------------------------------
// Raw Resting Heart Rate
// ---------------------------------------------------------------------------

/// Returns resting HR entries from the Raw Store for the given [window].
@riverpod
Future<List<RawEntry>> rawRestingHr(
  Ref ref, {
  Duration window = const Duration(days: 30),
  String? sourceName,
}) async {
  final db = ref.watch(appDatabaseProvider);
  return db.rawEntriesSince(
    type: RawDataType.restingHr,
    since: DateTime.now().subtract(window),
    sourceName: sourceName,
  );
}

// ---------------------------------------------------------------------------
// Raw Sleep
// ---------------------------------------------------------------------------

/// Returns deep sleep entries from the Raw Store for the given [window].
@riverpod
Future<List<RawEntry>> rawSleepDeep(
  Ref ref, {
  Duration window = const Duration(days: 30),
  String? sourceName,
}) async {
  final db = ref.watch(appDatabaseProvider);
  return db.rawEntriesSince(
    type: RawDataType.sleepDeep,
    since: DateTime.now().subtract(window),
    sourceName: sourceName,
  );
}

/// Returns REM sleep entries from the Raw Store for the given [window].
@riverpod
Future<List<RawEntry>> rawSleepRem(
  Ref ref, {
  Duration window = const Duration(days: 30),
  String? sourceName,
}) async {
  final db = ref.watch(appDatabaseProvider);
  return db.rawEntriesSince(
    type: RawDataType.sleepRem,
    since: DateTime.now().subtract(window),
    sourceName: sourceName,
  );
}

/// Returns light sleep entries from the Raw Store for the given [window].
@riverpod
Future<List<RawEntry>> rawSleepLight(
  Ref ref, {
  Duration window = const Duration(days: 30),
  String? sourceName,
}) async {
  final db = ref.watch(appDatabaseProvider);
  return db.rawEntriesSince(
    type: RawDataType.sleepLight,
    since: DateTime.now().subtract(window),
    sourceName: sourceName,
  );
}

/// Aggregated convenience provider — all three sleep stage lists as a record.
/// Plugins that need the full sleep picture use this instead of three watches.
@riverpod
Future<({List<RawEntry> deep, List<RawEntry> rem, List<RawEntry> light})> rawSleep(
  Ref ref, {
  Duration window = const Duration(days: 30),
  String? sourceName,
}) async {
  final deep = await ref.watch(
    rawSleepDeepProvider(window: window, sourceName: sourceName).future,
  );
  final rem = await ref.watch(
    rawSleepRemProvider(window: window, sourceName: sourceName).future,
  );
  final light = await ref.watch(
    rawSleepLightProvider(window: window, sourceName: sourceName).future,
  );
  return (deep: deep, rem: rem, light: light);
}

// ---------------------------------------------------------------------------
// Raw Steps
// ---------------------------------------------------------------------------

/// Returns step count entries from the Raw Store for the given [window].
@riverpod
Future<List<RawEntry>> rawSteps(
  Ref ref, {
  Duration window = const Duration(days: 30),
  String? sourceName,
}) async {
  final db = ref.watch(appDatabaseProvider);
  return db.rawEntriesSince(
    type: RawDataType.steps,
    since: DateTime.now().subtract(window),
    sourceName: sourceName,
  );
}
