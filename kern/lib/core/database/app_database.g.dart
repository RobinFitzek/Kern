// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $RawEntriesTable extends RawEntries
    with TableInfo<$RawEntriesTable, RawEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RawEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampMeta = const VerificationMeta(
    'timestamp',
  );
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
    'timestamp',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timestampEndMeta = const VerificationMeta(
    'timestampEnd',
  );
  @override
  late final GeneratedColumn<DateTime> timestampEnd = GeneratedColumn<DateTime>(
    'timestamp_end',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sourceNameMeta = const VerificationMeta(
    'sourceName',
  );
  @override
  late final GeneratedColumn<String> sourceName = GeneratedColumn<String>(
    'source_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('unknown'),
  );
  static const VerificationMeta _sourceRecordIdMeta = const VerificationMeta(
    'sourceRecordId',
  );
  @override
  late final GeneratedColumn<String> sourceRecordId = GeneratedColumn<String>(
    'source_record_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    type,
    value,
    timestamp,
    timestampEnd,
    sourceName,
    sourceRecordId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'raw_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<RawEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(
        _timestampMeta,
        timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta),
      );
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('timestamp_end')) {
      context.handle(
        _timestampEndMeta,
        timestampEnd.isAcceptableOrUnknown(
          data['timestamp_end']!,
          _timestampEndMeta,
        ),
      );
    }
    if (data.containsKey('source_name')) {
      context.handle(
        _sourceNameMeta,
        sourceName.isAcceptableOrUnknown(data['source_name']!, _sourceNameMeta),
      );
    }
    if (data.containsKey('source_record_id')) {
      context.handle(
        _sourceRecordIdMeta,
        sourceRecordId.isAcceptableOrUnknown(
          data['source_record_id']!,
          _sourceRecordIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RawEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RawEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value'],
      )!,
      timestamp: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp'],
      )!,
      timestampEnd: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}timestamp_end'],
      ),
      sourceName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_name'],
      )!,
      sourceRecordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_record_id'],
      ),
    );
  }

  @override
  $RawEntriesTable createAlias(String alias) {
    return $RawEntriesTable(attachedDatabase, alias);
  }
}

class RawEntry extends DataClass implements Insertable<RawEntry> {
  final int id;

  /// One of the [RawDataType] string constants.
  final String type;

  /// Numeric measurement value (bpm, ms, steps, minutes, …).
  final double value;

  /// UTC timestamp of the observation (start of the sample window).
  final DateTime timestamp;

  /// End of the sample window (nullable — point-in-time samples leave this null).
  final DateTime? timestampEnd;

  /// Originating app package name, e.g. "com.garmin.android.apps.connectmobile".
  /// Allows per-source filtering and future preferred-source logic.
  final String sourceName;

