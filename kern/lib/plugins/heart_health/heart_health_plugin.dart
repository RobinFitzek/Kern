import 'package:flutter/foundation.dart';

import '../../core/database/app_database.dart';
import '../../core/database/derived_keys.dart';

class HeartHealthPlugin {
  HeartHealthPlugin(this._db);

  final AppDatabase _db;

  static const int _lookbackDays = 28;

  Future<void> run(String date) async {
    final now = DateTime.now();
    final since = now.subtract(Duration(days: _lookbackDays));

    final rhrEntries = await _db.rawEntriesBetween(
      type: 'resting_hr',
      from: since,
      to: now,
    );
    final hrvEntries = await _db.rawEntriesBetween(
      type: 'hrv',
      from: since,
      to: now,
    );

    final rhrAvg = _avg(rhrEntries.map((e) => e.value));
    final rhrEntriesSorted = rhrEntries.toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    double rhrTrend = 0.0;
    if (rhrEntriesSorted.length >= 3) {
      final firstHalf = rhrEntriesSorted
          .take(rhrEntriesSorted.length ~/ 2)
          .map((e) => e.value);
      final secondHalf = rhrEntriesSorted
          .skip(rhrEntriesSorted.length ~/ 2)
          .map((e) => e.value);
      final firstAvg = _avg(firstHalf);
      final secondAvg = _avg(secondHalf);
      if (firstAvg > 0) {
        rhrTrend = (secondAvg / firstAvg).clamp(0.8, 1.2);
      }
    }

    final hrvBaseline = _avg(hrvEntries.map((e) => e.value));

    double cvFitness = 50.0;
    if (rhrAvg > 0) {
      if (rhrAvg < 50) {
        cvFitness = 85.0;
      } else if (rhrAvg < 60) {
        cvFitness = 70.0;
      } else if (rhrAvg < 70) {
        cvFitness = 55.0;
      } else if (rhrAvg < 80) {
        cvFitness = 40.0;
      } else {
        cvFitness = 25.0;
      }

      if (rhrTrend > 0 && rhrTrend < 1.0) {
        cvFitness = (cvFitness + 10).clamp(0.0, 100.0);
      } else if (rhrTrend > 1.0) {
        cvFitness = (cvFitness - 10).clamp(0.0, 100.0);
      }

      if (hrvBaseline > 40) {
        cvFitness = (cvFitness + 5).clamp(0.0, 100.0);
      }
    }

    debugPrint(
      '[HeartHealthPlugin] date=$date rhrAvg=$rhrAvg '
      'rhrTrend=$rhrTrend hrvBaseline=$hrvBaseline cvFitness=$cvFitness',
    );

    final ts = DateTime.now();
    await Future.wait([
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.heartHealth,
        key: HeartHealthKey.restingHr,
        value: rhrAvg,
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.heartHealth,
        key: HeartHealthKey.restingHrTrend,
        value: rhrTrend,
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.heartHealth,
        key: HeartHealthKey.hrvBaseline,
        value: hrvBaseline,
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.heartHealth,
        key: HeartHealthKey.cvFitnessEstimate,
        value: cvFitness,
        date: date,
        computedAt: ts,
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
}
