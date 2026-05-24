import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../../core/database/app_database.dart';
import '../../core/database/derived_keys.dart';

class RecoveryPlugin {
  RecoveryPlugin(this._db);

  final AppDatabase _db;

  static const double _hrvDeclineThreshold = 0.85;
  static const double _hrvRecoveryThreshold = 1.05;
  static const double _rhrRiseThreshold = 1.05;
  static const double _rhrRecoveryThreshold = 0.95;
  static const int _baselineDays = 14;

  Future<void> run(String date) async {
    final now = DateTime.now();
    final baselineStart = now.subtract(Duration(days: _baselineDays + 7));
    final recentStart = now.subtract(const Duration(days: 7));

    final recentHrv = await _db.rawEntriesBetween(
      type: 'hrv',
      from: recentStart,
      to: now,
    );
    final baselineHrv = await _db.rawEntriesBetween(
      type: 'hrv',
      from: baselineStart,
      to: recentStart.subtract(const Duration(seconds: 1)),
    );
    final recentRhr = await _db.rawEntriesBetween(
      type: 'resting_hr',
      from: recentStart,
      to: now,
    );
    final baselineRhr = await _db.rawEntriesBetween(
      type: 'resting_hr',
      from: baselineStart,
      to: recentStart.subtract(const Duration(seconds: 1)),
    );

    final recentHrvAvg = _avg(recentHrv.map((e) => e.value));
    final baselineHrvAvg = _avg(baselineHrv.map((e) => e.value));
    final recentRhrAvg = _avg(recentRhr.map((e) => e.value));
    final baselineRhrAvg = _avg(baselineRhr.map((e) => e.value));

    double hrvTrend = 0.0;
    if (baselineHrvAvg > 0 && recentHrvAvg > 0) {
      hrvTrend = (recentHrvAvg / baselineHrvAvg).clamp(0.5, 2.0);
    }

    double rhrTrend = 0.0;
    if (baselineRhrAvg > 0 && recentRhrAvg > 0) {
      rhrTrend = (recentRhrAvg / baselineRhrAvg).clamp(0.5, 2.0);
    }

    String state;
    double score;
    String recommendation;

    if (hrvTrend == 0.0 && rhrTrend == 0.0) {
      state = 'insufficient_data';
      score = 50.0;
      recommendation = 'Noch nicht genügend HRV- und Ruhepuls-Daten für eine Erholungsanalyse.';
    } else {
      int signals = 0;
      double scored = 50.0;

      if (hrvTrend > 0) {
        if (hrvTrend >= _hrvRecoveryThreshold) {
          signals++;
          scored += 20;
        } else if (hrvTrend <= _hrvDeclineThreshold) {
          signals--;
          scored -= 20;
        }
      }

      if (rhrTrend > 0) {
        if (rhrTrend <= _rhrRecoveryThreshold) {
          signals++;
          scored += 15;
        } else if (rhrTrend >= _rhrRiseThreshold) {
          signals--;
          scored -= 15;
        }
      }

      score = scored.clamp(0.0, 100.0);

      if (signals >= 2) {
        state = 'recovered';
        recommendation = 'Deine Erholungswerte zeigen eine positive Entwicklung. '
            'Ein guter Tag für intensives Training.';
      } else if (signals >= 1) {
        state = 'recovering';
        recommendation = 'Dein Körper erholt sich. '
            'Moderate Belastung ist heute in Ordnung.';
      } else if (signals <= -2) {
        state = 'fatigued';
        recommendation = 'Deine Erholungswerte deuten auf Ermüdung hin. '
            'Fokus auf Regeneration, leichte Bewegung oder ein Ruhetag.';
      } else if (signals <= -1) {
        state = 'declining';
        recommendation = 'Deine Erholungstrends sind rückläufig. '
            'Erwäge einen leichteren Trainingstag.';
      } else {
        state = 'stable';
        recommendation = 'Deine Erholungswerte sind stabil. '
            'Du kannst dein normales Trainingspensum beibehalten.';
      }
    }

    debugPrint(
      '[RecoveryPlugin] date=$date state=$state score=$score '
      'hrvTrend=$hrvTrend rhrTrend=$rhrTrend',
    );

    final ts = DateTime.now();
    await Future.wait([
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.recovery,
        key: RecoveryKey.state,
        value: _stateToNumeric(state),
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.recovery,
        key: RecoveryKey.score,
        value: score,
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.recovery,
        key: RecoveryKey.hrvTrend,
        value: hrvTrend,
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.recovery,
        key: RecoveryKey.rhrTrend,
        value: rhrTrend,
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.recovery,
        key: RecoveryKey.recommendation,
        value: 0.0,
        date: date,
        computedAt: ts,
        metadata: Value(recommendation),
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

  double _stateToNumeric(String state) {
    switch (state) {
      case 'recovered':
        return 1.0;
      case 'recovering':
        return 2.0;
      case 'stable':
        return 3.0;
      case 'declining':
        return 4.0;
      case 'fatigued':
        return 5.0;
      case 'insufficient_data':
        return 6.0;
      default:
        return 6.0;
    }
  }
}
