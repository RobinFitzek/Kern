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
import 'insight_engine.dart';
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

// ---------------------------------------------------------------------------
// Strain — Steps
// ---------------------------------------------------------------------------

/// Yesterday's total steps from Derived Store.
@riverpod
Future<double?> strainStepsYesterday(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.strain,
    key: StrainKey.stepsYesterday,
    date: d,
  );
  return entry?.value;
}

/// 7-day average steps from Derived Store.
@riverpod
Future<double?> strainSteps7dAvg(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.strain,
    key: StrainKey.steps7dAvg,
    date: d,
  );
  return entry?.value;
}

/// Three daily insights (Erholung, Schlaf, Belastung) generated from
/// readiness, sleep, and strain data.
@riverpod
Future<List<DailyInsight>> dailyInsights(Ref ref, {String? date}) async {
  final physCompAsync =
      ref.watch(readinessPhysicalComponentsProvider(date: date).future);
  final mentCompAsync =
      ref.watch(readinessMentalComponentsProvider(date: date).future);
  final sleepScoreAsync =
      ref.watch(sleepScoreProvider(date: date).future);
  final sleepMinsAsync =
      ref.watch(sleepMinutesProvider(date: date).future);
  final strainScoreAsync =
      ref.watch(strainScoreProvider(date: date).future);
  final acwrAsync =
      ref.watch(readinessAcwrProvider(date: date).future);
  final sriAsync =
      ref.watch(readinessSriProvider(date: date).future);
  final stepsYesterdayAsync =
      ref.watch(strainStepsYesterdayProvider(date: date).future);
  final steps7dAvgAsync =
      ref.watch(strainSteps7dAvgProvider(date: date).future);
  final physScoreAsync =
      ref.watch(readinessPhysicalScoreProvider(date: date).future);

  final physComp = await physCompAsync;
  final mentComp = await mentCompAsync;
  final sleepScore = await sleepScoreAsync;
  final sleepMins = await sleepMinsAsync;
  final strainScore = await strainScoreAsync;
  final acwr = await acwrAsync;
  final sri = await sriAsync;
  final stepsYesterday = await stepsYesterdayAsync;
  final steps7dAvg = await steps7dAvgAsync;
  final physScore = await physScoreAsync;

  final ctx = InsightContext(
    hrvScore: physComp?['hrv_score'],
    todayHrvMs: physComp?['today_hrv_ms'],
    rhrScore: physComp?['rhr_score'],
    todayRhrBpm: physComp?['today_rhr_bpm'],
    physicalScore: physScore,
    sleepQualityScore: sleepScore,
    deepMins: sleepMins.deep,
    remMins: sleepMins.rem,
    totalSleepMins: sleepMins.total,
    sleepEfficiencyPct: mentComp?['today_efficiency_pct'],
    sriValue: sri,
    strainScore: strainScore,
    acwrValue: acwr,
    stepsYesterday: stepsYesterday,
    steps7dAvg: steps7dAvg,
  );

  return const InsightEngine().generateInsights(ctx);
}

// ---------------------------------------------------------------------------
// Calibration & Historical
// ---------------------------------------------------------------------------

/// Counts distinct days with raw data per type (for calibration progress UI).
@riverpod
Future<({int hrvDays, int sleepNights})> readinessDataCounts(Ref ref) async {
  final db = ref.watch(appDatabaseProvider);
  final counts = await db.rawDataDateCounts();
  return (
    hrvDays: counts['hrv'] ?? 0,
    sleepNights: counts['sleep_deep'] ?? 0,
  );
}

/// Historical readiness scores over [days] for trend chart.
@riverpod
Future<List<({String date, double? physical, double? mental})>>
    historicalReadinessScores(Ref ref, {int days = 14}) async {
  final db = ref.watch(appDatabaseProvider);
  final end = DateTime.now();
  final start = end.subtract(Duration(days: days));

  final startStr =
      '${start.year}-${start.month.toString().padLeft(2, '0')}-${start.day.toString().padLeft(2, '0')}';
  final endStr =
      '${end.year}-${end.month.toString().padLeft(2, '0')}-${end.day.toString().padLeft(2, '0')}';

  final physEntries = await db.derivedForDateRange(
    namespace: DerivedNamespace.readiness,
    key: ReadinessKey.physicalScore,
    startDate: startStr,
    endDate: endStr,
  );
  final mentEntries = await db.derivedForDateRange(
    namespace: DerivedNamespace.readiness,
    key: ReadinessKey.mentalScore,
    startDate: startStr,
    endDate: endStr,
  );

  final physMap = {for (final e in physEntries) e.date: e.value};
  final mentMap = {for (final e in mentEntries) e.date: e.value};

  final allDates = {...physMap.keys, ...mentMap.keys}.toList()..sort();
  return allDates
      .map((d) => (date: d, physical: physMap[d], mental: mentMap[d]))
      .toList();
}

