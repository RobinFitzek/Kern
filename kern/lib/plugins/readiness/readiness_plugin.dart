import 'dart:math';

import 'package:flutter/foundation.dart';

import '../../core/database/app_database.dart';
import '../../core/database/derived_keys.dart';
import '../../core/database/tables.dart';

// ---------------------------------------------------------------------------
// ReadinessPlugin
// ---------------------------------------------------------------------------
// Weighted composite score (0–100) from HRV, sleep, and strain.
//
// Weights (default):
//   HRV   40% — compares 7-day avg to 30-day personal baseline
//   Sleep 35% — yesterday's deep+REM vs. optimal 180 min
//   Strain 25% — yesterday's steps vs. 7-day avg (inverse: high = lower score)
//
// If HRV data is unavailable or calibrating (<7 days), weights shift:
//   Sleep 60% / Strain 40%
// ---------------------------------------------------------------------------

class ReadinessPlugin {
  ReadinessPlugin(this._db);

  final AppDatabase _db;

  static const int _minHrvPoints = 5; // points needed before HRV is trusted
  static const double _optimalStageMins = 180.0; // 90 deep + 90 REM
  static const double _optimalTotalMins = 480.0; // 8 hours

  Future<void> run(String date) async {
    final now = DateTime.now().toUtc();

    // --- Fetch raw data -------------------------------------------------------

    final hrv30d = await _db.rawEntriesSince(
      type: RawDataType.hrv,
      since: now.subtract(const Duration(days: 30)),
    );

    // Sleep: last 36 hours captures last night regardless of timezone offset.
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

    // Steps: 8 days = yesterday + 7-day baseline
    final steps8d = await _db.rawEntriesSince(
      type: RawDataType.steps,
      since: now.subtract(const Duration(days: 8)),
    );

    // --- Compute contributions ------------------------------------------------

    final bool isCalibrating = hrv30d.length < _minHrvPoints;
    final double? hrvC = isCalibrating ? null : _hrvContribution(hrv30d);
    final double? sleepC = _sleepContribution(deepEntries, remEntries, lightEntries);
    final double? strainC = _strainContribution(steps8d, now);

    debugPrint(
      '[ReadinessPlugin] hrv=$hrvC sleep=$sleepC strain=$strainC calibrating=$isCalibrating',
    );

    if (sleepC == null && strainC == null) {
      debugPrint('[ReadinessPlugin] not enough data to write score');
      return;
    }

    // --- Weighted score -------------------------------------------------------

    // Redistribute weights when components are missing.
    double totalWeight = 0;
    double scoreSum = 0;

    if (hrvC != null) {
      scoreSum += hrvC * 0.40;
      totalWeight += 0.40;
    }
    if (sleepC != null) {
      final w = hrvC != null ? 0.35 : 0.60;
      scoreSum += sleepC * w;
      totalWeight += w;
    }
    if (strainC != null) {
      final w = hrvC != null ? 0.25 : 0.40;
      scoreSum += strainC * w;
      totalWeight += w;
    }

    final score = totalWeight > 0
        ? (scoreSum / totalWeight) * 100.0
        : 0.0;

    final computedAt = DateTime.now().toUtc();

    // --- Write to Derived Store -----------------------------------------------

    Future<void> write(String key, double value) => _db.upsertDerived(
          DerivedEntriesCompanion.insert(
            namespace: DerivedNamespace.readiness,
            key: key,
            value: value,
            date: date,
            computedAt: computedAt,
          ),
        );

    await Future.wait([
      write(ReadinessKey.score, score.clamp(0, 100)),
      write(ReadinessKey.isCalibrating, isCalibrating ? 1.0 : 0.0),
      if (hrvC != null) write(ReadinessKey.hrvContribution, hrvC),
      if (sleepC != null) write(ReadinessKey.sleepContribution, sleepC),
      if (strainC != null) write(ReadinessKey.strainContribution, strainC),
    ]);

    debugPrint('[ReadinessPlugin] wrote score=${score.toStringAsFixed(1)} for $date');
  }

  // --- Algorithm helpers -----------------------------------------------------

  /// HRV: normalized ratio of 7-day avg vs 30-day baseline.
  /// Ratio clamped to [0.7, 1.3]; mapped linearly to [0, 1].
  double? _hrvContribution(List<RawEntry> entries) {
    if (entries.length < _minHrvPoints) return null;

    final values = entries.map((e) => e.value).toList();
    final baseline = _mean(values); // 30-day baseline

    final cutoff = DateTime.now().toUtc().subtract(const Duration(days: 7));
    final recent = entries.where((e) => e.timestamp.isAfter(cutoff)).map((e) => e.value).toList();

    if (recent.isEmpty) return null;
    final recentAvg = _mean(recent);
    if (baseline == 0) return null;

    final ratio = recentAvg / baseline;
    const minR = 0.7, maxR = 1.3;
    return ((ratio.clamp(minR, maxR)) - minR) / (maxR - minR);
  }

  /// Sleep: quality from deep+REM stages and total duration.
  double? _sleepContribution(
    List<RawEntry> deep,
    List<RawEntry> rem,
    List<RawEntry> light,
  ) {
    // Stage entries from Health Connect store duration in minutes as value.
    final deepMins = deep.fold(0.0, (s, e) => s + e.value);
    final remMins = rem.fold(0.0, (s, e) => s + e.value);
    final lightMins = light.fold(0.0, (s, e) => s + e.value);
    final totalMins = deepMins + remMins + lightMins;

    if (totalMins == 0) return null;

    final stageScore = min((deepMins + remMins), _optimalStageMins) / _optimalStageMins;
    final durationScore = min(totalMins, _optimalTotalMins) / _optimalTotalMins;

    return (0.6 * stageScore + 0.4 * durationScore).clamp(0.0, 1.0);
  }

  /// Strain: inverse of yesterday's steps vs 7-day avg.
  /// High step ratio → high strain → lower readiness.
  double? _strainContribution(List<RawEntry> stepsEntries, DateTime now) {
    if (stepsEntries.isEmpty) return null;

    final yesterdayStart = DateTime(now.year, now.month, now.day - 1).toUtc();
    final yesterdayEnd = DateTime(now.year, now.month, now.day).toUtc();

    final yesterdaySteps = stepsEntries
        .where((e) => e.timestamp.isAfter(yesterdayStart) && e.timestamp.isBefore(yesterdayEnd))
        .fold(0.0, (s, e) => s + e.value);

    // 7-day avg excluding yesterday
    final olderSteps = stepsEntries
        .where((e) => e.timestamp.isBefore(yesterdayStart))
        .toList();
    if (olderSteps.isEmpty) return null;

    // Sum per day then average
    final Map<String, double> byDay = {};
    for (final e in olderSteps) {
      final key = '${e.timestamp.year}-${e.timestamp.month}-${e.timestamp.day}';
      byDay[key] = (byDay[key] ?? 0) + e.value;
    }
    final avg7d = byDay.values.fold(0.0, (s, v) => s + v) / byDay.length;

    if (avg7d == 0) return 0.5; // neutral when no baseline
    final ratio = yesterdaySteps / avg7d;

    // ratio 0.5 = well rested → 1.0, ratio 1.5 = overtrained → 0.0
    const minR = 0.5, maxR = 1.5;
    return (1.0 - ((ratio.clamp(minR, maxR) - minR) / (maxR - minR))).clamp(0.0, 1.0);
  }

  double _mean(List<double> values) =>
      values.isEmpty ? 0 : values.reduce((a, b) => a + b) / values.length;
}
