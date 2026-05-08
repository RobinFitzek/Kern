class AggregatedDataPoint {
  final DateTime timestamp; // Bucket timestamp
  final double value;
  final String formattedAxisLabel;

  // Additional data for MIN_MAX_AVG or sum
  final double? min;
  final double? max;
  final int count;

  AggregatedDataPoint({
    required this.timestamp,
    required this.value,
    required this.formattedAxisLabel,
    this.min,
    this.max,
    this.count = 1,
  });
}
