/// Derived Store reader providers for the UI layer.
///
/// These providers read the LATEST computed values from the Derived Store.
/// They never compute anything — computation is done by the plugins via
/// PluginRunner. The UI simply watches these and rebuilds when the DB changes.
library;

import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/database/derived_keys.dart';
import '../../plugins/raw/raw_providers.dart';
import '../plugin_runner.dart';

part 'derived_providers.g.dart';

// ---------------------------------------------------------------------------
// Readiness — Legacy (v1, backward-compatible)
// ---------------------------------------------------------------------------

/// Today's composite readiness score (0–100), or null if not yet computed.
/// This is the average of physical and mental for backward compatibility.
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
// Readiness — Bimodal (v2)
// ---------------------------------------------------------------------------

/// Today's Physical Readiness Score (0–100), final after Bayesian fusion.
@riverpod
Future<double?> readinessPhysicalScore(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.readiness,
    key: ReadinessKey.physicalScore,
    date: d,
  );
  return entry?.value;
}

/// Today's Mental/Cognitive Readiness Score (0–100), final after Bayesian fusion.
@riverpod
Future<double?> readinessMentalScore(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.readiness,
    key: ReadinessKey.mentalScore,
    date: d,
  );
  return entry?.value;
}

/// Both bimodal scores as a single record — prevents double-fetch in UI.
@riverpod
Future<({double? physical, double? mental})> readinessBimodalScores(
  Ref ref, {
  String? date,
}) async {
  final physical = await ref.watch(readinessPhysicalScoreProvider(date: date).future);
  final mental = await ref.watch(readinessMentalScoreProvider(date: date).future);
  return (physical: physical, mental: mental);
}

/// Physical score component breakdown, parsed from JSON metadata.
@riverpod
Future<Map<String, double>?> readinessPhysicalComponents(
  Ref ref, {
  String? date,
}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.readiness,
    key: ReadinessKey.physicalComponents,
    date: d,
  );
  if (entry?.metadata == null) return null;
  try {
    final Map<String, dynamic> raw = jsonDecode(entry!.metadata!);
    return raw.map((k, v) => MapEntry(k, (v as num?)?.toDouble() ?? 0.0));
  } catch (_) {
    return null;
  }
}

/// Mental score component breakdown, parsed from JSON metadata.
@riverpod
Future<Map<String, double>?> readinessMentalComponents(
  Ref ref, {
  String? date,
}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.readiness,
    key: ReadinessKey.mentalComponents,
    date: d,
  );
  if (entry?.metadata == null) return null;
  try {
    final Map<String, dynamic> raw = jsonDecode(entry!.metadata!);
    return raw.map((k, v) => MapEntry(k, (v as num?)?.toDouble() ?? 0.0));
  } catch (_) {
    return null;
  }
}

/// Sleep Regularity Index value (-100 to +100) for display.
@riverpod
Future<double?> readinessSri(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.readiness,
    key: ReadinessKey.sri,
    date: d,
  );
  return entry?.value;
}

/// ACWR (Acute:Chronic Workload Ratio) for display.
@riverpod
Future<double?> readinessAcwr(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.readiness,
    key: ReadinessKey.acwr,
    date: d,
  );
  return entry?.value;
}

// ---------------------------------------------------------------------------
// User Feedback (Morning Check-in)
// ---------------------------------------------------------------------------

/// Today's user feedback entry (Soreness, Energy, Stress).
/// Returns null if the user has not submitted today's check-in yet.
@riverpod
Stream<UserFeedbackViewModel?> todayFeedback(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  final today = todayDateString();
  return db.watchFeedback(today).map((data) {
    if (data == null) return null;
    return UserFeedbackViewModel(
      soreness: data.soreness,
      energy: data.energy,
      stress: data.stress,
      recordedAt: data.recordedAt,
    );
  });
}

/// View-model carrying today's submitted feedback.
class UserFeedbackViewModel {
  const UserFeedbackViewModel({
    required this.soreness,
    required this.energy,
    required this.stress,
    required this.recordedAt,
  });

  final double soreness; // 1–10
  final double energy;   // 1–10
  final double stress;   // 1–10
  final DateTime recordedAt;
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

// ---------------------------------------------------------------------------
// AI Coach
// ---------------------------------------------------------------------------

/// Today's AI coaching insight, or null if not yet generated.
@riverpod
Future<Map<String, String>?> aiInsight(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();

  final entry = await db.latestDerived(
    namespace: DerivedNamespace.ai,
    key: 'todays_insight',
    date: d,
  );

  if (entry == null || entry.metadata == null) return null;

  try {
    final Map<String, dynamic> data = jsonDecode(entry.metadata!);
    return {
      'title': data[AiKey.insightTitle] as String? ?? 'Daily Insight',
      'text': data[AiKey.insightText] as String? ?? '',
    };
  } catch (e) {
    return null;
  }
}
