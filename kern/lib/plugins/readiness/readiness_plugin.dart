import 'dart:convert';
import 'dart:math';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/foundation.dart';

import '../../core/database/app_database.dart';
import '../../core/database/derived_keys.dart';
import '../../core/database/tables.dart';
import 'readiness_algorithm.dart';

// ---------------------------------------------------------------------------
// ReadinessPlugin — bimodal Physical + Mental Readiness Score
// ---------------------------------------------------------------------------
//
// Computes two independent daily scores (0–100) from Health Connect data:
//
//   Physical Readiness (R_phys):
//     • Nightly RMSSD (HRV)     weight 35%
//     • Resting Heart Rate       weight 20%
//     • Deep Sleep duration      weight 20%
//     • Total Sleep Time         weight 15%
//     • ACWR Strain Penalty      weight 10% (penalty, not additive)
//
//   Mental Readiness (R_ment):
//     • REM Sleep duration       weight 30%
//     • Sleep Regularity Index   weight 30%
//     • HRV Coefficient of Var   weight 20%
//     • Sleep Efficiency (WASO)  weight 20%
//
//   Both scores are fused with optional morning check-in (Bayesian update):
//     R_final = w_obj * R_obj + (1-w_obj) * R_subj
//
//   Default: w_obj = 0.8 (trusts sensors 80%). Adapts as feedback accumulates.
//
//   Data requirements:
//     - 28-day baseline window for Z-score normalization
//     - ≥ 7 HRV points to enable HRV component (else calibrating)
//     - ≥ 14 sleep nights for Sleep Regularity Index (SRI)
//     - Active calories (preferred) or steps (fallback) for ACWR
// ---------------------------------------------------------------------------

class ReadinessPlugin {
  ReadinessPlugin(this._db);

  final AppDatabase _db;
  final ReadinessAlgorithm _algo = const ReadinessAlgorithm();

  // ── Thresholds ─────────────────────────────────────────────────────────────
  static const int _minHrvPoints = 7;
  static const int _minSleepNights = 3;
  static const int _sriMinDays = 14;
  static const Duration _baselineWindow = Duration(days: 28);
  static const Duration _acwrChronicWindow = Duration(days: 28);
  static const Duration _acwrAcuteWindow = Duration(days: 7);
  static const double _defaultWObj = 0.8;

