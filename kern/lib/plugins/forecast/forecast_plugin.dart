import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../../core/database/app_database.dart';
import '../../core/database/derived_keys.dart';

class ForecastPlugin {
  ForecastPlugin(this._db);

  final AppDatabase _db;

  static const int _historyDays = 28;
  static const int _trendDays = 7;

  Future<void> run(String date) async {
    final now = DateTime.now();
    final since = now.subtract(Duration(days: _historyDays));
    final startStr = _fmtDate(since);
    final endStr = _fmtDate(now);

    final physEntries = await _db.derivedForDateRange(
      namespace: DerivedNamespace.readiness,
      key: ReadinessKey.physicalScore,
      startDate: startStr,
      endDate: endStr,
    );
    final mentEntries = await _db.derivedForDateRange(
      namespace: DerivedNamespace.readiness,
      key: ReadinessKey.mentalScore,
      startDate: startStr,
      endDate: endStr,
    );
    final strainEntries = await _db.derivedForDateRange(
      namespace: DerivedNamespace.strain,
      key: StrainKey.daily,
      startDate: _fmtDate(now.subtract(Duration(days: _trendDays))),
      endDate: endStr,
    );
    final recoveryEntries = await _db.derivedForDateRange(
      namespace: DerivedNamespace.recovery,
      key: RecoveryKey.score,
      startDate: _fmtDate(now.subtract(Duration(days: _trendDays))),
      endDate: endStr,
    );

    final physSorted = physEntries.toList()..sort((a, b) => a.date.compareTo(b.date));
    final mentSorted = mentEntries.toList()..sort((a, b) => a.date.compareTo(b.date));

    final recentPhys = physSorted.length > _trendDays
        ? physSorted.sublist(physSorted.length - _trendDays)
        : physSorted;
    final recentMent = mentSorted.length > _trendDays
        ? mentSorted.sublist(mentSorted.length - _trendDays)
        : mentSorted;

    final physLr = _linearRegression(recentPhys);
    final mentLr = _linearRegression(recentMent);

    double predictedPhys;
    double predictedMent;
    if (recentPhys.isNotEmpty && physLr.slope.abs() < 100) {
      predictedPhys = (recentPhys.last.value + physLr.slope).clamp(0.0, 100.0);
    } else {
      predictedPhys = recentPhys.isNotEmpty ? recentPhys.last.value : 50.0;
    }

    if (recentMent.isNotEmpty && mentLr.slope.abs() < 100) {
      predictedMent = (recentMent.last.value + mentLr.slope).clamp(0.0, 100.0);
    } else {
      predictedMent = recentMent.isNotEmpty ? recentMent.last.value : 50.0;
    }

    final confidence = physLr.rSquared.clamp(0.0, 100.0);

    int category;
    if (predictedPhys >= 80) {
      category = 4;
    } else if (predictedPhys >= 65) {
      category = 3;
    } else if (predictedPhys >= 50) {
      category = 2;
    } else if (predictedPhys >= 35) {
      category = 1;
    } else {
      category = 0;
    }

    final strainAvg = strainEntries.isEmpty
        ? 0.0
        : strainEntries.map((e) => e.value).reduce((a, b) => a + b) / strainEntries.length;
    final recoveryAvg = recoveryEntries.isEmpty
        ? 0.0
        : recoveryEntries.map((e) => e.value).reduce((a, b) => a + b) / recoveryEntries.length;
    final recoveryDebt = (strainAvg - recoveryAvg).clamp(-50.0, 50.0);

    String recommendation;
    if (recentPhys.length < 3) {
      recommendation = 'Noch nicht genug Daten für eine zuverlässige Prognose. '
          'Sammle mindestens 3 Tage Readiness-Daten.';
    } else if (category >= 4) {
      recommendation = 'Hervorragende Aussichten für morgen! '
          'Deine Readiness liegt im optimalen Bereich — ein idealer Tag '
          'für intensives Training oder wichtige Aufgaben.';
    } else if (category >= 3) {
      recommendation = 'Gute Prognose. Deine Readiness bleibt solide. '
          'Normales Training und Alltag sind morgen gut machbar.';
    } else if (category >= 2) {
      recommendation = 'Mittlere Prognose. Deine Readiness ist okay, '
          'aber nicht auf dem Höhepunkt. Ein moderater Trainingstag '
          'oder leichte Aktivität sind passend.';
    } else if (category >= 1) {
      final debtMsg = recoveryDebt > 10
          ? ' Deine Erholung hinkt hinterher — priorisiere Regeneration.'
          : '';
      recommendation = 'Niedrige Prognose. Morgen wird voraussichtlich ein '
          'schwächerer Tag. Plane leichte Aktivität und genug Schlaf ein.$debtMsg';
    } else {
      recommendation = 'Kritische Prognose. Deine Readiness fällt in den '
          'kritischen Bereich. Ein Ruhetag morgen ist die beste Strategie. '
          'Fokussiere dich auf Schlaf, Ernährung und Erholung.';
    }

    if (recoveryDebt > 15) {
      recommendation += ' Zusätzlich baust du Erholungsschulden auf — '
          'reduziere deine Trainingsintensität für 2–3 Tage.';
    } else if (recoveryDebt < -15) {
      recommendation += ' Deine Erholungskapazität ist hoch — du könntest '
          'die Trainingsintensität steigern, wenn du möchtest.';
    }

    if (confidence < 30 && recentPhys.length >= 5) {
      recommendation += ' Die Prognose ist unsicher — deine Werte schwanken '
          'stark. Achte morgen früh auf deinen aktuellen Readiness Score.';
    }

    debugPrint(
      '[ForecastPlugin] date=$date phys=${predictedPhys.toInt()} '
      'slope=${physLr.slope.toStringAsFixed(1)} confidence=${confidence.toInt()} '
      'debt=${recoveryDebt.toInt()}',
    );

    final ts = DateTime.now();
    await Future.wait([
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.forecast,
        key: ForecastKey.predictedReadiness,
        value: predictedPhys,
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.forecast,
        key: ForecastKey.predictedMental,
        value: predictedMent,
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.forecast,
        key: ForecastKey.trendSlope,
        value: physLr.slope,
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.forecast,
        key: ForecastKey.confidence,
        value: confidence,
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.forecast,
        key: ForecastKey.category,
        value: category.toDouble(),
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.forecast,
        key: ForecastKey.recoveryDebt,
        value: recoveryDebt,
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.forecast,
        key: ForecastKey.recommendation,
        value: 0.0,
        date: date,
        computedAt: ts,
        metadata: Value(recommendation),
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.forecast,
        key: ForecastKey.mentalTrend,
        value: mentLr.slope,
        date: date,
        computedAt: ts,
      )),
    ]);
  }

  _LrResult _linearRegression(List<dynamic> entries) {
    if (entries.length < 2) return _LrResult(0, 0, 0.0);

    final n = entries.length;
    double sumX = 0, sumY = 0, sumXY = 0, sumX2 = 0, sumY2 = 0;
    for (var i = 0; i < n; i++) {
      final x = i.toDouble();
      final y = (entries[i] as dynamic).value as double;
      sumX += x;
      sumY += y;
      sumXY += x * y;
      sumX2 += x * x;
      sumY2 += y * y;
    }

    final denom = n * sumX2 - sumX * sumX;
    if (denom == 0) return _LrResult(0, 0, 0.0);

    final slope = (n * sumXY - sumX * sumY) / denom;
    final intercept = (sumY - slope * sumX) / n;

    final yMean = sumY / n;
    double ssRes = 0, ssTot = 0;
    for (var i = 0; i < n; i++) {
      final y = (entries[i] as dynamic).value as double;
      final predicted = intercept + slope * i;
      ssRes += (y - predicted) * (y - predicted);
      ssTot += (y - yMean) * (y - yMean);
    }

    final rSquared = ssTot == 0 ? 0.0 : (1.0 - ssRes / ssTot) * 100.0;

    return _LrResult(slope, intercept, rSquared.clamp(0.0, 100.0));
  }

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}

class _LrResult {
  final double slope;
  final double intercept;
  final double rSquared;
  const _LrResult(this.slope, this.intercept, this.rSquared);
}
