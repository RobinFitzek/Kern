import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../core/database/app_database.dart';
import '../../core/database/derived_keys.dart';

class HydrationPlugin {
  HydrationPlugin(this._db);

  final AppDatabase _db;

  static const double _dailyGoalMl = 2500.0;

  Future<void> run(String date) async {
    final waterEntries = await _db.rawEntriesSince(
      type: 'water',
      since: DateTime.now().toUtc().subtract(const Duration(hours: 36)),
    );

    final totalMl = waterEntries.fold(0.0, (s, e) => s + e.value);
    final goalFraction = (totalMl / _dailyGoalMl).clamp(0.0, 1.0);
    final score = (goalFraction * 100).clamp(0.0, 100.0);

    debugPrint('[HydrationPlugin] date=$date totalMl=$totalMl score=$score');

    await _db.upsertDerived(
      DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.hydration,
        key: HydrationKey.dailyMl,
        value: totalMl,
        date: date,
        computedAt: DateTime.now(),
      ),
    );
    await _db.upsertDerived(
      DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.hydration,
        key: HydrationKey.goalPercent,
        value: score,
        date: date,
        computedAt: DateTime.now(),
      ),
    );
  }
}
