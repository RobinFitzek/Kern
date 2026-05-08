import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:drift/drift.dart';

import '../../core/database/tables.dart';
import '../../core/database/app_database.dart';
import '../../core/services/service_providers.dart';
import '../../plugins/raw/raw_providers.dart';
import '../../core/data/data_type_config.dart';
import 'data_explorer_state.dart';
import 'aggregated_data_point.dart';

part 'data_providers.g.dart';

@riverpod
Future<List<RawEntry>> recentRawEntries(RecentRawEntriesRef ref, {String? filterType}) async {
  final db = ref.watch(appDatabaseProvider);
  
  // Custom query to get the latest 200 entries, optionally filtered
  final query = db.select(db.rawEntries);
  
  if (filterType != null && filterType.isNotEmpty) {
    query.where((t) => t.type.equals(filterType));
  }
  
  query.orderBy([(t) => OrderingTerm.desc(t.timestamp)]);
  query.limit(200);
  
  return query.get();
}

@riverpod
Future<List<String>> availableDataTypes(AvailableDataTypesRef ref) async {
  final db = ref.watch(appDatabaseProvider);
  
  // Custom SQL to get distinct types
  final result = await db.customSelect(
    'SELECT DISTINCT type FROM raw_entries ORDER BY type ASC'
  ).get();
  
  return result.map((row) => row.read<String>('type')).toList();
}

@riverpod
Future<double?> baselineAverage(BaselineAverageRef ref, String type) async {
  final db = ref.watch(appDatabaseProvider);
  final end = DateTime.now();
  final start = end.subtract(const Duration(days: 30));

  final query = db.select(db.rawEntries)
    ..where((t) => t.type.equals(type))
    ..where((t) => t.timestamp.isBetweenValues(start, end));
    
  final entries = await query.get();
  if (entries.isEmpty) return null;
  
  // Assuming basic average for baseline regardless of config for simplicity in v1
  double sum = 0;
  for (var e in entries) {
    sum += e.value;
  }
  return sum / entries.length;
}

@riverpod
Future<List<AggregatedDataPoint>> aggregatedDataQuery(AggregatedDataQueryRef ref, String type) async {
  final db = ref.watch(appDatabaseProvider);
  final period = ref.watch(dataExplorerTimeRangeProvider);
  final config = DataTypeRegistry.getConfig(type);

  final query = db.select(db.rawEntries)
    ..where((t) => t.type.equals(type))
    ..where((t) => t.timestamp.isBetweenValues(period.start, period.end))
    ..orderBy([(t) => OrderingTerm.asc(t.timestamp)]);
    
  final rawEntries = await query.get();
  
  if (rawEntries.isEmpty) return [];

  // Group by time buckets
  final Map<int, List<RawEntry>> buckets = {};
  
  for (final entry in rawEntries) {
    final bucketTs = _getBucketStart(entry.timestamp, period.granularity);
    final key = bucketTs.millisecondsSinceEpoch;
    buckets.putIfAbsent(key, () => []).add(entry);
  }

  final aggType = config.aggregationFor(period.granularity);
  final results = <AggregatedDataPoint>[];

  final sortedKeys = buckets.keys.toList()..sort();
  for (final key in sortedKeys) {
    final entries = buckets[key]!;
    final bucketTs = DateTime.fromMillisecondsSinceEpoch(key);
    
    double value = 0;
    double? min;
    double? max;
    
    if (aggType == AggregationType.sum) {
      value = entries.fold(0.0, (sum, e) => sum + e.value);
    } else if (aggType == AggregationType.average) {
      value = entries.fold(0.0, (sum, e) => sum + e.value) / entries.length;
    } else if (aggType == AggregationType.minMaxAvg) {
      min = entries.first.value;
      max = entries.first.value;
      double sum = 0;
      for (final e in entries) {
        if (e.value < min!) min = e.value;
        if (e.value > max!) max = e.value;
        sum += e.value;
      }
      value = sum / entries.length;
    } else if (aggType == AggregationType.single) {
      value = entries.first.value; // Just take the first one
    }

    results.add(AggregatedDataPoint(
      timestamp: bucketTs,
      value: value,
      min: min,
      max: max,
      count: entries.length,
      formattedAxisLabel: config.formatAxisLabel(bucketTs, period.granularity),
    ));
  }

  return results;
}

DateTime _getBucketStart(DateTime date, TimeGranularity g) {
  switch (g) {
    case TimeGranularity.day:
      return DateTime(date.year, date.month, date.day, date.hour);
    case TimeGranularity.week:
      return DateTime(date.year, date.month, date.day);
    case TimeGranularity.month:
      // Start of week for that month view (e.g. grouped by ISO week)
      // For simplicity, just group by Day in month view
      return DateTime(date.year, date.month, date.day);
    case TimeGranularity.year:
      return DateTime(date.year, date.month, 1);
  }
}
