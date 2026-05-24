import 'dart:math' as math;

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../../core/database/app_database.dart';
import '../../core/database/derived_keys.dart';

class ChronotypePlugin {
  ChronotypePlugin(this._db);

  final AppDatabase _db;

  static const int _lookbackDays = 28;
  static const int _minNights = 7;

  Future<void> run(String date) async {
    final now = DateTime.now();
    final start = now.subtract(Duration(days: _lookbackDays));

    final deepEntries = await _db.rawEntriesBetween(
      type: 'sleep_deep',
      from: start,
      to: now,
    );
    final remEntries = await _db.rawEntriesBetween(
      type: 'sleep_rem',
      from: start,
      to: now,
    );
    final lightEntries = await _db.rawEntriesBetween(
      type: 'sleep_light',
      from: start,
      to: now,
    );

    final allSleep = [...deepEntries, ...remEntries, ...lightEntries];

    final nights = <String, List<DateTime>>{};
    for (final entry in allSleep) {
      final nightDate = _fmtDate(entry.timestamp);
      nights.putIfAbsent(nightDate, () => []);
      nights[nightDate]!.add(entry.timestamp);
      if (entry.timestampEnd != null) {
        nights[nightDate]!.add(entry.timestampEnd!);
      }
    }

    final nightData = <_NightWindow>[];
    for (final entry in nights.entries) {
      final times = entry.value;
      if (times.isEmpty) continue;
      times.sort();
      final bed = times.first;
      final wake = times.last;
      final duration = wake.difference(bed).inMinutes;
      if (duration < 60 || duration > 900) continue;

      final bedHour = bed.hour + bed.minute / 60.0;
      double wakeHour = wake.hour + wake.minute / 60.0;
      if (wakeHour < bedHour) wakeHour += 24.0;

      final midpointHour = (bedHour + wakeHour) / 2.0;
      final normalizedMidpoint = midpointHour >= 24.0
          ? midpointHour - 24.0
          : midpointHour;

      nightData.add(_NightWindow(
        bedHour: bedHour,
        wakeHour: wakeHour,
        midpointHour: normalizedMidpoint,
        durationMins: duration.toDouble(),
        date: entry.key,
      ));
    }

    if (nightData.length < _minNights) {
      debugPrint('[ChronotypePlugin] date=$date insufficient nights: ${nightData.length}');
      final ts = DateTime.now();
      await _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.chronotype,
        key: ChronotypeKey.category,
        value: 5.0,
        date: date,
        computedAt: ts,
      ));
      return;
    }

    final avgBed = nightData.map((n) => n.bedHour).reduce((a, b) => a + b) / nightData.length;
    final avgWake = nightData.map((n) => n.wakeHour).reduce((a, b) => a + b) / nightData.length;
    final avgMid = nightData.map((n) => n.midpointHour).reduce((a, b) => a + b) / nightData.length;
    final avgDur = nightData.map((n) => n.durationMins).reduce((a, b) => a + b) / nightData.length;

    double sumSq = 0.0;
    for (final n in nightData) {
      sumSq += (n.midpointHour - avgMid) * (n.midpointHour - avgMid);
    }
    final variability = _sqrt(sumSq / nightData.length) * 60.0;

    int category;
    String categoryLabel;
    if (avgMid < 2.0) {
      category = 0;
      categoryLabel = 'Extremer Frühaufsteher';
    } else if (avgMid < 4.0) {
      category = 1;
      categoryLabel = 'Frühaufsteher';
    } else if (avgMid < 6.0) {
      category = 2;
      categoryLabel = 'Normaltyp';
    } else if (avgMid < 8.0) {
      category = 3;
      categoryLabel = 'Spättyp';
    } else {
      category = 4;
      categoryLabel = 'Extremer Spättyp';
    }

    debugPrint(
      '[ChronotypePlugin] date=$date mid=${avgMid.toStringAsFixed(1)} '
      'bed=${avgBed.toStringAsFixed(1)} wake=${avgWake.toStringAsFixed(1)} '
      'category=$categoryLabel variability=${variability.toInt()}min',
    );

    final ts = DateTime.now();
    await Future.wait([
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.chronotype,
        key: ChronotypeKey.avgBedtimeHour,
        value: avgBed,
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.chronotype,
        key: ChronotypeKey.avgWaketimeHour,
        value: avgWake,
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.chronotype,
        key: ChronotypeKey.midpointHour,
        value: avgMid,
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.chronotype,
        key: ChronotypeKey.variabilityMins,
        value: variability,
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.chronotype,
        key: ChronotypeKey.category,
        value: category.toDouble(),
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.chronotype,
        key: ChronotypeKey.categoryLabel,
        value: 0.0,
        date: date,
        computedAt: ts,
        metadata: Value(categoryLabel),
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.chronotype,
        key: ChronotypeKey.avgDurationMins,
        value: avgDur,
        date: date,
        computedAt: ts,
      )),
    ]);
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

class _NightWindow {
  const _NightWindow({
    required this.bedHour,
    required this.wakeHour,
    required this.midpointHour,
    required this.durationMins,
    required this.date,
  });
  final double bedHour;
  final double wakeHour;
  final double midpointHour;
  final double durationMins;
  final String date;
}
