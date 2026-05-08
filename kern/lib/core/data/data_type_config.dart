import 'package:flutter/material.dart';
import '../../core/database/tables.dart';

enum TimeGranularity { day, week, month, year }
enum AggregationType { sum, average, minMaxAvg, single }
enum ChartDisplayType { line, bar }

abstract class DataTypeConfig {
  String get id; // e.g. "steps", "hrv"
  String get name; // UI name
  String get unit; // e.g. "ms", "bpm", "steps"

  // How to aggregate raw points into a single period point
  AggregationType aggregationFor(TimeGranularity g);

  // How to display the chart
  ChartDisplayType get chartType;

  // Format the value for UI
  String formatValue(double value);
  
  // Format period label for X axis
  String formatAxisLabel(DateTime date, TimeGranularity g);
}

// ---------------------------------------------------------------------------
// Implementations
// ---------------------------------------------------------------------------

class StepsConfig extends DataTypeConfig {
  @override
  String get id => RawDataType.steps;
  @override
  String get name => 'Steps';
  @override
  String get unit => 'steps';
  @override
  ChartDisplayType get chartType => ChartDisplayType.bar;

  @override
  AggregationType aggregationFor(TimeGranularity g) {
    if (g == TimeGranularity.day) return AggregationType.sum; // sum hourly points
    if (g == TimeGranularity.week) return AggregationType.sum; // sum daily points
    if (g == TimeGranularity.month) return AggregationType.sum;
    return AggregationType.sum;
  }

  @override
  String formatValue(double value) => value.toInt().toString();

  @override
  String formatAxisLabel(DateTime date, TimeGranularity g) => _defaultAxisFormat(date, g);
}

class HrvConfig extends DataTypeConfig {
  @override
  String get id => RawDataType.hrv;
  @override
  String get name => 'HRV';
  @override
  String get unit => 'ms';
  @override
  ChartDisplayType get chartType => ChartDisplayType.line;

  @override
  AggregationType aggregationFor(TimeGranularity g) => AggregationType.average;

  @override
  String formatValue(double value) => value.toStringAsFixed(0);

  @override
  String formatAxisLabel(DateTime date, TimeGranularity g) => _defaultAxisFormat(date, g);
}

class RestingHrConfig extends DataTypeConfig {
  @override
  String get id => RawDataType.restingHr;
  @override
  String get name => 'Resting HR';
  @override
  String get unit => 'bpm';
  @override
  ChartDisplayType get chartType => ChartDisplayType.line;

  @override
  AggregationType aggregationFor(TimeGranularity g) {
    if (g == TimeGranularity.day) return AggregationType.single;
    return AggregationType.average;
  }

  @override
  String formatValue(double value) => value.toStringAsFixed(0);

  @override
  String formatAxisLabel(DateTime date, TimeGranularity g) => _defaultAxisFormat(date, g);
}

class DefaultConfig extends DataTypeConfig {
  DefaultConfig(this._id);
  final String _id;

  @override
  String get id => _id;
  @override
  String get name => _id.toUpperCase();
  @override
  String get unit => '';
  @override
  ChartDisplayType get chartType => ChartDisplayType.line;

  @override
  AggregationType aggregationFor(TimeGranularity g) => AggregationType.average;

  @override
  String formatValue(double value) => value.toStringAsFixed(1);

  @override
  String formatAxisLabel(DateTime date, TimeGranularity g) => _defaultAxisFormat(date, g);
}

String _defaultAxisFormat(DateTime date, TimeGranularity g) {
  switch (g) {
    case TimeGranularity.day:
      return '${date.hour}:00';
    case TimeGranularity.week:
      final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
      return days[date.weekday - 1];
    case TimeGranularity.month:
      return '${date.day}';
    case TimeGranularity.year:
      final months = ['J', 'F', 'M', 'A', 'M', 'J', 'J', 'A', 'S', 'O', 'N', 'D'];
      return months[date.month - 1];
  }
}

// Registry
class DataTypeRegistry {
  static final Map<String, DataTypeConfig> _configs = {
    RawDataType.steps: StepsConfig(),
    RawDataType.hrv: HrvConfig(),
    RawDataType.restingHr: RestingHrConfig(),
    // Add more specific configs here
  };

  static DataTypeConfig getConfig(String id) {
    return _configs[id] ?? DefaultConfig(id);
  }
}
