/// Derived Store reader providers for the UI layer.
///
/// These providers read the LATEST computed values from the Derived Store.
/// They never compute anything — computation is done by the plugins via
/// PluginRunner. The UI simply watches these and rebuilds when the DB changes.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/database/derived_keys.dart';
import '../../plugins/raw/raw_providers.dart';
import '../plugin_runner.dart';

part 'derived_providers.g.dart';

// ---------------------------------------------------------------------------
// Readiness
// ---------------------------------------------------------------------------

/// Today's readiness score (0–100), or null if not yet computed.
@riverpod
Future<double?> readinessScore(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.readiness,
    key: ReadinessKey.score,
    date: d,
  );
  return entry?.value;
}

/// Whether the readiness score is still in the calibration period.
@riverpod
Future<bool> readinessIsCalibrating(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.readiness,
    key: ReadinessKey.isCalibrating,
    date: d,
  );
  return (entry?.value ?? 1.0) == 1.0;
}

/// Readiness component contributions (hrv, sleep, strain) as a record.
/// Each value is 0–1, or null if that component had no data.
@riverpod
Future<({double? hrv, double? sleep, double? strain})> readinessComponents(
  Ref ref, {
  String? date,
}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();

  final results = await Future.wait([
    db.latestDerived(namespace: DerivedNamespace.readiness, key: ReadinessKey.hrvContribution, date: d),
    db.latestDerived(namespace: DerivedNamespace.readiness, key: ReadinessKey.sleepContribution, date: d),
    db.latestDerived(namespace: DerivedNamespace.readiness, key: ReadinessKey.strainContribution, date: d),
  ]);

  return (
    hrv: results[0]?.value,
    sleep: results[1]?.value,
    strain: results[2]?.value,
  );
}

// ---------------------------------------------------------------------------
// Sleep
// ---------------------------------------------------------------------------

/// Today's sleep quality score (0–100), or null if not computed.
@riverpod
Future<double?> sleepScore(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.sleep,
    key: SleepKey.qualityScore,
    date: d,
  );
  return entry?.value;
}

/// Today's sleep stage minutes as a record.
@riverpod
Future<({double deep, double rem, double light, double total})> sleepMinutes(
  Ref ref, {
  String? date,
}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();

  final results = await Future.wait([
    db.latestDerived(namespace: DerivedNamespace.sleep, key: SleepKey.deepMinutes, date: d),
    db.latestDerived(namespace: DerivedNamespace.sleep, key: SleepKey.remMinutes, date: d),
    db.latestDerived(namespace: DerivedNamespace.sleep, key: SleepKey.lightMinutes, date: d),
    db.latestDerived(namespace: DerivedNamespace.sleep, key: SleepKey.totalMinutes, date: d),
  ]);

  return (
    deep: results[0]?.value ?? 0,
    rem: results[1]?.value ?? 0,
    light: results[2]?.value ?? 0,
    total: results[3]?.value ?? 0,
  );
}

// ---------------------------------------------------------------------------
// Strain
// ---------------------------------------------------------------------------

/// Today's strain score (0–100), or null if not computed.
@riverpod
Future<double?> strainScore(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.strain,
    key: StrainKey.daily,
    date: d,
  );
  return entry?.value;
}
