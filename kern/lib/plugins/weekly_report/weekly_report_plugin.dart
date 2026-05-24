import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../../core/database/app_database.dart';
import '../../core/database/derived_keys.dart';

class WeeklyReportPlugin {
  WeeklyReportPlugin(this._db);

  final AppDatabase _db;

  Future<void> run(String date) async {
    final end = DateTime.now();
    final start = end.subtract(const Duration(days: 7));

    final startStr = _fmtDate(start);
    final endStr = _fmtDate(end);

    final readinessEntries = await _db.derivedForDateRange(
      namespace: DerivedNamespace.readiness,
      key: ReadinessKey.physicalScore,
      startDate: startStr,
      endDate: endStr,
    );
    final sleepEntries = await _db.derivedForDateRange(
      namespace: DerivedNamespace.sleep,
      key: SleepKey.qualityScore,
      startDate: startStr,
      endDate: endStr,
    );
    final strainEntries = await _db.derivedForDateRange(
      namespace: DerivedNamespace.strain,
      key: StrainKey.daily,
      startDate: startStr,
      endDate: endStr,
    );

    final now = DateTime.now();
    final rawStepEntries = await _db.rawEntriesBetween(
      type: 'steps',
      from: start,
      to: now,
    );

    final avgReadiness = _avg(readinessEntries.map((e) => e.value));
    final avgSleep = _avg(sleepEntries.map((e) => e.value));
    final avgStrain = _avg(strainEntries.map((e) => e.value));
    final totalSteps = rawStepEntries.fold(0.0, (s, e) => s + e.value);

    final summaryJson = jsonEncode({
      'avg_readiness': avgReadiness,
      'avg_sleep': avgSleep,
      'avg_strain': avgStrain,
      'total_steps': totalSteps,
      'readiness_trend': _trendLabel(readinessEntries.map((e) => e.value).toList()),
      'sleep_trend': _trendLabel(sleepEntries.map((e) => e.value).toList()),
      'strain_trend': _trendLabel(strainEntries.map((e) => e.value).toList()),
    });

    debugPrint('[WeeklyReportPlugin] date=$date avgReadiness=$avgReadiness');

    final ts = DateTime.now();
    await Future.wait([
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.weeklyReport,
        key: WeeklyReportKey.avgReadiness,
        value: avgReadiness,
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.weeklyReport,
        key: WeeklyReportKey.avgSleep,
        value: avgSleep,
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.weeklyReport,
        key: WeeklyReportKey.avgStrain,
        value: avgStrain,
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.weeklyReport,
        key: WeeklyReportKey.totalSteps,
        value: totalSteps,
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.weeklyReport,
        key: WeeklyReportKey.summaryText,
        value: 0.0,
        date: date,
        computedAt: ts,
        metadata: Value(summaryJson),
      )),
    ]);
  }

  double _avg(Iterable<double> values) {
    double sum = 0.0;
    int count = 0;
    for (final v in values) {
      sum += v;
      count++;
    }
    return count == 0 ? 0.0 : sum / count;
  }

  String _trendLabel(List<double> values) {
    if (values.length < 2) return 'stable';
    final firstHalf = values.take(values.length ~/ 2).toList();
    final secondHalf = values.skip(values.length ~/ 2).toList();
    final firstAvg = _avg(firstHalf);
    final secondAvg = _avg(secondHalf);
    if (firstAvg == 0) return 'stable';
    final change = (secondAvg / firstAvg) - 1.0;
    if (change > 0.05) return 'improving';
    if (change < -0.05) return 'declining';
    return 'stable';
  }

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
