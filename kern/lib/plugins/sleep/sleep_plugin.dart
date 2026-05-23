import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../core/database/app_database.dart';
import '../../core/database/derived_keys.dart';
import '../../core/database/tables.dart';

// ---------------------------------------------------------------------------
// SleepPlugin
// ---------------------------------------------------------------------------
// Computes a 0–100 sleep quality score from last night's stage data.
//
// Score = 60% × stage_score + 40% × duration_score
//   stage_score    = min(deep + REM, 180 min) / 180
//   duration_score = min(total sleep, 480 min) / 480
// ---------------------------------------------------------------------------

class SleepPlugin {
  SleepPlugin(this._db);

  final AppDatabase _db;

  static const double _optimalStageMins = 180.0;
  static const double _optimalTotalMins = 480.0;

  Future<void> run(String date) async {
    final now = DateTime.now().toUtc();
    final sleepStart = now.subtract(const Duration(hours: 36));

    final deepEntries = await _db.rawEntriesBetween(
      type: RawDataType.sleepDeep,
      from: sleepStart,
      to: now,
    );
    final remEntries = await _db.rawEntriesBetween(
      type: RawDataType.sleepRem,
      from: sleepStart,
      to: now,
    );
    final lightEntries = await _db.rawEntriesBetween(
      type: RawDataType.sleepLight,
      from: sleepStart,
      to: now,
    );

    final deepMins = _sumDuration(deepEntries);
    final remMins = _sumDuration(remEntries);
    final lightMins = _sumDuration(lightEntries);
    final totalMins = deepMins + remMins + lightMins;

    if (totalMins == 0) {
      debugPrint('[SleepPlugin] no sleep data for $date');
      return;
    }

    final stageScore = min((deepMins + remMins), _optimalStageMins) / _optimalStageMins;
    final durationScore = min(totalMins, _optimalTotalMins) / _optimalTotalMins;
    final qualityScore = ((0.6 * stageScore + 0.4 * durationScore) * 100).clamp(0.0, 100.0);

    debugPrint(
      '[SleepPlugin] deep=${deepMins.toStringAsFixed(0)}m '
      'rem=${remMins.toStringAsFixed(0)}m '
      'light=${lightMins.toStringAsFixed(0)}m '
      'quality=${qualityScore.toStringAsFixed(1)}',
    );

    final computedAt = DateTime.now().toUtc();

    Future<void> write(String key, double value) => _db.upsertDerived(
          DerivedEntriesCompanion.insert(
            namespace: DerivedNamespace.sleep,
            key: key,
            value: value,
            date: date,
            computedAt: computedAt,
          ),
        );

    await Future.wait([
      write(SleepKey.qualityScore, qualityScore),
      write(SleepKey.deepMinutes, deepMins),
      write(SleepKey.remMinutes, remMins),
      write(SleepKey.lightMinutes, lightMins),
      write(SleepKey.totalMinutes, totalMins),
    ]);
  }

  /// Sums the duration of sleep stage entries in minutes from timestamps.
  /// Uses timestampEnd - timestamp; falls back to value field for legacy data.
  double _sumDuration(List<RawEntry> entries) {
    double total = 0.0;
    for (final e in entries) {
      if (e.timestampEnd != null) {
        final mins = e.timestampEnd!.difference(e.timestamp).inSeconds / 60.0;
        if (mins > 0 && mins < 480) total += mins;
      } else {
        if (e.value > 0 && e.value < 480) total += e.value;
      }
    }
    return total;
  }
}
