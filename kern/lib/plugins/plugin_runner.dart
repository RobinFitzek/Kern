import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../plugins/raw/raw_providers.dart';
import 'readiness/readiness_plugin.dart';
import 'sleep/sleep_plugin.dart';
import 'strain/strain_plugin.dart';
import 'ai/ai_plugin.dart';

part 'plugin_runner.g.dart';

// ---------------------------------------------------------------------------
// PluginRunResult — summary of a plugin run
// ---------------------------------------------------------------------------

class PluginRunResult {
  const PluginRunResult({
    required this.date,
    required this.readinessOk,
    required this.sleepOk,
    required this.strainOk,
    this.errors = const {},
  });

  final String date;
  final bool readinessOk;
  final bool sleepOk;
  final bool strainOk;

  /// Map of plugin name → error for any that failed.
  final Map<String, Object> errors;

  bool get allOk => readinessOk && sleepOk && strainOk;

  @override
  String toString() =>
      'PluginRunResult($date, readiness=$readinessOk, sleep=$sleepOk, strain=$strainOk, errors=$errors)';
}

// ---------------------------------------------------------------------------
// PluginRunner — orchestrates all plugins for a given date
// ---------------------------------------------------------------------------

@riverpod
class PluginRunner extends _$PluginRunner {
  @override
  AsyncValue<PluginRunResult?> build() => const AsyncValue.data(null);

  /// Run all plugins for [date] (format: "yyyy-MM-dd").
  ///
  /// Each plugin runs independently — a failure in one does not prevent
  /// the others from completing. Errors are captured in [PluginRunResult.errors].
  Future<void> runAll(String date) async {
    state = const AsyncValue.loading();

    final db = ref.read(appDatabaseProvider);

    final readinessPlugin = ReadinessPlugin(db);
    final sleepPlugin = SleepPlugin(db);
    final strainPlugin = StrainPlugin(db);

    bool readinessOk = false;
    bool sleepOk = false;
    bool strainOk = false;
    final Map<String, Object> errors = {};

    // Run all plugins in parallel, catching each independently.
    await Future.wait([
      _run('ReadinessPlugin', () => readinessPlugin.run(date)).then((_) {
        readinessOk = true;
      }).catchError((Object e) {
        errors['ReadinessPlugin'] = e;
        debugPrint('[PluginRunner] ReadinessPlugin failed: $e');
      }),
      _run('SleepPlugin', () => sleepPlugin.run(date)).then((_) {
        sleepOk = true;
      }).catchError((Object e) {
        errors['SleepPlugin'] = e;
        debugPrint('[PluginRunner] SleepPlugin failed: $e');
      }),
      _run('StrainPlugin', () => strainPlugin.run(date)).then((_) {
        strainOk = true;
      }).catchError((Object e) {
        errors['StrainPlugin'] = e;
        debugPrint('[PluginRunner] StrainPlugin failed: $e');
      }),
    ]);

    final result = PluginRunResult(
      date: date,
      readinessOk: readinessOk,
      sleepOk: sleepOk,
      strainOk: strainOk,
      errors: errors,
    );

    // AI Coach depends on the derived scores from other plugins
    try {
      final aiPlugin = AiPlugin(db);
      await _run('AiPlugin', () => aiPlugin.run(date));
    } catch (e) {
      errors['AiPlugin'] = e;
      debugPrint('[PluginRunner] AiPlugin failed: $e');
    }

    debugPrint('[PluginRunner] done: $result');
    state = AsyncValue.data(result);
  }

  Future<void> _run(String name, Future<void> Function() fn) async {
    debugPrint('[PluginRunner] starting $name');
    await fn();
    debugPrint('[PluginRunner] $name complete');
  }

  /// Retroactively compute scores for past dates that have raw data but
  /// no derived Readiness score yet. Called once after the initial sync
  /// so existing Health Connect data is used immediately.
  ///
  /// Backfills up to [maxDays] days into the past (default 30).
  Future<void> runBackfill({int maxDays = 30}) async {
    final db = ref.read(appDatabaseProvider);
    final readinessPlugin = ReadinessPlugin(db);
    final sleepPlugin = SleepPlugin(db);
    final strainPlugin = StrainPlugin(db);

    final today = DateTime.now();
    int computed = 0;

    for (var i = 1; i <= maxDays; i++) {
      final day = today.subtract(Duration(days: i));
      final dateStr = '${day.year}-'
          '${day.month.toString().padLeft(2, '0')}-'
          '${day.day.toString().padLeft(2, '0')}';

      // Skip if score already computed for this date
      final existing = await db.latestDerived(
        namespace: 'readiness',
        key: 'physical_score',
        date: dateStr,
      );
      if (existing != null) continue;

      try {
        await Future.wait([
          readinessPlugin.run(dateStr),
          sleepPlugin.run(dateStr),
          strainPlugin.run(dateStr),
        ]);
        computed++;
        debugPrint('[PluginRunner] backfilled $dateStr');
      } catch (e) {
        debugPrint('[PluginRunner] backfill failed for $dateStr: $e');
      }
    }

    debugPrint('[PluginRunner] backfill complete: $computed dates computed');
  }
}

// ---------------------------------------------------------------------------
// Date helper
// ---------------------------------------------------------------------------

/// Returns today's date as "yyyy-MM-dd" in local time.
String todayDateString() {
  final d = DateTime.now();
  return '${d.year}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';
}