  /// Health Connect's own UUID for this record (nullable for data not from HC).
  /// Stored for audit / future upsert workflows; not used as the primary key.
  final String? sourceRecordId;
  const RawEntry({
    required this.id,
    required this.type,
    required this.value,
    required this.timestamp,
    this.timestampEnd,
    required this.sourceName,
    this.sourceRecordId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['type'] = Variable<String>(type);
    map['value'] = Variable<double>(value);
    map['timestamp'] = Variable<DateTime>(timestamp);
    if (!nullToAbsent || timestampEnd != null) {
      map['timestamp_end'] = Variable<DateTime>(timestampEnd);
    }
    map['source_name'] = Variable<String>(sourceName);
    if (!nullToAbsent || sourceRecordId != null) {
      map['source_record_id'] = Variable<String>(sourceRecordId);
    }
    return map;
  }

  RawEntriesCompanion toCompanion(bool nullToAbsent) {
    return RawEntriesCompanion(
      id: Value(id),
      type: Value(type),
      value: Value(value),
      timestamp: Value(timestamp),
      timestampEnd: timestampEnd == null && nullToAbsent
          ? const Value.absent()
          : Value(timestampEnd),
      sourceName: Value(sourceName),
      sourceRecordId: sourceRecordId == null && nullToAbsent
          ? const Value.absent()
          : Value(sourceRecordId),
    );
  }

  factory RawEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RawEntry(
      id: serializer.fromJson<int>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      value: serializer.fromJson<double>(json['value']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      timestampEnd: serializer.fromJson<DateTime?>(json['timestampEnd']),
      sourceName: serializer.fromJson<String>(json['sourceName']),
      sourceRecordId: serializer.fromJson<String?>(json['sourceRecordId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'type': serializer.toJson<String>(type),
      'value': serializer.toJson<double>(value),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'timestampEnd': serializer.toJson<DateTime?>(timestampEnd),
      'sourceName': serializer.toJson<String>(sourceName),
      'sourceRecordId': serializer.toJson<String?>(sourceRecordId),
    };
  }

  RawEntry copyWith({
    int? id,
    String? type,
    double? value,
    DateTime? timestamp,
    Value<DateTime?> timestampEnd = const Value.absent(),
    String? sourceName,
    Value<String?> sourceRecordId = const Value.absent(),
  }) => RawEntry(
    id: id ?? this.id,
    type: type ?? this.type,
    value: value ?? this.value,
    timestamp: timestamp ?? this.timestamp,
    timestampEnd: timestampEnd.present ? timestampEnd.value : this.timestampEnd,
    sourceName: sourceName ?? this.sourceName,
    sourceRecordId: sourceRecordId.present
        ? sourceRecordId.value
        : this.sourceRecordId,
  );
  RawEntry copyWithCompanion(RawEntriesCompanion data) {
    return RawEntry(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      value: data.value.present ? data.value.value : this.value,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      timestampEnd: data.timestampEnd.present
          ? data.timestampEnd.value
          : this.timestampEnd,
      sourceName: data.sourceName.present
          ? data.sourceName.value
          : this.sourceName,
      sourceRecordId: data.sourceRecordId.present
          ? data.sourceRecordId.value
          : this.sourceRecordId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RawEntry(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('value: $value, ')
          ..write('timestamp: $timestamp, ')
          ..write('timestampEnd: $timestampEnd, ')
          ..write('sourceName: $sourceName, ')
          ..write('sourceRecordId: $sourceRecordId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    type,
    value,
    timestamp,
    timestampEnd,
    sourceName,
    sourceRecordId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RawEntry &&
          other.id == this.id &&
          other.type == this.type &&
          other.value == this.value &&
          other.timestamp == this.timestamp &&
          other.timestampEnd == this.timestampEnd &&
          other.sourceName == this.sourceName &&
          other.sourceRecordId == this.sourceRecordId);
}

class RawEntriesCompanion extends UpdateCompanion<RawEntry> {
  final Value<int> id;
  final Value<String> type;
  final Value<double> value;
  final Value<DateTime> timestamp;
  final Value<DateTime?> timestampEnd;
  final Value<String> sourceName;
  final Value<String?> sourceRecordId;
  const RawEntriesCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.value = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.timestampEnd = const Value.absent(),
    this.sourceName = const Value.absent(),
    this.sourceRecordId = const Value.absent(),
  });
  RawEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String type,
    required double value,
    required DateTime timestamp,
    this.timestampEnd = const Value.absent(),
    this.sourceName = const Value.absent(),
    this.sourceRecordId = const Value.absent(),
  }) : type = Value(type),
       value = Value(value),
       timestamp = Value(timestamp);
  static Insertable<RawEntry> custom({
    Expression<int>? id,
    Expression<String>? type,
    Expression<double>? value,
    Expression<DateTime>? timestamp,
    Expression<DateTime>? timestampEnd,
    Expression<String>? sourceName,
    Expression<String>? sourceRecordId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (value != null) 'value': value,
      if (timestamp != null) 'timestamp': timestamp,
      if (timestampEnd != null) 'timestamp_end': timestampEnd,
      if (sourceName != null) 'source_name': sourceName,
      if (sourceRecordId != null) 'source_record_id': sourceRecordId,
    });
  }

  RawEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? type,
    Value<double>? value,
    Value<DateTime>? timestamp,
    Value<DateTime?>? timestampEnd,
    Value<String>? sourceName,
    Value<String?>? sourceRecordId,
  }) {
    return RawEntriesCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      value: value ?? this.value,
      timestamp: timestamp ?? this.timestamp,
      timestampEnd: timestampEnd ?? this.timestampEnd,
      sourceName: sourceName ?? this.sourceName,
      sourceRecordId: sourceRecordId ?? this.sourceRecordId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (timestampEnd.present) {
      map['timestamp_end'] = Variable<DateTime>(timestampEnd.value);
    }
    if (sourceName.present) {
      map['source_name'] = Variable<String>(sourceName.value);
    }
    if (sourceRecordId.present) {
      map['source_record_id'] = Variable<String>(sourceRecordId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RawEntriesCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('value: $value, ')
          ..write('timestamp: $timestamp, ')
          ..write('timestampEnd: $timestampEnd, ')
          ..write('sourceName: $sourceName, ')
          ..write('sourceRecordId: $sourceRecordId')
          ..write(')'))
        .toString();
  }
}