  Future<void> run(String date) async {
    final now = DateTime.now().toUtc();
    debugPrint('[ReadinessPlugin] Computing for date=$date');

    // ── 1. Fetch raw data ────────────────────────────────────────────────────
    final baselineStart = now.subtract(_baselineWindow);
    final sleepWindow = now.subtract(const Duration(hours: 36));

    // HRV: full 28-day window for baseline + 7-day for CV
    final hrv28d = await _db.rawEntriesSince(
      type: RawDataType.hrv,
      since: baselineStart,
    );

    // Resting HR: 28-day baseline
    final rhr28d = await _db.rawEntriesSince(
      type: RawDataType.restingHr,
      since: baselineStart,
    );

    // Sleep stages: 28-day window for baseline + SRI computation
    final deepAll = await _db.rawEntriesSince(
      type: RawDataType.sleepDeep,
      since: baselineStart,
    );
    final remAll = await _db.rawEntriesSince(
      type: RawDataType.sleepRem,
      since: baselineStart,
    );
    final lightAll = await _db.rawEntriesSince(
      type: RawDataType.sleepLight,
      since: baselineStart,
    );

    // Active Calories for ACWR (28d chronic + 7d acute)
    final calories28d = await _db.rawEntriesSince(
      type: 'active_energy_burned',
      since: now.subtract(_acwrChronicWindow),
    );

    // Morning check-in feedback (may be null if not yet submitted)
    final feedback = await _db.getFeedback(date);

    // ── 2. Aggregate nightly data ────────────────────────────────────────────
    final nights = _aggregateNights(
      deepAll: deepAll,
      remAll: remAll,
      lightAll: lightAll,
      hrv: hrv28d,
      rhr: rhr28d,
      windowStart: baselineStart,
    );

    final hasHrvData = hrv28d.length >= _minHrvPoints;
    final hasSleepData = nights.length >= _minSleepNights;

    if (!hasSleepData && !hasHrvData) {
      debugPrint('[ReadinessPlugin] Insufficient data — skipping computation');
      return;
    }

    // Tonight's data (most recent night in window)
    final tonight = _lastNight(
      deepAll: deepAll,
      remAll: remAll,
      lightAll: lightAll,
      hrv: hrv28d,
      rhr: rhr28d,
      since: sleepWindow,
      now: now,
    );

    if (tonight == null && !hasHrvData) {
      debugPrint('[ReadinessPlugin] No recent sleep night found — skipping');
      return;
    }

    // ── 3. Build baseline arrays ─────────────────────────────────────────────
    // Exclude tonight from baseline (compare against history, not itself)
    final cutoffNight = tonight?.date;
    final historicalNights = nights
        .where((n) => n.date != cutoffNight)
        .toList();

    final baselineHrv = historicalNights
        .where((n) => n.avgHrv != null)
        .map((n) => n.avgHrv!)
        .toList();
    final baselineRhr = historicalNights
        .where((n) => n.avgRhr != null)
        .map((n) => n.avgRhr!)
        .toList();
    final baselineDeep = historicalNights.map((n) => n.deepMins).toList();
    final baselineTst = historicalNights.map((n) => n.totalSleepMins).toList();
    final baselineRem = historicalNights.map((n) => n.remMins).toList();

    // 7-day HRV for Coefficient of Variation
    final hrv7dCutoff = now.subtract(const Duration(days: 7));
    final hrv7d = hrv28d
        .where((e) => e.timestamp.isAfter(hrv7dCutoff))
        .map((e) => e.value)
        .toList();
    final cv7d = _algo.coefficientOfVariation(hrv7d);
    final baselineCv = _computeRollingCv(hrv28d, windowDays: 7);

    // ── 4. Compute Z-scores ──────────────────────────────────────────────────
    final todayHrv = tonight?.avgHrv ?? (baselineHrv.isNotEmpty ? _mean(baselineHrv) : 0.0);
    final todayRhr = tonight?.avgRhr ?? (baselineRhr.isNotEmpty ? _mean(baselineRhr) : 0.0);
    final todayDeep = tonight?.deepMins ?? 0.0;
    final todayTst = tonight?.totalSleepMins ?? 0.0;
    final todayRem = tonight?.remMins ?? 0.0;
    final todayEfficiency = tonight?.efficiency ?? 0.85;

    final zHrv = hasHrvData && baselineHrv.length >= 3
        ? _algo.zScore(todayHrv, baselineHrv)
        : 0.0;
    final zRhr = baselineRhr.length >= 3
        ? _algo.zScore(todayRhr, baselineRhr)
        : 0.0;
    final zDeep = baselineDeep.length >= 3
        ? _algo.zScore(todayDeep, baselineDeep)
        : 0.0;
    final zTst = baselineTst.length >= 3
        ? _algo.zScore(todayTst, baselineTst)
        : 0.0;
    final zRem = baselineRem.length >= 3
        ? _algo.zScore(todayRem, baselineRem)
        : 0.0;
    final zCv = baselineCv.length >= 3
        ? _algo.zScore(cv7d, baselineCv)
        : 0.0;

    // ── 5. Sleep Regularity Index ────────────────────────────────────────────
    final sleepIntervals = nights
        .map((n) => SleepInterval(start: n.sessionStart, end: n.sessionEnd))
        .toList();
    final sri = _algo.computeSri(sleepIntervals, minDays: _sriMinDays);

    // ── 6. ACWR ──────────────────────────────────────────────────────────────
    final acwrValue = _computeAcwr(calories28d, now);

    // ── 7. Determine Bayesian weight ─────────────────────────────────────────
    final wObj = _computeWObj(hrv28d.length, nights.length);

    // ── 8. Build inputs and compute scores ───────────────────────────────────
    final inputs = ReadinessInputs(
      zHrv: zHrv,
      zRhr: zRhr,
      zDeep: zDeep,
      zTst: zTst,
      zRem: zRem,
      zCv: zCv,
      sri: sri,
      sleepEfficiency: todayEfficiency,
      acwrValue: acwrValue,
      hasHrvData: hasHrvData,
      hasSleepData: hasSleepData,
      sriDaysAvailable: nights.length,
    );

    final components = _algo.compute(
      inputs: inputs,
      soreness: feedback?.soreness,
      energy: feedback?.energy,
      stress: feedback?.stress,
      wObj: wObj,
    );

    // ── 9. Write to Derived Store ────────────────────────────────────────────
    final computedAt = DateTime.now().toUtc();

    Future<void> write(String key, double value, {String? metadata}) =>
        _db.upsertDerived(
          DerivedEntriesCompanion.insert(
            namespace: DerivedNamespace.readiness,
            key: key,
            value: value,
            date: date,
            computedAt: computedAt,
            metadata: Value.absentIfNull(metadata),
          ),
        );

    // Physical components JSON
    final physJson = jsonEncode({
      'hrv_score': _round(components.hrvScore),
      'rhr_score': _round(components.rhrScore),
      'deep_score': _round(components.deepScore),
      'tst_score': _round(components.tstScore),
      'acwr_penalty': _round(components.acwrPenalty),
      'z_hrv': _round(zHrv),
      'z_rhr': _round(zRhr),
      'z_deep': _round(zDeep),
      'z_tst': _round(zTst),
      'today_hrv_ms': _round(todayHrv),
      'today_rhr_bpm': _round(todayRhr),
      'today_deep_min': _round(todayDeep),
      'today_tst_min': _round(todayTst),
    });

    // Mental components JSON
    final mentJson = jsonEncode({
      'rem_score': _round(components.remScore),
      'sri_score': _round(components.sriScore),
      'cv_score': _round(components.cvScore),
      'efficiency_score': _round(components.efficiencyScore),
      'z_rem': _round(zRem),
      'z_cv': _round(zCv),
      'today_rem_min': _round(todayRem),
      'today_efficiency_pct': _round(todayEfficiency * 100),
      'sri_value': sri != null ? _round(sri) : null,
    });

    await Future.wait([
      // Legacy monolithic score (average of both for backward compatibility)
      write(ReadinessKey.score, ((components.physFinal + components.mentFinal) / 2).clamp(0, 100)),
      write(ReadinessKey.isCalibrating, components.isCalibrating ? 1.0 : 0.0),

      // Bimodal scores
      write(ReadinessKey.physicalScoreObj, components.physObj),
      write(ReadinessKey.physicalScore, components.physFinal),
      write(ReadinessKey.mentalScoreObj, components.mentObj),
      write(ReadinessKey.mentalScore, components.mentFinal),

      // Components with JSON metadata
      write(ReadinessKey.physicalComponents, components.physFinal,
          metadata: physJson),
      write(ReadinessKey.mentalComponents, components.mentFinal,
          metadata: mentJson),

      // Auxiliary metrics
      write(ReadinessKey.acwr, acwrValue),
      if (sri != null) write(ReadinessKey.sri, sri),
      write(ReadinessKey.wObjWeight, wObj),

      // Legacy contributions for backward compat
      if (hasHrvData)
        write(ReadinessKey.hrvContribution, components.hrvScore / 100.0),
      if (hasSleepData) ...[
        write(ReadinessKey.sleepContribution,
            (components.deepScore + components.remScore) / 200.0),
        write(ReadinessKey.strainContribution,
            (100.0 - components.acwrPenalty * 4) / 100.0),
      ],
    ]);

    debugPrint(
      '[ReadinessPlugin] ✓ date=$date '
      'physical=${components.physFinal.toStringAsFixed(1)} '
      'mental=${components.mentFinal.toStringAsFixed(1)} '
      'calibrating=${components.isCalibrating} '
      'sri=${sri?.toStringAsFixed(1)} '
      'acwr=${acwrValue.toStringAsFixed(2)} '
      'wObj=$wObj',
    );
  }

