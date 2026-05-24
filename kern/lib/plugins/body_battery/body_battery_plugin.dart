import 'package:flutter/foundation.dart';

import '../../core/database/app_database.dart';
import '../../core/database/derived_keys.dart';

class BodyBatteryPlugin {
  BodyBatteryPlugin(this._db);

  final AppDatabase _db;

  Future<void> run(String date) async {
    final db = _db;
    final today = date;

    final sleepScoreEntry = await db.latestDerived(
      namespace: DerivedNamespace.sleep,
      key: SleepKey.qualityScore,
      date: today,
    );
    final strainScoreEntry = await db.latestDerived(
      namespace: DerivedNamespace.strain,
      key: StrainKey.daily,
      date: today,
    );

    final now = DateTime.now();
    final hrvEntries = await db.rawEntriesBetween(
      type: 'hrv',
      from: now.subtract(const Duration(days: 3)),
      to: now,
    );

    final sleepScore = sleepScoreEntry?.value ?? 50.0;
    final strainScore = strainScoreEntry?.value ?? 0.0;

    final hourOfDay = now.hour;
    final timeDrain = _timeBasedDrain(hourOfDay);

    final hrvContribution = _hrvEnergyContribution(hrvEntries);

    final morningLevel = ((sleepScore * 0.7) + (hrvContribution * 0.3)).clamp(0.0, 100.0);

    final strainDrain = (strainScore / 100.0) * 40.0;
    final totalDrain = (timeDrain + strainDrain).clamp(0.0, 95.0);

    final drainRate = (totalDrain / 24.0).clamp(0.0, 10.0);

    final currentLevel = (morningLevel - totalDrain).clamp(5.0, 100.0);

    debugPrint(
      '[BodyBatteryPlugin] date=$date morningLevel=$morningLevel '
      'currentLevel=$currentLevel drainRate=$drainRate',
    );

    final ts = DateTime.now();
    await Future.wait([
      db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.bodyBattery,
        key: BodyBatteryKey.currentLevel,
        value: currentLevel,
        date: today,
        computedAt: ts,
      )),
      db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.bodyBattery,
        key: BodyBatteryKey.morningLevel,
        value: morningLevel,
        date: today,
        computedAt: ts,
      )),
      db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.bodyBattery,
        key: BodyBatteryKey.drainRate,
        value: drainRate,
        date: today,
        computedAt: ts,
      )),
    ]);
  }

  double _timeBasedDrain(int hour) {
    if (hour < 6) return 0.0;
    if (hour < 12) return (hour - 6) * 3.0;
    if (hour < 18) return 18.0 + (hour - 12) * 2.0;
    return 30.0 + (hour - 18) * 1.5;
  }

  double _hrvEnergyContribution(List<dynamic> hrvEntries) {
    if (hrvEntries.isEmpty) return 50.0;
    final avg = hrvEntries.map((e) => e.value as double).reduce((a, b) => a + b) / hrvEntries.length;
    if (avg > 40) return 75.0;
    if (avg > 25) return 60.0;
    if (avg > 15) return 40.0;
    return 25.0;
  }
}
