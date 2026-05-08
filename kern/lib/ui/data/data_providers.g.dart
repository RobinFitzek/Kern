// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$recentRawEntriesHash() => r'2ffef403280657b2dea11b7932eb1f4c1b63c539';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [recentRawEntries].
@ProviderFor(recentRawEntries)
const recentRawEntriesProvider = RecentRawEntriesFamily();

/// See also [recentRawEntries].
class RecentRawEntriesFamily extends Family<AsyncValue<List<RawEntry>>> {
  /// See also [recentRawEntries].
  const RecentRawEntriesFamily();

  /// See also [recentRawEntries].
  RecentRawEntriesProvider call({String? filterType}) {
    return RecentRawEntriesProvider(filterType: filterType);
  }

  @override
  RecentRawEntriesProvider getProviderOverride(
    covariant RecentRawEntriesProvider provider,
  ) {
    return call(filterType: provider.filterType);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'recentRawEntriesProvider';
}

/// See also [recentRawEntries].
class RecentRawEntriesProvider
    extends AutoDisposeFutureProvider<List<RawEntry>> {
  /// See also [recentRawEntries].
  RecentRawEntriesProvider({String? filterType})
    : this._internal(
        (ref) => recentRawEntries(
          ref as RecentRawEntriesRef,
          filterType: filterType,
        ),
        from: recentRawEntriesProvider,
        name: r'recentRawEntriesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$recentRawEntriesHash,
        dependencies: RecentRawEntriesFamily._dependencies,
        allTransitiveDependencies:
            RecentRawEntriesFamily._allTransitiveDependencies,
        filterType: filterType,
      );

  RecentRawEntriesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.filterType,
  }) : super.internal();

  final String? filterType;

  @override
  Override overrideWith(
    FutureOr<List<RawEntry>> Function(RecentRawEntriesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RecentRawEntriesProvider._internal(
        (ref) => create(ref as RecentRawEntriesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        filterType: filterType,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<RawEntry>> createElement() {
    return _RecentRawEntriesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecentRawEntriesProvider && other.filterType == filterType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, filterType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RecentRawEntriesRef on AutoDisposeFutureProviderRef<List<RawEntry>> {
  /// The parameter `filterType` of this provider.
  String? get filterType;
}

class _RecentRawEntriesProviderElement
    extends AutoDisposeFutureProviderElement<List<RawEntry>>
    with RecentRawEntriesRef {
  _RecentRawEntriesProviderElement(super.provider);

  @override
  String? get filterType => (origin as RecentRawEntriesProvider).filterType;
}

String _$availableDataTypesHash() =>
    r'ef8f8aedef172f61c737a8af7c1ebf8270960780';

/// See also [availableDataTypes].
@ProviderFor(availableDataTypes)
final availableDataTypesProvider =
    AutoDisposeFutureProvider<List<String>>.internal(
      availableDataTypes,
      name: r'availableDataTypesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$availableDataTypesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AvailableDataTypesRef = AutoDisposeFutureProviderRef<List<String>>;
String _$baselineAverageHash() => r'740463a10c3d4abacf03f4b6f10dd6b23996cd90';

/// See also [baselineAverage].
@ProviderFor(baselineAverage)
const baselineAverageProvider = BaselineAverageFamily();

/// See also [baselineAverage].
class BaselineAverageFamily extends Family<AsyncValue<double?>> {
  /// See also [baselineAverage].
  const BaselineAverageFamily();

  /// See also [baselineAverage].
  BaselineAverageProvider call(String type) {
    return BaselineAverageProvider(type);
  }

  @override
  BaselineAverageProvider getProviderOverride(
    covariant BaselineAverageProvider provider,
  ) {
    return call(provider.type);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'baselineAverageProvider';
}

/// See also [baselineAverage].
class BaselineAverageProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [baselineAverage].
  BaselineAverageProvider(String type)
    : this._internal(
        (ref) => baselineAverage(ref as BaselineAverageRef, type),
        from: baselineAverageProvider,
        name: r'baselineAverageProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$baselineAverageHash,
        dependencies: BaselineAverageFamily._dependencies,
        allTransitiveDependencies:
            BaselineAverageFamily._allTransitiveDependencies,
        type: type,
      );

  BaselineAverageProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final String type;

  @override
  Override overrideWith(
    FutureOr<double?> Function(BaselineAverageRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BaselineAverageProvider._internal(
        (ref) => create(ref as BaselineAverageRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<double?> createElement() {
    return _BaselineAverageProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BaselineAverageProvider && other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin BaselineAverageRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `type` of this provider.
  String get type;
}

class _BaselineAverageProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with BaselineAverageRef {
  _BaselineAverageProviderElement(super.provider);

  @override
  String get type => (origin as BaselineAverageProvider).type;
}

String _$aggregatedDataQueryHash() =>
    r'99101b8648adebc9c641b6e8635c61bb07a103cb';

/// See also [aggregatedDataQuery].
@ProviderFor(aggregatedDataQuery)
const aggregatedDataQueryProvider = AggregatedDataQueryFamily();

/// See also [aggregatedDataQuery].
class AggregatedDataQueryFamily
    extends Family<AsyncValue<List<AggregatedDataPoint>>> {
  /// See also [aggregatedDataQuery].
  const AggregatedDataQueryFamily();

  /// See also [aggregatedDataQuery].
  AggregatedDataQueryProvider call(String type) {
    return AggregatedDataQueryProvider(type);
  }

  @override
  AggregatedDataQueryProvider getProviderOverride(
    covariant AggregatedDataQueryProvider provider,
  ) {
    return call(provider.type);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'aggregatedDataQueryProvider';
}

/// See also [aggregatedDataQuery].
class AggregatedDataQueryProvider
    extends AutoDisposeFutureProvider<List<AggregatedDataPoint>> {
  /// See also [aggregatedDataQuery].
  AggregatedDataQueryProvider(String type)
    : this._internal(
        (ref) => aggregatedDataQuery(ref as AggregatedDataQueryRef, type),
        from: aggregatedDataQueryProvider,
        name: r'aggregatedDataQueryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$aggregatedDataQueryHash,
        dependencies: AggregatedDataQueryFamily._dependencies,
        allTransitiveDependencies:
            AggregatedDataQueryFamily._allTransitiveDependencies,
        type: type,
      );

  AggregatedDataQueryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.type,
  }) : super.internal();

  final String type;

  @override
  Override overrideWith(
    FutureOr<List<AggregatedDataPoint>> Function(
      AggregatedDataQueryRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AggregatedDataQueryProvider._internal(
        (ref) => create(ref as AggregatedDataQueryRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        type: type,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<AggregatedDataPoint>> createElement() {
    return _AggregatedDataQueryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AggregatedDataQueryProvider && other.type == type;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, type.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AggregatedDataQueryRef
    on AutoDisposeFutureProviderRef<List<AggregatedDataPoint>> {
  /// The parameter `type` of this provider.
  String get type;
}

class _AggregatedDataQueryProviderElement
    extends AutoDisposeFutureProviderElement<List<AggregatedDataPoint>>
    with AggregatedDataQueryRef {
  _AggregatedDataQueryProviderElement(super.provider);

  @override
  String get type => (origin as AggregatedDataQueryProvider).type;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