  // ---------------------------------------------------------------------------
  // Data aggregation helpers
  // ---------------------------------------------------------------------------

  /// Groups raw sleep stage entries into per-night aggregates.
  List<NightSleepData> _aggregateNights({
    required List<RawEntry> deepAll,
    required List<RawEntry> remAll,
    required List<RawEntry> lightAll,
    required List<RawEntry> hrv,
    required List<RawEntry> rhr,
    required DateTime windowStart,
  }) {
    // Group by date key (using the END of the sleep segment to assign the date)
    final Map<String, List<RawEntry>> deepByDate = {};
    final Map<String, List<RawEntry>> remByDate = {};
    final Map<String, List<RawEntry>> lightByDate = {};

    void groupByDate(List<RawEntry> entries, Map<String, List<RawEntry>> map) {
      for (final e in entries) {
        // Use the calendar date of the END of the sleep segment to assign
        // the night (sleep starting at 23:00 ends at 07:00 next day → next day)
        final endTs = e.timestampEnd ?? e.timestamp;
        final key = _dateKey(endTs);
        map.putIfAbsent(key, () => []).add(e);
      }
    }

    groupByDate(deepAll, deepByDate);
    groupByDate(remAll, remByDate);
    groupByDate(lightAll, lightByDate);

    // Collect all dates
    final allDates = {
      ...deepByDate.keys,
      ...remByDate.keys,
      ...lightByDate.keys,
    }.toList()
      ..sort();

    final nights = <NightSleepData>[];

    for (final dateStr in allDates) {
      final deepEntries = deepByDate[dateStr] ?? [];
      final remEntries = remByDate[dateStr] ?? [];
      final lightEntries = lightByDate[dateStr] ?? [];

      final deepMins = _sumDuration(deepEntries);
      final remMins = _sumDuration(remEntries);
      final lightMins = _sumDuration(lightEntries);

      if (deepMins + remMins + lightMins < 30) continue; // Noise filter

      // Estimate session boundaries from stage entries
      final allEntries = [...deepEntries, ...remEntries, ...lightEntries];
      allEntries.sort((a, b) => a.timestamp.compareTo(b.timestamp));
      final sessionStart = allEntries.first.timestamp;
      final sessionEnd = allEntries
          .map((e) => e.timestampEnd ?? e.timestamp)
          .reduce((a, b) => a.isAfter(b) ? a : b);
      final timeInBedMins =
          sessionEnd.difference(sessionStart).inMinutes.toDouble();

      // Average HRV from entries within the sleep window
      // Weight: prefer deep sleep phases (higher signal quality)
      final sleepHrv = _avgHrvDuringSleep(hrv, sessionStart, sessionEnd,
          deepEntries: deepEntries);
      final sleepRhr = _avgRhrDuringSleep(rhr, sessionStart, sessionEnd,
          deepEntries: deepEntries, remEntries: remEntries);

      nights.add(NightSleepData(
        date: dateStr,
        deepMins: deepMins,
        remMins: remMins,
        lightMins: lightMins,
        timeInBedMins: timeInBedMins,
        sessionStart: sessionStart,
        sessionEnd: sessionEnd,
        avgHrv: sleepHrv,
        avgRhr: sleepRhr,
      ));
    }

    return nights;
  }