// ---------------------------------------------------------------------------
// Hydration
// ---------------------------------------------------------------------------

/// Today's total water intake in ml, or null.
@riverpod
Future<double?> hydrationDailyMl(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.hydration,
    key: HydrationKey.dailyMl,
    date: d,
  );
  return entry?.value;
}

/// Today's hydration goal percentage (0–100), or null.
@riverpod
Future<double?> hydrationGoalPercent(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.hydration,
    key: HydrationKey.goalPercent,
    date: d,
  );
  return entry?.value;
}

// ---------------------------------------------------------------------------
// Recovery
// ---------------------------------------------------------------------------

@riverpod
Future<double?> recoveryScore(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.recovery,
    key: RecoveryKey.score,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<String?> recoveryState(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.recovery,
    key: RecoveryKey.state,
    date: d,
  );
  if (entry == null) return null;
  return _recoveryStateString(entry.value);
}

@riverpod
Future<double?> recoveryHrvTrend(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.recovery,
    key: RecoveryKey.hrvTrend,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<double?> recoveryRhrTrend(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.recovery,
    key: RecoveryKey.rhrTrend,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<String?> recoveryRecommendation(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.recovery,
    key: RecoveryKey.recommendation,
    date: d,
  );
  return entry?.metadata;
}

String _recoveryStateString(double value) {
  switch (value.toInt()) {
    case 1:
      return 'Erholt';
    case 2:
      return 'Erholt sich';
    case 3:
      return 'Stabil';
    case 4:
      return 'Rückläufig';
    case 5:
      return 'Ermüdet';
    default:
      return 'Kalibrierung';
  }
}

// ---------------------------------------------------------------------------
// Heart Health
// ---------------------------------------------------------------------------

@riverpod
Future<double?> heartHealthRestingHr(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.heartHealth,
    key: HeartHealthKey.restingHr,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<double?> heartHealthRestingHrTrend(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.heartHealth,
    key: HeartHealthKey.restingHrTrend,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<double?> heartHealthHrvBaseline(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.heartHealth,
    key: HeartHealthKey.hrvBaseline,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<double?> heartHealthCvFitness(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.heartHealth,
    key: HeartHealthKey.cvFitnessEstimate,
    date: d,
  );
  return entry?.value;
}

// ---------------------------------------------------------------------------
// Weekly Report
// ---------------------------------------------------------------------------

@riverpod
Future<double?> weeklyAvgReadiness(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.weeklyReport,
    key: WeeklyReportKey.avgReadiness,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<double?> weeklyAvgSleep(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.weeklyReport,
    key: WeeklyReportKey.avgSleep,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<double?> weeklyAvgStrain(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.weeklyReport,
    key: WeeklyReportKey.avgStrain,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<double?> weeklyTotalSteps(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.weeklyReport,
    key: WeeklyReportKey.totalSteps,
    date: d,
  );
  return entry?.value;
}

// ---------------------------------------------------------------------------
// Body Battery
// ---------------------------------------------------------------------------

@riverpod
Future<double?> bodyBatteryCurrentLevel(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.bodyBattery,
    key: BodyBatteryKey.currentLevel,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<double?> bodyBatteryMorningLevel(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.bodyBattery,
    key: BodyBatteryKey.morningLevel,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<double?> bodyBatteryDrainRate(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.bodyBattery,
    key: BodyBatteryKey.drainRate,
    date: d,
  );
  return entry?.value;
}

// ---------------------------------------------------------------------------
// Active Energy
// ---------------------------------------------------------------------------

@riverpod
Future<double?> activeEnergyDailyKcal(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.activeEnergy,
    key: ActiveEnergyKey.dailyKcal,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<double?> activeEnergyWeeklyAvg(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.activeEnergy,
    key: ActiveEnergyKey.weeklyAvg,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<String?> activeEnergyLevel(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.activeEnergy,
    key: ActiveEnergyKey.activityLevel,
    date: d,
  );
  if (entry == null) return null;
  final raw = entry.metadata ?? _activeLevelString(entry.value);
  return raw;
}

String _activeLevelString(double value) {
  switch (value.toInt()) {
    case 5:
      return 'Sehr aktiv';
    case 4:
      return 'Aktiv';
    case 3:
      return 'Moderat';
    case 2:
      return 'Leicht';
    case 1:
      return 'Sitzend';
    default:
      return 'Sitzend';
  }
}

// ---------------------------------------------------------------------------
// Sleep Debt
// ---------------------------------------------------------------------------

@riverpod
Future<double?> sleepDebtBankBalance(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.sleepDebt,
    key: SleepDebtKey.bankBalance,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<double?> sleepDebtBankScore(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.sleepDebt,
    key: SleepDebtKey.bankScore,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<double?> sleepDebtDailyShortfall(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.sleepDebt,
    key: SleepDebtKey.dailyShortfall,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<double?> sleepDebtLastNightSurplus(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.sleepDebt,
    key: SleepDebtKey.lastNightSurplus,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<int?> sleepDebtSeverity(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.sleepDebt,
    key: SleepDebtKey.debtSeverity,
    date: d,
  );
  if (entry == null) return null;
  return entry.value.toInt();
}

@riverpod
Future<double?> sleepDebtRecoveryDays(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.sleepDebt,
    key: SleepDebtKey.recoveryDays,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<int?> sleepDebtTrend(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.sleepDebt,
    key: SleepDebtKey.trendDirection,
    date: d,
  );
  if (entry == null) return null;
  return entry.value.toInt();
}

@riverpod
Future<double?> sleepDebtSleepGoal(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.sleepDebt,
    key: SleepDebtKey.sleepGoal,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<double?> sleepDebtWeeklyTrend(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.sleepDebt,
    key: SleepDebtKey.weeklyBalanceTrend,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<Map<String, dynamic>?> sleepDebtDetailJson(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.sleepDebt,
    key: SleepDebtKey.detailJson,
    date: d,
  );
  if (entry?.metadata == null) return null;
  try {
    return jsonDecode(entry!.metadata!) as Map<String, dynamic>;
  } catch (_) {
    return null;
  }
}

// ---------------------------------------------------------------------------
// Workload Balance
// ---------------------------------------------------------------------------

@riverpod
Future<double?> workloadBalanceRatio(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.workloadBalance,
    key: WorkloadBalanceKey.ratio,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<int?> workloadBalanceState(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.workloadBalance,
    key: WorkloadBalanceKey.state,
    date: d,
  );
  if (entry == null) return null;
  return entry.value.toInt();
}

@riverpod
Future<double?> workloadBalanceScore(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.workloadBalance,
    key: WorkloadBalanceKey.score,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<String?> workloadBalanceTrainingAdvice(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.workloadBalance,
    key: WorkloadBalanceKey.trainingAdvice,
    date: d,
  );
  return entry?.metadata;
}

@riverpod
Future<double?> workloadBalanceAcuteLoad(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.workloadBalance,
    key: WorkloadBalanceKey.acuteLoad,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<double?> workloadBalanceChronicLoad(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.workloadBalance,
    key: WorkloadBalanceKey.chronicLoad,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<double?> workloadBalanceRecoveryLevel(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.workloadBalance,
    key: WorkloadBalanceKey.recoveryLevel,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<double?> workloadBalanceReadinessLevel(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.workloadBalance,
    key: WorkloadBalanceKey.readinessLevel,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<int?> workloadBalanceTrend(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.workloadBalance,
    key: WorkloadBalanceKey.trend,
    date: d,
  );
  if (entry == null) return null;
  return entry.value.toInt();
}

// ---------------------------------------------------------------------------
// Consistency
// ---------------------------------------------------------------------------

@riverpod
Future<double?> consistencyOverallScore(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.consistency,
    key: ConsistencyKey.overallScore,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<double?> consistencyStepsScore(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.consistency,
    key: ConsistencyKey.stepsScore,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<double?> consistencyEnergyScore(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.consistency,
    key: ConsistencyKey.energyScore,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<int?> consistencyState(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.consistency,
    key: ConsistencyKey.state,
    date: d,
  );
  if (entry == null) return null;
  return entry.value.toInt();
}

@riverpod
Future<double?> consistencyActiveDays(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.consistency,
    key: ConsistencyKey.activeDays,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<double?> consistencyStreak(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.consistency,
    key: ConsistencyKey.streak,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<double?> consistencyBestStreak(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.consistency,
    key: ConsistencyKey.bestStreak,
    date: d,
  );
  return entry?.value;
}

// ---------------------------------------------------------------------------
// Chronotype
// ---------------------------------------------------------------------------

@riverpod
Future<int?> chronotypeCategory(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.chronotype,
    key: ChronotypeKey.category,
    date: d,
  );
  if (entry == null) return null;
  return entry.value.toInt();
}

@riverpod
Future<String?> chronotypeCategoryLabel(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.chronotype,
    key: ChronotypeKey.categoryLabel,
    date: d,
  );
  return entry?.metadata;
}

@riverpod
Future<double?> chronotypeAvgBedtime(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.chronotype,
    key: ChronotypeKey.avgBedtimeHour,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<double?> chronotypeAvgWaketime(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.chronotype,
    key: ChronotypeKey.avgWaketimeHour,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<double?> chronotypeMidpoint(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.chronotype,
    key: ChronotypeKey.midpointHour,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<double?> chronotypeVariability(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.chronotype,
    key: ChronotypeKey.variabilityMins,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<double?> chronotypeAvgDuration(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.chronotype,
    key: ChronotypeKey.avgDurationMins,
    date: d,
  );
  return entry?.value;
}

// ---------------------------------------------------------------------------
// Stress Load
// ---------------------------------------------------------------------------

@riverpod
Future<double?> stressLoadScore(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.stressLoad,
    key: StressLoadKey.score,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<double?> stressLoadRatio(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.stressLoad,
    key: StressLoadKey.stressRatio,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<double?> stressLoadNighttimeBaseline(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.stressLoad,
    key: StressLoadKey.nighttimeBaseline,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<double?> stressLoadDaytimeHrv(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.stressLoad,
    key: StressLoadKey.daytimeHrv,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<int?> stressLoadCategory(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.stressLoad,
    key: StressLoadKey.category,
    date: d,
  );
  if (entry == null) return null;
  return entry.value.toInt();
}

@riverpod
Future<int?> stressLoadBaselineTrend(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.stressLoad,
    key: StressLoadKey.baselineTrend,
    date: d,
  );
  if (entry == null) return null;
  return entry.value.toInt();
}

@riverpod
Future<String?> stressLoadRecommendation(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.stressLoad,
    key: StressLoadKey.recommendation,
    date: d,
  );
  return entry?.metadata;
}

// ---------------------------------------------------------------------------
// Forecast
// ---------------------------------------------------------------------------

@riverpod
Future<double?> forecastPredictedReadiness(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.forecast,
    key: ForecastKey.predictedReadiness,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<double?> forecastPredictedMental(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.forecast,
    key: ForecastKey.predictedMental,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<double?> forecastTrendSlope(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.forecast,
    key: ForecastKey.trendSlope,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<double?> forecastConfidence(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.forecast,
    key: ForecastKey.confidence,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<int?> forecastCategory(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.forecast,
    key: ForecastKey.category,
    date: d,
  );
  if (entry == null) return null;
  return entry.value.toInt();
}

@riverpod
Future<double?> forecastRecoveryDebt(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.forecast,
    key: ForecastKey.recoveryDebt,
    date: d,
  );
  return entry?.value;
}

@riverpod
Future<String?> forecastRecommendation(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.forecast,
    key: ForecastKey.recommendation,
    date: d,
  );
  return entry?.metadata;
}

@riverpod
Future<double?> forecastMentalTrend(Ref ref, {String? date}) async {
  final db = ref.watch(appDatabaseProvider);
  final d = date ?? todayDateString();
  final entry = await db.latestDerived(
    namespace: DerivedNamespace.forecast,
    key: ForecastKey.mentalTrend,
    date: d,
  );
  return entry?.value;
}
