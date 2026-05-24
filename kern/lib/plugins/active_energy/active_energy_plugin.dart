import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';

import '../../core/database/app_database.dart';
import '../../core/database/derived_keys.dart';

class ActiveEnergyPlugin {
  ActiveEnergyPlugin(this._db);

  final AppDatabase _db;

  Future<void> run(String date) async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final sevenDaysAgo = todayStart.subtract(const Duration(days: 7));

    final todayEntries = await _db.rawEntriesBetween(
      type: 'active_energy_burned',
      from: todayStart,
      to: now,
    );
    final weekEntries = await _db.rawEntriesBetween(
      type: 'active_energy_burned',
      from: sevenDaysAgo,
      to: now,
    );

    final dailyKcal = todayEntries.fold(0.0, (s, e) => s + e.value);

    final weekKcal = weekEntries.fold(0.0, (s, e) => s + e.value);
    final weeklyAvg = weekKcal / 7.0;

    String activityLevel;
    if (weeklyAvg > 600) {
      activityLevel = 'very_active';
    } else if (weeklyAvg > 400) {
      activityLevel = 'active';
    } else if (weeklyAvg > 200) {
      activityLevel = 'moderate';
    } else if (weeklyAvg > 50) {
      activityLevel = 'light';
    } else {
      activityLevel = 'sedentary';
    }

    debugPrint(
      '[ActiveEnergyPlugin] date=$date dailyKcal=$dailyKcal '
      'weeklyAvg=$weeklyAvg level=$activityLevel',
    );

    final ts = DateTime.now();
    await Future.wait([
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.activeEnergy,
        key: ActiveEnergyKey.dailyKcal,
        value: dailyKcal,
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.activeEnergy,
        key: ActiveEnergyKey.weeklyAvg,
        value: weeklyAvg,
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.activeEnergy,
        key: ActiveEnergyKey.activityLevel,
        value: _levelToNumeric(activityLevel),
        date: date,
        computedAt: ts,
        metadata: Value(activityLevel),
      )),
    ]);
  }

  double _levelToNumeric(String level) {
    switch (level) {
      case 'very_active':
        return 5.0;
      case 'active':
        return 4.0;
      case 'moderate':
        return 3.0;
      case 'light':
        return 2.0;
      case 'sedentary':
        return 1.0;
      default:
        return 1.0;
    }
  }
}
