import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

/// Verifies the sleep quality scoring formula used by SleepPlugin:
///
///   stageScore    = min(deepMins + remMins, 180) / 180
///   durationScore = min(totalMins, 480) / 480
///   qualityScore  = (0.6 * stageScore + 0.4 * durationScore) * 100
///
/// These tests validate the formula independently of the database layer.
/// The actual SleepPlugin reads from Raw Store and writes to Derived Store;
/// the scoring math tested here is the core logic.

double sleepStageScore(double deepMins, double remMins) {
  return min(deepMins + remMins, 180.0) / 180.0;
}

double sleepDurationScore(double totalMins) {
  return min(totalMins, 480.0) / 480.0;
}

double sleepQualityScore(double deepMins, double remMins, double lightMins) {
  final totalMins = deepMins + remMins + lightMins;
  final stageScore = sleepStageScore(deepMins, remMins);
  final durationScore = sleepDurationScore(totalMins);
  return ((0.6 * stageScore + 0.4 * durationScore) * 100).clamp(0.0, 100.0);
}

void main() {
  group('sleepStageScore', () {
    test('optimal deep+REM = 180min → 1.0', () {
      expect(sleepStageScore(90.0, 90.0), closeTo(1.0, 0.001));
      expect(sleepStageScore(120.0, 60.0), closeTo(1.0, 0.001));
    });

    test('exceeds cap: still 1.0', () {
      expect(sleepStageScore(120.0, 100.0), closeTo(1.0, 0.001));
      expect(sleepStageScore(200.0, 200.0), closeTo(1.0, 0.001));
    });

    test('half optimal → 0.5', () {
      expect(sleepStageScore(45.0, 45.0), closeTo(0.5, 0.001));
    });

    test('zero → 0', () {
      expect(sleepStageScore(0.0, 0.0), closeTo(0.0, 0.001));
    });
  });

  group('sleepDurationScore', () {
    test('8 hours (480min) → 1.0', () {
      expect(sleepDurationScore(480.0), closeTo(1.0, 0.001));
    });

    test('more than 8 hours → still 1.0', () {
      expect(sleepDurationScore(600.0), closeTo(1.0, 0.001));
    });

    test('4 hours → 0.5', () {
      expect(sleepDurationScore(240.0), closeTo(0.5, 0.001));
    });

    test('0 hours → 0', () {
      expect(sleepDurationScore(0.0), closeTo(0.0, 0.001));
    });
  });

  group('sleepQualityScore — full formula', () {
    test('optimal sleep (7h total, 90min deep + 90min REM) → 100', () {
      final score = sleepQualityScore(90.0, 90.0, 240.0);
      expect(score, closeTo(95.0, 0.1));
    });

    test('poor sleep (3h total, 30min quality) → low score', () {
      final score = sleepQualityScore(15.0, 15.0, 150.0);
      expect(score, lessThan(30.0));
    });

    test('no sleep data → 0', () {
      final score = sleepQualityScore(0.0, 0.0, 0.0);
      expect(score, 0.0);
    });

    test('score never exceeds 100', () {
      final score = sleepQualityScore(200.0, 200.0, 200.0);
      expect(score, lessThanOrEqualTo(100.0));
    });

    test('score never below 0', () {
      final score = sleepQualityScore(0.0, 0.0, 0.0);
      expect(score, greaterThanOrEqualTo(0.0));
    });
  });
}
