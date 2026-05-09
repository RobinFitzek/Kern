import '../../core/database/app_database.dart';

class AggregatedDataPoint {
  final DateTime timestamp; // Bucket timestamp
  final double value;
  final String formattedAxisLabel;

  // Additional data for MIN_MAX_AVG or sum
  final double? min;
  final double? max;
  final int count;
  final List<RawEntry> rawEntries;

  AggregatedDataPoint({
    required this.timestamp,
    required this.value,
    required this.formattedAxisLabel,
    this.min,
    this.max,
    this.count = 1,
    this.rawEntries = const [],
  });
}
