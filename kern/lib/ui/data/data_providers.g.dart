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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
