import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';
import 'package:health/health.dart';

import '../database/app_database.dart';
import '../database/tables.dart';

// ---------------------------------------------------------------------------
// HealthConnectService
// ---------------------------------------------------------------------------
// Responsible for:
//   1. Requesting Health Connect permissions
//   2. Delta-syncing health observations (only new data since last sync)
//   3. Writing observations into the Raw Store with full source attribution
//
// This class does NOT compute derived values — that is the plugins' job.
// ---------------------------------------------------------------------------

class HealthConnectService {
  HealthConnectService(this._db);

  final AppDatabase _db;
  final Health _health = Health();

  /// Initial backfill window when a data type has never been synced.
  static const Duration _initialBackfill = Duration(days: 30);

  // -------------------------------------------------------------------------
  // Permissions
  // -------------------------------------------------------------------------

  static const List<HealthDataType> _readTypes = [
    HealthDataType.HEART_RATE_VARIABILITY_RMSSD,
    HealthDataType.RESTING_HEART_RATE,
    HealthDataType.SLEEP_DEEP,
    HealthDataType.SLEEP_REM,
    HealthDataType.SLEEP_LIGHT,
    HealthDataType.STEPS,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.WATER,
  ];

  static List<HealthDataAccess> get _permissions =>
      _readTypes.map((_) => HealthDataAccess.READ).toList();

  /// Request Health Connect read permissions.
  /// Returns `true` when all permissions are granted.
  Future<bool> requestPermissions() async {
    try {
      return await _health.requestAuthorization(
        _readTypes,
        permissions: _permissions,
      );
    } catch (e) {
      debugPrint('[HealthConnectService] requestPermissions error: $e');
      return false;
    }
  }

  /// Check whether all required permissions are already granted.
  Future<bool> hasPermissions() async {
    try {
      return await _health.hasPermissions(
            _readTypes,
            permissions: _permissions,
          ) ??
          false;
    } catch (e) {
      debugPrint('[HealthConnectService] hasPermissions error: $e');
      return false;
    }
  }

  /// Maps a HealthDataType to the internal RawStore type name.
  String _mapType(HealthDataType type) {
    switch (type) {
      case HealthDataType.HEART_RATE_VARIABILITY_RMSSD:
        return RawDataType.hrv;
      case HealthDataType.RESTING_HEART_RATE:
        return RawDataType.restingHr;
      case HealthDataType.SLEEP_DEEP:
        return RawDataType.sleepDeep;
      case HealthDataType.SLEEP_REM:
        return RawDataType.sleepRem;
      case HealthDataType.SLEEP_LIGHT:
        return RawDataType.sleepLight;
      case HealthDataType.STEPS:
        return RawDataType.steps;
      case HealthDataType.HEART_RATE:
        return RawDataType.heartRate;
      default:
        // Use lowercase string representation for dynamically supported types.
        return type.name.toLowerCase();
    }
  }

  /// Full sync — all data types in parallel.
  /// Each type independently tracks its own watermark, so partial failures
  /// only affect the failed type on the next retry.
  Future<void> syncAll() {
    final futures = _readTypes.map((type) => _deltaSync(
          types: [type],
          rawType: _mapType(type),
        ));
    return Future.wait(futures);
  }

  // -------------------------------------------------------------------------
  // Internal — delta sync core
  // -------------------------------------------------------------------------

  Future<void> _deltaSync({
    required List<HealthDataType> types,
    required String rawType,
  }) async {
    final now = DateTime.now().toUtc();

    // Determine the start of the fetch window.
    // First run: go back 30 days. Subsequent runs: start from last watermark,
    // overlapping by 1 hour to catch any late-arriving data.
    final lastSync = await _db.lastSyncedAt(rawType);
    final start = lastSync != null
        ? lastSync.subtract(const Duration(hours: 1))
        : now.subtract(_initialBackfill);

    debugPrint(
      '[HealthConnectService] $rawType: fetching '
      '${start.toIso8601String()} → ${now.toIso8601String()}',
    );

    try {
      final points = await _health.getHealthDataFromTypes(
        startTime: start,
        endTime: now,
        types: types,
      );

      if (points.isEmpty) {
        // Advance watermark even with no data — avoids re-querying empty ranges.
        await _db.markSynced(rawType, now);
        return;
      }

      final companions = points.map((point) {
        final numericValue = point.value is NumericHealthValue
            ? (point.value as NumericHealthValue).numericValue.toDouble()
            : 0.0;

        // If it's a complex value, try to serialize it or at least capture its string representation
        String? metadataJson;
        if (point.value is! NumericHealthValue) {
          try {
            // Using toString as a safe fallback. The health package objects usually
            // override toString() to provide a JSON-like map representation.
            metadataJson = point.value.toString();
          } catch (_) {}
        }

        // sourceId is the originating app's package name in the health package,
        // e.g. "com.garmin.android.apps.connectmobile".
        final origin = point.sourceId.isNotEmpty ? point.sourceId : 'unknown';

        return RawEntriesCompanion(
          type: Value(rawType),
          value: Value(numericValue),
          timestamp: Value(point.dateFrom.toUtc()),
          timestampEnd: Value(point.dateTo.toUtc()),
          sourceName: Value(origin),
          // sourceId is the package name; uuid is Health Connect's record UUID.
          sourceRecordId: Value(point.uuid),
          metadata: Value(metadataJson),
        );
      }).toList();

      // insertOrIgnore — rows matching (type, timestamp, sourceName) are skipped.
      await _db.insertRawBatch(companions);
      await _db.markSynced(rawType, now);

      debugPrint(
        '[HealthConnectService] $rawType: stored/skipped '
        '${companions.length} entries from '
        '${_uniqueSources(points).join(", ")}',
      );
    } catch (e) {
      // Do NOT advance the watermark on failure — next sync will retry.
      debugPrint('[HealthConnectService] _deltaSync($rawType) error: $e');
    }
  }

  /// Returns the distinct source app names present in a batch of points.
  static List<String> _uniqueSources(List<HealthDataPoint> points) =>
      points.map((p) => p.sourceId).toSet().toList();
}
