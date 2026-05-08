// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'derived_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$readinessScoreHash() => r'039faa7685157598ae884eb6deaae883aaec82a1';

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

/// Today's readiness score (0–100), or null if not yet computed.
///
/// Copied from [readinessScore].
@ProviderFor(readinessScore)
const readinessScoreProvider = ReadinessScoreFamily();

/// Today's readiness score (0–100), or null if not yet computed.
///
/// Copied from [readinessScore].
class ReadinessScoreFamily extends Family<AsyncValue<double?>> {
  /// Today's readiness score (0–100), or null if not yet computed.
  ///
  /// Copied from [readinessScore].
  const ReadinessScoreFamily();

  /// Today's readiness score (0–100), or null if not yet computed.
  ///
  /// Copied from [readinessScore].
  ReadinessScoreProvider call({String? date}) {
    return ReadinessScoreProvider(date: date);
  }

  @override
  ReadinessScoreProvider getProviderOverride(
    covariant ReadinessScoreProvider provider,
  ) {
    return call(date: provider.date);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'readinessScoreProvider';
}

/// Today's readiness score (0–100), or null if not yet computed.
///
/// Copied from [readinessScore].
class ReadinessScoreProvider extends AutoDisposeFutureProvider<double?> {
  /// Today's readiness score (0–100), or null if not yet computed.
  ///
  /// Copied from [readinessScore].
  ReadinessScoreProvider({String? date})
    : this._internal(
        (ref) => readinessScore(ref as ReadinessScoreRef, date: date),
        from: readinessScoreProvider,
        name: r'readinessScoreProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$readinessScoreHash,
        dependencies: ReadinessScoreFamily._dependencies,
        allTransitiveDependencies:
            ReadinessScoreFamily._allTransitiveDependencies,
        date: date,
      );

  ReadinessScoreProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final String? date;