  /// Returns the most recent night's data from the short window.
  NightSleepData? _lastNight({
    required List<RawEntry> deepAll,
    required List<RawEntry> remAll,
    required List<RawEntry> lightAll,
    required List<RawEntry> hrv,
    required List<RawEntry> rhr,
    required DateTime since,
    required DateTime now,
  }) {
    final deepRecent = deepAll.where((e) => e.timestamp.isAfter(since)).toList();
    final remRecent = remAll.where((e) => e.timestamp.isAfter(since)).toList();
    final lightRecent =
        lightAll.where((e) => e.timestamp.isAfter(since)).toList();

    if (deepRecent.isEmpty && remRecent.isEmpty && lightRecent.isEmpty) {
      return null;
    }

    final deepMins = _sumDuration(deepRecent);
    final remMins = _sumDuration(remRecent);
    final lightMins = _sumDuration(lightRecent);

    if (deepMins + remMins + lightMins < 30) return null;

    final allEntries = [...deepRecent, ...remRecent, ...lightRecent];
    allEntries.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    final sessionStart = allEntries.first.timestamp;
    final sessionEnd = allEntries
        .map((e) => e.timestampEnd ?? e.timestamp)
        .reduce((a, b) => a.isAfter(b) ? a : b);
    final timeInBedMins =
        sessionEnd.difference(sessionStart).inMinutes.toDouble();

    final dateStr = _dateKey(sessionEnd);

    final avgHrv = _avgHrvDuringSleep(hrv, sessionStart, sessionEnd,
        deepEntries: deepRecent);
    final avgRhr = _avgRhrDuringSleep(rhr, sessionStart, sessionEnd,
        deepEntries: deepRecent, remEntries: remRecent);

    return NightSleepData(
      date: dateStr,
      deepMins: deepMins,
      remMins: remMins,
      lightMins: lightMins,
      timeInBedMins: timeInBedMins,
      sessionStart: sessionStart,
      sessionEnd: sessionEnd,
      avgHrv: avgHrv,
      avgRhr: avgRhr,
    );
  }

