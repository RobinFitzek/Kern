import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../../core/database/app_database.dart';
import '../../core/database/derived_keys.dart';

class ConsistencyPlugin {
  ConsistencyPlugin(this._db);

  final AppDatabase _db;

  static const int _lookbackDays = 14;
  static const double _activeThreshold = 5000.0;

  Future<void> run(String date) async {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: _lookbackDays));

    final rawSteps = await _db.rawEntriesBetween(
      type: 'steps',
      from: start,
      to: now,
    );
    final rawEnergy = await _db.rawEntriesBetween(
      type: 'active_energy_burned',
      from: start,
      to: now,
    );

    final stepsByDay = <String, double>{};
    final energyByDay = <String, double>{};

    for (final e in rawSteps) {
      final d = _fmtDate(e.timestamp);
      stepsByDay[d] = (stepsByDay[d] ?? 0) + e.value;
    }
    for (final e in rawEnergy) {
      final d = _fmtDate(e.timestamp);
      energyByDay[d] = (energyByDay[d] ?? 0) + e.value;
    }

    final allDates = <String>{...stepsByDay.keys, ...energyByDay.keys}.toList()
      ..sort();

    final stepValues = allDates.map((d) => stepsByDay[d] ?? 0.0).toList();
    final energyValues = allDates.map((d) => energyByDay[d] ?? 0.0).toList();
    final recentDates = allDates.length > _lookbackDays
        ? allDates.sublist(allDates.length - _lookbackDays)
        : allDates;
    final recentSteps = stepValues.length > _lookbackDays
        ? stepValues.sublist(stepValues.length - _lookbackDays)
        : stepValues;
    final recentEnergy = energyValues.length > _lookbackDays
        ? energyValues.sublist(energyValues.length - _lookbackDays)
        : energyValues;

    final stepsScore = _consistencyScore(recentSteps);
    final energyScore = _consistencyScore(recentEnergy);
    final overallScore = (stepsScore + energyScore) / 2.0;

    final activeDays = recentSteps.where((s) => s >= _activeThreshold).length;
    int streak = 0;
    for (var i = recentSteps.length - 1; i >= 0; i--) {
      if (recentSteps[i] >= _activeThreshold) {
        streak++;
      } else {
        break;
      }
    }
    int bestStreak = 0;
    int current = 0;
    for (final s in recentSteps) {
      if (s >= _activeThreshold) {
        current++;
        if (current > bestStreak) bestStreak = current;
      } else {
        current = 0;
      }
    }

    int state;
    if (overallScore >= 80) {
      state = 3;
    } else if (overallScore >= 60) {
      state = 2;
    } else if (overallScore >= 40) {
      state = 1;
    } else {
      state = 0;
    }

    debugPrint(
      '[ConsistencyPlugin] date=$date overall=${overallScore.toInt()} '
      'steps=${stepsScore.toInt()} energy=${energyScore.toInt()} '
      'activeDays=$activeDays streak=$streak',
    );

    final ts = DateTime.now();
    await Future.wait([
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.consistency,
        key: ConsistencyKey.stepsScore,
        value: stepsScore,
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.consistency,
        key: ConsistencyKey.energyScore,
        value: energyScore,
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.consistency,
        key: ConsistencyKey.overallScore,
        value: overallScore,
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.consistency,
        key: ConsistencyKey.activeDays,
        value: activeDays.toDouble(),
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.consistency,
        key: ConsistencyKey.streak,
        value: streak.toDouble(),
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.consistency,
        key: ConsistencyKey.bestStreak,
        value: bestStreak.toDouble(),
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.consistency,
        key: ConsistencyKey.state,
        value: state.toDouble(),
        date: date,
        computedAt: ts,
      )),
    ]);
  }

  double _consistencyScore(List<double> dailyValues) {
    if (dailyValues.isEmpty) return 0.0;
    final nonZero = dailyValues.where((v) => v > 0).toList();
    if (nonZero.length < 3) return 30.0;

    final mean = nonZero.reduce((a, b) => a + b) / nonZero.length;
    if (mean <= 0) return 0.0;

    double sumSqDiff = 0.0;
    for (final v in nonZero) {
      sumSqDiff += (v - mean) * (v - mean);
    }
    final stdDev = (sumSqDiff / nonZero.length) < 0.0001
        ? 0.0
        : _sqrt(sumSqDiff / nonZero.length);

    final cv = stdDev / mean;
    return (100.0 * (1.0 - cv)).clamp(0.0, 100.0);
  }

  double _sqrt(double x) {
    if (x <= 0) return 0;
    double guess = x / 2;
    for (int i = 0; i < 20; i++) {
      guess = (guess + x / guess) / 2;
    }
    return guess;
  }

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
