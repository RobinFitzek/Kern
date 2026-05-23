import 'dart:math';

// ---------------------------------------------------------------------------
// ReadinessAlgorithm
// ---------------------------------------------------------------------------
// Pure-Dart algorithm module — NO Flutter dependencies.
//
// Implements the bimodal readiness scoring system as specified in the
// scientific design document:
//
//   Physical Score (R_phys):
//     Weights: HRV 35%, RHR 20%, Deep Sleep 20%, TST 15%, ACWR Penalty 10%
//     Formula: Σ(w_i * Score(Z_i)) - Penalty(ACWR)
//
//   Mental Score (R_ment):
//     Weights: REM 30%, SRI 30%, HRV-CV 20%, Sleep Efficiency 20%
//     Formula: Σ(w_i * Score_i)
//
//   Bayesian Fusion:
//     R_final = w_obj * R_obj + w_subj * R_subj
//
// All individual metric scores use tanh-based sigmoid scaling:
//   Score_pos(Z) = 50 + 50 * tanh(Z)   — higher is better
//   Score_neg(Z) = 50 + 50 * tanh(-Z)  — lower is better
//
// This maps:  Z=0   → 50,  Z=+1 → 76,  Z=-1 → 24
//             Z=+2  → 90,  Z=-2 → 10
// ---------------------------------------------------------------------------

/// Holds all raw Z-scores and derived metrics needed by the algorithm.
class ReadinessInputs {
  const ReadinessInputs({
    required this.zHrv,
    required this.zRhr,
    required this.zDeep,
    required this.zTst,
    required this.zRem,
    required this.zCv,
    required this.sri,
    required this.sleepEfficiency,
    required this.acwrValue,
    this.hasHrvData = true,
    this.hasSleepData = true,
    this.sriDaysAvailable = 0,
  });

  /// Z-score of today's nightly RMSSD vs. 28-day baseline.
  final double zHrv;

  /// Z-score of tonight's resting HR vs. 28-day baseline (inverse metric).
  final double zRhr;

  /// Z-score of tonight's deep sleep duration vs. 28-day baseline.
  final double zDeep;

  /// Z-score of tonight's total sleep time (TST) vs. 28-day baseline.
  final double zTst;

  /// Z-score of tonight's REM sleep duration vs. 28-day baseline.
  final double zRem;

  /// Z-score of the 7-day HRV coefficient of variation vs. 28-day baseline.
  /// A low CV is better → this is used with scoreNeg.
  final double zCv;

  /// Sleep Regularity Index (-100 to +100). Requires ≥14 days of data.
  /// Set to null when insufficient data is available.
  final double? sri;

  /// Sleep efficiency: TST / Time-in-Bed (0.0 – 1.0).
  /// Derived from (1 - WASO_fraction).
  final double sleepEfficiency;

  /// Acute:Chronic Workload Ratio (7-day / 28-day active calories).
  final double acwrValue;

  /// False when < 7 HRV data points exist (cold start).
  final bool hasHrvData;

  /// False when < 3 days of sleep data exist.
  final bool hasSleepData;

  /// Number of days of sleep data available for SRI computation.
  final int sriDaysAvailable;
}

/// Detailed breakdown of score contributions for UI display.
class ReadinessComponents {
  const ReadinessComponents({
    required this.physObj,
    required this.mentObj,
    required this.physFinal,
    required this.mentFinal,
    required this.hrvScore,
    required this.rhrScore,
    required this.deepScore,
    required this.tstScore,
    required this.acwrPenalty,
    required this.remScore,
    required this.sriScore,
    required this.cvScore,
    required this.efficiencyScore,
    required this.acwr,
    required this.sriValue,
    required this.wObj,
    required this.isCalibrating,
  });

  final double physObj;
  final double mentObj;
  final double physFinal;
  final double mentFinal;

  // Physical sub-scores (all on 0–100 scale before weighting)
  final double hrvScore;
  final double rhrScore;
  final double deepScore;
  final double tstScore;
  final double acwrPenalty; // Already in score-penalty units (0–25)

  // Mental sub-scores
  final double remScore;
  final double sriScore;
  final double cvScore;
  final double efficiencyScore;

  // Raw values for display
  final double acwr;
  final double? sriValue;
  final double wObj;
  final bool isCalibrating;
}

// ---------------------------------------------------------------------------
// Algorithm implementation
// ---------------------------------------------------------------------------

class ReadinessAlgorithm {
  const ReadinessAlgorithm();

  // ── Core sigmoid scalers ─────────────────────────────────────────────────

