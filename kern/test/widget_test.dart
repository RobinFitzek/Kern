import 'package:flutter_test/flutter_test.dart';

import 'package:kern/plugins/readiness/readiness_algorithm.dart';

/// Smoke test: ensures the algorithm module loads without errors
/// and produces valid output for nominal inputs.
void main() {
  test('ReadinessAlgorithm produces valid score range', () {
    const algo = ReadinessAlgorithm();

    final inputs = ReadinessInputs(
      zHrv: 1.0,
      zRhr: -1.0,
      zDeep: 1.0,
      zTst: 1.0,
      zRem: 1.0,
      zCv: -1.0,
      sri: 50.0,
      sleepEfficiency: 0.9,
      acwrValue: 1.0,
      hasHrvData: true,
      hasSleepData: true,
      sriDaysAvailable: 14,
    );

    final result = algo.compute(inputs: inputs);

    expect(result.physFinal, greaterThanOrEqualTo(0.0));
    expect(result.physFinal, lessThanOrEqualTo(100.0));
    expect(result.mentFinal, greaterThanOrEqualTo(0.0));
    expect(result.mentFinal, lessThanOrEqualTo(100.0));
    expect(result.isCalibrating, false);
  });
}