  /// Weighted average HRV during sleep, giving 2× weight to deep sleep epochs.
  double? _avgHrvDuringSleep(
    List<RawEntry> hrvEntries,
    DateTime sessionStart,
    DateTime sessionEnd, {
    required List<RawEntry> deepEntries,
  }) {
    final during = hrvEntries.where((e) =>
        e.timestamp.isAfter(sessionStart) &&
        e.timestamp.isBefore(sessionEnd) &&
        e.value > 5 && // Filter physiological outliers
        e.value < 200);

    if (during.isEmpty) return null;

    // Build deep-sleep time intervals for phase weighting
    final deepIntervals = deepEntries.map((e) => (
          start: e.timestamp,
          end: e.timestampEnd ?? e.timestamp.add(const Duration(minutes: 5)),
        ));

    double weightedSum = 0.0;
    double totalWeight = 0.0;

    for (final e in during) {
      final isInDeep = deepIntervals
          .any((d) => e.timestamp.isAfter(d.start) && e.timestamp.isBefore(d.end));
      final weight = isInDeep ? 2.0 : 1.0;
      weightedSum += e.value * weight;
      totalWeight += weight;
    }

    return totalWeight > 0 ? weightedSum / totalWeight : null;
  }

  /// Average resting HR during non-REM sleep phases (excludes REM artefacts).
  double? _avgRhrDuringSleep(
    List<RawEntry> rhrEntries,
    DateTime sessionStart,
    DateTime sessionEnd, {
    required List<RawEntry> deepEntries,
    required List<RawEntry> remEntries,
  }) {
    // Exclude REM windows (sympathetic surges inflate HR)
    final remIntervals = remEntries.map((e) => (
          start: e.timestamp,
          end: e.timestampEnd ?? e.timestamp.add(const Duration(minutes: 5)),
        ));

    final validRhr = rhrEntries.where((e) {
      if (!e.timestamp.isAfter(sessionStart) ||
          !e.timestamp.isBefore(sessionEnd)) return false;
      if (e.value < 25 || e.value > 120) return false; // Physiological bounds
      final inRem = remIntervals.any(
          (r) => e.timestamp.isAfter(r.start) && e.timestamp.isBefore(r.end));
      return !inRem;
    });

    if (validRhr.isEmpty) return null;
    final values = validRhr.map((e) => e.value).toList();
    return _mean(values);
  }

