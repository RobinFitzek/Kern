import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../plugins/raw/raw_providers.dart';
import 'readiness/readiness_plugin.dart';
import 'sleep/sleep_plugin.dart';
import 'strain/strain_plugin.dart';

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

    debugPrint('[PluginRunner] done: $result');
    state = AsyncValue.data(result);
  }

  Future<void> _run(String name, Future<void> Function() fn) async {
    debugPrint('[PluginRunner] starting $name');
    await fn();
    debugPrint('[PluginRunner] $name complete');
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
