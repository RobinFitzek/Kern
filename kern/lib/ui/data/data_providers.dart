import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:drift/drift.dart';

import '../../core/database/tables.dart';
import '../../core/database/app_database.dart';
import '../../core/services/service_providers.dart';
import '../../plugins/raw/raw_providers.dart';

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
