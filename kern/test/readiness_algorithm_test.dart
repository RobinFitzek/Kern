import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:kern/plugins/readiness/readiness_algorithm.dart';

void main() {
  // ---------------------------------------------------------------------------
  // scorePos / scoreNeg — sigmoid scaling
  // ---------------------------------------------------------------------------

  group('scorePos', () {
    final algo = const ReadinessAlgorithm();

    test('Z=0 maps to 50 (neutral)', () {
      expect(algo.scorePos(0.0), closeTo(50.0, 0.01));
    });

    test('Z=1 maps to ~88', () {
      expect(algo.scorePos(1.0), closeTo(88.08, 0.01));
    });

    test('Z=2 maps to ~98', () {
      expect(algo.scorePos(2.0), closeTo(98.20, 0.01));
    });

    test('Z=-1 maps to ~12', () {
      expect(algo.scorePos(-1.0), closeTo(11.92, 0.01));
    });

    test('Z=-2 maps to ~2', () {
      expect(algo.scorePos(-2.0), closeTo(1.80, 0.01));
    });

    test('Z=3 maps to ~99.75', () {
      expect(algo.scorePos(3.0), closeTo(99.75, 0.01));
    });

    test('Z=5 asymptotes to ~100', () {
      expect(algo.scorePos(5.0), greaterThan(99.9));
      expect(algo.scorePos(5.0), lessThan(100.01));
    });

    test('Z=-5 asymptotes to ~0', () {
      expect(algo.scorePos(-5.0), greaterThan(-0.01));
      expect(algo.scorePos(-5.0), lessThan(0.1));
    });
  });

  group('scoreNeg', () {
    final algo = const ReadinessAlgorithm();

    test('Z=0 maps to 50', () {
      expect(algo.scoreNeg(0.0), closeTo(50.0, 0.01));
    });

    test('lower raw value = higher score (Z=-1 → ~88)', () {
      expect(algo.scoreNeg(-1.0), closeTo(88.08, 0.01));
    });

    test('higher raw value = lower score (Z=1 → ~12)', () {
      expect(algo.scoreNeg(1.0), closeTo(11.92, 0.01));
    });
  });

  // ---------------------------------------------------------------------------
  // ACWR Penalty
  // ---------------------------------------------------------------------------

  group('acwrPenalty', () {
    final algo = const ReadinessAlgorithm();

    test('sweet spot 0.8–1.3: no penalty', () {
      expect(algo.acwrPenalty(0.8), 0.0);
      expect(algo.acwrPenalty(1.0), 0.0);
      expect(algo.acwrPenalty(1.3), 0.0);
    });

    test('ACWR 1.5: moderate penalty', () {
      expect(algo.acwrPenalty(1.5), closeTo(9.84, 0.1));
    });

    test('ACWR 2.0: max penalty (25)', () {
      expect(algo.acwrPenalty(2.0), closeTo(20.65, 0.1));
    });

    test('ACWR 3.0+: capped at 25', () {
      expect(algo.acwrPenalty(3.0), lessThan(25.01));
      expect(algo.acwrPenalty(5.0), lessThan(25.01));
    });

    test('ACWR 0.0: no penalty', () {
      expect(algo.acwrPenalty(0.0), 0.0);
    });
  });

  // ---------------------------------------------------------------------------
  // Z-Score
  // ---------------------------------------------------------------------------

  group('zScore', () {
    final algo = const ReadinessAlgorithm();

    test('normal baseline: Z≈0 when today=mean', () {
      final baseline = [40.0, 50.0, 60.0];
      final z = algo.zScore(50.0, baseline);
      expect(z, closeTo(0.0, 0.01));
    });

    test('today above mean: positive Z', () {
      final baseline = [40.0, 50.0, 60.0];
      final z = algo.zScore(70.0, baseline);
      expect(z, greaterThan(0.0));
    });

    test('today below mean: negative Z', () {
      final baseline = [40.0, 50.0, 60.0];
      final z = algo.zScore(30.0, baseline);
      expect(z, lessThan(0.0));
    });

    test('empty baseline → Z=0', () {
      expect(algo.zScore(50.0, []), 0.0);
    });

    test('single-value baseline (sigma=0) → Z=0', () {
      expect(algo.zScore(60.0, [50.0]), 0.0);
    });

    test('all-equal baseline (sigma≈0) → Z=0', () {
      expect(algo.zScore(60.0, [50.0, 50.0, 50.0]), 0.0);
    });

    test('Z-scores are symmetric', () {
      final baseline = [30.0, 40.0, 50.0, 60.0, 70.0];
      final zPlus = algo.zScore(60.0, baseline);
      final zMinus = algo.zScore(40.0, baseline);
      expect(zPlus, closeTo(-zMinus, 0.01));
    });

    test('extreme outlier gives large Z', () {
      final baseline = List.generate(100, (_) => 50.0 + Random().nextDouble() * 10);
      final z = algo.zScore(150.0, baseline);
      expect(z.abs(), greaterThan(5.0));
    });
  });

  // ---------------------------------------------------------------------------
  // Coefficient of Variation
  // ---------------------------------------------------------------------------

  group('coefficientOfVariation', () {
    final algo = const ReadinessAlgorithm();

    test('empty → 0', () {
      expect(algo.coefficientOfVariation([]), 0.0);
    });

    test('mean zero → 0', () {
      expect(algo.coefficientOfVariation([0.0, 0.0]), 0.0);
    });

    test('normal data', () {
      final cv = algo.coefficientOfVariation([45.0, 50.0, 55.0]);
      expect(cv, closeTo(0.1, 0.01));
    });

    test('all equal → 0', () {
      expect(algo.coefficientOfVariation([50.0, 50.0, 50.0]), 0.0);
    });
  });

  // ---------------------------------------------------------------------------
  // Sleep Regularity Index
  // ---------------------------------------------------------------------------

  group('computeSri', () {
    final algo = const ReadinessAlgorithm();

    test('insufficient days → null', () {
      final intervals = _makeRegularIntervals(days: 5, sleepHours: 23, wakeHours: 7);
      expect(algo.computeSri(intervals, minDays: 14), isNull);
    });

    test('empty → null', () {
      expect(algo.computeSri([]), isNull);
    });

    test('perfect regularity → SRI=100', () {
      final intervals = _makeRegularIntervals(days: 16, sleepHours: 23, wakeHours: 7);
      final sri = algo.computeSri(intervals);
      expect(sri, isNotNull);
      expect(sri!, closeTo(100.0, 5.0));
    });

    test('random sleep times → SRI low', () {
      final rng = Random(42);
      final now = DateTime(2026, 5, 1);
      final intervals = <SleepInterval>[];
      for (var d = 0; d < 30; d++) {
        final day = now.subtract(Duration(hours: 24 * d));
        final offset = rng.nextInt(4) - 2; // ±2 hours
        final start = day.subtract(Duration(hours: 23 + offset));
        final end = day.subtract(Duration(hours: 7 + offset));
        intervals.add(SleepInterval(start: start, end: end));
      }
      final sri = algo.computeSri(intervals);
      expect(sri, isNotNull);
      expect(sri!, lessThan(85.0));
    });
  });

  // ---------------------------------------------------------------------------
  // Physical Score — objective
  // ---------------------------------------------------------------------------

  group('physicalScoreObjective', () {
    final algo = const ReadinessAlgorithm();

    test('all data present, neutral Z-scores → ~50', () {
      final inputs = ReadinessInputs(
        zHrv: 0.0,
        zRhr: 0.0,
        zDeep: 0.0,
        zTst: 0.0,
        zRem: 0.0,
        zCv: 0.0,
        sri: 0.0,
        sleepEfficiency: 0.85,
        acwrValue: 1.0,
        hasHrvData: true,
        hasSleepData: true,
        sriDaysAvailable: 14,
      );
      final score = algo.physicalScoreObjective(inputs);
      expect(score, closeTo(50.0, 5.0));
    });

    test('excellent metrics → high score', () {
      final inputs = ReadinessInputs(
        zHrv: 2.0,
        zRhr: -2.0,
        zDeep: 2.0,
        zTst: 2.0,
        zRem: 2.0,
        zCv: -2.0,
        sri: 80.0,
        sleepEfficiency: 0.95,
        acwrValue: 1.0,
        hasHrvData: true,
        hasSleepData: true,
        sriDaysAvailable: 14,
      );
      final score = algo.physicalScoreObjective(inputs);
      expect(score, greaterThan(85.0));
    });

    test('poor metrics → low score', () {
      final inputs = ReadinessInputs(
        zHrv: -2.0,
        zRhr: 2.0,
        zDeep: -2.0,
        zTst: -2.0,
        zRem: -2.0,
        zCv: 2.0,
        sri: -50.0,
        sleepEfficiency: 0.55,
        acwrValue: 1.0,
        hasHrvData: true,
        hasSleepData: true,
        sriDaysAvailable: 14,
      );
      final score = algo.physicalScoreObjective(inputs);
      expect(score, lessThan(30.0));
    });

    test('missing HRV data: weighs sleep+TST more', () {
      final inputs = ReadinessInputs(
        zHrv: 0.0,
        zRhr: 0.0,
        zDeep: 0.0,
        zTst: 0.0,
        zRem: 0.0,
        zCv: 0.0,
        sri: 0.0,
        sleepEfficiency: 0.85,
        acwrValue: 1.0,
        hasHrvData: false,
        hasSleepData: true,
        sriDaysAvailable: 14,
      );
      final score = algo.physicalScoreObjective(inputs);
      expect(score, closeTo(50.0, 10.0));
    });

    test('missing both HRV and sleep: returns 50', () {
      final inputs = ReadinessInputs(
        zHrv: 0.0,
        zRhr: 0.0,
        zDeep: 0.0,
        zTst: 0.0,
        zRem: 0.0,
        zCv: 0.0,
        sri: 0.0,
        sleepEfficiency: 0.85,
        acwrValue: 1.0,
        hasHrvData: false,
        hasSleepData: false,
        sriDaysAvailable: 0,
      );
      final score = algo.physicalScoreObjective(inputs);
      expect(score, 50.0);
    });

    test('high ACWR penalty reduces score', () {
      final inputsGood = ReadinessInputs(
        zHrv: 2.0, zRhr: -2.0, zDeep: 2.0, zTst: 2.0,
        zRem: 2.0, zCv: -2.0, sri: 80.0, sleepEfficiency: 0.95,
        acwrValue: 1.0,
        hasHrvData: true, hasSleepData: true, sriDaysAvailable: 14,
      );
      final inputsStrained = ReadinessInputs(
        zHrv: 2.0, zRhr: -2.0, zDeep: 2.0, zTst: 2.0,
        zRem: 2.0, zCv: -2.0, sri: 80.0, sleepEfficiency: 0.95,
        acwrValue: 2.5,
        hasHrvData: true, hasSleepData: true, sriDaysAvailable: 14,
      );
      final goodScore = algo.physicalScoreObjective(inputsGood);
      final strainedScore = algo.physicalScoreObjective(inputsStrained);
      expect(strainedScore, lessThan(goodScore));
    });
  });

  // ---------------------------------------------------------------------------
  // Mental Score — objective
  // ---------------------------------------------------------------------------

  group('mentalScoreObjective', () {
    final algo = const ReadinessAlgorithm();

    test('all data present, neutral Z-scores → ~50', () {
      final inputs = ReadinessInputs(
        zHrv: 0.0, zRhr: 0.0, zDeep: 0.0, zTst: 0.0,
        zRem: 0.0, zCv: 0.0, sri: 0.0, sleepEfficiency: 0.85,
        acwrValue: 1.0,
        hasHrvData: true, hasSleepData: true, sriDaysAvailable: 14,
      );
      final score = algo.mentalScoreObjective(inputs);
      expect(score, closeTo(50.0, 8.0));
    });

    test('excellent REM + high SRI + good CV → high mental score', () {
      final inputs = ReadinessInputs(
        zHrv: 2.0, zRhr: -2.0, zDeep: 2.0, zTst: 2.0,
        zRem: 2.0, zCv: -2.0, sri: 90.0, sleepEfficiency: 0.95,
        acwrValue: 1.0,
        hasHrvData: true, hasSleepData: true, sriDaysAvailable: 14,
      );
      final score = algo.mentalScoreObjective(inputs);
      expect(score, greaterThan(85.0));
    });

    test('missing SRI: REM weight increases', () {
      final inputs = ReadinessInputs(
        zHrv: 1.0, zRhr: -1.0, zDeep: 1.0, zTst: 1.0,
        zRem: 2.0, zCv: -1.0, sri: null, sleepEfficiency: 0.9,
        acwrValue: 1.0,
        hasHrvData: true, hasSleepData: true, sriDaysAvailable: 7,
      );
      final score = algo.mentalScoreObjective(inputs);
      expect(score, greaterThan(60.0));
    });

    test('missing HRV: CV weight shifts to efficiency', () {
      final inputs = ReadinessInputs(
        zHrv: 0.0, zRhr: 0.0, zDeep: 0.0, zTst: 0.0,
        zRem: 0.0, zCv: 0.0, sri: 0.0, sleepEfficiency: 0.95,
        acwrValue: 1.0,
        hasHrvData: false, hasSleepData: true, sriDaysAvailable: 14,
      );
      final score = algo.mentalScoreObjective(inputs);
      expect(score, greaterThan(60.0));
    });

    test('missing all data → 50', () {
      final inputs = ReadinessInputs(
        zHrv: 0.0, zRhr: 0.0, zDeep: 0.0, zTst: 0.0,
        zRem: 0.0, zCv: 0.0, sri: null, sleepEfficiency: 0.0,
        acwrValue: 1.0,
        hasHrvData: false, hasSleepData: false, sriDaysAvailable: 0,
      );
      final score = algo.mentalScoreObjective(inputs);
      expect(score, 50.0);
    });
  });

  // ---------------------------------------------------------------------------
  // Bayesian Fusion
  // ---------------------------------------------------------------------------

  group('bayesianFusion', () {
    final algo = const ReadinessAlgorithm();

    test('no feedback → pure objective', () {
      final result = algo.bayesianFusion(
        physObj: 80.0,
        mentObj: 70.0,
        wObj: 0.8,
      );
      expect(result.physFinal, 80.0);
      expect(result.mentFinal, 70.0);
    });

    test('wObj=1.0 → pure objective even with feedback', () {
      final result = algo.bayesianFusion(
        physObj: 80.0,
        mentObj: 70.0,
        wObj: 1.0,
        soreness: 5.0,
        energy: 5.0,
        stress: 5.0,
      );
      expect(result.physFinal, 80.0);
      expect(result.mentFinal, 70.0);
    });

    test('full subjective (wObj=0) → follows feedback', () {
      final result = algo.bayesianFusion(
        physObj: 50.0,
        mentObj: 50.0,
        wObj: 0.0,
        soreness: 1.0, // no pain → high physical
        energy: 10.0, // high energy → high mental
        stress: 1.0, // low stress → high mental
      );
      // soreness=1 → (10-1)/9 * 100 = 100
      expect(result.physFinal, closeTo(100.0, 1.0));
      // energy=10 → (10-1)/9 * 100 = 100, stress=1 → (10-1)/9 * 100 = 100, avg = 100
      expect(result.mentFinal, closeTo(100.0, 1.0));
    });

    test('extreme bad feedback pulls score down', () {
      final result = algo.bayesianFusion(
        physObj: 80.0,
        mentObj: 80.0,
        wObj: 0.5,
        soreness: 10.0, // extreme pain
        energy: 1.0, // no energy
        stress: 10.0, // extreme stress
      );
      expect(result.physFinal, lessThan(80.0));
      expect(result.mentFinal, lessThan(80.0));
    });

    test('soreness=5.5, energy=5.5, stress=5.5 → neutral feedback, score moves toward 50', () {
      final result = algo.bayesianFusion(
        physObj: 70.0,
        mentObj: 70.0,
        wObj: 0.8,
        soreness: 5.5,
        energy: 5.5,
        stress: 5.5,
      );
      // physFinal = 0.8*70 + 0.2*50 = 66
      expect(result.physFinal, closeTo(66.0, 1.0));
      expect(result.mentFinal, closeTo(66.0, 1.0));
    });
  });

  // ---------------------------------------------------------------------------
  // Full compute() integration
  // ---------------------------------------------------------------------------

  group('compute', () {
    final algo = const ReadinessAlgorithm();

    test('normal case: both scores computed, not calibrating', () {
      final inputs = ReadinessInputs(
        zHrv: 1.0, zRhr: -1.0, zDeep: 1.0, zTst: 1.0,
        zRem: 1.0, zCv: -1.0, sri: 50.0, sleepEfficiency: 0.9,
        acwrValue: 1.0,
        hasHrvData: true, hasSleepData: true, sriDaysAvailable: 14,
      );
      final result = algo.compute(inputs: inputs);
      expect(result.physFinal, greaterThan(0.0));
      expect(result.physFinal, lessThan(100.01));
      expect(result.mentFinal, greaterThan(0.0));
      expect(result.mentFinal, lessThan(100.01));
      expect(result.isCalibrating, false);
    });

    test('calibrating when missing HRV or sleep', () {
      final inputsNoHrv = ReadinessInputs(
        zHrv: 0.0, zRhr: 0.0, zDeep: 0.0, zTst: 0.0,
        zRem: 0.0, zCv: 0.0, sri: null, sleepEfficiency: 0.0,
        acwrValue: 1.0,
        hasHrvData: false, hasSleepData: true, sriDaysAvailable: 0,
      );
      final result1 = algo.compute(inputs: inputsNoHrv);
      expect(result1.isCalibrating, true);

      final inputsNoSleep = ReadinessInputs(
        zHrv: 0.0, zRhr: 0.0, zDeep: 0.0, zTst: 0.0,
        zRem: 0.0, zCv: 0.0, sri: null, sleepEfficiency: 0.0,
        acwrValue: 1.0,
        hasHrvData: true, hasSleepData: false, sriDaysAvailable: 0,
      );
      final result2 = algo.compute(inputs: inputsNoSleep);
      expect(result2.isCalibrating, true);
    });

    test('with feedback: fused scores differ from objective', () {
      final inputs = ReadinessInputs(
        zHrv: 1.0, zRhr: -1.0, zDeep: 1.0, zTst: 1.0,
        zRem: 1.0, zCv: -1.0, sri: 50.0, sleepEfficiency: 0.9,
        acwrValue: 1.0,
        hasHrvData: true, hasSleepData: true, sriDaysAvailable: 14,
      );
      final withoutFeedback = algo.compute(inputs: inputs);
      final withFeedback = algo.compute(
        inputs: inputs,
        soreness: 9.0, // very sore
        energy: 2.0, // low energy
        stress: 8.0, // high stress
        wObj: 0.5,
      );
      expect(withFeedback.physFinal, lessThan(withoutFeedback.physFinal));
      expect(withFeedback.mentFinal, lessThan(withoutFeedback.mentFinal));
    });

    test('all sub-scores present in result', () {
      final inputs = ReadinessInputs(
        zHrv: 1.0, zRhr: -1.0, zDeep: 1.0, zTst: 1.0,
        zRem: 1.0, zCv: -1.0, sri: 50.0, sleepEfficiency: 0.9,
        acwrValue: 1.0,
        hasHrvData: true, hasSleepData: true, sriDaysAvailable: 14,
      );
      final result = algo.compute(inputs: inputs);
      expect(result.hrvScore, isNot(0.0));
      expect(result.rhrScore, isNot(0.0));
      expect(result.deepScore, isNot(0.0));
      expect(result.tstScore, isNot(0.0));
      expect(result.remScore, isNot(0.0));
      expect(result.sriScore, isNot(0.0));
      expect(result.cvScore, isNot(0.0));
      expect(result.efficiencyScore, isNot(0.0));
      expect(result.acwrPenalty, isNonNegative);
      expect(result.wObj, 0.8);
    });

    test('score is clamped to [0, 100] range', () {
      final inputs = ReadinessInputs(
        zHrv: 10.0, zRhr: -10.0, zDeep: 10.0, zTst: 10.0,
        zRem: 10.0, zCv: -10.0, sri: 100.0, sleepEfficiency: 1.0,
        acwrValue: 1.0,
        hasHrvData: true, hasSleepData: true, sriDaysAvailable: 14,
      );
      final result = algo.compute(inputs: inputs);
      expect(result.physFinal, lessThanOrEqualTo(100.0));
      expect(result.physFinal, greaterThanOrEqualTo(0.0));
      expect(result.mentFinal, lessThanOrEqualTo(100.0));
      expect(result.mentFinal, greaterThanOrEqualTo(0.0));
    });
  });

  // ---------------------------------------------------------------------------
  // Support types
  // ---------------------------------------------------------------------------

  group('NightSleepData', () {
    test('totalSleepMins sums stages', () {
      final night = NightSleepData(
        date: '2026-05-01',
        deepMins: 60.0,
        remMins: 90.0,
        lightMins: 240.0,
        timeInBedMins: 480.0,
        sessionStart: DateTime(2026, 5, 1, 23),
        sessionEnd: DateTime(2026, 5, 2, 7),
        avgHrv: 55.0,
        avgRhr: 58.0,
      );
      expect(night.totalSleepMins, 390.0);
    });

    test('efficiency = totalSleepMins / timeInBedMins', () {
      final night = NightSleepData(
        date: '2026-05-01',
        deepMins: 60.0,
        remMins: 90.0,
        lightMins: 240.0,
        timeInBedMins: 480.0,
        sessionStart: DateTime(2026, 5, 1, 23),
        sessionEnd: DateTime(2026, 5, 2, 7),
        avgHrv: 55.0,
        avgRhr: 58.0,
      );
      expect(night.efficiency, closeTo(0.8125, 0.01));
    });

    test('efficiency=0 when timeInBed=0', () {
      final night = NightSleepData(
        date: '2026-05-01',
        deepMins: 0.0,
        remMins: 0.0,
        lightMins: 0.0,
        timeInBedMins: 0.0,
        sessionStart: DateTime(2026, 5, 1, 23),
        sessionEnd: DateTime(2026, 5, 2, 7),
        avgHrv: null,
        avgRhr: null,
      );
      expect(night.efficiency, 0.0);
    });
  });
}

// ---------------------------------------------------------------------------
// Helper: generate regular sleep intervals for SRI testing
// ---------------------------------------------------------------------------

List<SleepInterval> _makeRegularIntervals({
  required int days,
  required int sleepHours,
  required int wakeHours,
}) {
  final now = DateTime(2026, 5, 20);
  final intervals = <SleepInterval>[];
  for (var d = 0; d < days; d++) {
    final day = now.subtract(Duration(hours: 24 * d));
    final start = day.subtract(Duration(hours: sleepHours));
    final end = day.subtract(Duration(hours: wakeHours));
    intervals.add(SleepInterval(start: start, end: end));
  }
  return intervals;
}