class $DerivedEntriesTable extends DerivedEntries
    with TableInfo<$DerivedEntriesTable, DerivedEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DerivedEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _namespaceMeta = const VerificationMeta(
    'namespace',
  );
  @override
  late final GeneratedColumn<String> namespace = GeneratedColumn<String>(
    'namespace',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<double> value = GeneratedColumn<double>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _computedAtMeta = const VerificationMeta(
    'computedAt',
  );
  @override
  late final GeneratedColumn<DateTime> computedAt = GeneratedColumn<DateTime>(
    'computed_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _metadataMeta = const VerificationMeta(
    'metadata',
  );
  @override
  late final GeneratedColumn<String> metadata = GeneratedColumn<String>(
    'metadata',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    namespace,
    key,
    value,
    date,
    computedAt,
    metadata,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'derived_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<DerivedEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('namespace')) {
      context.handle(
        _namespaceMeta,
        namespace.isAcceptableOrUnknown(data['namespace']!, _namespaceMeta),
      );
    } else if (isInserting) {
      context.missing(_namespaceMeta);
    }
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('computed_at')) {
      context.handle(
        _computedAtMeta,
        computedAt.isAcceptableOrUnknown(data['computed_at']!, _computedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_computedAtMeta);
    }
    if (data.containsKey('metadata')) {
      context.handle(
        _metadataMeta,
        metadata.isAcceptableOrUnknown(data['metadata']!, _metadataMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DerivedEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DerivedEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      namespace: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}namespace'],
      )!,
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}value'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      computedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}computed_at'],
      )!,
      metadata: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}metadata'],
      ),
    );
  }

  @override
  $DerivedEntriesTable createAlias(String alias) {
    return $DerivedEntriesTable(attachedDatabase, alias);
  }
}

class DerivedEntry extends DataClass implements Insertable<DerivedEntry> {
  final int id;

  /// Plugin namespace, e.g. "readiness", "sleep", "strain", "ai".
  final String namespace;

  /// Key within the namespace, e.g. "score", "components", "daily".
  final String key;

  /// Computed numeric value.
  final double value;

  /// Calendar date string in ISO-8601 format, e.g. "2026-05-08".
  /// Scopes uniqueness to one computed value per plugin-key per day.
  final String date;

  /// UTC timestamp when this value was computed (for ordering within a day).
  final DateTime computedAt;