  /// Maps a Z-score to [0, 100] where higher Z → higher score.
  /// Score_pos(Z) = 50 + 50 × tanh(Z)
  double scorePos(double z) => 50.0 + 50.0 * _tanh(z);

  /// Maps a Z-score to [0, 100] where lower raw value → higher score.
  /// Score_neg(Z) = 50 + 50 × tanh(-Z)
  double scoreNeg(double z) => 50.0 + 50.0 * _tanh(-z);

  // ── ACWR Penalty ─────────────────────────────────────────────────────────

  /// Computes the ACWR training load penalty subtracted from R_phys.
  ///
  /// "Sweet Spot": 0.8 – 1.3 → no penalty
  /// >1.3: exponential penalty, maximum 25 points at ACWR ≥ 2.0
  double acwrPenalty(double acwr) {
    if (acwr <= 1.3) return 0.0;
    // Exponential growth: penalty = 25 × (1 - e^(-(acwr-1.3) × 2.5))
    final excess = acwr - 1.3;
    return (25.0 * (1.0 - exp(-excess * 2.5))).clamp(0.0, 25.0);
  }

  // ── Sleep Regularity Index ───────────────────────────────────────────────

  /// Computes the Sleep Regularity Index (SRI) from a list of sleep intervals.
  ///
  /// Uses minute-epoch resolution as per Phillips et al. (2017):
  ///   SRI = -100 + 200 × (1/N-1 Σ δ(s_i, s_{i+24h}))
  ///
  /// Returns null when fewer than [minDays] of data are available.
  double? computeSri(
    List<SleepInterval> sleepIntervals, {
    int minDays = 14,
  }) {
    if (sleepIntervals.isEmpty) return null;

    // Determine overall date range
    final earliest = sleepIntervals.fold(
      sleepIntervals.first.start,
      (min, s) => s.start.isBefore(min) ? s.start : min,
    );
    final latest = sleepIntervals.fold(
      sleepIntervals.first.end,
      (max, s) => s.end.isAfter(max) ? s.end : max,
    );

    final totalDays = latest.difference(earliest).inDays;
    if (totalDays < minDays) return null;

    // Build minute-epoch bitmap for the full range
    // 1 = sleeping, 0 = awake
    final totalMinutes = latest.difference(earliest).inMinutes;
    if (totalMinutes <= 0) return null;

    final bitmap = List<bool>.filled(totalMinutes, false);
    for (final interval in sleepIntervals) {
      final startOffset = interval.start.difference(earliest).inMinutes;
      final endOffset = interval.end.difference(earliest).inMinutes;
      for (var m = startOffset.clamp(0, totalMinutes - 1);
          m < endOffset.clamp(0, totalMinutes);
          m++) {
        bitmap[m] = true;
      }
    }

    // Count matching epochs at 24h offset
    const epochsPerDay = 1440; // 24 × 60
    int matches = 0;
    int comparisons = 0;

    for (var i = 0; i < totalMinutes - epochsPerDay; i++) {
      if (bitmap[i] == bitmap[i + epochsPerDay]) matches++;
      comparisons++;
    }

    if (comparisons == 0) return null;
    return -100.0 + 200.0 * (matches / comparisons);
  }

  // ── Z-Score Computation ──────────────────────────────────────────────────

  /// Computes the Z-score of [today] against a [baseline] list of historical values.
  /// Returns 0.0 when insufficient data prevents meaningful normalization.
  double zScore(double today, List<double> baseline) {
    if (baseline.isEmpty) return 0.0;
    final mu = _mean(baseline);
    final sigma = _stddev(baseline, mu);
    if (sigma < 1e-6) return 0.0; // avoid div-by-zero when all values are equal
    return (today - mu) / sigma;
  }

  /// Computes the Coefficient of Variation (σ/μ) of recent HRV values.
  /// Returns 0.0 on empty input.
  double coefficientOfVariation(List<double> values) {
    if (values.isEmpty) return 0.0;
    final mu = _mean(values);
    if (mu < 1e-6) return 0.0;
    return _stddev(values, mu) / mu;
  }

  // ── Physical Score ───────────────────────────────────────────────────────