  // ---------------------------------------------------------------------------
  // ACWR computation
  // ---------------------------------------------------------------------------

  double _computeAcwr(List<RawEntry> calories, DateTime now) {
    if (calories.isEmpty) return 1.0; // Neutral when no data

    // Sum calories per day
    final Map<String, double> byDay = {};
    for (final e in calories) {
      final key = _dateKey(e.timestamp);
      byDay[key] = (byDay[key] ?? 0.0) + e.value;
    }

    if (byDay.isEmpty) return 1.0;

    // Acute: 7-day sum
    final acuteCutoff = now.subtract(_acwrAcuteWindow);
    final acuteKcal = byDay.entries
        .where((e) {
          final date = DateTime.parse(e.key);
          return date.isAfter(acuteCutoff);
        })
        .fold(0.0, (s, e) => s + e.value);

    // Chronic: 28-day average weekly load
    final chronicWeeklyAvg =
        byDay.values.fold(0.0, (s, v) => s + v) / byDay.length * 7;

    if (chronicWeeklyAvg < 1.0) return 1.0; // Avoid division by near-zero

    // Acute is 7-day sum; chronic is expressed as 7-day average
    return (acuteKcal / chronicWeeklyAvg).clamp(0.1, 5.0);
  }

  // ---------------------------------------------------------------------------
  // Rolling CV helper
  // ---------------------------------------------------------------------------

  /// Computes daily rolling CV over [windowDays] sub-windows within the 28d set.
  List<double> _computeRollingCv(List<RawEntry> hrv28d, {int windowDays = 7}) {
    if (hrv28d.length < windowDays * 2) return [];

    final Map<String, List<double>> byDay = {};
    for (final e in hrv28d) {
      byDay.putIfAbsent(_dateKey(e.timestamp), () => []).add(e.value);
    }
    final dates = byDay.keys.toList()..sort();

    final List<double> cvs = [];
    for (var i = windowDays; i < dates.length; i++) {
      final windowDates = dates.sublist(i - windowDays, i);
      final values = windowDates.expand((d) => byDay[d] ?? []).cast<double>().toList();
      cvs.add(_algo.coefficientOfVariation(values));
    }
    return cvs;
  }

  // ---------------------------------------------------------------------------
  // Bayesian weight calculation
  // ---------------------------------------------------------------------------

  /// Computes the objective data weight w_obj for Bayesian fusion.
  ///
  /// Starts high (trusting sensors) and remains stable unless specific
  /// conditions indicate the subjective signal is more reliable.
  /// (Full ML-based adaptation would use stored prediction error history.)
  double _computeWObj(int hrvPoints, int sleepNights) {
    if (hrvPoints < _minHrvPoints) return 0.9; // Less data → trust sensors more
    if (sleepNights < _minSleepNights) return 0.9;
    if (sleepNights < 14) return 0.85; // Still building baseline
    return _defaultWObj; // 0.8 steady state
  }

  // ---------------------------------------------------------------------------
  // Utility
  // ---------------------------------------------------------------------------

  String _dateKey(DateTime dt) =>
      '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';

  /// Sums the duration of sleep stage entries in minutes.
  /// Health Connect stores stage intervals with start/end timestamps;
  /// the value field may also encode duration — we use timestamps.
  double _sumDuration(List<RawEntry> entries) {
    double total = 0.0;
    for (final e in entries) {
      if (e.timestampEnd != null) {
        final mins = e.timestampEnd!.difference(e.timestamp).inSeconds / 60.0;
        if (mins > 0 && mins < 480) total += mins; // Sanity: max 8h per segment
      } else {
        // Fallback: value stored as minutes (older format)
        if (e.value > 0 && e.value < 480) total += e.value;
      }
    }
    return total;
  }

  double _mean(List<double> v) =>
      v.isEmpty ? 0.0 : v.reduce((a, b) => a + b) / v.length;

  double _round(double v) => (v * 10).roundToDouble() / 10;
}
