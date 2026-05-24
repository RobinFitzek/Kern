import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../../core/database/app_database.dart';
import '../../core/database/derived_keys.dart';

class StressLoadPlugin {
  StressLoadPlugin(this._db);

  final AppDatabase _db;

  static const int _lookbackDays = 14;
  static const int _nightStart = 22;
  static const int _nightEnd = 6;
  static const int _dayStart = 6;
  static const int _dayEnd = 18;

  Future<void> run(String date) async {
    final now = DateTime.now();
    final since = now.subtract(Duration(days: _lookbackDays));

    final hrvEntries = await _db.rawEntriesBetween(
      type: 'hrv',
      from: since,
      to: now,
    );

    if (hrvEntries.isEmpty) {
      debugPrint('[StressLoadPlugin] date=$date no HRV data');
      final ts = DateTime.now();
      await _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.stressLoad,
        key: StressLoadKey.category,
        value: 5.0,
        date: date,
        computedAt: ts,
      ));
      return;
    }

    final nightValues = <double>[];
    final dayValues = <double>[];

    for (final entry in hrvEntries) {
      final hour = entry.timestamp.hour;
      if (hour >= _nightStart || hour < _nightEnd) {
        nightValues.add(entry.value);
      } else if (hour >= _dayStart && hour < _dayEnd) {
        dayValues.add(entry.value);
      }
    }

    final nightAvg = nightValues.isEmpty ? 0.0 : nightValues.reduce((a, b) => a + b) / nightValues.length;
    final dayAvg = dayValues.isEmpty ? 0.0 : dayValues.reduce((a, b) => a + b) / dayValues.length;

    if (nightAvg <= 0) {
      debugPrint('[StressLoadPlugin] date=$date no nighttime HRV baseline');
      final ts = DateTime.now();
      await _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.stressLoad,
        key: StressLoadKey.category,
        value: 5.0,
        date: date,
        computedAt: ts,
      ));
      return;
    }

    double daytimeToday = dayAvg;
    final todayEntries = hrvEntries.where((e) {
      final d = _fmtDate(e.timestamp);
      return d == date;
    }).toList();
    if (todayEntries.isNotEmpty) {
      final todayDaytime = todayEntries.where((e) {
        final h = e.timestamp.hour;
        return h >= _dayStart && h < _dayEnd;
      }).toList();
      if (todayDaytime.isNotEmpty) {
        daytimeToday = todayDaytime.map((e) => e.value).reduce((a, b) => a + b) / todayDaytime.length;
      }
    }

    final stressRatio = daytimeToday / nightAvg;
    final score = _ratioToScore(stressRatio);

    int category;
    if (stressRatio >= 1.0) {
      category = 0;
    } else if (stressRatio >= 0.8) {
      category = 1;
    } else if (stressRatio >= 0.6) {
      category = 2;
    } else if (stressRatio >= 0.4) {
      category = 3;
    } else {
      category = 4;
    }

    int baselineTrend = _computeBaselineTrend(hrvEntries);

    String recommendation;
    switch (category) {
      case 0:
        recommendation = 'Dein autonomes Nervensystem ist im Gleichgewicht. '
            'Deine HRV ist tagsüber stabil — ein Zeichen guter Stressresistenz. '
            'Behalte deine aktuelle Routine bei.';
        break;
      case 1:
        recommendation = 'Leichter Stress messbar. Deine Tages-HRV liegt leicht '
            'unter deiner Nacht-Baseline. Kurze Atemübungen (5 min) oder ein '
            'Spaziergang helfen, die Balance wiederherzustellen.';
        break;
      case 2:
        recommendation = 'Moderate Stressbelastung. Dein Körper zeigt deutliche '
            'Stresssignale. Plane heute bewusste Erholungspausen ein — '
            'Atemübungen, Meditation oder ein ruhiger Spaziergang werden empfohlen.';
        break;
      case 3:
        recommendation = 'Hohe Stressbelastung! Deine HRV ist tagsüber stark '
            'reduziert. Das ist ein klares Signal deines Körpers, die Belastung '
            'zu reduzieren. Ein Ruhetag oder aktive Erholung sind heute wichtiger '
            'als Training.';
        break;
      default:
        recommendation = 'Extreme Stressbelastung! Deine HRV ist tagsüber massiv '
            'eingebrochen. Dein Körper ist im Kampf-oder-Flucht-Modus. '
            'Priorisiere heute Schlaf, Ernährung und komplette Erholung. '
            'Training würde deine Situation verschlechtern.';
    }

    debugPrint(
      '[StressLoadPlugin] date=$date ratio=${stressRatio.toStringAsFixed(2)} '
      'night=${nightAvg.toStringAsFixed(0)} day=${daytimeToday.toStringAsFixed(0)} '
      'score=${score.toInt()} cat=$category',
    );

    final ts = DateTime.now();
    await Future.wait([
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.stressLoad,
        key: StressLoadKey.score,
        value: score,
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.stressLoad,
        key: StressLoadKey.stressRatio,
        value: stressRatio,
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.stressLoad,
        key: StressLoadKey.nighttimeBaseline,
        value: nightAvg,
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.stressLoad,
        key: StressLoadKey.daytimeHrv,
        value: daytimeToday,
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.stressLoad,
        key: StressLoadKey.category,
        value: category.toDouble(),
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.stressLoad,
        key: StressLoadKey.baselineTrend,
        value: baselineTrend.toDouble(),
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.stressLoad,
        key: StressLoadKey.recommendation,
        value: 0.0,
        date: date,
        computedAt: ts,
        metadata: Value(recommendation),
      )),
    ]);
  }

  double _ratioToScore(double ratio) {
    if (ratio >= 1.0) return 100.0;
    if (ratio >= 0.8) return (80.0 + (ratio - 0.8) * 100.0).clamp(80.0, 100.0);
    if (ratio >= 0.6) return (50.0 + (ratio - 0.6) * 150.0).clamp(50.0, 80.0);
    if (ratio >= 0.4) return (20.0 + (ratio - 0.4) * 150.0).clamp(20.0, 50.0);
    return (ratio / 0.4 * 20.0).clamp(0.0, 20.0);
  }

  int _computeBaselineTrend(List<dynamic> entries) {
    final sorted = entries.toList()..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    if (sorted.length < 7) return 1;

    final half = sorted.length ~/ 2;
    final older = sorted.sublist(0, half);
    final newer = sorted.sublist(half);

    final olderNight = older.where((e) { final h = e.timestamp.hour; return h >= _nightStart || h < _nightEnd; }).toList();
    final newerNight = newer.where((e) { final h = e.timestamp.hour; return h >= _nightStart || h < _nightEnd; }).toList();

    if (olderNight.isEmpty || newerNight.isEmpty) return 1;

    final olderAvg = olderNight.map((e) => e.value as double).reduce((a, b) => a + b) / olderNight.length;
    final newerAvg = newerNight.map((e) => e.value as double).reduce((a, b) => a + b) / newerNight.length;

    if (olderAvg <= 0) return 1;
    final change = newerAvg / olderAvg;
    if (change > 1.05) return 1;
    if (change < 0.95) return -1;
    return 0;
  }

  String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
