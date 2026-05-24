import 'package:drift/drift.dart';

// ---------------------------------------------------------------------------
// Raw Store — append-only, immutable health data from Health Connect / Garmin
// ---------------------------------------------------------------------------

/// String constants for [RawEntries.type].
/// Plain class (not enum) so Drift stores the raw string without a converter.
class RawDataType {
  static const String hrv = 'hrv';
  static const String restingHr = 'resting_hr';
  static const String sleepDeep = 'sleep_deep';
  static const String sleepRem = 'sleep_rem';
  static const String sleepLight = 'sleep_light';
  static const String steps = 'steps';
  static const String heartRate = 'heart_rate';
  static const String activeEnergyBurned = 'active_energy_burned';
  static const String water = 'water';

  RawDataType._();
}

/// A single health observation. The table is append-only; rows are never
/// updated or deleted — only the sync watermark (SyncStates) advances.
///
/// ### Deduplication
/// The unique constraint on (type, timestamp, source_name) makes re-syncing
/// idempotent. Health Connect returns the full window on every call; without
/// this constraint the same data would accumulate 30× after 30 daily syncs.
///
/// ### Multi-device attribution
/// [sourceName] stores the originating app's package name (e.g.
/// `"com.garmin.android.apps.connectmobile"`, `"com.google.android.apps.fitness"`).
/// [sourceRecordId] stores Health Connect's own UUID for the record, which
/// enables future re-ingestion without re-inserting.
class RawEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// One of the [RawDataType] string constants.
  TextColumn get type => text()();

  /// Numeric measurement value (bpm, ms, steps, minutes, …).
  RealColumn get value => real()();

  /// UTC timestamp of the observation (start of the sample window).
  DateTimeColumn get timestamp => dateTime()();

  /// End of the sample window (nullable — point-in-time samples leave this null).
  DateTimeColumn get timestampEnd => dateTime().nullable()();

  /// Originating app package name, e.g. "com.garmin.android.apps.connectmobile".
  /// Allows per-source filtering and future preferred-source logic.
  TextColumn get sourceName => text().withDefault(const Constant('unknown'))();

  /// Health Connect's own UUID for this record (nullable for data not from HC).
  /// Stored for audit / future upsert workflows; not used as the primary key.
  TextColumn get sourceRecordId => text().nullable()();

  /// Optional JSON blob for complex raw data (e.g., Blood Pressure Systolic/Diastolic).
  TextColumn get metadata => text().nullable()();

  /// Composite uniqueness: one row per (type, sample-start, source-app).
  /// Prevents duplicate insertion when the same time window is re-synced.
  Set<List<Column>> get uniqueColumns => {
        [type, timestamp, sourceName],
      };
}

// ---------------------------------------------------------------------------
// Derived Store — computed values written exclusively by plugins
// ---------------------------------------------------------------------------

/// A computed key-value entry scoped to a plugin namespace.
///
/// ### Uniqueness
/// The unique constraint on (namespace, key, date) means each plugin writes
/// exactly one value per key per calendar day. Plugins use `upsertDerived`
/// which resolves conflicts by replacing the existing row.
class DerivedEntries extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Plugin namespace, e.g. "readiness", "sleep", "strain", "ai".
  TextColumn get namespace => text()();

  /// Key within the namespace, e.g. "score", "components", "daily".
  TextColumn get key => text()();

  /// Computed numeric value.
  RealColumn get value => real()();

  /// Calendar date string in ISO-8601 format, e.g. "2026-05-08".
  /// Scopes uniqueness to one computed value per plugin-key per day.
  TextColumn get date => text()();

  /// UTC timestamp when this value was computed (for ordering within a day).
  DateTimeColumn get computedAt => dateTime()();

  /// Optional JSON blob for complex plugin outputs (e.g. component breakdown).
  TextColumn get metadata => text().nullable()();

  /// One score per (plugin, key, day) — prevents unbounded accumulation.
  Set<List<Column>> get uniqueColumns => {
        [namespace, key, date],
      };
}

// ---------------------------------------------------------------------------
// Sync State — delta-sync watermarks per data type
// ---------------------------------------------------------------------------

/// Tracks the timestamp of the last successful sync per data type.
///
/// On first run, [lastSyncedAt] is null and the service fetches 30 days.
/// On subsequent runs, it fetches only from [lastSyncedAt] to now —
/// avoiding re-processing data already in the Raw Store and staying well
/// within Health Connect's rate limits.
class SyncStates extends Table {
  /// One of the [RawDataType] string constants — the primary key.
  TextColumn get dataType => text()();

  /// UTC timestamp of the last completed sync for this data type.
  DateTimeColumn get lastSyncedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {dataType};
}

// ---------------------------------------------------------------------------
// Plugin Settings
// ---------------------------------------------------------------------------

/// Persists user preferences for plugins (dashboard position, enabled state).
class PluginSettings extends Table {
  /// Unique identifier of the plugin (e.g. 'readiness', 'sleep').
  TextColumn get pluginId => text()();

  /// Whether the plugin is currently enabled by the user.
  BoolColumn get isEnabled => boolean().withDefault(const Constant(true))();

  /// The dashboard slot where this plugin should render:
  /// 'header', 'main', 'footer', or 'hidden'.
  TextColumn get dashboardSlot => text().withDefault(const Constant('hidden'))();

  /// Sort order within the slot. Lower numbers appear first.
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {pluginId};
}

// ---------------------------------------------------------------------------
// User Feedback — daily morning check-in for Bayesian score calibration
// ---------------------------------------------------------------------------

/// Stores the user's morning self-assessment for each day.
///
/// One row per calendar day (ISO-8601 date string is the primary key).
/// Used by [ReadinessPlugin] to perform Bayesian updating of the objective
/// sensor-derived scores with subjective perception data.
///
/// Modelled after the Hooper Index / Acute Readiness Monitoring Scale (ARMS).
class UserFeedback extends Table {
  /// Calendar date in ISO-8601 format ("2026-05-09"). Acts as primary key.
  TextColumn get date => text()();

  /// Perceived muscular soreness / fatigue.
  /// Scale 1–10: 1 = no pain / fully rested, 10 = extreme soreness.
  RealColumn get soreness => real()();

  /// Perceived energy level and mood.
  /// Scale 1–10: 10 = highly energetic / motivated, 1 = exhausted / lethargic.
  RealColumn get energy => real()();

  /// Perceived psychological stress from external stressors.
  /// Scale 1–10: 1 = completely relaxed, 10 = massive stress.
  RealColumn get stress => real()();

  /// UTC timestamp when the user submitted this check-in.
  DateTimeColumn get recordedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {date};
}
