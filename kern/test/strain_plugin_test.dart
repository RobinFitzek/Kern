import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

/// Verifies the strain scoring formula used by StrainPlugin:
///
///   strain = min(yesterday / avg7d, 2.0) / 2.0 * 100
///
///   where:
///     yesterday = yesterday's step count
///     avg7d     = average daily steps over the preceding 7 non-zero days
///
/// These tests validate the formula independently of the database layer.

double strainScore(double yesterdaySteps, double avg7d) {
  if (avg7d == 0) {
    return yesterdaySteps > 0 ? 50.0 : 0.0;
  }
  return (min(yesterdaySteps / avg7d, 2.0) / 2.0 * 100).clamp(0.0, 100.0);
}

void main() {
  group('strainScore', () {
    test('yesterday = average → score 50', () {
      expect(strainScore(10000.0, 10000.0), closeTo(50.0, 0.01));
    });

    test('yesterday = double average → score 100', () {
      expect(strainScore(20000.0, 10000.0), closeTo(100.0, 0.01));
    });

    test('yesterday > double average → capped at 100', () {
      expect(strainScore(30000.0, 10000.0), closeTo(100.0, 0.01));
    });

    test('rest day → score 0', () {
      expect(strainScore(0.0, 10000.0), closeTo(0.0, 0.01));
    });

    test('no baseline, yesterday had steps → neutral 50', () {
      expect(strainScore(5000.0, 0.0), closeTo(50.0, 0.01));
    });

    test('no baseline, no steps → 0', () {
      expect(strainScore(0.0, 0.0), 0.0);
    });

    test('half average = score 25', () {
      expect(strainScore(5000.0, 10000.0), closeTo(25.0, 0.01));
    });

    test('1.5x average = score 75', () {
      expect(strainScore(15000.0, 10000.0), closeTo(75.0, 0.01));
    });

    test('score clamped to [0, 100]', () {
      expect(strainScore(100000.0, 10000.0), 100.0);
      expect(strainScore(0.0, 10000.0), 0.0);
    });
  });
}
