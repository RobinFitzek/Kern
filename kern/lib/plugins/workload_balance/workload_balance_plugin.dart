import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../../core/database/app_database.dart';
import '../../core/database/derived_keys.dart';

class WorkloadBalancePlugin {
  WorkloadBalancePlugin(this._db);

  final AppDatabase _db;

  static const int _acuteWindow = 7;
  static const int _chronicWindow = 28;

  Future<void> run(String date) async {
    final now = DateTime.now();

    final chronicStartStr = _fmtDate(now.subtract(Duration(days: _chronicWindow)));
    final acuteStartStr = _fmtDate(now.subtract(Duration(days: _acuteWindow)));
    final endStr = _fmtDate(now);

    final strainEntries = await _db.derivedForDateRange(
      namespace: DerivedNamespace.strain,
      key: StrainKey.daily,
      startDate: chronicStartStr,
      endDate: endStr,
    );

    final recoveryEntries = await _db.derivedForDateRange(
      namespace: DerivedNamespace.recovery,
      key: RecoveryKey.score,
      startDate: acuteStartStr,
      endDate: endStr,
    );

    final readinessEntries = await _db.derivedForDateRange(
      namespace: DerivedNamespace.readiness,
      key: ReadinessKey.physicalScore,
      startDate: acuteStartStr,
      endDate: endStr,
    );

    final strainSorted = strainEntries.toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    final recoverySorted = recoveryEntries.toList()
      ..sort((a, b) => a.date.compareTo(b.date));
    final readinessSorted = readinessEntries.toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    final acuteCutoff = now.subtract(Duration(days: _acuteWindow));
    final acuteStrainEntries = strainSorted
        .where((e) => _parseDate(e.date).isAfter(acuteCutoff) || e.date == _fmtDate(acuteCutoff))
        .toList();

    final acuteLoad = _avg(acuteStrainEntries.map((e) => e.value));
    final chronicLoad = _avg(strainSorted.map((e) => e.value));
    final recoveryLevel = _avg(recoverySorted.map((e) => e.value));
    final readinessLevel = _avg(readinessSorted.map((e) => e.value));

    final safeRecovery = recoveryLevel.clamp(10.0, 100.0);
    final normalizedStrain = acuteLoad / 100.0;
    final normalizedRecovery = safeRecovery / 100.0;

    final ratio = normalizedRecovery > 0.01
        ? normalizedStrain / normalizedRecovery
        : normalizedStrain * 2.0;

    int state;
    String trainingAdvice;
    double score;

    if (ratio < 0.4) {
      state = 1;
      trainingAdvice = 'Heute hart trainieren — deine Erholungswerte sind stark. '
          'Nutze den Tag für ein intensives Training.';
    } else if (ratio < 0.8) {
      state = 2;
      trainingAdvice = 'Gute Balance — dein normales Training ist heute ideal. '
          'Weder über- noch unterfordert.';
    } else if (ratio < 1.2) {
      state = 2;
      trainingAdvice = 'Solide Balance mit moderater Belastung. '
          'Dein Training liegt im angemessenen Bereich.';
    } else if (ratio < 1.8) {
      state = 3;
      trainingAdvice = 'Du trainierst mehr als du erholst — funktionelles Overreaching. '
          'Plane einen leichteren Tag oder aktive Erholung ein.';
    } else {
      state = 4;
      trainingAdvice = 'Deine Belastung übersteigt deine Erholung deutlich. '
          'Ein Ruhetag wird dringend empfohlen, um Verletzungen und Burnout zu vermeiden.';
    }

    if (chronicLoad < 10.0 && acuteLoad < 10.0) {
      state = 0;
      trainingAdvice = 'Kaum Trainingsdaten vorhanden. Sobald du regelmäßig aktiv bist, '
          'kann die Balance berechnet werden.';
    }

    score = _computeScore(ratio, state);

    int trend = 1;
    if (strainSorted.length >= 14) {
      final olderEntries = strainSorted.sublist(0, strainSorted.length - 7);
      final recentEntries = strainSorted.sublist(strainSorted.length - 7);
      final olderAvg = _avg(olderEntries.map((e) => e.value));
      final recentAvg = _avg(recentEntries.map((e) => e.value));
      if (olderAvg > 10) {
        final trendChange = (recentAvg - olderAvg) / olderAvg;
        if (trendChange > 0.10) {
          trend = 0;
        } else if (trendChange < -0.10) {
          trend = 2;
        }
      }
    }

    debugPrint(
      '[WorkloadBalancePlugin] date=$date ratio=${ratio.toStringAsFixed(2)} '
      'acute=${acuteLoad.toStringAsFixed(0)} chronic=${chronicLoad.toStringAsFixed(0)} '
      'state=$state score=${score.toInt()}',
    );

    final ts = DateTime.now();
    await Future.wait([
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.workloadBalance,
        key: WorkloadBalanceKey.ratio,
        value: ratio,
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.workloadBalance,
        key: WorkloadBalanceKey.state,
        value: state.toDouble(),
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.workloadBalance,
        key: WorkloadBalanceKey.score,
        value: score,
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.workloadBalance,
        key: WorkloadBalanceKey.trainingAdvice,
        value: 0.0,
        date: date,
        computedAt: ts,
        metadata: Value(trainingAdvice),
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.workloadBalance,
        key: WorkloadBalanceKey.acuteLoad,
        value: acuteLoad,
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.workloadBalance,
        key: WorkloadBalanceKey.chronicLoad,
        value: chronicLoad,
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.workloadBalance,
        key: WorkloadBalanceKey.recoveryLevel,
        value: recoveryLevel,
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.workloadBalance,
        key: WorkloadBalanceKey.readinessLevel,
        value: readinessLevel,
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.workloadBalance,
        key: WorkloadBalanceKey.trend,
        value: trend.toDouble(),
        date: date,
        computedAt: ts,
      )),
    ]);
  }

  static double balanceToScoreStatic(double ratio, int state) =>
      _computeScore(ratio, state);

  static double _computeScore(double ratio, int state) {
    if (state == 0) return 50.0;
    if (ratio <= 0.0) return 30.0;
    if (ratio >= 3.0) return 0.0;

    final normalized = (ratio - 0.6).abs();
    final score = 100.0 - (normalized * 80.0).clamp(0.0, 100.0);
    return score.clamp(0.0, 100.0);
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

  DateTime _parseDate(String dateStr) {
    try {
      final parts = dateStr.split('-');
      return DateTime(int.parse(parts[0]), int.parse(parts[1]), int.parse(parts[2]));
    } catch (_) {
      return DateTime(2000);
    }
  }

  static String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