  /// Optional JSON blob for complex plugin outputs (e.g. component breakdown).
  final String? metadata;
  const DerivedEntry({
    required this.id,
    required this.namespace,
    required this.key,
    required this.value,
    required this.date,
    required this.computedAt,
    this.metadata,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['namespace'] = Variable<String>(namespace);
    map['key'] = Variable<String>(key);
    map['value'] = Variable<double>(value);
    map['date'] = Variable<String>(date);
    map['computed_at'] = Variable<DateTime>(computedAt);
    if (!nullToAbsent || metadata != null) {
      map['metadata'] = Variable<String>(metadata);
    }
    return map;
  }

  DerivedEntriesCompanion toCompanion(bool nullToAbsent) {
    return DerivedEntriesCompanion(
      id: Value(id),
      namespace: Value(namespace),
      key: Value(key),
      value: Value(value),
      date: Value(date),
      computedAt: Value(computedAt),
      metadata: metadata == null && nullToAbsent
          ? const Value.absent()
          : Value(metadata),
    );
  }

  factory DerivedEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DerivedEntry(
      id: serializer.fromJson<int>(json['id']),
      namespace: serializer.fromJson<String>(json['namespace']),
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<double>(json['value']),
      date: serializer.fromJson<String>(json['date']),
      computedAt: serializer.fromJson<DateTime>(json['computedAt']),
      metadata: serializer.fromJson<String?>(json['metadata']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'namespace': serializer.toJson<String>(namespace),
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<double>(value),
      'date': serializer.toJson<String>(date),
      'computedAt': serializer.toJson<DateTime>(computedAt),
      'metadata': serializer.toJson<String?>(metadata),
    };
  }

  DerivedEntry copyWith({
    int? id,
    String? namespace,
    String? key,
    double? value,
    String? date,
    DateTime? computedAt,
    Value<String?> metadata = const Value.absent(),
  }) => DerivedEntry(
    id: id ?? this.id,
    namespace: namespace ?? this.namespace,
    key: key ?? this.key,
    value: value ?? this.value,
    date: date ?? this.date,
    computedAt: computedAt ?? this.computedAt,
    metadata: metadata.present ? metadata.value : this.metadata,
  );
  DerivedEntry copyWithCompanion(DerivedEntriesCompanion data) {
    return DerivedEntry(
      id: data.id.present ? data.id.value : this.id,
      namespace: data.namespace.present ? data.namespace.value : this.namespace,
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
      date: data.date.present ? data.date.value : this.date,
      computedAt: data.computedAt.present
          ? data.computedAt.value
          : this.computedAt,
      metadata: data.metadata.present ? data.metadata.value : this.metadata,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DerivedEntry(')
          ..write('id: $id, ')
          ..write('namespace: $namespace, ')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('date: $date, ')
          ..write('computedAt: $computedAt, ')
          ..write('metadata: $metadata')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, namespace, key, value, date, computedAt, metadata);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DerivedEntry &&
          other.id == this.id &&
          other.namespace == this.namespace &&
          other.key == this.key &&
          other.value == this.value &&
          other.date == this.date &&
          other.computedAt == this.computedAt &&
          other.metadata == this.metadata);
}

class DerivedEntriesCompanion extends UpdateCompanion<DerivedEntry> {
  final Value<int> id;
  final Value<String> namespace;
  final Value<String> key;
  final Value<double> value;
  final Value<String> date;
  final Value<DateTime> computedAt;
  final Value<String?> metadata;
  const DerivedEntriesCompanion({
    this.id = const Value.absent(),
    this.namespace = const Value.absent(),
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.date = const Value.absent(),
    this.computedAt = const Value.absent(),
    this.metadata = const Value.absent(),
  });
  DerivedEntriesCompanion.insert({
    this.id = const Value.absent(),
    required String namespace,
    required String key,
    required double value,
    required String date,
    required DateTime computedAt,
    this.metadata = const Value.absent(),
  }) : namespace = Value(namespace),
       key = Value(key),
       value = Value(value),
       date = Value(date),
       computedAt = Value(computedAt);
  static Insertable<DerivedEntry> custom({
    Expression<int>? id,
    Expression<String>? namespace,
    Expression<String>? key,
    Expression<double>? value,
    Expression<String>? date,
    Expression<DateTime>? computedAt,
    Expression<String>? metadata,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (namespace != null) 'namespace': namespace,
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (date != null) 'date': date,
      if (computedAt != null) 'computed_at': computedAt,
      if (metadata != null) 'metadata': metadata,
    });
  }

  DerivedEntriesCompanion copyWith({
    Value<int>? id,
    Value<String>? namespace,
    Value<String>? key,
    Value<double>? value,
    Value<String>? date,
    Value<DateTime>? computedAt,
    Value<String?>? metadata,
  }) {
    return DerivedEntriesCompanion(
      id: id ?? this.id,
      namespace: namespace ?? this.namespace,
      key: key ?? this.key,
      value: value ?? this.value,
      date: date ?? this.date,
      computedAt: computedAt ?? this.computedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (namespace.present) {
      map['namespace'] = Variable<String>(namespace.value);
    }
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<double>(value.value);
    }
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (computedAt.present) {
      map['computed_at'] = Variable<DateTime>(computedAt.value);
    }
    if (metadata.present) {
      map['metadata'] = Variable<String>(metadata.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DerivedEntriesCompanion(')
          ..write('id: $id, ')
          ..write('namespace: $namespace, ')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('date: $date, ')
          ..write('computedAt: $computedAt, ')
          ..write('metadata: $metadata')
          ..write(')'))
        .toString();
  }
}

class $SyncStatesTable extends SyncStates
    with TableInfo<$SyncStatesTable, SyncState> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncStatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dataTypeMeta = const VerificationMeta(
    'dataType',
  );
  @override
  late final GeneratedColumn<String> dataType = GeneratedColumn<String>(
    'data_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSyncedAtMeta = const VerificationMeta(
    'lastSyncedAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncedAt = GeneratedColumn<DateTime>(
    'last_synced_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [dataType, lastSyncedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_states';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncState> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('data_type')) {
      context.handle(
        _dataTypeMeta,
        dataType.isAcceptableOrUnknown(data['data_type']!, _dataTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_dataTypeMeta);
    }
    if (data.containsKey('last_synced_at')) {
      context.handle(
        _lastSyncedAtMeta,
        lastSyncedAt.isAcceptableOrUnknown(
          data['last_synced_at']!,
          _lastSyncedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastSyncedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {dataType};
  @override
  SyncState map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncState(
      dataType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data_type'],
      )!,
      lastSyncedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_synced_at'],
      )!,
    );
  }

  @override
  $SyncStatesTable createAlias(String alias) {
    return $SyncStatesTable(attachedDatabase, alias);
  }
}

class SyncState extends DataClass implements Insertable<SyncState> {
  /// One of the [RawDataType] string constants — the primary key.
  final String dataType;

  /// UTC timestamp of the last completed sync for this data type.
  final DateTime lastSyncedAt;
  const SyncState({required this.dataType, required this.lastSyncedAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['data_type'] = Variable<String>(dataType);
    map['last_synced_at'] = Variable<DateTime>(lastSyncedAt);
    return map;
  }

  SyncStatesCompanion toCompanion(bool nullToAbsent) {
    return SyncStatesCompanion(
      dataType: Value(dataType),
      lastSyncedAt: Value(lastSyncedAt),
    );
  }

  factory SyncState.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncState(
      dataType: serializer.fromJson<String>(json['dataType']),
      lastSyncedAt: serializer.fromJson<DateTime>(json['lastSyncedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'dataType': serializer.toJson<String>(dataType),
      'lastSyncedAt': serializer.toJson<DateTime>(lastSyncedAt),
    };
  }

  SyncState copyWith({String? dataType, DateTime? lastSyncedAt}) => SyncState(
    dataType: dataType ?? this.dataType,
    lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
  );
  SyncState copyWithCompanion(SyncStatesCompanion data) {
    return SyncState(
      dataType: data.dataType.present ? data.dataType.value : this.dataType,
      lastSyncedAt: data.lastSyncedAt.present
          ? data.lastSyncedAt.value
          : this.lastSyncedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncState(')
          ..write('dataType: $dataType, ')
          ..write('lastSyncedAt: $lastSyncedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(dataType, lastSyncedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncState &&
          other.dataType == this.dataType &&
          other.lastSyncedAt == this.lastSyncedAt);
}

class SyncStatesCompanion extends UpdateCompanion<SyncState> {
  final Value<String> dataType;
  final Value<DateTime> lastSyncedAt;
  final Value<int> rowid;
  const SyncStatesCompanion({
    this.dataType = const Value.absent(),
    this.lastSyncedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncStatesCompanion.insert({
    required String dataType,
    required DateTime lastSyncedAt,
    this.rowid = const Value.absent(),
  }) : dataType = Value(dataType),
       lastSyncedAt = Value(lastSyncedAt);
  static Insertable<SyncState> custom({
    Expression<String>? dataType,
    Expression<DateTime>? lastSyncedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (dataType != null) 'data_type': dataType,
      if (lastSyncedAt != null) 'last_synced_at': lastSyncedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncStatesCompanion copyWith({
    Value<String>? dataType,
    Value<DateTime>? lastSyncedAt,
    Value<int>? rowid,
  }) {
    return SyncStatesCompanion(
      dataType: dataType ?? this.dataType,
      lastSyncedAt: lastSyncedAt ?? this.lastSyncedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (dataType.present) {
      map['data_type'] = Variable<String>(dataType.value);
    }
    if (lastSyncedAt.present) {
      map['last_synced_at'] = Variable<DateTime>(lastSyncedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncStatesCompanion(')
          ..write('dataType: $dataType, ')
          ..write('lastSyncedAt: $lastSyncedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $RawEntriesTable rawEntries = $RawEntriesTable(this);
  late final $DerivedEntriesTable derivedEntries = $DerivedEntriesTable(this);
  late final $SyncStatesTable syncStates = $SyncStatesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    rawEntries,
    derivedEntries,
    syncStates,
  ];
}

typedef $$RawEntriesTableCreateCompanionBuilder =
    RawEntriesCompanion Function({
      Value<int> id,
      required String type,
      required double value,
      required DateTime timestamp,
      Value<DateTime?> timestampEnd,
      Value<String> sourceName,
      Value<String?> sourceRecordId,
    });
typedef $$RawEntriesTableUpdateCompanionBuilder =
    RawEntriesCompanion Function({
      Value<int> id,
      Value<String> type,
      Value<double> value,
      Value<DateTime> timestamp,
      Value<DateTime?> timestampEnd,
      Value<String> sourceName,
      Value<String?> sourceRecordId,
    });

class $$RawEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $RawEntriesTable> {
  $$RawEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get timestampEnd => $composableBuilder(
    column: $table.timestampEnd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceName => $composableBuilder(
    column: $table.sourceName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceRecordId => $composableBuilder(
    column: $table.sourceRecordId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RawEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $RawEntriesTable> {
  $$RawEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
    column: $table.timestamp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get timestampEnd => $composableBuilder(
    column: $table.timestampEnd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceName => $composableBuilder(
    column: $table.sourceName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceRecordId => $composableBuilder(
    column: $table.sourceRecordId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RawEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RawEntriesTable> {
  $$RawEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<DateTime> get timestampEnd => $composableBuilder(
    column: $table.timestampEnd,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceName => $composableBuilder(
    column: $table.sourceName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceRecordId => $composableBuilder(
    column: $table.sourceRecordId,
    builder: (column) => column,
  );
}

class $$RawEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RawEntriesTable,
          RawEntry,
          $$RawEntriesTableFilterComposer,
          $$RawEntriesTableOrderingComposer,
          $$RawEntriesTableAnnotationComposer,
          $$RawEntriesTableCreateCompanionBuilder,
          $$RawEntriesTableUpdateCompanionBuilder,
          (RawEntry, BaseReferences<_$AppDatabase, $RawEntriesTable, RawEntry>),
          RawEntry,
          PrefetchHooks Function()
        > {
  $$RawEntriesTableTableManager(_$AppDatabase db, $RawEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RawEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RawEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RawEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<double> value = const Value.absent(),
                Value<DateTime> timestamp = const Value.absent(),
                Value<DateTime?> timestampEnd = const Value.absent(),
                Value<String> sourceName = const Value.absent(),
                Value<String?> sourceRecordId = const Value.absent(),
              }) => RawEntriesCompanion(
                id: id,
                type: type,
                value: value,
                timestamp: timestamp,
                timestampEnd: timestampEnd,
                sourceName: sourceName,
                sourceRecordId: sourceRecordId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String type,
                required double value,
                required DateTime timestamp,
                Value<DateTime?> timestampEnd = const Value.absent(),
                Value<String> sourceName = const Value.absent(),
                Value<String?> sourceRecordId = const Value.absent(),
              }) => RawEntriesCompanion.insert(
                id: id,
                type: type,
                value: value,
                timestamp: timestamp,
                timestampEnd: timestampEnd,
                sourceName: sourceName,
                sourceRecordId: sourceRecordId,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RawEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RawEntriesTable,
      RawEntry,
      $$RawEntriesTableFilterComposer,
      $$RawEntriesTableOrderingComposer,
      $$RawEntriesTableAnnotationComposer,
      $$RawEntriesTableCreateCompanionBuilder,
      $$RawEntriesTableUpdateCompanionBuilder,
      (RawEntry, BaseReferences<_$AppDatabase, $RawEntriesTable, RawEntry>),
      RawEntry,
      PrefetchHooks Function()
    >;
typedef $$DerivedEntriesTableCreateCompanionBuilder =
    DerivedEntriesCompanion Function({
      Value<int> id,
      required String namespace,
      required String key,
      required double value,
      required String date,
      required DateTime computedAt,
      Value<String?> metadata,
    });
typedef $$DerivedEntriesTableUpdateCompanionBuilder =
    DerivedEntriesCompanion Function({
      Value<int> id,
      Value<String> namespace,
      Value<String> key,
      Value<double> value,
      Value<String> date,
      Value<DateTime> computedAt,
      Value<String?> metadata,
    });

class $$DerivedEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $DerivedEntriesTable> {
  $$DerivedEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get namespace => $composableBuilder(
    column: $table.namespace,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get computedAt => $composableBuilder(
    column: $table.computedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DerivedEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $DerivedEntriesTable> {
  $$DerivedEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get namespace => $composableBuilder(
    column: $table.namespace,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get computedAt => $composableBuilder(
    column: $table.computedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get metadata => $composableBuilder(
    column: $table.metadata,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DerivedEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $DerivedEntriesTable> {
  $$DerivedEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get namespace =>
      $composableBuilder(column: $table.namespace, builder: (column) => column);

  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<double> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);

  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<DateTime> get computedAt => $composableBuilder(
    column: $table.computedAt,
    builder: (column) => column,
  );

  GeneratedColumn<String> get metadata =>
      $composableBuilder(column: $table.metadata, builder: (column) => column);
}

class $$DerivedEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DerivedEntriesTable,
          DerivedEntry,
          $$DerivedEntriesTableFilterComposer,
          $$DerivedEntriesTableOrderingComposer,
          $$DerivedEntriesTableAnnotationComposer,
          $$DerivedEntriesTableCreateCompanionBuilder,
          $$DerivedEntriesTableUpdateCompanionBuilder,
          (
            DerivedEntry,
            BaseReferences<_$AppDatabase, $DerivedEntriesTable, DerivedEntry>,
          ),
          DerivedEntry,
          PrefetchHooks Function()
        > {
  $$DerivedEntriesTableTableManager(
    _$AppDatabase db,
    $DerivedEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DerivedEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DerivedEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DerivedEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> namespace = const Value.absent(),
                Value<String> key = const Value.absent(),
                Value<double> value = const Value.absent(),
                Value<String> date = const Value.absent(),
                Value<DateTime> computedAt = const Value.absent(),
                Value<String?> metadata = const Value.absent(),
              }) => DerivedEntriesCompanion(
                id: id,
                namespace: namespace,
                key: key,
                value: value,
                date: date,
                computedAt: computedAt,
                metadata: metadata,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String namespace,
                required String key,
                required double value,
                required String date,
                required DateTime computedAt,
                Value<String?> metadata = const Value.absent(),
              }) => DerivedEntriesCompanion.insert(
                id: id,
                namespace: namespace,
                key: key,
                value: value,
                date: date,
                computedAt: computedAt,
                metadata: metadata,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DerivedEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DerivedEntriesTable,
      DerivedEntry,
      $$DerivedEntriesTableFilterComposer,
      $$DerivedEntriesTableOrderingComposer,
      $$DerivedEntriesTableAnnotationComposer,
      $$DerivedEntriesTableCreateCompanionBuilder,
      $$DerivedEntriesTableUpdateCompanionBuilder,
      (
        DerivedEntry,
        BaseReferences<_$AppDatabase, $DerivedEntriesTable, DerivedEntry>,
      ),
      DerivedEntry,
      PrefetchHooks Function()
    >;
typedef $$SyncStatesTableCreateCompanionBuilder =
    SyncStatesCompanion Function({
      required String dataType,
      required DateTime lastSyncedAt,
      Value<int> rowid,
    });
typedef $$SyncStatesTableUpdateCompanionBuilder =
    SyncStatesCompanion Function({
      Value<String> dataType,
      Value<DateTime> lastSyncedAt,
      Value<int> rowid,
    });

class $$SyncStatesTableFilterComposer
    extends Composer<_$AppDatabase, $SyncStatesTable> {
  $$SyncStatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get dataType => $composableBuilder(
    column: $table.dataType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncStatesTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncStatesTable> {
  $$SyncStatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get dataType => $composableBuilder(
    column: $table.dataType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncStatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncStatesTable> {
  $$SyncStatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get dataType =>
      $composableBuilder(column: $table.dataType, builder: (column) => column);

  GeneratedColumn<DateTime> get lastSyncedAt => $composableBuilder(
    column: $table.lastSyncedAt,
    builder: (column) => column,
  );
}

class $$SyncStatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncStatesTable,
          SyncState,
          $$SyncStatesTableFilterComposer,
          $$SyncStatesTableOrderingComposer,
          $$SyncStatesTableAnnotationComposer,
          $$SyncStatesTableCreateCompanionBuilder,
          $$SyncStatesTableUpdateCompanionBuilder,
          (
            SyncState,
            BaseReferences<_$AppDatabase, $SyncStatesTable, SyncState>,
          ),
          SyncState,
          PrefetchHooks Function()
        > {
  $$SyncStatesTableTableManager(_$AppDatabase db, $SyncStatesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncStatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncStatesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncStatesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> dataType = const Value.absent(),
                Value<DateTime> lastSyncedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncStatesCompanion(
                dataType: dataType,
                lastSyncedAt: lastSyncedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String dataType,
                required DateTime lastSyncedAt,
                Value<int> rowid = const Value.absent(),
              }) => SyncStatesCompanion.insert(
                dataType: dataType,
                lastSyncedAt: lastSyncedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncStatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncStatesTable,
      SyncState,
      $$SyncStatesTableFilterComposer,
      $$SyncStatesTableOrderingComposer,
      $$SyncStatesTableAnnotationComposer,
      $$SyncStatesTableCreateCompanionBuilder,
      $$SyncStatesTableUpdateCompanionBuilder,
      (SyncState, BaseReferences<_$AppDatabase, $SyncStatesTable, SyncState>),
      SyncState,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$RawEntriesTableTableManager get rawEntries =>
      $$RawEntriesTableTableManager(_db, _db.rawEntries);
  $$DerivedEntriesTableTableManager get derivedEntries =>
      $$DerivedEntriesTableTableManager(_db, _db.derivedEntries);
  $$SyncStatesTableTableManager get syncStates =>
      $$SyncStatesTableTableManager(_db, _db.syncStates);
}
