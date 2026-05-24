/// Derived Store namespace and key constants.
///
/// Using typed constant classes prevents typos and makes refactoring safe.
/// All plugin writes and UI reads MUST use these constants.
library;

class DerivedNamespace {
  static const String readiness = 'readiness';
  static const String sleep = 'sleep';
  static const String strain = 'strain';
  static const String ai = 'ai';
  static const String feedback = 'feedback';
  static const String hydration = 'hydration';
  static const String recovery = 'recovery';
  static const String heartHealth = 'heart_health';
  static const String weeklyReport = 'weekly_report';
  static const String bodyBattery = 'body_battery';
  static const String activeEnergy = 'active_energy';
  static const String sleepDebt = 'sleep_debt';
  static const String workloadBalance = 'workload_balance';
  static const String consistency = 'consistency';
  static const String chronotype = 'chronotype';
  static const String stressLoad = 'stress_load';
  static const String forecast = 'forecast';
  DerivedNamespace._();
}

class ReadinessKey {
  // Legacy monolithic score — kept for backward-compatible reads during transition.
  static const String score = 'score';

  // Legacy component keys
  static const String hrvContribution = 'hrv_contribution';
  static const String sleepContribution = 'sleep_contribution';
  static const String strainContribution = 'strain_contribution';

  // ── Bimodal Algorithm (v2) ──────────────────────────────────────────────────

  /// Objective physical readiness score (0–100) before Bayesian update.
  static const String physicalScoreObj = 'physical_score_obj';

  /// Final physical readiness score (0–100) after Bayesian user feedback fusion.
  static const String physicalScore = 'physical_score';

  /// Objective mental/cognitive readiness score (0–100) before Bayesian update.
  static const String mentalScoreObj = 'mental_score_obj';

  /// Final mental/cognitive readiness score (0–100) after Bayesian user feedback fusion.
  static const String mentalScore = 'mental_score';

  /// JSON blob: {hrv, rhr, deep, tst, acwr} — contributions to physical score.
  /// Each sub-value is a score on 0–100 scale before weighting.
  static const String physicalComponents = 'physical_components';

  /// JSON blob: {rem, sri, cv, efficiency} — contributions to mental score.
  static const String mentalComponents = 'mental_components';

  /// Acute:Chronic Workload Ratio (stored for display/debugging).
  static const String acwr = 'acwr';

  /// Sleep Regularity Index value (-100 to +100, stored for display).
  static const String sri = 'sri';

  /// Current objective weight w_obj used in Bayesian fusion (0.0–1.0).
  /// Starts at 0.8; adapts over time as subjective data accumulates.
  static const String wObjWeight = 'w_obj_weight';

  /// 1.0 = still calibrating (< 7 days HRV or < 3 sleep nights), 0.0 = ready.
  static const String isCalibrating = 'is_calibrating';

  ReadinessKey._();
}

class SleepKey {
  static const String qualityScore = 'quality_score';
  static const String deepMinutes = 'deep_minutes';
  static const String remMinutes = 'rem_minutes';
  static const String lightMinutes = 'light_minutes';
  static const String totalMinutes = 'total_minutes';
  SleepKey._();
}

class StrainKey {
  static const String daily = 'daily';
  static const String stepsYesterday = 'steps_yesterday';
  static const String steps7dAvg = 'steps_7d_avg';
  StrainKey._();
}

class AiKey {
  static const String insightTitle = 'insight_title';
  static const String insightText = 'insight_text';
  AiKey._();
}

class FeedbackKey {
  /// Soreness rating 1–10 (1 = no pain, 10 = extreme).
  static const String soreness = 'soreness';

  /// Perceived energy & mood 1–10 (10 = high energy, 1 = lethargic).
  static const String energy = 'energy';

  /// Stress level 1–10 (1 = relaxed, 10 = extreme stress).
  static const String stress = 'stress';

  FeedbackKey._();
}

class HydrationKey {
  static const String dailyMl = 'daily_ml';
  static const String goalPercent = 'goal_percent';
  HydrationKey._();
}