  /// Computes the objective Physical Readiness Score (0–100).
  ///
  ///   R_phys = 0.35 * Score_pos(Z_hrv)
  ///           + 0.20 * Score_neg(Z_rhr)
  ///           + 0.20 * Score_pos(Z_deep)
  ///           + 0.15 * Score_pos(Z_tst)
  ///           - Penalty(ACWR)
  ///
  /// When HRV data is unavailable, its weight is redistributed to sleep/TST.
  double physicalScoreObjective(ReadinessInputs inputs) {
    double sum = 0.0;
    double totalWeight = 0.0;

    if (inputs.hasHrvData) {
      sum += 0.35 * scorePos(inputs.zHrv);
      totalWeight += 0.35;
    }

    // RHR always available if sleep data is present
    if (inputs.hasSleepData) {
      final rhrW = inputs.hasHrvData ? 0.20 : 0.30;
      sum += rhrW * scoreNeg(inputs.zRhr);
      totalWeight += rhrW;

      final deepW = inputs.hasHrvData ? 0.20 : 0.35;
      sum += deepW * scorePos(inputs.zDeep);
      totalWeight += deepW;

      final tstW = inputs.hasHrvData ? 0.15 : 0.25;
      sum += tstW * scorePos(inputs.zTst);
      totalWeight += tstW;
    }

    // Normalize to [0, 100] range before penalty
    final normalizedScore = totalWeight > 0 ? sum / totalWeight : 50.0;
    final penalty = acwrPenalty(inputs.acwrValue);
    return (normalizedScore - penalty).clamp(0.0, 100.0);
  }

  // ── Mental Score ─────────────────────────────────────────────────────────

  /// Computes the objective Mental/Cognitive Readiness Score (0–100).
  ///
  ///   R_ment = 0.30 * Score_pos(Z_rem)
  ///           + 0.30 * Scale_SRI
  ///           + 0.20 * Score_neg(Z_cv)   [low CV = stable = good]
  ///           + 0.20 * Efficiency_score
  ///
  /// SRI requires ≥14 days. When unavailable, its weight shifts to REM.
  double mentalScoreObjective(ReadinessInputs inputs) {
    double sum = 0.0;
    double totalWeight = 0.0;

    if (inputs.hasSleepData) {
      // REM — primary cognitive restoration indicator
      final remW = inputs.sri != null ? 0.30 : 0.50;
      sum += remW * scorePos(inputs.zRem);
      totalWeight += remW;

      // SRI — circadian regularity (requires ≥14 days)
      if (inputs.sri != null) {
        // Linear scale: SRI -100..+100 → 0..100
        final sriScore = (inputs.sri! + 100.0) / 2.0;
        sum += 0.30 * sriScore;
        totalWeight += 0.30;
      }

      // HRV Coefficient of Variation — autonomic stability
      final cvW = inputs.hasHrvData ? 0.20 : 0.0;
      if (inputs.hasHrvData) {
        sum += cvW * scoreNeg(inputs.zCv);
        totalWeight += cvW;
      }

      // Sleep Efficiency (WASO proxy) — 0.0 to 1.0 → 0 to 100
      final efficiencyScore = (inputs.sleepEfficiency * 100.0).clamp(0.0, 100.0);
      final effW = inputs.hasHrvData ? 0.20 : 0.50;
      sum += effW * efficiencyScore;
      totalWeight += effW;
    }

    return totalWeight > 0
        ? (sum / totalWeight).clamp(0.0, 100.0)
        : 50.0; // neutral when no data
  }

  // ── Bayesian Fusion ──────────────────────────────────────────────────────

  /// Fuses the objective sensor-derived scores with subjective morning check-in
  /// data using a weighted Bayesian approach.
  ///
  ///   R_phys_final = w_obj * R_phys_obj + w_subj * (100 - soreness*10)
  ///   R_ment_final = w_obj * R_ment_obj + w_subj * (energy*10 + (100-stress*10)) / 2
  ///
  /// [wObj] must be in [0.0, 1.0]. wSubj = 1 - wObj.
  /// When no feedback is available, pass wObj = 1.0 (full objective mode).
  ({double physFinal, double mentFinal}) bayesianFusion({
    required double physObj,
    required double mentObj,
    required double wObj,
    double? soreness, // 1–10
    double? energy, // 1–10
    double? stress, // 1–10
  }) {
    // No feedback → pure objective mode
    if (soreness == null || energy == null || stress == null || wObj >= 1.0) {
      return (physFinal: physObj, mentFinal: mentObj);
    }

    final wSubj = 1.0 - wObj;

    // Subjective physical: inverse of soreness (1=fresh=100, 10=exhausted=0)
    final sornessScore = ((10.0 - soreness) / 9.0 * 100.0).clamp(0.0, 100.0);
    final physSubj = sornessScore;

    // Subjective mental: average of normalized energy and inverted stress
    final energyScore = ((energy - 1.0) / 9.0 * 100.0).clamp(0.0, 100.0);
    final stressScore = ((10.0 - stress) / 9.0 * 100.0).clamp(0.0, 100.0);
    final mentSubj = (energyScore + stressScore) / 2.0;

    return (
      physFinal: (wObj * physObj + wSubj * physSubj).clamp(0.0, 100.0),
      mentFinal: (wObj * mentObj + wSubj * mentSubj).clamp(0.0, 100.0),
    );
  }

