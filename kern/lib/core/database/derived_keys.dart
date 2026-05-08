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
  DerivedNamespace._();
}

class ReadinessKey {
  static const String score = 'score';
  static const String hrvContribution = 'hrv_contribution';
  static const String sleepContribution = 'sleep_contribution';
  static const String strainContribution = 'strain_contribution';
  /// 1.0 = still calibrating (< 7 days HRV), 0.0 = ready.
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