class RecoveryKey {
  static const String state = 'state';
  static const String score = 'score';
  static const String hrvTrend = 'hrv_trend';
  static const String rhrTrend = 'rhr_trend';
  static const String recommendation = 'recommendation';
  RecoveryKey._();
}

class HeartHealthKey {
  static const String restingHr = 'resting_hr';
  static const String restingHrTrend = 'resting_hr_trend';
  static const String hrvBaseline = 'hrv_baseline';
  static const String cvFitnessEstimate = 'cv_fitness_estimate';
  HeartHealthKey._();
}

class WeeklyReportKey {
  static const String avgReadiness = 'avg_readiness';
  static const String avgSleep = 'avg_sleep';
  static const String avgStrain = 'avg_strain';
  static const String totalSteps = 'total_steps';
  static const String summaryText = 'summary_text';
  WeeklyReportKey._();
}

class BodyBatteryKey {
  static const String currentLevel = 'current_level';
  static const String morningLevel = 'morning_level';
  static const String drainRate = 'drain_rate';
  BodyBatteryKey._();
}

class ActiveEnergyKey {
  static const String dailyKcal = 'daily_kcal';
  static const String weeklyAvg = 'weekly_avg';
  static const String activityLevel = 'activity_level';
  ActiveEnergyKey._();
}

class SleepDebtKey {
  static const String bankBalance = 'bank_balance';
  static const String bankScore = 'bank_score';
  static const String dailyShortfall = 'daily_shortfall';
  static const String debtSeverity = 'debt_severity';
  static const String recoveryDays = 'recovery_days';
  static const String trendDirection = 'trend_direction';
  static const String sleepGoal = 'sleep_goal';
  static const String weeklyBalanceTrend = 'weekly_balance_trend';
  static const String lastNightSurplus = 'last_night_surplus';
  static const String detailJson = 'detail_json';
  SleepDebtKey._();
}

class WorkloadBalanceKey {
  static const String ratio = 'ratio';
  static const String state = 'state';
  static const String score = 'score';
  static const String trainingAdvice = 'training_advice';
  static const String acuteLoad = 'acute_load';
  static const String chronicLoad = 'chronic_load';
  static const String recoveryLevel = 'recovery_level';
  static const String readinessLevel = 'readiness_level';
  static const String trend = 'trend';
  WorkloadBalanceKey._();
}

class ConsistencyKey {
  static const String stepsScore = 'steps_score';
  static const String energyScore = 'energy_score';
  static const String overallScore = 'overall_score';
  static const String activeDays = 'active_days';
  static const String streak = 'streak';
  static const String bestStreak = 'best_streak';
  static const String state = 'state';
  ConsistencyKey._();
}

class ChronotypeKey {
  static const String avgBedtimeHour = 'avg_bedtime_hour';
  static const String avgWaketimeHour = 'avg_waketime_hour';
  static const String midpointHour = 'midpoint_hour';
  static const String variabilityMins = 'variability_mins';
  static const String category = 'category';
  static const String categoryLabel = 'category_label';
  static const String avgDurationMins = 'avg_duration_mins';
  ChronotypeKey._();
}

class StressLoadKey {
  static const String score = 'score';
  static const String stressRatio = 'stress_ratio';
  static const String nighttimeBaseline = 'nighttime_baseline';
  static const String daytimeHrv = 'daytime_hrv';
  static const String category = 'category';
  static const String baselineTrend = 'baseline_trend';
  static const String recommendation = 'recommendation';
  StressLoadKey._();
}

class ForecastKey {
  static const String predictedReadiness = 'predicted_readiness';
  static const String predictedMental = 'predicted_mental';
  static const String trendSlope = 'trend_slope';
  static const String confidence = 'confidence';
  static const String category = 'category';
  static const String recoveryDebt = 'recovery_debt';
  static const String recommendation = 'recommendation';
  static const String mentalTrend = 'mental_trend';
  ForecastKey._();
}