  // ── Full computation ─────────────────────────────────────────────────────

  /// Full end-to-end readiness computation.
  ReadinessComponents compute({
    required ReadinessInputs inputs,
    double? soreness,
    double? energy,
    double? stress,
    double wObj = 0.8,
  }) {
    final physObj = physicalScoreObjective(inputs);
    final mentObj = mentalScoreObjective(inputs);

    final fused = bayesianFusion(
      physObj: physObj,
      mentObj: mentObj,
      wObj: wObj,
      soreness: soreness,
      energy: energy,
      stress: stress,
    );

    // Compute sub-scores for UI display
    final hrvScore = inputs.hasHrvData ? scorePos(inputs.zHrv) : 50.0;
    final rhrScore = inputs.hasSleepData ? scoreNeg(inputs.zRhr) : 50.0;
    final deepScore = inputs.hasSleepData ? scorePos(inputs.zDeep) : 50.0;
    final tstScore = inputs.hasSleepData ? scorePos(inputs.zTst) : 50.0;
    final remScore = inputs.hasSleepData ? scorePos(inputs.zRem) : 50.0;
    final cvScore = inputs.hasHrvData ? scoreNeg(inputs.zCv) : 50.0;
    final sriScore = inputs.sri != null ? (inputs.sri! + 100.0) / 2.0 : 50.0;
    final efficiencyScore = (inputs.sleepEfficiency * 100.0).clamp(0.0, 100.0);
    final penalty = acwrPenalty(inputs.acwrValue);

    return ReadinessComponents(
      physObj: physObj,
      mentObj: mentObj,
      physFinal: fused.physFinal,
      mentFinal: fused.mentFinal,
      hrvScore: hrvScore,
      rhrScore: rhrScore,
      deepScore: deepScore,
      tstScore: tstScore,
      acwrPenalty: penalty,
      remScore: remScore,
      sriScore: sriScore,
      cvScore: cvScore,
      efficiencyScore: efficiencyScore,
      acwr: inputs.acwrValue,
      sriValue: inputs.sri,
      wObj: wObj,
      isCalibrating: !inputs.hasHrvData || !inputs.hasSleepData,
    );
  }

  // ── Private math helpers ─────────────────────────────────────────────────

  double _mean(List<double> values) =>
      values.isEmpty ? 0.0 : values.reduce((a, b) => a + b) / values.length;

  double _stddev(List<double> values, double mu) {
    if (values.length < 2) return 0.0;
    final variance =
        values.map((v) => (v - mu) * (v - mu)).reduce((a, b) => a + b) /
            (values.length - 1);
    return sqrt(variance);
  }

  // tanh — dart:math does not export hyperbolic functions; manual impl is stable
  // for the Z-score range (±3 typically, safe up to ±20).
  double _tanh(double x) => (exp(x) - exp(-x)) / (exp(x) + exp(-x));
}

// ---------------------------------------------------------------------------
// Support types
// ---------------------------------------------------------------------------

/// A sleep interval with start and end timestamps.
/// Used for SRI computation.
class SleepInterval {
  const SleepInterval({required this.start, required this.end});
  final DateTime start;
  final DateTime end;
}

/// Aggregated sleep data for a single night.
class NightSleepData {
  const NightSleepData({
    required this.date,
    required this.deepMins,
    required this.remMins,
    required this.lightMins,
    required this.timeInBedMins,
    required this.sessionStart,
    required this.sessionEnd,
    required this.avgHrv,
    required this.avgRhr,
  });

  final String date; // 'yyyy-MM-dd'
  final double deepMins;
  final double remMins;
  final double lightMins;
  final double timeInBedMins;
  final DateTime sessionStart;
  final DateTime sessionEnd;
  final double? avgHrv; // null when unavailable
  final double? avgRhr;

  double get totalSleepMins => deepMins + remMins + lightMins;
  double get efficiency =>
      timeInBedMins > 0 ? totalSleepMins / timeInBedMins : 0.0;
}
