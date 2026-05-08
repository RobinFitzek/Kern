import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables.dart';

part 'app_database.g.dart';

// ---------------------------------------------------------------------------
// Database — two isolated stores + sync watermark state
// ---------------------------------------------------------------------------

@DriftDatabase(tables: [RawEntries, DerivedEntries, SyncStates])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          // Composite indexes for hot query paths.
          // Drift doesn't have a declarative index API yet; raw SQL is idiomatic.
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_raw_type_ts '
            'ON raw_entries(type, timestamp)',
          );
          await customStatement(
            'CREATE INDEX IF NOT EXISTS idx_derived_ns_key_date '
            'ON derived_entries(namespace, key, date)',
          );
        },
        onUpgrade: (m, from, to) async {
          if (from < 2) {
            // v1 → v2: add sourceName, sourceRecordId, timestampEnd to raw_entries;
            //           add date column to derived_entries;
            //           create sync_states table;
            //           add indexes.
            await m.addColumn(rawEntries, rawEntries.sourceName);
            await m.addColumn(rawEntries, rawEntries.sourceRecordId);
            await m.addColumn(rawEntries, rawEntries.timestampEnd);
            await m.addColumn(derivedEntries, derivedEntries.date);
            await m.createTable(syncStates);
            await customStatement(
              'CREATE INDEX IF NOT EXISTS idx_raw_type_ts '
              'ON raw_entries(type, timestamp)',
            );
            await customStatement(
              'CREATE INDEX IF NOT EXISTS idx_derived_ns_key_date '
              'ON derived_entries(namespace, key, date)',
            );
          }
        },
        // Enforce foreign-key constraints and enable WAL mode for better
        // read/write concurrency (readers don't block writers).
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
          await customStatement('PRAGMA journal_mode = WAL');
        },
      );

  // -------------------------------------------------------------------------
  // Raw Store DAOs
  // -------------------------------------------------------------------------

  /// Insert a batch of raw observations, ignoring conflicts.
  ///
  /// Uses `insertOrIgnore` so that re-syncing the same time window is safe —
  /// rows that already exist (matched by the unique constraint on
  /// type + timestamp + sourceName) are silently skipped.
  Future<void> insertRawBatch(List<RawEntriesCompanion> entries) => batch(
        (b) => b.insertAll(rawEntries, entries, mode: InsertMode.insertOrIgnore),
      );

  /// Query raw entries of a given [type] within a [since] window,
  /// optionally filtered to a specific [sourceName] (device/app).
  Future<List<RawEntry>> rawEntriesSince({
    required String type,
    required DateTime since,
    String? sourceName,
  }) {
    final q = select(rawEntries)
      ..where(
        (t) =>
            t.type.equals(type) &
            t.timestamp.isBiggerOrEqualValue(since) &
            (sourceName != null ? t.sourceName.equals(sourceName) : const CustomExpression('1')),
      )
      ..orderBy([(t) => OrderingTerm.asc(t.timestamp)]);
    return q.get();
  }

  // -------------------------------------------------------------------------
  // Derived Store DAOs
  // -------------------------------------------------------------------------

  /// Upsert a derived value — called by plugins after computing their result.
  ///
  /// The unique constraint on (namespace, key, date) ensures only one value
  /// per plugin-key per day; conflicts replace the existing row.
  Future<void> upsertDerived(DerivedEntriesCompanion entry) =>
      into(derivedEntries).insertOnConflictUpdate(entry);

  /// Read the latest derived value for a given [namespace] + [key] pair,
  /// optionally scoped to a specific [date] string (e.g. "2026-05-08").
  Future<DerivedEntry?> latestDerived({
    required String namespace,
    required String key,
    String? date,
  }) {
    final q = select(derivedEntries)
      ..where(
        (t) =>
            t.namespace.equals(namespace) &
            t.key.equals(key) &
            (date != null ? t.date.equals(date) : const CustomExpression('1')),
      )
      ..orderBy([(t) => OrderingTerm.desc(t.computedAt)])
      ..limit(1);
    return q.getSingleOrNull();
  }

  /// Read all derived entries for a [namespace], ordered newest first.
  Future<List<DerivedEntry>> derivedForNamespace(String namespace) =>
      (select(derivedEntries)
            ..where((t) => t.namespace.equals(namespace))
            ..orderBy([(t) => OrderingTerm.desc(t.computedAt)]))
          .get();

  // -------------------------------------------------------------------------
  // Sync State DAOs
  // -------------------------------------------------------------------------

  /// Returns the timestamp of the last successful sync for [dataType],
  /// or `null` if this type has never been synced (triggers full 30-day fetch).
  Future<DateTime?> lastSyncedAt(String dataType) async {
    final row = await (select(syncStates)
          ..where((t) => t.dataType.equals(dataType)))
        .getSingleOrNull();
    return row?.lastSyncedAt;
  }

  /// Advances the watermark for [dataType] to [syncedAt].
  Future<void> markSynced(String dataType, DateTime syncedAt) =>
      into(syncStates).insertOnConflictUpdate(
        SyncStatesCompanion.insert(
          dataType: dataType,
          lastSyncedAt: syncedAt,
        ),
      );
}

// ---------------------------------------------------------------------------
// Connection helper
// ---------------------------------------------------------------------------

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'kern.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}
