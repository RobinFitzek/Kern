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
