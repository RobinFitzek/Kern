import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../core/database/app_database.dart';
import '../../core/database/derived_keys.dart';
import '../../core/database/tables.dart';

// ---------------------------------------------------------------------------
// StrainPlugin
// ---------------------------------------------------------------------------
// Computes a 0–100 daily strain score from yesterday's step count vs. the
// 7-day personal average.
//
// strain = min(yesterday / avg_7d, 2.0) / 2.0 × 100
//   0  = rest day (0 steps)
//   50 = average day (1× avg)
//   100 = double average (2× avg)
// ---------------------------------------------------------------------------

class StrainPlugin {
  StrainPlugin(this._db);

  final AppDatabase _db;

  Future<void> run(String date) async {
    final now = DateTime.now().toUtc();

    final stepsEntries = await _db.rawEntriesSince(
      type: RawDataType.steps,
      since: now.subtract(const Duration(days: 8)),
    );

    if (stepsEntries.isEmpty) {
      debugPrint('[StrainPlugin] no step data for $date');
      return;
    }

    // Yesterday's steps (previous calendar day in local time)
    final local = DateTime.now();
    final yesterdayStart = DateTime(local.year, local.month, local.day - 1).toUtc();
    final yesterdayEnd = DateTime(local.year, local.month, local.day).toUtc();

    final yesterdaySteps = stepsEntries
        .where((e) => e.timestamp.isAfter(yesterdayStart) && e.timestamp.isBefore(yesterdayEnd))
        .fold(0.0, (s, e) => s + e.value);

    // 7-day baseline: group older entries by day, average the daily totals
    final olderEntries = stepsEntries
        .where((e) => e.timestamp.isBefore(yesterdayStart))
        .toList();

    final Map<String, double> byDay = {};
    for (final e in olderEntries) {
      final local = e.timestamp.toLocal();
      final key = '${local.year}-${local.month.toString().padLeft(2, '0')}'
          '-${local.day.toString().padLeft(2, '0')}';
      byDay[key] = (byDay[key] ?? 0) + e.value;
    }

    final avg7d = byDay.isEmpty
        ? 0.0
        : byDay.values.fold(0.0, (s, v) => s + v) / byDay.length;

    final strain = avg7d == 0
        ? (yesterdaySteps > 0 ? 50.0 : 0.0) // neutral when no baseline
        : (min(yesterdaySteps / avg7d, 2.0) / 2.0 * 100).clamp(0.0, 100.0);

    debugPrint(
      '[StrainPlugin] yesterday=${yesterdaySteps.toStringAsFixed(0)} steps '
      'avg7d=${avg7d.toStringAsFixed(0)} steps '
      'strain=${strain.toStringAsFixed(1)}',
    );

    final computedAt = DateTime.now().toUtc();

    Future<void> write(String key, double value) => _db.upsertDerived(
          DerivedEntriesCompanion.insert(
            namespace: DerivedNamespace.strain,
            key: key,
            value: value,
            date: date,
            computedAt: computedAt,
          ),
        );

    await Future.wait([
      write(StrainKey.daily, strain),
      write(StrainKey.stepsYesterday, yesterdaySteps),
      write(StrainKey.steps7dAvg, avg7d),
    ]);
  }
}