  @override
  Override overrideWith(
    FutureOr<double?> Function(ReadinessScoreRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReadinessScoreProvider._internal(
        (ref) => create(ref as ReadinessScoreRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<double?> createElement() {
    return _ReadinessScoreProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReadinessScoreProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ReadinessScoreRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _ReadinessScoreProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with ReadinessScoreRef {
  _ReadinessScoreProviderElement(super.provider);

  @override
  String? get date => (origin as ReadinessScoreProvider).date;
}

String _$readinessIsCalibratingHash() =>
    r'9348a0691426df518f1fcadb546e5289031fde7a';

/// Whether the readiness score is still in the calibration period.
///
/// Copied from [readinessIsCalibrating].
@ProviderFor(readinessIsCalibrating)
const readinessIsCalibratingProvider = ReadinessIsCalibratingFamily();

/// Whether the readiness score is still in the calibration period.
///
/// Copied from [readinessIsCalibrating].
class ReadinessIsCalibratingFamily extends Family<AsyncValue<bool>> {
  /// Whether the readiness score is still in the calibration period.
  ///
  /// Copied from [readinessIsCalibrating].
  const ReadinessIsCalibratingFamily();

  /// Whether the readiness score is still in the calibration period.
  ///
  /// Copied from [readinessIsCalibrating].
  ReadinessIsCalibratingProvider call({String? date}) {
    return ReadinessIsCalibratingProvider(date: date);
  }

  @override
  ReadinessIsCalibratingProvider getProviderOverride(
    covariant ReadinessIsCalibratingProvider provider,
  ) {
    return call(date: provider.date);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'readinessIsCalibratingProvider';
}

/// Whether the readiness score is still in the calibration period.
///
/// Copied from [readinessIsCalibrating].
class ReadinessIsCalibratingProvider extends AutoDisposeFutureProvider<bool> {
  /// Whether the readiness score is still in the calibration period.
  ///
  /// Copied from [readinessIsCalibrating].
  ReadinessIsCalibratingProvider({String? date})
    : this._internal(
        (ref) => readinessIsCalibrating(
          ref as ReadinessIsCalibratingRef,
          date: date,
        ),
        from: readinessIsCalibratingProvider,
        name: r'readinessIsCalibratingProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$readinessIsCalibratingHash,
        dependencies: ReadinessIsCalibratingFamily._dependencies,
        allTransitiveDependencies:
            ReadinessIsCalibratingFamily._allTransitiveDependencies,
        date: date,
      );

  ReadinessIsCalibratingProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final String? date;

  @override
  Override overrideWith(
    FutureOr<bool> Function(ReadinessIsCalibratingRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReadinessIsCalibratingProvider._internal(
        (ref) => create(ref as ReadinessIsCalibratingRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _ReadinessIsCalibratingProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReadinessIsCalibratingProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ReadinessIsCalibratingRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _ReadinessIsCalibratingProviderElement
    extends AutoDisposeFutureProviderElement<bool>
    with ReadinessIsCalibratingRef {
  _ReadinessIsCalibratingProviderElement(super.provider);

  @override
  String? get date => (origin as ReadinessIsCalibratingProvider).date;
}

String _$readinessComponentsHash() =>
    r'8e4b7f1e81f663b383a7f3cef0fbe2857e2ca66d';

/// Readiness component contributions (hrv, sleep, strain) as a record.
/// Each value is 0–1, or null if that component had no data.
///
/// Copied from [readinessComponents].
@ProviderFor(readinessComponents)
const readinessComponentsProvider = ReadinessComponentsFamily();

/// Readiness component contributions (hrv, sleep, strain) as a record.
/// Each value is 0–1, or null if that component had no data.
///
/// Copied from [readinessComponents].
class ReadinessComponentsFamily
    extends Family<AsyncValue<({double? hrv, double? sleep, double? strain})>> {
  /// Readiness component contributions (hrv, sleep, strain) as a record.
  /// Each value is 0–1, or null if that component had no data.
  ///
  /// Copied from [readinessComponents].
  const ReadinessComponentsFamily();

  /// Readiness component contributions (hrv, sleep, strain) as a record.
  /// Each value is 0–1, or null if that component had no data.
  ///
  /// Copied from [readinessComponents].
  ReadinessComponentsProvider call({String? date}) {
    return ReadinessComponentsProvider(date: date);
  }

  @override
  ReadinessComponentsProvider getProviderOverride(
    covariant ReadinessComponentsProvider provider,
  ) {
    return call(date: provider.date);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'readinessComponentsProvider';
}

/// Readiness component contributions (hrv, sleep, strain) as a record.
/// Each value is 0–1, or null if that component had no data.
///
/// Copied from [readinessComponents].
class ReadinessComponentsProvider
    extends
        AutoDisposeFutureProvider<
          ({double? hrv, double? sleep, double? strain})
        > {
  /// Readiness component contributions (hrv, sleep, strain) as a record.
  /// Each value is 0–1, or null if that component had no data.
  ///
  /// Copied from [readinessComponents].
  ReadinessComponentsProvider({String? date})
    : this._internal(
        (ref) => readinessComponents(ref as ReadinessComponentsRef, date: date),
        from: readinessComponentsProvider,
        name: r'readinessComponentsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$readinessComponentsHash,
        dependencies: ReadinessComponentsFamily._dependencies,
        allTransitiveDependencies:
            ReadinessComponentsFamily._allTransitiveDependencies,
        date: date,
      );

  ReadinessComponentsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final String? date;

  @override
  Override overrideWith(
    FutureOr<({double? hrv, double? sleep, double? strain})> Function(
      ReadinessComponentsRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReadinessComponentsProvider._internal(
        (ref) => create(ref as ReadinessComponentsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<
    ({double? hrv, double? sleep, double? strain})
  >
  createElement() {
    return _ReadinessComponentsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReadinessComponentsProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ReadinessComponentsRef
    on
        AutoDisposeFutureProviderRef<
          ({double? hrv, double? sleep, double? strain})
        > {
  /// The parameter `date` of this provider.
  String? get date;
}

class _ReadinessComponentsProviderElement
    extends
        AutoDisposeFutureProviderElement<
          ({double? hrv, double? sleep, double? strain})
        >
    with ReadinessComponentsRef {
  _ReadinessComponentsProviderElement(super.provider);

  @override
  String? get date => (origin as ReadinessComponentsProvider).date;
}

String _$sleepScoreHash() => r'2cc1efa7991d84b4cd3b37121419e8f8c2b30209';

/// Today's sleep quality score (0–100), or null if not computed.
///
/// Copied from [sleepScore].
@ProviderFor(sleepScore)
const sleepScoreProvider = SleepScoreFamily();

/// Today's sleep quality score (0–100), or null if not computed.
///
/// Copied from [sleepScore].
class SleepScoreFamily extends Family<AsyncValue<double?>> {
  /// Today's sleep quality score (0–100), or null if not computed.
  ///
  /// Copied from [sleepScore].
  const SleepScoreFamily();

  /// Today's sleep quality score (0–100), or null if not computed.
  ///
  /// Copied from [sleepScore].
  SleepScoreProvider call({String? date}) {
    return SleepScoreProvider(date: date);
  }

  @override
  SleepScoreProvider getProviderOverride(
    covariant SleepScoreProvider provider,
  ) {
    return call(date: provider.date);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'sleepScoreProvider';
}

/// Today's sleep quality score (0–100), or null if not computed.
///
/// Copied from [sleepScore].
class SleepScoreProvider extends AutoDisposeFutureProvider<double?> {
  /// Today's sleep quality score (0–100), or null if not computed.
  ///
  /// Copied from [sleepScore].
  SleepScoreProvider({String? date})
    : this._internal(
        (ref) => sleepScore(ref as SleepScoreRef, date: date),
        from: sleepScoreProvider,
        name: r'sleepScoreProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$sleepScoreHash,
        dependencies: SleepScoreFamily._dependencies,
        allTransitiveDependencies: SleepScoreFamily._allTransitiveDependencies,
        date: date,
      );

  SleepScoreProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final String? date;

  @override
  Override overrideWith(
    FutureOr<double?> Function(SleepScoreRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SleepScoreProvider._internal(
        (ref) => create(ref as SleepScoreRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<double?> createElement() {
    return _SleepScoreProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SleepScoreProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SleepScoreRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _SleepScoreProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with SleepScoreRef {
  _SleepScoreProviderElement(super.provider);

  @override
  String? get date => (origin as SleepScoreProvider).date;
}

String _$sleepMinutesHash() => r'55bd4a9557997e1e59d20fac7d3768f719afaf26';

/// Today's sleep stage minutes as a record.
///
/// Copied from [sleepMinutes].
@ProviderFor(sleepMinutes)
const sleepMinutesProvider = SleepMinutesFamily();

/// Today's sleep stage minutes as a record.
///
/// Copied from [sleepMinutes].
class SleepMinutesFamily
    extends
        Family<
          AsyncValue<({double deep, double rem, double light, double total})>
        > {
  /// Today's sleep stage minutes as a record.
  ///
  /// Copied from [sleepMinutes].
  const SleepMinutesFamily();

  /// Today's sleep stage minutes as a record.
  ///
  /// Copied from [sleepMinutes].
  SleepMinutesProvider call({String? date}) {
    return SleepMinutesProvider(date: date);
  }

  @override
  SleepMinutesProvider getProviderOverride(
    covariant SleepMinutesProvider provider,
  ) {
    return call(date: provider.date);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'sleepMinutesProvider';
}

/// Today's sleep stage minutes as a record.
///
/// Copied from [sleepMinutes].
class SleepMinutesProvider
    extends
        AutoDisposeFutureProvider<
          ({double deep, double rem, double light, double total})
        > {
  /// Today's sleep stage minutes as a record.
  ///
  /// Copied from [sleepMinutes].
  SleepMinutesProvider({String? date})
    : this._internal(
        (ref) => sleepMinutes(ref as SleepMinutesRef, date: date),
        from: sleepMinutesProvider,
        name: r'sleepMinutesProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$sleepMinutesHash,
        dependencies: SleepMinutesFamily._dependencies,
        allTransitiveDependencies:
            SleepMinutesFamily._allTransitiveDependencies,
        date: date,
      );

  SleepMinutesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final String? date;

  @override
  Override overrideWith(
    FutureOr<({double deep, double rem, double light, double total})> Function(
      SleepMinutesRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SleepMinutesProvider._internal(
        (ref) => create(ref as SleepMinutesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<
    ({double deep, double rem, double light, double total})
  >
  createElement() {
    return _SleepMinutesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SleepMinutesProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SleepMinutesRef
    on
        AutoDisposeFutureProviderRef<
          ({double deep, double rem, double light, double total})
        > {
  /// The parameter `date` of this provider.
  String? get date;
}

class _SleepMinutesProviderElement
    extends
        AutoDisposeFutureProviderElement<
          ({double deep, double rem, double light, double total})
        >
    with SleepMinutesRef {
  _SleepMinutesProviderElement(super.provider);

  @override
  String? get date => (origin as SleepMinutesProvider).date;
}

String _$strainScoreHash() => r'ecf1898ee2add53d0665ef761a5c292608c2119f';

/// Today's strain score (0–100), or null if not computed.
///
/// Copied from [strainScore].
@ProviderFor(strainScore)
const strainScoreProvider = StrainScoreFamily();

/// Today's strain score (0–100), or null if not computed.
///
/// Copied from [strainScore].
class StrainScoreFamily extends Family<AsyncValue<double?>> {
  /// Today's strain score (0–100), or null if not computed.
  ///
  /// Copied from [strainScore].
  const StrainScoreFamily();

  /// Today's strain score (0–100), or null if not computed.
  ///
  /// Copied from [strainScore].
  StrainScoreProvider call({String? date}) {
    return StrainScoreProvider(date: date);
  }

  @override
  StrainScoreProvider getProviderOverride(
    covariant StrainScoreProvider provider,
  ) {
    return call(date: provider.date);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'strainScoreProvider';
}

/// Today's strain score (0–100), or null if not computed.
///
/// Copied from [strainScore].
class StrainScoreProvider extends AutoDisposeFutureProvider<double?> {
  /// Today's strain score (0–100), or null if not computed.
  ///
  /// Copied from [strainScore].
  StrainScoreProvider({String? date})
    : this._internal(
        (ref) => strainScore(ref as StrainScoreRef, date: date),
        from: strainScoreProvider,
        name: r'strainScoreProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$strainScoreHash,
        dependencies: StrainScoreFamily._dependencies,
        allTransitiveDependencies: StrainScoreFamily._allTransitiveDependencies,
        date: date,
      );

  StrainScoreProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.date,
  }) : super.internal();

  final String? date;

  @override
  Override overrideWith(
    FutureOr<double?> Function(StrainScoreRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StrainScoreProvider._internal(
        (ref) => create(ref as StrainScoreRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        date: date,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<double?> createElement() {
    return _StrainScoreProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StrainScoreProvider && other.date == date;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, date.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin StrainScoreRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _StrainScoreProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with StrainScoreRef {
  _StrainScoreProviderElement(super.provider);

  @override
  String? get date => (origin as StrainScoreProvider).date;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
