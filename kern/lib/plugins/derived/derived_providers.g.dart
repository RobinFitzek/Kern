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

/// Today's composite readiness score (0–100), or null if not yet computed.
/// This is the average of physical and mental for backward compatibility.
///
/// Copied from [readinessScore].
@ProviderFor(readinessScore)
const readinessScoreProvider = ReadinessScoreFamily();

/// Today's composite readiness score (0–100), or null if not yet computed.
/// This is the average of physical and mental for backward compatibility.
///
/// Copied from [readinessScore].
class ReadinessScoreFamily extends Family<AsyncValue<double?>> {
  /// Today's composite readiness score (0–100), or null if not yet computed.
  /// This is the average of physical and mental for backward compatibility.
  ///
  /// Copied from [readinessScore].
  const ReadinessScoreFamily();

  /// Today's composite readiness score (0–100), or null if not yet computed.
  /// This is the average of physical and mental for backward compatibility.
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

/// Today's composite readiness score (0–100), or null if not yet computed.
/// This is the average of physical and mental for backward compatibility.
///
/// Copied from [readinessScore].
class ReadinessScoreProvider extends AutoDisposeFutureProvider<double?> {
  /// Today's composite readiness score (0–100), or null if not yet computed.
  /// This is the average of physical and mental for backward compatibility.
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

String _$readinessPhysicalScoreHash() =>
    r'b15fd504f9ac1f9f53a5ccbc7e255be7da8876dd';

/// Today's Physical Readiness Score (0–100), final after Bayesian fusion.
///
/// Copied from [readinessPhysicalScore].
@ProviderFor(readinessPhysicalScore)
const readinessPhysicalScoreProvider = ReadinessPhysicalScoreFamily();

/// Today's Physical Readiness Score (0–100), final after Bayesian fusion.
///
/// Copied from [readinessPhysicalScore].
class ReadinessPhysicalScoreFamily extends Family<AsyncValue<double?>> {
  /// Today's Physical Readiness Score (0–100), final after Bayesian fusion.
  ///
  /// Copied from [readinessPhysicalScore].
  const ReadinessPhysicalScoreFamily();

  /// Today's Physical Readiness Score (0–100), final after Bayesian fusion.
  ///
  /// Copied from [readinessPhysicalScore].
  ReadinessPhysicalScoreProvider call({String? date}) {
    return ReadinessPhysicalScoreProvider(date: date);
  }

  @override
  ReadinessPhysicalScoreProvider getProviderOverride(
    covariant ReadinessPhysicalScoreProvider provider,
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
  String? get name => r'readinessPhysicalScoreProvider';
}

/// Today's Physical Readiness Score (0–100), final after Bayesian fusion.
///
/// Copied from [readinessPhysicalScore].
class ReadinessPhysicalScoreProvider
    extends AutoDisposeFutureProvider<double?> {
  /// Today's Physical Readiness Score (0–100), final after Bayesian fusion.
  ///
  /// Copied from [readinessPhysicalScore].
  ReadinessPhysicalScoreProvider({String? date})
    : this._internal(
        (ref) => readinessPhysicalScore(
          ref as ReadinessPhysicalScoreRef,
          date: date,
        ),
        from: readinessPhysicalScoreProvider,
        name: r'readinessPhysicalScoreProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$readinessPhysicalScoreHash,
        dependencies: ReadinessPhysicalScoreFamily._dependencies,
        allTransitiveDependencies:
            ReadinessPhysicalScoreFamily._allTransitiveDependencies,
        date: date,
      );

  ReadinessPhysicalScoreProvider._internal(
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
    FutureOr<double?> Function(ReadinessPhysicalScoreRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReadinessPhysicalScoreProvider._internal(
        (ref) => create(ref as ReadinessPhysicalScoreRef),
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
    return _ReadinessPhysicalScoreProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReadinessPhysicalScoreProvider && other.date == date;
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
mixin ReadinessPhysicalScoreRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _ReadinessPhysicalScoreProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with ReadinessPhysicalScoreRef {
  _ReadinessPhysicalScoreProviderElement(super.provider);

  @override
  String? get date => (origin as ReadinessPhysicalScoreProvider).date;
}

String _$readinessMentalScoreHash() =>
    r'60c2ee70305673fdf06968a8cd374193b9bc7ee7';

/// Today's Mental/Cognitive Readiness Score (0–100), final after Bayesian fusion.
///
/// Copied from [readinessMentalScore].
@ProviderFor(readinessMentalScore)
const readinessMentalScoreProvider = ReadinessMentalScoreFamily();

/// Today's Mental/Cognitive Readiness Score (0–100), final after Bayesian fusion.
///
/// Copied from [readinessMentalScore].
class ReadinessMentalScoreFamily extends Family<AsyncValue<double?>> {
  /// Today's Mental/Cognitive Readiness Score (0–100), final after Bayesian fusion.
  ///
  /// Copied from [readinessMentalScore].
  const ReadinessMentalScoreFamily();

  /// Today's Mental/Cognitive Readiness Score (0–100), final after Bayesian fusion.
  ///
  /// Copied from [readinessMentalScore].
  ReadinessMentalScoreProvider call({String? date}) {
    return ReadinessMentalScoreProvider(date: date);
  }

  @override
  ReadinessMentalScoreProvider getProviderOverride(
    covariant ReadinessMentalScoreProvider provider,
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
  String? get name => r'readinessMentalScoreProvider';
}

/// Today's Mental/Cognitive Readiness Score (0–100), final after Bayesian fusion.
///
/// Copied from [readinessMentalScore].
class ReadinessMentalScoreProvider extends AutoDisposeFutureProvider<double?> {
  /// Today's Mental/Cognitive Readiness Score (0–100), final after Bayesian fusion.
  ///
  /// Copied from [readinessMentalScore].
  ReadinessMentalScoreProvider({String? date})
    : this._internal(
        (ref) =>
            readinessMentalScore(ref as ReadinessMentalScoreRef, date: date),
        from: readinessMentalScoreProvider,
        name: r'readinessMentalScoreProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$readinessMentalScoreHash,
        dependencies: ReadinessMentalScoreFamily._dependencies,
        allTransitiveDependencies:
            ReadinessMentalScoreFamily._allTransitiveDependencies,
        date: date,
      );

  ReadinessMentalScoreProvider._internal(
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
    FutureOr<double?> Function(ReadinessMentalScoreRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReadinessMentalScoreProvider._internal(
        (ref) => create(ref as ReadinessMentalScoreRef),
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
    return _ReadinessMentalScoreProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReadinessMentalScoreProvider && other.date == date;
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
mixin ReadinessMentalScoreRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _ReadinessMentalScoreProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with ReadinessMentalScoreRef {
  _ReadinessMentalScoreProviderElement(super.provider);

  @override
  String? get date => (origin as ReadinessMentalScoreProvider).date;
}

String _$readinessBimodalScoresHash() =>
    r'3a141280c0ea634f938e5cf7dffc4b43838ba533';

/// Both bimodal scores as a single record — prevents double-fetch in UI.
///
/// Copied from [readinessBimodalScores].
@ProviderFor(readinessBimodalScores)
const readinessBimodalScoresProvider = ReadinessBimodalScoresFamily();

/// Both bimodal scores as a single record — prevents double-fetch in UI.
///
/// Copied from [readinessBimodalScores].
class ReadinessBimodalScoresFamily
    extends Family<AsyncValue<({double? physical, double? mental})>> {
  /// Both bimodal scores as a single record — prevents double-fetch in UI.
  ///
  /// Copied from [readinessBimodalScores].
  const ReadinessBimodalScoresFamily();

  /// Both bimodal scores as a single record — prevents double-fetch in UI.
  ///
  /// Copied from [readinessBimodalScores].
  ReadinessBimodalScoresProvider call({String? date}) {
    return ReadinessBimodalScoresProvider(date: date);
  }

  @override
  ReadinessBimodalScoresProvider getProviderOverride(
    covariant ReadinessBimodalScoresProvider provider,
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
  String? get name => r'readinessBimodalScoresProvider';
}

/// Both bimodal scores as a single record — prevents double-fetch in UI.
///
/// Copied from [readinessBimodalScores].
class ReadinessBimodalScoresProvider
    extends AutoDisposeFutureProvider<({double? physical, double? mental})> {
  /// Both bimodal scores as a single record — prevents double-fetch in UI.
  ///
  /// Copied from [readinessBimodalScores].
  ReadinessBimodalScoresProvider({String? date})
    : this._internal(
        (ref) => readinessBimodalScores(
          ref as ReadinessBimodalScoresRef,
          date: date,
        ),
        from: readinessBimodalScoresProvider,
        name: r'readinessBimodalScoresProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$readinessBimodalScoresHash,
        dependencies: ReadinessBimodalScoresFamily._dependencies,
        allTransitiveDependencies:
            ReadinessBimodalScoresFamily._allTransitiveDependencies,
        date: date,
      );

  ReadinessBimodalScoresProvider._internal(
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
    FutureOr<({double? physical, double? mental})> Function(
      ReadinessBimodalScoresRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReadinessBimodalScoresProvider._internal(
        (ref) => create(ref as ReadinessBimodalScoresRef),
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
  AutoDisposeFutureProviderElement<({double? physical, double? mental})>
  createElement() {
    return _ReadinessBimodalScoresProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReadinessBimodalScoresProvider && other.date == date;
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
mixin ReadinessBimodalScoresRef
    on AutoDisposeFutureProviderRef<({double? physical, double? mental})> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _ReadinessBimodalScoresProviderElement
    extends
        AutoDisposeFutureProviderElement<({double? physical, double? mental})>
    with ReadinessBimodalScoresRef {
  _ReadinessBimodalScoresProviderElement(super.provider);

  @override
  String? get date => (origin as ReadinessBimodalScoresProvider).date;
}

String _$readinessPhysicalComponentsHash() =>
    r'b45ae6a96e494229e436cc8317340daa82c70001';

/// Physical score component breakdown, parsed from JSON metadata.
///
/// Copied from [readinessPhysicalComponents].
@ProviderFor(readinessPhysicalComponents)
const readinessPhysicalComponentsProvider = ReadinessPhysicalComponentsFamily();

/// Physical score component breakdown, parsed from JSON metadata.
///
/// Copied from [readinessPhysicalComponents].
class ReadinessPhysicalComponentsFamily
    extends Family<AsyncValue<Map<String, double>?>> {
  /// Physical score component breakdown, parsed from JSON metadata.
  ///
  /// Copied from [readinessPhysicalComponents].
  const ReadinessPhysicalComponentsFamily();

  /// Physical score component breakdown, parsed from JSON metadata.
  ///
  /// Copied from [readinessPhysicalComponents].
  ReadinessPhysicalComponentsProvider call({String? date}) {
    return ReadinessPhysicalComponentsProvider(date: date);
  }

  @override
  ReadinessPhysicalComponentsProvider getProviderOverride(
    covariant ReadinessPhysicalComponentsProvider provider,
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
  String? get name => r'readinessPhysicalComponentsProvider';
}

/// Physical score component breakdown, parsed from JSON metadata.
///
/// Copied from [readinessPhysicalComponents].
class ReadinessPhysicalComponentsProvider
    extends AutoDisposeFutureProvider<Map<String, double>?> {
  /// Physical score component breakdown, parsed from JSON metadata.
  ///
  /// Copied from [readinessPhysicalComponents].
  ReadinessPhysicalComponentsProvider({String? date})
    : this._internal(
        (ref) => readinessPhysicalComponents(
          ref as ReadinessPhysicalComponentsRef,
          date: date,
        ),
        from: readinessPhysicalComponentsProvider,
        name: r'readinessPhysicalComponentsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$readinessPhysicalComponentsHash,
        dependencies: ReadinessPhysicalComponentsFamily._dependencies,
        allTransitiveDependencies:
            ReadinessPhysicalComponentsFamily._allTransitiveDependencies,
        date: date,
      );

  ReadinessPhysicalComponentsProvider._internal(
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
    FutureOr<Map<String, double>?> Function(
      ReadinessPhysicalComponentsRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReadinessPhysicalComponentsProvider._internal(
        (ref) => create(ref as ReadinessPhysicalComponentsRef),
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
  AutoDisposeFutureProviderElement<Map<String, double>?> createElement() {
    return _ReadinessPhysicalComponentsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReadinessPhysicalComponentsProvider && other.date == date;
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
mixin ReadinessPhysicalComponentsRef
    on AutoDisposeFutureProviderRef<Map<String, double>?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _ReadinessPhysicalComponentsProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, double>?>
    with ReadinessPhysicalComponentsRef {
  _ReadinessPhysicalComponentsProviderElement(super.provider);

  @override
  String? get date => (origin as ReadinessPhysicalComponentsProvider).date;
}

String _$readinessMentalComponentsHash() =>
    r'599c96e759c1308052dba54d48734fa325d1900b';

/// Mental score component breakdown, parsed from JSON metadata.
///
/// Copied from [readinessMentalComponents].
@ProviderFor(readinessMentalComponents)
const readinessMentalComponentsProvider = ReadinessMentalComponentsFamily();

/// Mental score component breakdown, parsed from JSON metadata.
///
/// Copied from [readinessMentalComponents].
class ReadinessMentalComponentsFamily
    extends Family<AsyncValue<Map<String, double>?>> {
  /// Mental score component breakdown, parsed from JSON metadata.
  ///
  /// Copied from [readinessMentalComponents].
  const ReadinessMentalComponentsFamily();

  /// Mental score component breakdown, parsed from JSON metadata.
  ///
  /// Copied from [readinessMentalComponents].
  ReadinessMentalComponentsProvider call({String? date}) {
    return ReadinessMentalComponentsProvider(date: date);
  }

  @override
  ReadinessMentalComponentsProvider getProviderOverride(
    covariant ReadinessMentalComponentsProvider provider,
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
  String? get name => r'readinessMentalComponentsProvider';
}

/// Mental score component breakdown, parsed from JSON metadata.
///
/// Copied from [readinessMentalComponents].
class ReadinessMentalComponentsProvider
    extends AutoDisposeFutureProvider<Map<String, double>?> {
  /// Mental score component breakdown, parsed from JSON metadata.
  ///
  /// Copied from [readinessMentalComponents].
  ReadinessMentalComponentsProvider({String? date})
    : this._internal(
        (ref) => readinessMentalComponents(
          ref as ReadinessMentalComponentsRef,
          date: date,
        ),
        from: readinessMentalComponentsProvider,
        name: r'readinessMentalComponentsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$readinessMentalComponentsHash,
        dependencies: ReadinessMentalComponentsFamily._dependencies,
        allTransitiveDependencies:
            ReadinessMentalComponentsFamily._allTransitiveDependencies,
        date: date,
      );

  ReadinessMentalComponentsProvider._internal(
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
    FutureOr<Map<String, double>?> Function(
      ReadinessMentalComponentsRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReadinessMentalComponentsProvider._internal(
        (ref) => create(ref as ReadinessMentalComponentsRef),
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
  AutoDisposeFutureProviderElement<Map<String, double>?> createElement() {
    return _ReadinessMentalComponentsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReadinessMentalComponentsProvider && other.date == date;
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
mixin ReadinessMentalComponentsRef
    on AutoDisposeFutureProviderRef<Map<String, double>?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _ReadinessMentalComponentsProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, double>?>
    with ReadinessMentalComponentsRef {
  _ReadinessMentalComponentsProviderElement(super.provider);

  @override
  String? get date => (origin as ReadinessMentalComponentsProvider).date;
}

String _$readinessSriHash() => r'f5ec67a4394200adaef8066ef3c3bbbe893edf77';

/// Sleep Regularity Index value (-100 to +100) for display.
///
/// Copied from [readinessSri].
@ProviderFor(readinessSri)
const readinessSriProvider = ReadinessSriFamily();

/// Sleep Regularity Index value (-100 to +100) for display.
///
/// Copied from [readinessSri].
class ReadinessSriFamily extends Family<AsyncValue<double?>> {
  /// Sleep Regularity Index value (-100 to +100) for display.
  ///
  /// Copied from [readinessSri].
  const ReadinessSriFamily();

  /// Sleep Regularity Index value (-100 to +100) for display.
  ///
  /// Copied from [readinessSri].
  ReadinessSriProvider call({String? date}) {
    return ReadinessSriProvider(date: date);
  }

  @override
  ReadinessSriProvider getProviderOverride(
    covariant ReadinessSriProvider provider,
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
  String? get name => r'readinessSriProvider';
}

/// Sleep Regularity Index value (-100 to +100) for display.
///
/// Copied from [readinessSri].
class ReadinessSriProvider extends AutoDisposeFutureProvider<double?> {
  /// Sleep Regularity Index value (-100 to +100) for display.
  ///
  /// Copied from [readinessSri].
  ReadinessSriProvider({String? date})
    : this._internal(
        (ref) => readinessSri(ref as ReadinessSriRef, date: date),
        from: readinessSriProvider,
        name: r'readinessSriProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$readinessSriHash,
        dependencies: ReadinessSriFamily._dependencies,
        allTransitiveDependencies:
            ReadinessSriFamily._allTransitiveDependencies,
        date: date,
      );

  ReadinessSriProvider._internal(
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
    FutureOr<double?> Function(ReadinessSriRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReadinessSriProvider._internal(
        (ref) => create(ref as ReadinessSriRef),
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
    return _ReadinessSriProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReadinessSriProvider && other.date == date;
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
mixin ReadinessSriRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _ReadinessSriProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with ReadinessSriRef {
  _ReadinessSriProviderElement(super.provider);

  @override
  String? get date => (origin as ReadinessSriProvider).date;
}

String _$readinessAcwrHash() => r'd6520d15b3f9dac40142531146311d121cadaa02';

/// ACWR (Acute:Chronic Workload Ratio) for display.
///
/// Copied from [readinessAcwr].
@ProviderFor(readinessAcwr)
const readinessAcwrProvider = ReadinessAcwrFamily();

/// ACWR (Acute:Chronic Workload Ratio) for display.
///
/// Copied from [readinessAcwr].
class ReadinessAcwrFamily extends Family<AsyncValue<double?>> {
  /// ACWR (Acute:Chronic Workload Ratio) for display.
  ///
  /// Copied from [readinessAcwr].
  const ReadinessAcwrFamily();

  /// ACWR (Acute:Chronic Workload Ratio) for display.
  ///
  /// Copied from [readinessAcwr].
  ReadinessAcwrProvider call({String? date}) {
    return ReadinessAcwrProvider(date: date);
  }

  @override
  ReadinessAcwrProvider getProviderOverride(
    covariant ReadinessAcwrProvider provider,
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
  String? get name => r'readinessAcwrProvider';
}

/// ACWR (Acute:Chronic Workload Ratio) for display.
///
/// Copied from [readinessAcwr].
class ReadinessAcwrProvider extends AutoDisposeFutureProvider<double?> {
  /// ACWR (Acute:Chronic Workload Ratio) for display.
  ///
  /// Copied from [readinessAcwr].
  ReadinessAcwrProvider({String? date})
    : this._internal(
        (ref) => readinessAcwr(ref as ReadinessAcwrRef, date: date),
        from: readinessAcwrProvider,
        name: r'readinessAcwrProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$readinessAcwrHash,
        dependencies: ReadinessAcwrFamily._dependencies,
        allTransitiveDependencies:
            ReadinessAcwrFamily._allTransitiveDependencies,
        date: date,
      );

  ReadinessAcwrProvider._internal(
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
    FutureOr<double?> Function(ReadinessAcwrRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReadinessAcwrProvider._internal(
        (ref) => create(ref as ReadinessAcwrRef),
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
    return _ReadinessAcwrProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReadinessAcwrProvider && other.date == date;
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
mixin ReadinessAcwrRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _ReadinessAcwrProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with ReadinessAcwrRef {
  _ReadinessAcwrProviderElement(super.provider);

  @override
  String? get date => (origin as ReadinessAcwrProvider).date;
}

String _$todayFeedbackHash() => r'c69a3722d92c6138349804f51fe0beafa00724ed';

/// Today's user feedback entry (Soreness, Energy, Stress).
/// Returns null if the user has not submitted today's check-in yet.
///
/// Copied from [todayFeedback].
@ProviderFor(todayFeedback)
final todayFeedbackProvider =
    AutoDisposeStreamProvider<UserFeedbackViewModel?>.internal(
      todayFeedback,
      name: r'todayFeedbackProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$todayFeedbackHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef TodayFeedbackRef = AutoDisposeStreamProviderRef<UserFeedbackViewModel?>;
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

String _$aiInsightHash() => r'888d2d2a62fea02c05a601967c8e7818d7d3247c';

/// Today's AI coaching insight, or null if not yet generated.
///
/// Copied from [aiInsight].
@ProviderFor(aiInsight)
const aiInsightProvider = AiInsightFamily();

/// Today's AI coaching insight, or null if not yet generated.
///
/// Copied from [aiInsight].
class AiInsightFamily extends Family<AsyncValue<Map<String, String>?>> {
  /// Today's AI coaching insight, or null if not yet generated.
  ///
  /// Copied from [aiInsight].
  const AiInsightFamily();

  /// Today's AI coaching insight, or null if not yet generated.
  ///
  /// Copied from [aiInsight].
  AiInsightProvider call({String? date}) {
    return AiInsightProvider(date: date);
  }

  @override
  AiInsightProvider getProviderOverride(covariant AiInsightProvider provider) {
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
  String? get name => r'aiInsightProvider';
}

/// Today's AI coaching insight, or null if not yet generated.
///
/// Copied from [aiInsight].
class AiInsightProvider
    extends AutoDisposeFutureProvider<Map<String, String>?> {
  /// Today's AI coaching insight, or null if not yet generated.
  ///
  /// Copied from [aiInsight].
  AiInsightProvider({String? date})
    : this._internal(
        (ref) => aiInsight(ref as AiInsightRef, date: date),
        from: aiInsightProvider,
        name: r'aiInsightProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$aiInsightHash,
        dependencies: AiInsightFamily._dependencies,
        allTransitiveDependencies: AiInsightFamily._allTransitiveDependencies,
        date: date,
      );

  AiInsightProvider._internal(
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
    FutureOr<Map<String, String>?> Function(AiInsightRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AiInsightProvider._internal(
        (ref) => create(ref as AiInsightRef),
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
  AutoDisposeFutureProviderElement<Map<String, String>?> createElement() {
    return _AiInsightProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AiInsightProvider && other.date == date;
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
mixin AiInsightRef on AutoDisposeFutureProviderRef<Map<String, String>?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _AiInsightProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, String>?>
    with AiInsightRef {
  _AiInsightProviderElement(super.provider);

  @override
  String? get date => (origin as AiInsightProvider).date;
}

String _$strainStepsYesterdayHash() =>
    r'c8f53a92549526a7b8e9472fb7dfcf65aab217bf';

/// Yesterday's total steps from Derived Store.
///
/// Copied from [strainStepsYesterday].
@ProviderFor(strainStepsYesterday)
const strainStepsYesterdayProvider = StrainStepsYesterdayFamily();

/// Yesterday's total steps from Derived Store.
///
/// Copied from [strainStepsYesterday].
class StrainStepsYesterdayFamily extends Family<AsyncValue<double?>> {
  /// Yesterday's total steps from Derived Store.
  ///
  /// Copied from [strainStepsYesterday].
  const StrainStepsYesterdayFamily();

  /// Yesterday's total steps from Derived Store.
  ///
  /// Copied from [strainStepsYesterday].
  StrainStepsYesterdayProvider call({String? date}) {
    return StrainStepsYesterdayProvider(date: date);
  }

  @override
  StrainStepsYesterdayProvider getProviderOverride(
    covariant StrainStepsYesterdayProvider provider,
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
  String? get name => r'strainStepsYesterdayProvider';
}

/// Yesterday's total steps from Derived Store.
///
/// Copied from [strainStepsYesterday].
class StrainStepsYesterdayProvider extends AutoDisposeFutureProvider<double?> {
  /// Yesterday's total steps from Derived Store.
  ///
  /// Copied from [strainStepsYesterday].
  StrainStepsYesterdayProvider({String? date})
    : this._internal(
        (ref) =>
            strainStepsYesterday(ref as StrainStepsYesterdayRef, date: date),
        from: strainStepsYesterdayProvider,
        name: r'strainStepsYesterdayProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$strainStepsYesterdayHash,
        dependencies: StrainStepsYesterdayFamily._dependencies,
        allTransitiveDependencies:
            StrainStepsYesterdayFamily._allTransitiveDependencies,
        date: date,
      );

  StrainStepsYesterdayProvider._internal(
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
    FutureOr<double?> Function(StrainStepsYesterdayRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StrainStepsYesterdayProvider._internal(
        (ref) => create(ref as StrainStepsYesterdayRef),
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
    return _StrainStepsYesterdayProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StrainStepsYesterdayProvider && other.date == date;
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
mixin StrainStepsYesterdayRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _StrainStepsYesterdayProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with StrainStepsYesterdayRef {
  _StrainStepsYesterdayProviderElement(super.provider);

  @override
  String? get date => (origin as StrainStepsYesterdayProvider).date;
}

String _$strainSteps7dAvgHash() => r'67313caeaa1f82195fc78e263c6e8b1ec0d88188';

/// 7-day average steps from Derived Store.
///
/// Copied from [strainSteps7dAvg].
@ProviderFor(strainSteps7dAvg)
const strainSteps7dAvgProvider = StrainSteps7dAvgFamily();

/// 7-day average steps from Derived Store.
///
/// Copied from [strainSteps7dAvg].
class StrainSteps7dAvgFamily extends Family<AsyncValue<double?>> {
  /// 7-day average steps from Derived Store.
  ///
  /// Copied from [strainSteps7dAvg].
  const StrainSteps7dAvgFamily();

  /// 7-day average steps from Derived Store.
  ///
  /// Copied from [strainSteps7dAvg].
  StrainSteps7dAvgProvider call({String? date}) {
    return StrainSteps7dAvgProvider(date: date);
  }

  @override
  StrainSteps7dAvgProvider getProviderOverride(
    covariant StrainSteps7dAvgProvider provider,
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
  String? get name => r'strainSteps7dAvgProvider';
}

/// 7-day average steps from Derived Store.
///
/// Copied from [strainSteps7dAvg].
class StrainSteps7dAvgProvider extends AutoDisposeFutureProvider<double?> {
  /// 7-day average steps from Derived Store.
  ///
  /// Copied from [strainSteps7dAvg].
  StrainSteps7dAvgProvider({String? date})
    : this._internal(
        (ref) => strainSteps7dAvg(ref as StrainSteps7dAvgRef, date: date),
        from: strainSteps7dAvgProvider,
        name: r'strainSteps7dAvgProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$strainSteps7dAvgHash,
        dependencies: StrainSteps7dAvgFamily._dependencies,
        allTransitiveDependencies:
            StrainSteps7dAvgFamily._allTransitiveDependencies,
        date: date,
      );

  StrainSteps7dAvgProvider._internal(
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
    FutureOr<double?> Function(StrainSteps7dAvgRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StrainSteps7dAvgProvider._internal(
        (ref) => create(ref as StrainSteps7dAvgRef),
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
    return _StrainSteps7dAvgProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StrainSteps7dAvgProvider && other.date == date;
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
mixin StrainSteps7dAvgRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _StrainSteps7dAvgProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with StrainSteps7dAvgRef {
  _StrainSteps7dAvgProviderElement(super.provider);

  @override
  String? get date => (origin as StrainSteps7dAvgProvider).date;
}

String _$dailyInsightsHash() => r'0f51cb53fa90aa1731c769fe060575b4fe83984b';

/// Three daily insights (Erholung, Schlaf, Belastung) generated from
/// readiness, sleep, and strain data.
///
/// Copied from [dailyInsights].
@ProviderFor(dailyInsights)
const dailyInsightsProvider = DailyInsightsFamily();

/// Three daily insights (Erholung, Schlaf, Belastung) generated from
/// readiness, sleep, and strain data.
///
/// Copied from [dailyInsights].
class DailyInsightsFamily extends Family<AsyncValue<List<DailyInsight>>> {
  /// Three daily insights (Erholung, Schlaf, Belastung) generated from
  /// readiness, sleep, and strain data.
  ///
  /// Copied from [dailyInsights].
  const DailyInsightsFamily();

  /// Three daily insights (Erholung, Schlaf, Belastung) generated from
  /// readiness, sleep, and strain data.
  ///
  /// Copied from [dailyInsights].
  DailyInsightsProvider call({String? date}) {
    return DailyInsightsProvider(date: date);
  }

  @override
  DailyInsightsProvider getProviderOverride(
    covariant DailyInsightsProvider provider,
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
  String? get name => r'dailyInsightsProvider';
}

/// Three daily insights (Erholung, Schlaf, Belastung) generated from
/// readiness, sleep, and strain data.
///
/// Copied from [dailyInsights].
class DailyInsightsProvider
    extends AutoDisposeFutureProvider<List<DailyInsight>> {
  /// Three daily insights (Erholung, Schlaf, Belastung) generated from
  /// readiness, sleep, and strain data.
  ///
  /// Copied from [dailyInsights].
  DailyInsightsProvider({String? date})
    : this._internal(
        (ref) => dailyInsights(ref as DailyInsightsRef, date: date),
        from: dailyInsightsProvider,
        name: r'dailyInsightsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$dailyInsightsHash,
        dependencies: DailyInsightsFamily._dependencies,
        allTransitiveDependencies:
            DailyInsightsFamily._allTransitiveDependencies,
        date: date,
      );

  DailyInsightsProvider._internal(
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
    FutureOr<List<DailyInsight>> Function(DailyInsightsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DailyInsightsProvider._internal(
        (ref) => create(ref as DailyInsightsRef),
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
  AutoDisposeFutureProviderElement<List<DailyInsight>> createElement() {
    return _DailyInsightsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DailyInsightsProvider && other.date == date;
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
mixin DailyInsightsRef on AutoDisposeFutureProviderRef<List<DailyInsight>> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _DailyInsightsProviderElement
    extends AutoDisposeFutureProviderElement<List<DailyInsight>>
    with DailyInsightsRef {
  _DailyInsightsProviderElement(super.provider);

  @override
  String? get date => (origin as DailyInsightsProvider).date;
}

String _$readinessDataCountsHash() =>
    r'4d09229f5ce7ddf3ed30f0830ab795629bfaa48c';

/// Counts distinct days with raw data per type (for calibration progress UI).
///
/// Copied from [readinessDataCounts].
@ProviderFor(readinessDataCounts)
final readinessDataCountsProvider =
    AutoDisposeFutureProvider<({int hrvDays, int sleepNights})>.internal(
      readinessDataCounts,
      name: r'readinessDataCountsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$readinessDataCountsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReadinessDataCountsRef =
    AutoDisposeFutureProviderRef<({int hrvDays, int sleepNights})>;
String _$historicalReadinessScoresHash() =>
    r'542ea85ff9d4037158f993572981f9f8d6ebf270';

/// Historical readiness scores over [days] for trend chart.
///
/// Copied from [historicalReadinessScores].
@ProviderFor(historicalReadinessScores)
const historicalReadinessScoresProvider = HistoricalReadinessScoresFamily();

/// Historical readiness scores over [days] for trend chart.
///
/// Copied from [historicalReadinessScores].
class HistoricalReadinessScoresFamily
    extends
        Family<
          AsyncValue<List<({String date, double? physical, double? mental})>>
        > {
  /// Historical readiness scores over [days] for trend chart.
  ///
  /// Copied from [historicalReadinessScores].
  const HistoricalReadinessScoresFamily();

  /// Historical readiness scores over [days] for trend chart.
  ///
  /// Copied from [historicalReadinessScores].
  HistoricalReadinessScoresProvider call({int days = 14}) {
    return HistoricalReadinessScoresProvider(days: days);
  }

  @override
  HistoricalReadinessScoresProvider getProviderOverride(
    covariant HistoricalReadinessScoresProvider provider,
  ) {
    return call(days: provider.days);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'historicalReadinessScoresProvider';
}

/// Historical readiness scores over [days] for trend chart.
///
/// Copied from [historicalReadinessScores].
class HistoricalReadinessScoresProvider
    extends
        AutoDisposeFutureProvider<
          List<({String date, double? physical, double? mental})>
        > {
  /// Historical readiness scores over [days] for trend chart.
  ///
  /// Copied from [historicalReadinessScores].
  HistoricalReadinessScoresProvider({int days = 14})
    : this._internal(
        (ref) => historicalReadinessScores(
          ref as HistoricalReadinessScoresRef,
          days: days,
        ),
        from: historicalReadinessScoresProvider,
        name: r'historicalReadinessScoresProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$historicalReadinessScoresHash,
        dependencies: HistoricalReadinessScoresFamily._dependencies,
        allTransitiveDependencies:
            HistoricalReadinessScoresFamily._allTransitiveDependencies,
        days: days,
      );

  HistoricalReadinessScoresProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.days,
  }) : super.internal();

  final int days;

  @override
  Override overrideWith(
    FutureOr<List<({String date, double? physical, double? mental})>> Function(
      HistoricalReadinessScoresRef provider,
    )
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HistoricalReadinessScoresProvider._internal(
        (ref) => create(ref as HistoricalReadinessScoresRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        days: days,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<
    List<({String date, double? physical, double? mental})>
  >
  createElement() {
    return _HistoricalReadinessScoresProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HistoricalReadinessScoresProvider && other.days == days;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, days.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HistoricalReadinessScoresRef
    on
        AutoDisposeFutureProviderRef<
          List<({String date, double? physical, double? mental})>
        > {
  /// The parameter `days` of this provider.
  int get days;
}

class _HistoricalReadinessScoresProviderElement
    extends
        AutoDisposeFutureProviderElement<
          List<({String date, double? physical, double? mental})>
        >
    with HistoricalReadinessScoresRef {
  _HistoricalReadinessScoresProviderElement(super.provider);

  @override
  int get days => (origin as HistoricalReadinessScoresProvider).days;
}

String _$hydrationDailyMlHash() => r'd6fa20e21fc75ff8a5c5a4b2435460cb1a5b4314';

/// Today's total water intake in ml, or null.
///
/// Copied from [hydrationDailyMl].
@ProviderFor(hydrationDailyMl)
const hydrationDailyMlProvider = HydrationDailyMlFamily();

/// Today's total water intake in ml, or null.
///
/// Copied from [hydrationDailyMl].
class HydrationDailyMlFamily extends Family<AsyncValue<double?>> {
  /// Today's total water intake in ml, or null.
  ///
  /// Copied from [hydrationDailyMl].
  const HydrationDailyMlFamily();

  /// Today's total water intake in ml, or null.
  ///
  /// Copied from [hydrationDailyMl].
  HydrationDailyMlProvider call({String? date}) {
    return HydrationDailyMlProvider(date: date);
  }

  @override
  HydrationDailyMlProvider getProviderOverride(
    covariant HydrationDailyMlProvider provider,
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
  String? get name => r'hydrationDailyMlProvider';
}

/// Today's total water intake in ml, or null.
///
/// Copied from [hydrationDailyMl].
class HydrationDailyMlProvider extends AutoDisposeFutureProvider<double?> {
  /// Today's total water intake in ml, or null.
  ///
  /// Copied from [hydrationDailyMl].
  HydrationDailyMlProvider({String? date})
    : this._internal(
        (ref) => hydrationDailyMl(ref as HydrationDailyMlRef, date: date),
        from: hydrationDailyMlProvider,
        name: r'hydrationDailyMlProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$hydrationDailyMlHash,
        dependencies: HydrationDailyMlFamily._dependencies,
        allTransitiveDependencies:
            HydrationDailyMlFamily._allTransitiveDependencies,
        date: date,
      );

  HydrationDailyMlProvider._internal(
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
    FutureOr<double?> Function(HydrationDailyMlRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HydrationDailyMlProvider._internal(
        (ref) => create(ref as HydrationDailyMlRef),
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
    return _HydrationDailyMlProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HydrationDailyMlProvider && other.date == date;
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
mixin HydrationDailyMlRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _HydrationDailyMlProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with HydrationDailyMlRef {
  _HydrationDailyMlProviderElement(super.provider);

  @override
  String? get date => (origin as HydrationDailyMlProvider).date;
}

String _$hydrationGoalPercentHash() =>
    r'a4e738e4a76c36da8c71e72fd1007165cc34eaab';

/// Today's hydration goal percentage (0–100), or null.
///
/// Copied from [hydrationGoalPercent].
@ProviderFor(hydrationGoalPercent)
const hydrationGoalPercentProvider = HydrationGoalPercentFamily();

/// Today's hydration goal percentage (0–100), or null.
///
/// Copied from [hydrationGoalPercent].
class HydrationGoalPercentFamily extends Family<AsyncValue<double?>> {
  /// Today's hydration goal percentage (0–100), or null.
  ///
  /// Copied from [hydrationGoalPercent].
  const HydrationGoalPercentFamily();

  /// Today's hydration goal percentage (0–100), or null.
  ///
  /// Copied from [hydrationGoalPercent].
  HydrationGoalPercentProvider call({String? date}) {
    return HydrationGoalPercentProvider(date: date);
  }

  @override
  HydrationGoalPercentProvider getProviderOverride(
    covariant HydrationGoalPercentProvider provider,
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
  String? get name => r'hydrationGoalPercentProvider';
}

/// Today's hydration goal percentage (0–100), or null.
///
/// Copied from [hydrationGoalPercent].
class HydrationGoalPercentProvider extends AutoDisposeFutureProvider<double?> {
  /// Today's hydration goal percentage (0–100), or null.
  ///
  /// Copied from [hydrationGoalPercent].
  HydrationGoalPercentProvider({String? date})
    : this._internal(
        (ref) =>
            hydrationGoalPercent(ref as HydrationGoalPercentRef, date: date),
        from: hydrationGoalPercentProvider,
        name: r'hydrationGoalPercentProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$hydrationGoalPercentHash,
        dependencies: HydrationGoalPercentFamily._dependencies,
        allTransitiveDependencies:
            HydrationGoalPercentFamily._allTransitiveDependencies,
        date: date,
      );

  HydrationGoalPercentProvider._internal(
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
    FutureOr<double?> Function(HydrationGoalPercentRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HydrationGoalPercentProvider._internal(
        (ref) => create(ref as HydrationGoalPercentRef),
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
    return _HydrationGoalPercentProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HydrationGoalPercentProvider && other.date == date;
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
mixin HydrationGoalPercentRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _HydrationGoalPercentProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with HydrationGoalPercentRef {
  _HydrationGoalPercentProviderElement(super.provider);

  @override
  String? get date => (origin as HydrationGoalPercentProvider).date;
}

String _$recoveryScoreHash() => r'31d5773090ac9d4dd98770503822a7e8350919af';

/// See also [recoveryScore].
@ProviderFor(recoveryScore)
const recoveryScoreProvider = RecoveryScoreFamily();

/// See also [recoveryScore].
class RecoveryScoreFamily extends Family<AsyncValue<double?>> {
  /// See also [recoveryScore].
  const RecoveryScoreFamily();

  /// See also [recoveryScore].
  RecoveryScoreProvider call({String? date}) {
    return RecoveryScoreProvider(date: date);
  }

  @override
  RecoveryScoreProvider getProviderOverride(
    covariant RecoveryScoreProvider provider,
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
  String? get name => r'recoveryScoreProvider';
}

/// See also [recoveryScore].
class RecoveryScoreProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [recoveryScore].
  RecoveryScoreProvider({String? date})
    : this._internal(
        (ref) => recoveryScore(ref as RecoveryScoreRef, date: date),
        from: recoveryScoreProvider,
        name: r'recoveryScoreProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$recoveryScoreHash,
        dependencies: RecoveryScoreFamily._dependencies,
        allTransitiveDependencies:
            RecoveryScoreFamily._allTransitiveDependencies,
        date: date,
      );

  RecoveryScoreProvider._internal(
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
    FutureOr<double?> Function(RecoveryScoreRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RecoveryScoreProvider._internal(
        (ref) => create(ref as RecoveryScoreRef),
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
    return _RecoveryScoreProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecoveryScoreProvider && other.date == date;
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
mixin RecoveryScoreRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _RecoveryScoreProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with RecoveryScoreRef {
  _RecoveryScoreProviderElement(super.provider);

  @override
  String? get date => (origin as RecoveryScoreProvider).date;
}

String _$recoveryStateHash() => r'587d4b5d77499b44ae9c00f39b6c6593846a7269';

/// See also [recoveryState].
@ProviderFor(recoveryState)
const recoveryStateProvider = RecoveryStateFamily();

/// See also [recoveryState].
class RecoveryStateFamily extends Family<AsyncValue<String?>> {
  /// See also [recoveryState].
  const RecoveryStateFamily();

  /// See also [recoveryState].
  RecoveryStateProvider call({String? date}) {
    return RecoveryStateProvider(date: date);
  }

  @override
  RecoveryStateProvider getProviderOverride(
    covariant RecoveryStateProvider provider,
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
  String? get name => r'recoveryStateProvider';
}

/// See also [recoveryState].
class RecoveryStateProvider extends AutoDisposeFutureProvider<String?> {
  /// See also [recoveryState].
  RecoveryStateProvider({String? date})
    : this._internal(
        (ref) => recoveryState(ref as RecoveryStateRef, date: date),
        from: recoveryStateProvider,
        name: r'recoveryStateProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$recoveryStateHash,
        dependencies: RecoveryStateFamily._dependencies,
        allTransitiveDependencies:
            RecoveryStateFamily._allTransitiveDependencies,
        date: date,
      );

  RecoveryStateProvider._internal(
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
    FutureOr<String?> Function(RecoveryStateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RecoveryStateProvider._internal(
        (ref) => create(ref as RecoveryStateRef),
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
  AutoDisposeFutureProviderElement<String?> createElement() {
    return _RecoveryStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecoveryStateProvider && other.date == date;
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
mixin RecoveryStateRef on AutoDisposeFutureProviderRef<String?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _RecoveryStateProviderElement
    extends AutoDisposeFutureProviderElement<String?>
    with RecoveryStateRef {
  _RecoveryStateProviderElement(super.provider);

  @override
  String? get date => (origin as RecoveryStateProvider).date;
}

String _$recoveryHrvTrendHash() => r'3b963e80ace32e1a795fda9235fa2ab2e30cab0c';

/// See also [recoveryHrvTrend].
@ProviderFor(recoveryHrvTrend)
const recoveryHrvTrendProvider = RecoveryHrvTrendFamily();

/// See also [recoveryHrvTrend].
class RecoveryHrvTrendFamily extends Family<AsyncValue<double?>> {
  /// See also [recoveryHrvTrend].
  const RecoveryHrvTrendFamily();

  /// See also [recoveryHrvTrend].
  RecoveryHrvTrendProvider call({String? date}) {
    return RecoveryHrvTrendProvider(date: date);
  }

  @override
  RecoveryHrvTrendProvider getProviderOverride(
    covariant RecoveryHrvTrendProvider provider,
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
  String? get name => r'recoveryHrvTrendProvider';
}

/// See also [recoveryHrvTrend].
class RecoveryHrvTrendProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [recoveryHrvTrend].
  RecoveryHrvTrendProvider({String? date})
    : this._internal(
        (ref) => recoveryHrvTrend(ref as RecoveryHrvTrendRef, date: date),
        from: recoveryHrvTrendProvider,
        name: r'recoveryHrvTrendProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$recoveryHrvTrendHash,
        dependencies: RecoveryHrvTrendFamily._dependencies,
        allTransitiveDependencies:
            RecoveryHrvTrendFamily._allTransitiveDependencies,
        date: date,
      );

  RecoveryHrvTrendProvider._internal(
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
    FutureOr<double?> Function(RecoveryHrvTrendRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RecoveryHrvTrendProvider._internal(
        (ref) => create(ref as RecoveryHrvTrendRef),
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
    return _RecoveryHrvTrendProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecoveryHrvTrendProvider && other.date == date;
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
mixin RecoveryHrvTrendRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _RecoveryHrvTrendProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with RecoveryHrvTrendRef {
  _RecoveryHrvTrendProviderElement(super.provider);

  @override
  String? get date => (origin as RecoveryHrvTrendProvider).date;
}

String _$recoveryRhrTrendHash() => r'df654115be2d1a5a39e7ccbe8c895e5654049907';

/// See also [recoveryRhrTrend].
@ProviderFor(recoveryRhrTrend)
const recoveryRhrTrendProvider = RecoveryRhrTrendFamily();

/// See also [recoveryRhrTrend].
class RecoveryRhrTrendFamily extends Family<AsyncValue<double?>> {
  /// See also [recoveryRhrTrend].
  const RecoveryRhrTrendFamily();

  /// See also [recoveryRhrTrend].
  RecoveryRhrTrendProvider call({String? date}) {
    return RecoveryRhrTrendProvider(date: date);
  }

  @override
  RecoveryRhrTrendProvider getProviderOverride(
    covariant RecoveryRhrTrendProvider provider,
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
  String? get name => r'recoveryRhrTrendProvider';
}

/// See also [recoveryRhrTrend].
class RecoveryRhrTrendProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [recoveryRhrTrend].
  RecoveryRhrTrendProvider({String? date})
    : this._internal(
        (ref) => recoveryRhrTrend(ref as RecoveryRhrTrendRef, date: date),
        from: recoveryRhrTrendProvider,
        name: r'recoveryRhrTrendProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$recoveryRhrTrendHash,
        dependencies: RecoveryRhrTrendFamily._dependencies,
        allTransitiveDependencies:
            RecoveryRhrTrendFamily._allTransitiveDependencies,
        date: date,
      );

  RecoveryRhrTrendProvider._internal(
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
    FutureOr<double?> Function(RecoveryRhrTrendRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RecoveryRhrTrendProvider._internal(
        (ref) => create(ref as RecoveryRhrTrendRef),
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
    return _RecoveryRhrTrendProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecoveryRhrTrendProvider && other.date == date;
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
mixin RecoveryRhrTrendRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _RecoveryRhrTrendProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with RecoveryRhrTrendRef {
  _RecoveryRhrTrendProviderElement(super.provider);

  @override
  String? get date => (origin as RecoveryRhrTrendProvider).date;
}

String _$recoveryRecommendationHash() =>
    r'43dd180b542119c22bdf2099c26f10b5e48d2ee8';

/// See also [recoveryRecommendation].
@ProviderFor(recoveryRecommendation)
const recoveryRecommendationProvider = RecoveryRecommendationFamily();

/// See also [recoveryRecommendation].
class RecoveryRecommendationFamily extends Family<AsyncValue<String?>> {
  /// See also [recoveryRecommendation].
  const RecoveryRecommendationFamily();

  /// See also [recoveryRecommendation].
  RecoveryRecommendationProvider call({String? date}) {
    return RecoveryRecommendationProvider(date: date);
  }

  @override
  RecoveryRecommendationProvider getProviderOverride(
    covariant RecoveryRecommendationProvider provider,
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
  String? get name => r'recoveryRecommendationProvider';
}

/// See also [recoveryRecommendation].
class RecoveryRecommendationProvider
    extends AutoDisposeFutureProvider<String?> {
  /// See also [recoveryRecommendation].
  RecoveryRecommendationProvider({String? date})
    : this._internal(
        (ref) => recoveryRecommendation(
          ref as RecoveryRecommendationRef,
          date: date,
        ),
        from: recoveryRecommendationProvider,
        name: r'recoveryRecommendationProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$recoveryRecommendationHash,
        dependencies: RecoveryRecommendationFamily._dependencies,
        allTransitiveDependencies:
            RecoveryRecommendationFamily._allTransitiveDependencies,
        date: date,
      );

  RecoveryRecommendationProvider._internal(
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
    FutureOr<String?> Function(RecoveryRecommendationRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RecoveryRecommendationProvider._internal(
        (ref) => create(ref as RecoveryRecommendationRef),
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
  AutoDisposeFutureProviderElement<String?> createElement() {
    return _RecoveryRecommendationProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RecoveryRecommendationProvider && other.date == date;
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
mixin RecoveryRecommendationRef on AutoDisposeFutureProviderRef<String?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _RecoveryRecommendationProviderElement
    extends AutoDisposeFutureProviderElement<String?>
    with RecoveryRecommendationRef {
  _RecoveryRecommendationProviderElement(super.provider);

  @override
  String? get date => (origin as RecoveryRecommendationProvider).date;
}

String _$heartHealthRestingHrHash() =>
    r'ae348f5339ba6efec74dc9ff486571d5691a3285';

/// See also [heartHealthRestingHr].
@ProviderFor(heartHealthRestingHr)
const heartHealthRestingHrProvider = HeartHealthRestingHrFamily();

/// See also [heartHealthRestingHr].
class HeartHealthRestingHrFamily extends Family<AsyncValue<double?>> {
  /// See also [heartHealthRestingHr].
  const HeartHealthRestingHrFamily();

  /// See also [heartHealthRestingHr].
  HeartHealthRestingHrProvider call({String? date}) {
    return HeartHealthRestingHrProvider(date: date);
  }

  @override
  HeartHealthRestingHrProvider getProviderOverride(
    covariant HeartHealthRestingHrProvider provider,
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
  String? get name => r'heartHealthRestingHrProvider';
}

/// See also [heartHealthRestingHr].
class HeartHealthRestingHrProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [heartHealthRestingHr].
  HeartHealthRestingHrProvider({String? date})
    : this._internal(
        (ref) =>
            heartHealthRestingHr(ref as HeartHealthRestingHrRef, date: date),
        from: heartHealthRestingHrProvider,
        name: r'heartHealthRestingHrProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$heartHealthRestingHrHash,
        dependencies: HeartHealthRestingHrFamily._dependencies,
        allTransitiveDependencies:
            HeartHealthRestingHrFamily._allTransitiveDependencies,
        date: date,
      );

  HeartHealthRestingHrProvider._internal(
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
    FutureOr<double?> Function(HeartHealthRestingHrRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HeartHealthRestingHrProvider._internal(
        (ref) => create(ref as HeartHealthRestingHrRef),
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
    return _HeartHealthRestingHrProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HeartHealthRestingHrProvider && other.date == date;
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
mixin HeartHealthRestingHrRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _HeartHealthRestingHrProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with HeartHealthRestingHrRef {
  _HeartHealthRestingHrProviderElement(super.provider);

  @override
  String? get date => (origin as HeartHealthRestingHrProvider).date;
}

String _$heartHealthRestingHrTrendHash() =>
    r'222030980d3bffd933c891d38c3ff7b8d6e2ed9d';

/// See also [heartHealthRestingHrTrend].
@ProviderFor(heartHealthRestingHrTrend)
const heartHealthRestingHrTrendProvider = HeartHealthRestingHrTrendFamily();

/// See also [heartHealthRestingHrTrend].
class HeartHealthRestingHrTrendFamily extends Family<AsyncValue<double?>> {
  /// See also [heartHealthRestingHrTrend].
  const HeartHealthRestingHrTrendFamily();

  /// See also [heartHealthRestingHrTrend].
  HeartHealthRestingHrTrendProvider call({String? date}) {
    return HeartHealthRestingHrTrendProvider(date: date);
  }

  @override
  HeartHealthRestingHrTrendProvider getProviderOverride(
    covariant HeartHealthRestingHrTrendProvider provider,
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
  String? get name => r'heartHealthRestingHrTrendProvider';
}

/// See also [heartHealthRestingHrTrend].
class HeartHealthRestingHrTrendProvider
    extends AutoDisposeFutureProvider<double?> {
  /// See also [heartHealthRestingHrTrend].
  HeartHealthRestingHrTrendProvider({String? date})
    : this._internal(
        (ref) => heartHealthRestingHrTrend(
          ref as HeartHealthRestingHrTrendRef,
          date: date,
        ),
        from: heartHealthRestingHrTrendProvider,
        name: r'heartHealthRestingHrTrendProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$heartHealthRestingHrTrendHash,
        dependencies: HeartHealthRestingHrTrendFamily._dependencies,
        allTransitiveDependencies:
            HeartHealthRestingHrTrendFamily._allTransitiveDependencies,
        date: date,
      );

  HeartHealthRestingHrTrendProvider._internal(
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
    FutureOr<double?> Function(HeartHealthRestingHrTrendRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HeartHealthRestingHrTrendProvider._internal(
        (ref) => create(ref as HeartHealthRestingHrTrendRef),
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
    return _HeartHealthRestingHrTrendProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HeartHealthRestingHrTrendProvider && other.date == date;
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
mixin HeartHealthRestingHrTrendRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _HeartHealthRestingHrTrendProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with HeartHealthRestingHrTrendRef {
  _HeartHealthRestingHrTrendProviderElement(super.provider);

  @override
  String? get date => (origin as HeartHealthRestingHrTrendProvider).date;
}

String _$heartHealthHrvBaselineHash() =>
    r'226dd1b0f108ffca53cf58711e9524ee28a9df5c';

/// See also [heartHealthHrvBaseline].
@ProviderFor(heartHealthHrvBaseline)
const heartHealthHrvBaselineProvider = HeartHealthHrvBaselineFamily();

/// See also [heartHealthHrvBaseline].
class HeartHealthHrvBaselineFamily extends Family<AsyncValue<double?>> {
  /// See also [heartHealthHrvBaseline].
  const HeartHealthHrvBaselineFamily();

  /// See also [heartHealthHrvBaseline].
  HeartHealthHrvBaselineProvider call({String? date}) {
    return HeartHealthHrvBaselineProvider(date: date);
  }

  @override
  HeartHealthHrvBaselineProvider getProviderOverride(
    covariant HeartHealthHrvBaselineProvider provider,
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
  String? get name => r'heartHealthHrvBaselineProvider';
}

/// See also [heartHealthHrvBaseline].
class HeartHealthHrvBaselineProvider
    extends AutoDisposeFutureProvider<double?> {
  /// See also [heartHealthHrvBaseline].
  HeartHealthHrvBaselineProvider({String? date})
    : this._internal(
        (ref) => heartHealthHrvBaseline(
          ref as HeartHealthHrvBaselineRef,
          date: date,
        ),
        from: heartHealthHrvBaselineProvider,
        name: r'heartHealthHrvBaselineProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$heartHealthHrvBaselineHash,
        dependencies: HeartHealthHrvBaselineFamily._dependencies,
        allTransitiveDependencies:
            HeartHealthHrvBaselineFamily._allTransitiveDependencies,
        date: date,
      );

  HeartHealthHrvBaselineProvider._internal(
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
    FutureOr<double?> Function(HeartHealthHrvBaselineRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HeartHealthHrvBaselineProvider._internal(
        (ref) => create(ref as HeartHealthHrvBaselineRef),
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
    return _HeartHealthHrvBaselineProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HeartHealthHrvBaselineProvider && other.date == date;
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
mixin HeartHealthHrvBaselineRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _HeartHealthHrvBaselineProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with HeartHealthHrvBaselineRef {
  _HeartHealthHrvBaselineProviderElement(super.provider);

  @override
  String? get date => (origin as HeartHealthHrvBaselineProvider).date;
}

String _$heartHealthCvFitnessHash() =>
    r'c603d97207f15169cdcca32df6d4c61591610424';

/// See also [heartHealthCvFitness].
@ProviderFor(heartHealthCvFitness)
const heartHealthCvFitnessProvider = HeartHealthCvFitnessFamily();

/// See also [heartHealthCvFitness].
class HeartHealthCvFitnessFamily extends Family<AsyncValue<double?>> {
  /// See also [heartHealthCvFitness].
  const HeartHealthCvFitnessFamily();

  /// See also [heartHealthCvFitness].
  HeartHealthCvFitnessProvider call({String? date}) {
    return HeartHealthCvFitnessProvider(date: date);
  }

  @override
  HeartHealthCvFitnessProvider getProviderOverride(
    covariant HeartHealthCvFitnessProvider provider,
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
  String? get name => r'heartHealthCvFitnessProvider';
}

/// See also [heartHealthCvFitness].
class HeartHealthCvFitnessProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [heartHealthCvFitness].
  HeartHealthCvFitnessProvider({String? date})
    : this._internal(
        (ref) =>
            heartHealthCvFitness(ref as HeartHealthCvFitnessRef, date: date),
        from: heartHealthCvFitnessProvider,
        name: r'heartHealthCvFitnessProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$heartHealthCvFitnessHash,
        dependencies: HeartHealthCvFitnessFamily._dependencies,
        allTransitiveDependencies:
            HeartHealthCvFitnessFamily._allTransitiveDependencies,
        date: date,
      );

  HeartHealthCvFitnessProvider._internal(
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
    FutureOr<double?> Function(HeartHealthCvFitnessRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HeartHealthCvFitnessProvider._internal(
        (ref) => create(ref as HeartHealthCvFitnessRef),
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
    return _HeartHealthCvFitnessProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HeartHealthCvFitnessProvider && other.date == date;
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
mixin HeartHealthCvFitnessRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _HeartHealthCvFitnessProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with HeartHealthCvFitnessRef {
  _HeartHealthCvFitnessProviderElement(super.provider);

  @override
  String? get date => (origin as HeartHealthCvFitnessProvider).date;
}

String _$weeklyAvgReadinessHash() =>
    r'd3097a57b6fafe5dd792a7eae6d2251433c63874';

/// See also [weeklyAvgReadiness].
@ProviderFor(weeklyAvgReadiness)
const weeklyAvgReadinessProvider = WeeklyAvgReadinessFamily();

/// See also [weeklyAvgReadiness].
class WeeklyAvgReadinessFamily extends Family<AsyncValue<double?>> {
  /// See also [weeklyAvgReadiness].
  const WeeklyAvgReadinessFamily();

  /// See also [weeklyAvgReadiness].
  WeeklyAvgReadinessProvider call({String? date}) {
    return WeeklyAvgReadinessProvider(date: date);
  }

  @override
  WeeklyAvgReadinessProvider getProviderOverride(
    covariant WeeklyAvgReadinessProvider provider,
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
  String? get name => r'weeklyAvgReadinessProvider';
}

/// See also [weeklyAvgReadiness].
class WeeklyAvgReadinessProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [weeklyAvgReadiness].
  WeeklyAvgReadinessProvider({String? date})
    : this._internal(
        (ref) => weeklyAvgReadiness(ref as WeeklyAvgReadinessRef, date: date),
        from: weeklyAvgReadinessProvider,
        name: r'weeklyAvgReadinessProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$weeklyAvgReadinessHash,
        dependencies: WeeklyAvgReadinessFamily._dependencies,
        allTransitiveDependencies:
            WeeklyAvgReadinessFamily._allTransitiveDependencies,
        date: date,
      );

  WeeklyAvgReadinessProvider._internal(
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
    FutureOr<double?> Function(WeeklyAvgReadinessRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WeeklyAvgReadinessProvider._internal(
        (ref) => create(ref as WeeklyAvgReadinessRef),
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
    return _WeeklyAvgReadinessProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WeeklyAvgReadinessProvider && other.date == date;
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
mixin WeeklyAvgReadinessRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _WeeklyAvgReadinessProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with WeeklyAvgReadinessRef {
  _WeeklyAvgReadinessProviderElement(super.provider);

  @override
  String? get date => (origin as WeeklyAvgReadinessProvider).date;
}

String _$weeklyAvgSleepHash() => r'581f10f0818bf438773c4454105be33347fee680';

/// See also [weeklyAvgSleep].
@ProviderFor(weeklyAvgSleep)
const weeklyAvgSleepProvider = WeeklyAvgSleepFamily();

/// See also [weeklyAvgSleep].
class WeeklyAvgSleepFamily extends Family<AsyncValue<double?>> {
  /// See also [weeklyAvgSleep].
  const WeeklyAvgSleepFamily();

  /// See also [weeklyAvgSleep].
  WeeklyAvgSleepProvider call({String? date}) {
    return WeeklyAvgSleepProvider(date: date);
  }

  @override
  WeeklyAvgSleepProvider getProviderOverride(
    covariant WeeklyAvgSleepProvider provider,
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
  String? get name => r'weeklyAvgSleepProvider';
}

/// See also [weeklyAvgSleep].
class WeeklyAvgSleepProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [weeklyAvgSleep].
  WeeklyAvgSleepProvider({String? date})
    : this._internal(
        (ref) => weeklyAvgSleep(ref as WeeklyAvgSleepRef, date: date),
        from: weeklyAvgSleepProvider,
        name: r'weeklyAvgSleepProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$weeklyAvgSleepHash,
        dependencies: WeeklyAvgSleepFamily._dependencies,
        allTransitiveDependencies:
            WeeklyAvgSleepFamily._allTransitiveDependencies,
        date: date,
      );

  WeeklyAvgSleepProvider._internal(
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
    FutureOr<double?> Function(WeeklyAvgSleepRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WeeklyAvgSleepProvider._internal(
        (ref) => create(ref as WeeklyAvgSleepRef),
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
    return _WeeklyAvgSleepProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WeeklyAvgSleepProvider && other.date == date;
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
mixin WeeklyAvgSleepRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _WeeklyAvgSleepProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with WeeklyAvgSleepRef {
  _WeeklyAvgSleepProviderElement(super.provider);

  @override
  String? get date => (origin as WeeklyAvgSleepProvider).date;
}

String _$weeklyAvgStrainHash() => r'ee4ef90f30141072a8d23a13feb3e253719a0a13';

/// See also [weeklyAvgStrain].
@ProviderFor(weeklyAvgStrain)
const weeklyAvgStrainProvider = WeeklyAvgStrainFamily();

/// See also [weeklyAvgStrain].
class WeeklyAvgStrainFamily extends Family<AsyncValue<double?>> {
  /// See also [weeklyAvgStrain].
  const WeeklyAvgStrainFamily();

  /// See also [weeklyAvgStrain].
  WeeklyAvgStrainProvider call({String? date}) {
    return WeeklyAvgStrainProvider(date: date);
  }

  @override
  WeeklyAvgStrainProvider getProviderOverride(
    covariant WeeklyAvgStrainProvider provider,
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
  String? get name => r'weeklyAvgStrainProvider';
}

/// See also [weeklyAvgStrain].
class WeeklyAvgStrainProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [weeklyAvgStrain].
  WeeklyAvgStrainProvider({String? date})
    : this._internal(
        (ref) => weeklyAvgStrain(ref as WeeklyAvgStrainRef, date: date),
        from: weeklyAvgStrainProvider,
        name: r'weeklyAvgStrainProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$weeklyAvgStrainHash,
        dependencies: WeeklyAvgStrainFamily._dependencies,
        allTransitiveDependencies:
            WeeklyAvgStrainFamily._allTransitiveDependencies,
        date: date,
      );

  WeeklyAvgStrainProvider._internal(
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
    FutureOr<double?> Function(WeeklyAvgStrainRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WeeklyAvgStrainProvider._internal(
        (ref) => create(ref as WeeklyAvgStrainRef),
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
    return _WeeklyAvgStrainProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WeeklyAvgStrainProvider && other.date == date;
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
mixin WeeklyAvgStrainRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _WeeklyAvgStrainProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with WeeklyAvgStrainRef {
  _WeeklyAvgStrainProviderElement(super.provider);

  @override
  String? get date => (origin as WeeklyAvgStrainProvider).date;
}

String _$weeklyTotalStepsHash() => r'06c6da0190619f3db3acd137eebd9c3ee168c848';

/// See also [weeklyTotalSteps].
@ProviderFor(weeklyTotalSteps)
const weeklyTotalStepsProvider = WeeklyTotalStepsFamily();

/// See also [weeklyTotalSteps].
class WeeklyTotalStepsFamily extends Family<AsyncValue<double?>> {
  /// See also [weeklyTotalSteps].
  const WeeklyTotalStepsFamily();

  /// See also [weeklyTotalSteps].
  WeeklyTotalStepsProvider call({String? date}) {
    return WeeklyTotalStepsProvider(date: date);
  }

  @override
  WeeklyTotalStepsProvider getProviderOverride(
    covariant WeeklyTotalStepsProvider provider,
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
  String? get name => r'weeklyTotalStepsProvider';
}

/// See also [weeklyTotalSteps].
class WeeklyTotalStepsProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [weeklyTotalSteps].
  WeeklyTotalStepsProvider({String? date})
    : this._internal(
        (ref) => weeklyTotalSteps(ref as WeeklyTotalStepsRef, date: date),
        from: weeklyTotalStepsProvider,
        name: r'weeklyTotalStepsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$weeklyTotalStepsHash,
        dependencies: WeeklyTotalStepsFamily._dependencies,
        allTransitiveDependencies:
            WeeklyTotalStepsFamily._allTransitiveDependencies,
        date: date,
      );

  WeeklyTotalStepsProvider._internal(
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
    FutureOr<double?> Function(WeeklyTotalStepsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WeeklyTotalStepsProvider._internal(
        (ref) => create(ref as WeeklyTotalStepsRef),
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
    return _WeeklyTotalStepsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WeeklyTotalStepsProvider && other.date == date;
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
mixin WeeklyTotalStepsRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _WeeklyTotalStepsProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with WeeklyTotalStepsRef {
  _WeeklyTotalStepsProviderElement(super.provider);

  @override
  String? get date => (origin as WeeklyTotalStepsProvider).date;
}

String _$bodyBatteryCurrentLevelHash() =>
    r'833d12389c62a216719cd437fdaf4cb51460baa1';

/// See also [bodyBatteryCurrentLevel].
@ProviderFor(bodyBatteryCurrentLevel)
const bodyBatteryCurrentLevelProvider = BodyBatteryCurrentLevelFamily();

/// See also [bodyBatteryCurrentLevel].
class BodyBatteryCurrentLevelFamily extends Family<AsyncValue<double?>> {
  /// See also [bodyBatteryCurrentLevel].
  const BodyBatteryCurrentLevelFamily();

  /// See also [bodyBatteryCurrentLevel].
  BodyBatteryCurrentLevelProvider call({String? date}) {
    return BodyBatteryCurrentLevelProvider(date: date);
  }

  @override
  BodyBatteryCurrentLevelProvider getProviderOverride(
    covariant BodyBatteryCurrentLevelProvider provider,
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
  String? get name => r'bodyBatteryCurrentLevelProvider';
}

/// See also [bodyBatteryCurrentLevel].
class BodyBatteryCurrentLevelProvider
    extends AutoDisposeFutureProvider<double?> {
  /// See also [bodyBatteryCurrentLevel].
  BodyBatteryCurrentLevelProvider({String? date})
    : this._internal(
        (ref) => bodyBatteryCurrentLevel(
          ref as BodyBatteryCurrentLevelRef,
          date: date,
        ),
        from: bodyBatteryCurrentLevelProvider,
        name: r'bodyBatteryCurrentLevelProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$bodyBatteryCurrentLevelHash,
        dependencies: BodyBatteryCurrentLevelFamily._dependencies,
        allTransitiveDependencies:
            BodyBatteryCurrentLevelFamily._allTransitiveDependencies,
        date: date,
      );

  BodyBatteryCurrentLevelProvider._internal(
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
    FutureOr<double?> Function(BodyBatteryCurrentLevelRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BodyBatteryCurrentLevelProvider._internal(
        (ref) => create(ref as BodyBatteryCurrentLevelRef),
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
    return _BodyBatteryCurrentLevelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BodyBatteryCurrentLevelProvider && other.date == date;
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
mixin BodyBatteryCurrentLevelRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _BodyBatteryCurrentLevelProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with BodyBatteryCurrentLevelRef {
  _BodyBatteryCurrentLevelProviderElement(super.provider);

  @override
  String? get date => (origin as BodyBatteryCurrentLevelProvider).date;
}

String _$bodyBatteryMorningLevelHash() =>
    r'c7859e749f5f2078dbff212295855eac33e2adb4';

/// See also [bodyBatteryMorningLevel].
@ProviderFor(bodyBatteryMorningLevel)
const bodyBatteryMorningLevelProvider = BodyBatteryMorningLevelFamily();

/// See also [bodyBatteryMorningLevel].
class BodyBatteryMorningLevelFamily extends Family<AsyncValue<double?>> {
  /// See also [bodyBatteryMorningLevel].
  const BodyBatteryMorningLevelFamily();

  /// See also [bodyBatteryMorningLevel].
  BodyBatteryMorningLevelProvider call({String? date}) {
    return BodyBatteryMorningLevelProvider(date: date);
  }

  @override
  BodyBatteryMorningLevelProvider getProviderOverride(
    covariant BodyBatteryMorningLevelProvider provider,
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
  String? get name => r'bodyBatteryMorningLevelProvider';
}

/// See also [bodyBatteryMorningLevel].
class BodyBatteryMorningLevelProvider
    extends AutoDisposeFutureProvider<double?> {
  /// See also [bodyBatteryMorningLevel].
  BodyBatteryMorningLevelProvider({String? date})
    : this._internal(
        (ref) => bodyBatteryMorningLevel(
          ref as BodyBatteryMorningLevelRef,
          date: date,
        ),
        from: bodyBatteryMorningLevelProvider,
        name: r'bodyBatteryMorningLevelProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$bodyBatteryMorningLevelHash,
        dependencies: BodyBatteryMorningLevelFamily._dependencies,
        allTransitiveDependencies:
            BodyBatteryMorningLevelFamily._allTransitiveDependencies,
        date: date,
      );

  BodyBatteryMorningLevelProvider._internal(
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
    FutureOr<double?> Function(BodyBatteryMorningLevelRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BodyBatteryMorningLevelProvider._internal(
        (ref) => create(ref as BodyBatteryMorningLevelRef),
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
    return _BodyBatteryMorningLevelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BodyBatteryMorningLevelProvider && other.date == date;
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
mixin BodyBatteryMorningLevelRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _BodyBatteryMorningLevelProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with BodyBatteryMorningLevelRef {
  _BodyBatteryMorningLevelProviderElement(super.provider);

  @override
  String? get date => (origin as BodyBatteryMorningLevelProvider).date;
}

String _$bodyBatteryDrainRateHash() =>
    r'18fb430d4aa54a5c20dd3a2b324611db85c135f7';

/// See also [bodyBatteryDrainRate].
@ProviderFor(bodyBatteryDrainRate)
const bodyBatteryDrainRateProvider = BodyBatteryDrainRateFamily();

/// See also [bodyBatteryDrainRate].
class BodyBatteryDrainRateFamily extends Family<AsyncValue<double?>> {
  /// See also [bodyBatteryDrainRate].
  const BodyBatteryDrainRateFamily();

  /// See also [bodyBatteryDrainRate].
  BodyBatteryDrainRateProvider call({String? date}) {
    return BodyBatteryDrainRateProvider(date: date);
  }

  @override
  BodyBatteryDrainRateProvider getProviderOverride(
    covariant BodyBatteryDrainRateProvider provider,
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
  String? get name => r'bodyBatteryDrainRateProvider';
}

/// See also [bodyBatteryDrainRate].
class BodyBatteryDrainRateProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [bodyBatteryDrainRate].
  BodyBatteryDrainRateProvider({String? date})
    : this._internal(
        (ref) =>
            bodyBatteryDrainRate(ref as BodyBatteryDrainRateRef, date: date),
        from: bodyBatteryDrainRateProvider,
        name: r'bodyBatteryDrainRateProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$bodyBatteryDrainRateHash,
        dependencies: BodyBatteryDrainRateFamily._dependencies,
        allTransitiveDependencies:
            BodyBatteryDrainRateFamily._allTransitiveDependencies,
        date: date,
      );

  BodyBatteryDrainRateProvider._internal(
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
    FutureOr<double?> Function(BodyBatteryDrainRateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: BodyBatteryDrainRateProvider._internal(
        (ref) => create(ref as BodyBatteryDrainRateRef),
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
    return _BodyBatteryDrainRateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is BodyBatteryDrainRateProvider && other.date == date;
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
mixin BodyBatteryDrainRateRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _BodyBatteryDrainRateProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with BodyBatteryDrainRateRef {
  _BodyBatteryDrainRateProviderElement(super.provider);

  @override
  String? get date => (origin as BodyBatteryDrainRateProvider).date;
}

String _$activeEnergyDailyKcalHash() =>
    r'b77605524030efd0cfeb7a86de9fa1beb9af735f';

/// See also [activeEnergyDailyKcal].
@ProviderFor(activeEnergyDailyKcal)
const activeEnergyDailyKcalProvider = ActiveEnergyDailyKcalFamily();

/// See also [activeEnergyDailyKcal].
class ActiveEnergyDailyKcalFamily extends Family<AsyncValue<double?>> {
  /// See also [activeEnergyDailyKcal].
  const ActiveEnergyDailyKcalFamily();

  /// See also [activeEnergyDailyKcal].
  ActiveEnergyDailyKcalProvider call({String? date}) {
    return ActiveEnergyDailyKcalProvider(date: date);
  }

  @override
  ActiveEnergyDailyKcalProvider getProviderOverride(
    covariant ActiveEnergyDailyKcalProvider provider,
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
  String? get name => r'activeEnergyDailyKcalProvider';
}

/// See also [activeEnergyDailyKcal].
class ActiveEnergyDailyKcalProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [activeEnergyDailyKcal].
  ActiveEnergyDailyKcalProvider({String? date})
    : this._internal(
        (ref) =>
            activeEnergyDailyKcal(ref as ActiveEnergyDailyKcalRef, date: date),
        from: activeEnergyDailyKcalProvider,
        name: r'activeEnergyDailyKcalProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$activeEnergyDailyKcalHash,
        dependencies: ActiveEnergyDailyKcalFamily._dependencies,
        allTransitiveDependencies:
            ActiveEnergyDailyKcalFamily._allTransitiveDependencies,
        date: date,
      );

  ActiveEnergyDailyKcalProvider._internal(
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
    FutureOr<double?> Function(ActiveEnergyDailyKcalRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ActiveEnergyDailyKcalProvider._internal(
        (ref) => create(ref as ActiveEnergyDailyKcalRef),
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
    return _ActiveEnergyDailyKcalProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ActiveEnergyDailyKcalProvider && other.date == date;
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
mixin ActiveEnergyDailyKcalRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _ActiveEnergyDailyKcalProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with ActiveEnergyDailyKcalRef {
  _ActiveEnergyDailyKcalProviderElement(super.provider);

  @override
  String? get date => (origin as ActiveEnergyDailyKcalProvider).date;
}

String _$activeEnergyWeeklyAvgHash() =>
    r'0560b1ad1cc3a0ed3e58a247faf6a8fea31668f6';

/// See also [activeEnergyWeeklyAvg].
@ProviderFor(activeEnergyWeeklyAvg)
const activeEnergyWeeklyAvgProvider = ActiveEnergyWeeklyAvgFamily();

/// See also [activeEnergyWeeklyAvg].
class ActiveEnergyWeeklyAvgFamily extends Family<AsyncValue<double?>> {
  /// See also [activeEnergyWeeklyAvg].
  const ActiveEnergyWeeklyAvgFamily();

  /// See also [activeEnergyWeeklyAvg].
  ActiveEnergyWeeklyAvgProvider call({String? date}) {
    return ActiveEnergyWeeklyAvgProvider(date: date);
  }

  @override
  ActiveEnergyWeeklyAvgProvider getProviderOverride(
    covariant ActiveEnergyWeeklyAvgProvider provider,
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
  String? get name => r'activeEnergyWeeklyAvgProvider';
}

/// See also [activeEnergyWeeklyAvg].
class ActiveEnergyWeeklyAvgProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [activeEnergyWeeklyAvg].
  ActiveEnergyWeeklyAvgProvider({String? date})
    : this._internal(
        (ref) =>
            activeEnergyWeeklyAvg(ref as ActiveEnergyWeeklyAvgRef, date: date),
        from: activeEnergyWeeklyAvgProvider,
        name: r'activeEnergyWeeklyAvgProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$activeEnergyWeeklyAvgHash,
        dependencies: ActiveEnergyWeeklyAvgFamily._dependencies,
        allTransitiveDependencies:
            ActiveEnergyWeeklyAvgFamily._allTransitiveDependencies,
        date: date,
      );

  ActiveEnergyWeeklyAvgProvider._internal(
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
    FutureOr<double?> Function(ActiveEnergyWeeklyAvgRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ActiveEnergyWeeklyAvgProvider._internal(
        (ref) => create(ref as ActiveEnergyWeeklyAvgRef),
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
    return _ActiveEnergyWeeklyAvgProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ActiveEnergyWeeklyAvgProvider && other.date == date;
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
mixin ActiveEnergyWeeklyAvgRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _ActiveEnergyWeeklyAvgProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with ActiveEnergyWeeklyAvgRef {
  _ActiveEnergyWeeklyAvgProviderElement(super.provider);

  @override
  String? get date => (origin as ActiveEnergyWeeklyAvgProvider).date;
}

String _$activeEnergyLevelHash() => r'8b30e3f41ac6267c0a60048cad6e8b45ce03df0a';

/// See also [activeEnergyLevel].
@ProviderFor(activeEnergyLevel)
const activeEnergyLevelProvider = ActiveEnergyLevelFamily();

/// See also [activeEnergyLevel].
class ActiveEnergyLevelFamily extends Family<AsyncValue<String?>> {
  /// See also [activeEnergyLevel].
  const ActiveEnergyLevelFamily();

  /// See also [activeEnergyLevel].
  ActiveEnergyLevelProvider call({String? date}) {
    return ActiveEnergyLevelProvider(date: date);
  }

  @override
  ActiveEnergyLevelProvider getProviderOverride(
    covariant ActiveEnergyLevelProvider provider,
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
  String? get name => r'activeEnergyLevelProvider';
}

/// See also [activeEnergyLevel].
class ActiveEnergyLevelProvider extends AutoDisposeFutureProvider<String?> {
  /// See also [activeEnergyLevel].
  ActiveEnergyLevelProvider({String? date})
    : this._internal(
        (ref) => activeEnergyLevel(ref as ActiveEnergyLevelRef, date: date),
        from: activeEnergyLevelProvider,
        name: r'activeEnergyLevelProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$activeEnergyLevelHash,
        dependencies: ActiveEnergyLevelFamily._dependencies,
        allTransitiveDependencies:
            ActiveEnergyLevelFamily._allTransitiveDependencies,
        date: date,
      );

  ActiveEnergyLevelProvider._internal(
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
    FutureOr<String?> Function(ActiveEnergyLevelRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ActiveEnergyLevelProvider._internal(
        (ref) => create(ref as ActiveEnergyLevelRef),
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
  AutoDisposeFutureProviderElement<String?> createElement() {
    return _ActiveEnergyLevelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ActiveEnergyLevelProvider && other.date == date;
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
mixin ActiveEnergyLevelRef on AutoDisposeFutureProviderRef<String?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _ActiveEnergyLevelProviderElement
    extends AutoDisposeFutureProviderElement<String?>
    with ActiveEnergyLevelRef {
  _ActiveEnergyLevelProviderElement(super.provider);

  @override
  String? get date => (origin as ActiveEnergyLevelProvider).date;
}

String _$sleepDebtBankBalanceHash() =>
    r'7854fdfe469727989521f99a044fc91c1dd39374';

/// See also [sleepDebtBankBalance].
@ProviderFor(sleepDebtBankBalance)
const sleepDebtBankBalanceProvider = SleepDebtBankBalanceFamily();

/// See also [sleepDebtBankBalance].
class SleepDebtBankBalanceFamily extends Family<AsyncValue<double?>> {
  /// See also [sleepDebtBankBalance].
  const SleepDebtBankBalanceFamily();

  /// See also [sleepDebtBankBalance].
  SleepDebtBankBalanceProvider call({String? date}) {
    return SleepDebtBankBalanceProvider(date: date);
  }

  @override
  SleepDebtBankBalanceProvider getProviderOverride(
    covariant SleepDebtBankBalanceProvider provider,
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
  String? get name => r'sleepDebtBankBalanceProvider';
}

/// See also [sleepDebtBankBalance].
class SleepDebtBankBalanceProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [sleepDebtBankBalance].
  SleepDebtBankBalanceProvider({String? date})
    : this._internal(
        (ref) =>
            sleepDebtBankBalance(ref as SleepDebtBankBalanceRef, date: date),
        from: sleepDebtBankBalanceProvider,
        name: r'sleepDebtBankBalanceProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$sleepDebtBankBalanceHash,
        dependencies: SleepDebtBankBalanceFamily._dependencies,
        allTransitiveDependencies:
            SleepDebtBankBalanceFamily._allTransitiveDependencies,
        date: date,
      );

  SleepDebtBankBalanceProvider._internal(
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
    FutureOr<double?> Function(SleepDebtBankBalanceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SleepDebtBankBalanceProvider._internal(
        (ref) => create(ref as SleepDebtBankBalanceRef),
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
    return _SleepDebtBankBalanceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SleepDebtBankBalanceProvider && other.date == date;
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
mixin SleepDebtBankBalanceRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _SleepDebtBankBalanceProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with SleepDebtBankBalanceRef {
  _SleepDebtBankBalanceProviderElement(super.provider);

  @override
  String? get date => (origin as SleepDebtBankBalanceProvider).date;
}

String _$sleepDebtBankScoreHash() =>
    r'5ec870ef7c59299f478025532af81ce0876f1631';

/// See also [sleepDebtBankScore].
@ProviderFor(sleepDebtBankScore)
const sleepDebtBankScoreProvider = SleepDebtBankScoreFamily();

/// See also [sleepDebtBankScore].
class SleepDebtBankScoreFamily extends Family<AsyncValue<double?>> {
  /// See also [sleepDebtBankScore].
  const SleepDebtBankScoreFamily();

  /// See also [sleepDebtBankScore].
  SleepDebtBankScoreProvider call({String? date}) {
    return SleepDebtBankScoreProvider(date: date);
  }

  @override
  SleepDebtBankScoreProvider getProviderOverride(
    covariant SleepDebtBankScoreProvider provider,
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
  String? get name => r'sleepDebtBankScoreProvider';
}

/// See also [sleepDebtBankScore].
class SleepDebtBankScoreProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [sleepDebtBankScore].
  SleepDebtBankScoreProvider({String? date})
    : this._internal(
        (ref) => sleepDebtBankScore(ref as SleepDebtBankScoreRef, date: date),
        from: sleepDebtBankScoreProvider,
        name: r'sleepDebtBankScoreProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$sleepDebtBankScoreHash,
        dependencies: SleepDebtBankScoreFamily._dependencies,
        allTransitiveDependencies:
            SleepDebtBankScoreFamily._allTransitiveDependencies,
        date: date,
      );

  SleepDebtBankScoreProvider._internal(
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
    FutureOr<double?> Function(SleepDebtBankScoreRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SleepDebtBankScoreProvider._internal(
        (ref) => create(ref as SleepDebtBankScoreRef),
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
    return _SleepDebtBankScoreProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SleepDebtBankScoreProvider && other.date == date;
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
mixin SleepDebtBankScoreRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _SleepDebtBankScoreProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with SleepDebtBankScoreRef {
  _SleepDebtBankScoreProviderElement(super.provider);

  @override
  String? get date => (origin as SleepDebtBankScoreProvider).date;
}

String _$sleepDebtDailyShortfallHash() =>
    r'62d3e92d408ced8883bee48e26af299ff3395cb4';

/// See also [sleepDebtDailyShortfall].
@ProviderFor(sleepDebtDailyShortfall)
const sleepDebtDailyShortfallProvider = SleepDebtDailyShortfallFamily();

/// See also [sleepDebtDailyShortfall].
class SleepDebtDailyShortfallFamily extends Family<AsyncValue<double?>> {
  /// See also [sleepDebtDailyShortfall].
  const SleepDebtDailyShortfallFamily();

  /// See also [sleepDebtDailyShortfall].
  SleepDebtDailyShortfallProvider call({String? date}) {
    return SleepDebtDailyShortfallProvider(date: date);
  }

  @override
  SleepDebtDailyShortfallProvider getProviderOverride(
    covariant SleepDebtDailyShortfallProvider provider,
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
  String? get name => r'sleepDebtDailyShortfallProvider';
}

/// See also [sleepDebtDailyShortfall].
class SleepDebtDailyShortfallProvider
    extends AutoDisposeFutureProvider<double?> {
  /// See also [sleepDebtDailyShortfall].
  SleepDebtDailyShortfallProvider({String? date})
    : this._internal(
        (ref) => sleepDebtDailyShortfall(
          ref as SleepDebtDailyShortfallRef,
          date: date,
        ),
        from: sleepDebtDailyShortfallProvider,
        name: r'sleepDebtDailyShortfallProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$sleepDebtDailyShortfallHash,
        dependencies: SleepDebtDailyShortfallFamily._dependencies,
        allTransitiveDependencies:
            SleepDebtDailyShortfallFamily._allTransitiveDependencies,
        date: date,
      );

  SleepDebtDailyShortfallProvider._internal(
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
    FutureOr<double?> Function(SleepDebtDailyShortfallRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SleepDebtDailyShortfallProvider._internal(
        (ref) => create(ref as SleepDebtDailyShortfallRef),
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
    return _SleepDebtDailyShortfallProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SleepDebtDailyShortfallProvider && other.date == date;
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
mixin SleepDebtDailyShortfallRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _SleepDebtDailyShortfallProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with SleepDebtDailyShortfallRef {
  _SleepDebtDailyShortfallProviderElement(super.provider);

  @override
  String? get date => (origin as SleepDebtDailyShortfallProvider).date;
}

String _$sleepDebtLastNightSurplusHash() =>
    r'fad67f99a610a6bdb3edfaa6638747afd88739c2';

/// See also [sleepDebtLastNightSurplus].
@ProviderFor(sleepDebtLastNightSurplus)
const sleepDebtLastNightSurplusProvider = SleepDebtLastNightSurplusFamily();

/// See also [sleepDebtLastNightSurplus].
class SleepDebtLastNightSurplusFamily extends Family<AsyncValue<double?>> {
  /// See also [sleepDebtLastNightSurplus].
  const SleepDebtLastNightSurplusFamily();

  /// See also [sleepDebtLastNightSurplus].
  SleepDebtLastNightSurplusProvider call({String? date}) {
    return SleepDebtLastNightSurplusProvider(date: date);
  }

  @override
  SleepDebtLastNightSurplusProvider getProviderOverride(
    covariant SleepDebtLastNightSurplusProvider provider,
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
  String? get name => r'sleepDebtLastNightSurplusProvider';
}

/// See also [sleepDebtLastNightSurplus].
class SleepDebtLastNightSurplusProvider
    extends AutoDisposeFutureProvider<double?> {
  /// See also [sleepDebtLastNightSurplus].
  SleepDebtLastNightSurplusProvider({String? date})
    : this._internal(
        (ref) => sleepDebtLastNightSurplus(
          ref as SleepDebtLastNightSurplusRef,
          date: date,
        ),
        from: sleepDebtLastNightSurplusProvider,
        name: r'sleepDebtLastNightSurplusProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$sleepDebtLastNightSurplusHash,
        dependencies: SleepDebtLastNightSurplusFamily._dependencies,
        allTransitiveDependencies:
            SleepDebtLastNightSurplusFamily._allTransitiveDependencies,
        date: date,
      );

  SleepDebtLastNightSurplusProvider._internal(
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
    FutureOr<double?> Function(SleepDebtLastNightSurplusRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SleepDebtLastNightSurplusProvider._internal(
        (ref) => create(ref as SleepDebtLastNightSurplusRef),
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
    return _SleepDebtLastNightSurplusProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SleepDebtLastNightSurplusProvider && other.date == date;
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
mixin SleepDebtLastNightSurplusRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _SleepDebtLastNightSurplusProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with SleepDebtLastNightSurplusRef {
  _SleepDebtLastNightSurplusProviderElement(super.provider);

  @override
  String? get date => (origin as SleepDebtLastNightSurplusProvider).date;
}

String _$sleepDebtSeverityHash() => r'6aaca2bc2d75353590c4bbd6dc1cae0993086574';

/// See also [sleepDebtSeverity].
@ProviderFor(sleepDebtSeverity)
const sleepDebtSeverityProvider = SleepDebtSeverityFamily();

/// See also [sleepDebtSeverity].
class SleepDebtSeverityFamily extends Family<AsyncValue<int?>> {
  /// See also [sleepDebtSeverity].
  const SleepDebtSeverityFamily();

  /// See also [sleepDebtSeverity].
  SleepDebtSeverityProvider call({String? date}) {
    return SleepDebtSeverityProvider(date: date);
  }

  @override
  SleepDebtSeverityProvider getProviderOverride(
    covariant SleepDebtSeverityProvider provider,
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
  String? get name => r'sleepDebtSeverityProvider';
}

/// See also [sleepDebtSeverity].
class SleepDebtSeverityProvider extends AutoDisposeFutureProvider<int?> {
  /// See also [sleepDebtSeverity].
  SleepDebtSeverityProvider({String? date})
    : this._internal(
        (ref) => sleepDebtSeverity(ref as SleepDebtSeverityRef, date: date),
        from: sleepDebtSeverityProvider,
        name: r'sleepDebtSeverityProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$sleepDebtSeverityHash,
        dependencies: SleepDebtSeverityFamily._dependencies,
        allTransitiveDependencies:
            SleepDebtSeverityFamily._allTransitiveDependencies,
        date: date,
      );

  SleepDebtSeverityProvider._internal(
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
    FutureOr<int?> Function(SleepDebtSeverityRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SleepDebtSeverityProvider._internal(
        (ref) => create(ref as SleepDebtSeverityRef),
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
  AutoDisposeFutureProviderElement<int?> createElement() {
    return _SleepDebtSeverityProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SleepDebtSeverityProvider && other.date == date;
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
mixin SleepDebtSeverityRef on AutoDisposeFutureProviderRef<int?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _SleepDebtSeverityProviderElement
    extends AutoDisposeFutureProviderElement<int?>
    with SleepDebtSeverityRef {
  _SleepDebtSeverityProviderElement(super.provider);

  @override
  String? get date => (origin as SleepDebtSeverityProvider).date;
}

String _$sleepDebtRecoveryDaysHash() =>
    r'ed86b8804a2f06d6203a6e269c5be72d6969c1b0';

/// See also [sleepDebtRecoveryDays].
@ProviderFor(sleepDebtRecoveryDays)
const sleepDebtRecoveryDaysProvider = SleepDebtRecoveryDaysFamily();

/// See also [sleepDebtRecoveryDays].
class SleepDebtRecoveryDaysFamily extends Family<AsyncValue<double?>> {
  /// See also [sleepDebtRecoveryDays].
  const SleepDebtRecoveryDaysFamily();

  /// See also [sleepDebtRecoveryDays].
  SleepDebtRecoveryDaysProvider call({String? date}) {
    return SleepDebtRecoveryDaysProvider(date: date);
  }

  @override
  SleepDebtRecoveryDaysProvider getProviderOverride(
    covariant SleepDebtRecoveryDaysProvider provider,
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
  String? get name => r'sleepDebtRecoveryDaysProvider';
}

/// See also [sleepDebtRecoveryDays].
class SleepDebtRecoveryDaysProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [sleepDebtRecoveryDays].
  SleepDebtRecoveryDaysProvider({String? date})
    : this._internal(
        (ref) =>
            sleepDebtRecoveryDays(ref as SleepDebtRecoveryDaysRef, date: date),
        from: sleepDebtRecoveryDaysProvider,
        name: r'sleepDebtRecoveryDaysProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$sleepDebtRecoveryDaysHash,
        dependencies: SleepDebtRecoveryDaysFamily._dependencies,
        allTransitiveDependencies:
            SleepDebtRecoveryDaysFamily._allTransitiveDependencies,
        date: date,
      );

  SleepDebtRecoveryDaysProvider._internal(
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
    FutureOr<double?> Function(SleepDebtRecoveryDaysRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SleepDebtRecoveryDaysProvider._internal(
        (ref) => create(ref as SleepDebtRecoveryDaysRef),
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
    return _SleepDebtRecoveryDaysProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SleepDebtRecoveryDaysProvider && other.date == date;
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
mixin SleepDebtRecoveryDaysRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _SleepDebtRecoveryDaysProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with SleepDebtRecoveryDaysRef {
  _SleepDebtRecoveryDaysProviderElement(super.provider);

  @override
  String? get date => (origin as SleepDebtRecoveryDaysProvider).date;
}

String _$sleepDebtTrendHash() => r'dab5afb1fe5c10576efe9ad2529abcebc48fdd2d';

/// See also [sleepDebtTrend].
@ProviderFor(sleepDebtTrend)
const sleepDebtTrendProvider = SleepDebtTrendFamily();

/// See also [sleepDebtTrend].
class SleepDebtTrendFamily extends Family<AsyncValue<int?>> {
  /// See also [sleepDebtTrend].
  const SleepDebtTrendFamily();

  /// See also [sleepDebtTrend].
  SleepDebtTrendProvider call({String? date}) {
    return SleepDebtTrendProvider(date: date);
  }

  @override
  SleepDebtTrendProvider getProviderOverride(
    covariant SleepDebtTrendProvider provider,
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
  String? get name => r'sleepDebtTrendProvider';
}

/// See also [sleepDebtTrend].
class SleepDebtTrendProvider extends AutoDisposeFutureProvider<int?> {
  /// See also [sleepDebtTrend].
  SleepDebtTrendProvider({String? date})
    : this._internal(
        (ref) => sleepDebtTrend(ref as SleepDebtTrendRef, date: date),
        from: sleepDebtTrendProvider,
        name: r'sleepDebtTrendProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$sleepDebtTrendHash,
        dependencies: SleepDebtTrendFamily._dependencies,
        allTransitiveDependencies:
            SleepDebtTrendFamily._allTransitiveDependencies,
        date: date,
      );

  SleepDebtTrendProvider._internal(
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
    FutureOr<int?> Function(SleepDebtTrendRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SleepDebtTrendProvider._internal(
        (ref) => create(ref as SleepDebtTrendRef),
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
  AutoDisposeFutureProviderElement<int?> createElement() {
    return _SleepDebtTrendProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SleepDebtTrendProvider && other.date == date;
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
mixin SleepDebtTrendRef on AutoDisposeFutureProviderRef<int?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _SleepDebtTrendProviderElement
    extends AutoDisposeFutureProviderElement<int?>
    with SleepDebtTrendRef {
  _SleepDebtTrendProviderElement(super.provider);

  @override
  String? get date => (origin as SleepDebtTrendProvider).date;
}

String _$sleepDebtSleepGoalHash() =>
    r'78d86ca67e5ad7eb378176f22d7506c0c3efe4f9';

/// See also [sleepDebtSleepGoal].
@ProviderFor(sleepDebtSleepGoal)
const sleepDebtSleepGoalProvider = SleepDebtSleepGoalFamily();

/// See also [sleepDebtSleepGoal].
class SleepDebtSleepGoalFamily extends Family<AsyncValue<double?>> {
  /// See also [sleepDebtSleepGoal].
  const SleepDebtSleepGoalFamily();

  /// See also [sleepDebtSleepGoal].
  SleepDebtSleepGoalProvider call({String? date}) {
    return SleepDebtSleepGoalProvider(date: date);
  }

  @override
  SleepDebtSleepGoalProvider getProviderOverride(
    covariant SleepDebtSleepGoalProvider provider,
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
  String? get name => r'sleepDebtSleepGoalProvider';
}

/// See also [sleepDebtSleepGoal].
class SleepDebtSleepGoalProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [sleepDebtSleepGoal].
  SleepDebtSleepGoalProvider({String? date})
    : this._internal(
        (ref) => sleepDebtSleepGoal(ref as SleepDebtSleepGoalRef, date: date),
        from: sleepDebtSleepGoalProvider,
        name: r'sleepDebtSleepGoalProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$sleepDebtSleepGoalHash,
        dependencies: SleepDebtSleepGoalFamily._dependencies,
        allTransitiveDependencies:
            SleepDebtSleepGoalFamily._allTransitiveDependencies,
        date: date,
      );

  SleepDebtSleepGoalProvider._internal(
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
    FutureOr<double?> Function(SleepDebtSleepGoalRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SleepDebtSleepGoalProvider._internal(
        (ref) => create(ref as SleepDebtSleepGoalRef),
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
    return _SleepDebtSleepGoalProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SleepDebtSleepGoalProvider && other.date == date;
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
mixin SleepDebtSleepGoalRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _SleepDebtSleepGoalProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with SleepDebtSleepGoalRef {
  _SleepDebtSleepGoalProviderElement(super.provider);

  @override
  String? get date => (origin as SleepDebtSleepGoalProvider).date;
}

String _$sleepDebtWeeklyTrendHash() =>
    r'd0e204063c10e69adef8864622731777ec5b74a8';

/// See also [sleepDebtWeeklyTrend].
@ProviderFor(sleepDebtWeeklyTrend)
const sleepDebtWeeklyTrendProvider = SleepDebtWeeklyTrendFamily();

/// See also [sleepDebtWeeklyTrend].
class SleepDebtWeeklyTrendFamily extends Family<AsyncValue<double?>> {
  /// See also [sleepDebtWeeklyTrend].
  const SleepDebtWeeklyTrendFamily();

  /// See also [sleepDebtWeeklyTrend].
  SleepDebtWeeklyTrendProvider call({String? date}) {
    return SleepDebtWeeklyTrendProvider(date: date);
  }

  @override
  SleepDebtWeeklyTrendProvider getProviderOverride(
    covariant SleepDebtWeeklyTrendProvider provider,
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
  String? get name => r'sleepDebtWeeklyTrendProvider';
}

/// See also [sleepDebtWeeklyTrend].
class SleepDebtWeeklyTrendProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [sleepDebtWeeklyTrend].
  SleepDebtWeeklyTrendProvider({String? date})
    : this._internal(
        (ref) =>
            sleepDebtWeeklyTrend(ref as SleepDebtWeeklyTrendRef, date: date),
        from: sleepDebtWeeklyTrendProvider,
        name: r'sleepDebtWeeklyTrendProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$sleepDebtWeeklyTrendHash,
        dependencies: SleepDebtWeeklyTrendFamily._dependencies,
        allTransitiveDependencies:
            SleepDebtWeeklyTrendFamily._allTransitiveDependencies,
        date: date,
      );

  SleepDebtWeeklyTrendProvider._internal(
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
    FutureOr<double?> Function(SleepDebtWeeklyTrendRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SleepDebtWeeklyTrendProvider._internal(
        (ref) => create(ref as SleepDebtWeeklyTrendRef),
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
    return _SleepDebtWeeklyTrendProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SleepDebtWeeklyTrendProvider && other.date == date;
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
mixin SleepDebtWeeklyTrendRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _SleepDebtWeeklyTrendProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with SleepDebtWeeklyTrendRef {
  _SleepDebtWeeklyTrendProviderElement(super.provider);

  @override
  String? get date => (origin as SleepDebtWeeklyTrendProvider).date;
}

String _$sleepDebtDetailJsonHash() =>
    r'f7a83bded55cd7805c04b82e5b2c000e4fc11066';

/// See also [sleepDebtDetailJson].
@ProviderFor(sleepDebtDetailJson)
const sleepDebtDetailJsonProvider = SleepDebtDetailJsonFamily();

/// See also [sleepDebtDetailJson].
class SleepDebtDetailJsonFamily
    extends Family<AsyncValue<Map<String, dynamic>?>> {
  /// See also [sleepDebtDetailJson].
  const SleepDebtDetailJsonFamily();

  /// See also [sleepDebtDetailJson].
  SleepDebtDetailJsonProvider call({String? date}) {
    return SleepDebtDetailJsonProvider(date: date);
  }

  @override
  SleepDebtDetailJsonProvider getProviderOverride(
    covariant SleepDebtDetailJsonProvider provider,
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
  String? get name => r'sleepDebtDetailJsonProvider';
}

/// See also [sleepDebtDetailJson].
class SleepDebtDetailJsonProvider
    extends AutoDisposeFutureProvider<Map<String, dynamic>?> {
  /// See also [sleepDebtDetailJson].
  SleepDebtDetailJsonProvider({String? date})
    : this._internal(
        (ref) => sleepDebtDetailJson(ref as SleepDebtDetailJsonRef, date: date),
        from: sleepDebtDetailJsonProvider,
        name: r'sleepDebtDetailJsonProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$sleepDebtDetailJsonHash,
        dependencies: SleepDebtDetailJsonFamily._dependencies,
        allTransitiveDependencies:
            SleepDebtDetailJsonFamily._allTransitiveDependencies,
        date: date,
      );

  SleepDebtDetailJsonProvider._internal(
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
    FutureOr<Map<String, dynamic>?> Function(SleepDebtDetailJsonRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SleepDebtDetailJsonProvider._internal(
        (ref) => create(ref as SleepDebtDetailJsonRef),
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
  AutoDisposeFutureProviderElement<Map<String, dynamic>?> createElement() {
    return _SleepDebtDetailJsonProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SleepDebtDetailJsonProvider && other.date == date;
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
mixin SleepDebtDetailJsonRef
    on AutoDisposeFutureProviderRef<Map<String, dynamic>?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _SleepDebtDetailJsonProviderElement
    extends AutoDisposeFutureProviderElement<Map<String, dynamic>?>
    with SleepDebtDetailJsonRef {
  _SleepDebtDetailJsonProviderElement(super.provider);

  @override
  String? get date => (origin as SleepDebtDetailJsonProvider).date;
}

String _$workloadBalanceRatioHash() =>
    r'669b06869e873978d913d523774e11de9e10490a';

/// See also [workloadBalanceRatio].
@ProviderFor(workloadBalanceRatio)
const workloadBalanceRatioProvider = WorkloadBalanceRatioFamily();

/// See also [workloadBalanceRatio].
class WorkloadBalanceRatioFamily extends Family<AsyncValue<double?>> {
  /// See also [workloadBalanceRatio].
  const WorkloadBalanceRatioFamily();

  /// See also [workloadBalanceRatio].
  WorkloadBalanceRatioProvider call({String? date}) {
    return WorkloadBalanceRatioProvider(date: date);
  }

  @override
  WorkloadBalanceRatioProvider getProviderOverride(
    covariant WorkloadBalanceRatioProvider provider,
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
  String? get name => r'workloadBalanceRatioProvider';
}

/// See also [workloadBalanceRatio].
class WorkloadBalanceRatioProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [workloadBalanceRatio].
  WorkloadBalanceRatioProvider({String? date})
    : this._internal(
        (ref) =>
            workloadBalanceRatio(ref as WorkloadBalanceRatioRef, date: date),
        from: workloadBalanceRatioProvider,
        name: r'workloadBalanceRatioProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$workloadBalanceRatioHash,
        dependencies: WorkloadBalanceRatioFamily._dependencies,
        allTransitiveDependencies:
            WorkloadBalanceRatioFamily._allTransitiveDependencies,
        date: date,
      );

  WorkloadBalanceRatioProvider._internal(
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
    FutureOr<double?> Function(WorkloadBalanceRatioRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WorkloadBalanceRatioProvider._internal(
        (ref) => create(ref as WorkloadBalanceRatioRef),
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
    return _WorkloadBalanceRatioProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkloadBalanceRatioProvider && other.date == date;
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
mixin WorkloadBalanceRatioRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _WorkloadBalanceRatioProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with WorkloadBalanceRatioRef {
  _WorkloadBalanceRatioProviderElement(super.provider);

  @override
  String? get date => (origin as WorkloadBalanceRatioProvider).date;
}

String _$workloadBalanceStateHash() =>
    r'30675c2773baac8b1fef0ad23dec2806982f22d7';

/// See also [workloadBalanceState].
@ProviderFor(workloadBalanceState)
const workloadBalanceStateProvider = WorkloadBalanceStateFamily();

/// See also [workloadBalanceState].
class WorkloadBalanceStateFamily extends Family<AsyncValue<int?>> {
  /// See also [workloadBalanceState].
  const WorkloadBalanceStateFamily();

  /// See also [workloadBalanceState].
  WorkloadBalanceStateProvider call({String? date}) {
    return WorkloadBalanceStateProvider(date: date);
  }

  @override
  WorkloadBalanceStateProvider getProviderOverride(
    covariant WorkloadBalanceStateProvider provider,
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
  String? get name => r'workloadBalanceStateProvider';
}

/// See also [workloadBalanceState].
class WorkloadBalanceStateProvider extends AutoDisposeFutureProvider<int?> {
  /// See also [workloadBalanceState].
  WorkloadBalanceStateProvider({String? date})
    : this._internal(
        (ref) =>
            workloadBalanceState(ref as WorkloadBalanceStateRef, date: date),
        from: workloadBalanceStateProvider,
        name: r'workloadBalanceStateProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$workloadBalanceStateHash,
        dependencies: WorkloadBalanceStateFamily._dependencies,
        allTransitiveDependencies:
            WorkloadBalanceStateFamily._allTransitiveDependencies,
        date: date,
      );

  WorkloadBalanceStateProvider._internal(
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
    FutureOr<int?> Function(WorkloadBalanceStateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WorkloadBalanceStateProvider._internal(
        (ref) => create(ref as WorkloadBalanceStateRef),
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
  AutoDisposeFutureProviderElement<int?> createElement() {
    return _WorkloadBalanceStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkloadBalanceStateProvider && other.date == date;
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
mixin WorkloadBalanceStateRef on AutoDisposeFutureProviderRef<int?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _WorkloadBalanceStateProviderElement
    extends AutoDisposeFutureProviderElement<int?>
    with WorkloadBalanceStateRef {
  _WorkloadBalanceStateProviderElement(super.provider);

  @override
  String? get date => (origin as WorkloadBalanceStateProvider).date;
}

String _$workloadBalanceScoreHash() =>
    r'82428e240dd0a9391241141de8e5f49faf437893';

/// See also [workloadBalanceScore].
@ProviderFor(workloadBalanceScore)
const workloadBalanceScoreProvider = WorkloadBalanceScoreFamily();

/// See also [workloadBalanceScore].
class WorkloadBalanceScoreFamily extends Family<AsyncValue<double?>> {
  /// See also [workloadBalanceScore].
  const WorkloadBalanceScoreFamily();

  /// See also [workloadBalanceScore].
  WorkloadBalanceScoreProvider call({String? date}) {
    return WorkloadBalanceScoreProvider(date: date);
  }

  @override
  WorkloadBalanceScoreProvider getProviderOverride(
    covariant WorkloadBalanceScoreProvider provider,
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
  String? get name => r'workloadBalanceScoreProvider';
}

/// See also [workloadBalanceScore].
class WorkloadBalanceScoreProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [workloadBalanceScore].
  WorkloadBalanceScoreProvider({String? date})
    : this._internal(
        (ref) =>
            workloadBalanceScore(ref as WorkloadBalanceScoreRef, date: date),
        from: workloadBalanceScoreProvider,
        name: r'workloadBalanceScoreProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$workloadBalanceScoreHash,
        dependencies: WorkloadBalanceScoreFamily._dependencies,
        allTransitiveDependencies:
            WorkloadBalanceScoreFamily._allTransitiveDependencies,
        date: date,
      );

  WorkloadBalanceScoreProvider._internal(
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
    FutureOr<double?> Function(WorkloadBalanceScoreRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WorkloadBalanceScoreProvider._internal(
        (ref) => create(ref as WorkloadBalanceScoreRef),
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
    return _WorkloadBalanceScoreProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkloadBalanceScoreProvider && other.date == date;
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
mixin WorkloadBalanceScoreRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _WorkloadBalanceScoreProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with WorkloadBalanceScoreRef {
  _WorkloadBalanceScoreProviderElement(super.provider);

  @override
  String? get date => (origin as WorkloadBalanceScoreProvider).date;
}

String _$workloadBalanceTrainingAdviceHash() =>
    r'2ef550726cd665a639c7a823da943aea7d9972ae';

/// See also [workloadBalanceTrainingAdvice].
@ProviderFor(workloadBalanceTrainingAdvice)
const workloadBalanceTrainingAdviceProvider =
    WorkloadBalanceTrainingAdviceFamily();

/// See also [workloadBalanceTrainingAdvice].
class WorkloadBalanceTrainingAdviceFamily extends Family<AsyncValue<String?>> {
  /// See also [workloadBalanceTrainingAdvice].
  const WorkloadBalanceTrainingAdviceFamily();

  /// See also [workloadBalanceTrainingAdvice].
  WorkloadBalanceTrainingAdviceProvider call({String? date}) {
    return WorkloadBalanceTrainingAdviceProvider(date: date);
  }

  @override
  WorkloadBalanceTrainingAdviceProvider getProviderOverride(
    covariant WorkloadBalanceTrainingAdviceProvider provider,
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
  String? get name => r'workloadBalanceTrainingAdviceProvider';
}

/// See also [workloadBalanceTrainingAdvice].
class WorkloadBalanceTrainingAdviceProvider
    extends AutoDisposeFutureProvider<String?> {
  /// See also [workloadBalanceTrainingAdvice].
  WorkloadBalanceTrainingAdviceProvider({String? date})
    : this._internal(
        (ref) => workloadBalanceTrainingAdvice(
          ref as WorkloadBalanceTrainingAdviceRef,
          date: date,
        ),
        from: workloadBalanceTrainingAdviceProvider,
        name: r'workloadBalanceTrainingAdviceProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$workloadBalanceTrainingAdviceHash,
        dependencies: WorkloadBalanceTrainingAdviceFamily._dependencies,
        allTransitiveDependencies:
            WorkloadBalanceTrainingAdviceFamily._allTransitiveDependencies,
        date: date,
      );

  WorkloadBalanceTrainingAdviceProvider._internal(
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
    FutureOr<String?> Function(WorkloadBalanceTrainingAdviceRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WorkloadBalanceTrainingAdviceProvider._internal(
        (ref) => create(ref as WorkloadBalanceTrainingAdviceRef),
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
  AutoDisposeFutureProviderElement<String?> createElement() {
    return _WorkloadBalanceTrainingAdviceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkloadBalanceTrainingAdviceProvider && other.date == date;
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
mixin WorkloadBalanceTrainingAdviceRef
    on AutoDisposeFutureProviderRef<String?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _WorkloadBalanceTrainingAdviceProviderElement
    extends AutoDisposeFutureProviderElement<String?>
    with WorkloadBalanceTrainingAdviceRef {
  _WorkloadBalanceTrainingAdviceProviderElement(super.provider);

  @override
  String? get date => (origin as WorkloadBalanceTrainingAdviceProvider).date;
}

String _$workloadBalanceAcuteLoadHash() =>
    r'a2c950a456173abade140a0cec981d401ef832c0';

/// See also [workloadBalanceAcuteLoad].
@ProviderFor(workloadBalanceAcuteLoad)
const workloadBalanceAcuteLoadProvider = WorkloadBalanceAcuteLoadFamily();

/// See also [workloadBalanceAcuteLoad].
class WorkloadBalanceAcuteLoadFamily extends Family<AsyncValue<double?>> {
  /// See also [workloadBalanceAcuteLoad].
  const WorkloadBalanceAcuteLoadFamily();

  /// See also [workloadBalanceAcuteLoad].
  WorkloadBalanceAcuteLoadProvider call({String? date}) {
    return WorkloadBalanceAcuteLoadProvider(date: date);
  }

  @override
  WorkloadBalanceAcuteLoadProvider getProviderOverride(
    covariant WorkloadBalanceAcuteLoadProvider provider,
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
  String? get name => r'workloadBalanceAcuteLoadProvider';
}

/// See also [workloadBalanceAcuteLoad].
class WorkloadBalanceAcuteLoadProvider
    extends AutoDisposeFutureProvider<double?> {
  /// See also [workloadBalanceAcuteLoad].
  WorkloadBalanceAcuteLoadProvider({String? date})
    : this._internal(
        (ref) => workloadBalanceAcuteLoad(
          ref as WorkloadBalanceAcuteLoadRef,
          date: date,
        ),
        from: workloadBalanceAcuteLoadProvider,
        name: r'workloadBalanceAcuteLoadProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$workloadBalanceAcuteLoadHash,
        dependencies: WorkloadBalanceAcuteLoadFamily._dependencies,
        allTransitiveDependencies:
            WorkloadBalanceAcuteLoadFamily._allTransitiveDependencies,
        date: date,
      );

  WorkloadBalanceAcuteLoadProvider._internal(
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
    FutureOr<double?> Function(WorkloadBalanceAcuteLoadRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WorkloadBalanceAcuteLoadProvider._internal(
        (ref) => create(ref as WorkloadBalanceAcuteLoadRef),
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
    return _WorkloadBalanceAcuteLoadProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkloadBalanceAcuteLoadProvider && other.date == date;
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
mixin WorkloadBalanceAcuteLoadRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _WorkloadBalanceAcuteLoadProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with WorkloadBalanceAcuteLoadRef {
  _WorkloadBalanceAcuteLoadProviderElement(super.provider);

  @override
  String? get date => (origin as WorkloadBalanceAcuteLoadProvider).date;
}

String _$workloadBalanceChronicLoadHash() =>
    r'4891b6ceda8e2afd4bb646d173887031f293ac4a';

/// See also [workloadBalanceChronicLoad].
@ProviderFor(workloadBalanceChronicLoad)
const workloadBalanceChronicLoadProvider = WorkloadBalanceChronicLoadFamily();

/// See also [workloadBalanceChronicLoad].
class WorkloadBalanceChronicLoadFamily extends Family<AsyncValue<double?>> {
  /// See also [workloadBalanceChronicLoad].
  const WorkloadBalanceChronicLoadFamily();

  /// See also [workloadBalanceChronicLoad].
  WorkloadBalanceChronicLoadProvider call({String? date}) {
    return WorkloadBalanceChronicLoadProvider(date: date);
  }

  @override
  WorkloadBalanceChronicLoadProvider getProviderOverride(
    covariant WorkloadBalanceChronicLoadProvider provider,
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
  String? get name => r'workloadBalanceChronicLoadProvider';
}

/// See also [workloadBalanceChronicLoad].
class WorkloadBalanceChronicLoadProvider
    extends AutoDisposeFutureProvider<double?> {
  /// See also [workloadBalanceChronicLoad].
  WorkloadBalanceChronicLoadProvider({String? date})
    : this._internal(
        (ref) => workloadBalanceChronicLoad(
          ref as WorkloadBalanceChronicLoadRef,
          date: date,
        ),
        from: workloadBalanceChronicLoadProvider,
        name: r'workloadBalanceChronicLoadProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$workloadBalanceChronicLoadHash,
        dependencies: WorkloadBalanceChronicLoadFamily._dependencies,
        allTransitiveDependencies:
            WorkloadBalanceChronicLoadFamily._allTransitiveDependencies,
        date: date,
      );

  WorkloadBalanceChronicLoadProvider._internal(
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
    FutureOr<double?> Function(WorkloadBalanceChronicLoadRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WorkloadBalanceChronicLoadProvider._internal(
        (ref) => create(ref as WorkloadBalanceChronicLoadRef),
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
    return _WorkloadBalanceChronicLoadProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkloadBalanceChronicLoadProvider && other.date == date;
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
mixin WorkloadBalanceChronicLoadRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _WorkloadBalanceChronicLoadProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with WorkloadBalanceChronicLoadRef {
  _WorkloadBalanceChronicLoadProviderElement(super.provider);

  @override
  String? get date => (origin as WorkloadBalanceChronicLoadProvider).date;
}

String _$workloadBalanceRecoveryLevelHash() =>
    r'aded84853c740ddaf0caa7e6544005a441c46267';

/// See also [workloadBalanceRecoveryLevel].
@ProviderFor(workloadBalanceRecoveryLevel)
const workloadBalanceRecoveryLevelProvider =
    WorkloadBalanceRecoveryLevelFamily();

/// See also [workloadBalanceRecoveryLevel].
class WorkloadBalanceRecoveryLevelFamily extends Family<AsyncValue<double?>> {
  /// See also [workloadBalanceRecoveryLevel].
  const WorkloadBalanceRecoveryLevelFamily();

  /// See also [workloadBalanceRecoveryLevel].
  WorkloadBalanceRecoveryLevelProvider call({String? date}) {
    return WorkloadBalanceRecoveryLevelProvider(date: date);
  }

  @override
  WorkloadBalanceRecoveryLevelProvider getProviderOverride(
    covariant WorkloadBalanceRecoveryLevelProvider provider,
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
  String? get name => r'workloadBalanceRecoveryLevelProvider';
}

/// See also [workloadBalanceRecoveryLevel].
class WorkloadBalanceRecoveryLevelProvider
    extends AutoDisposeFutureProvider<double?> {
  /// See also [workloadBalanceRecoveryLevel].
  WorkloadBalanceRecoveryLevelProvider({String? date})
    : this._internal(
        (ref) => workloadBalanceRecoveryLevel(
          ref as WorkloadBalanceRecoveryLevelRef,
          date: date,
        ),
        from: workloadBalanceRecoveryLevelProvider,
        name: r'workloadBalanceRecoveryLevelProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$workloadBalanceRecoveryLevelHash,
        dependencies: WorkloadBalanceRecoveryLevelFamily._dependencies,
        allTransitiveDependencies:
            WorkloadBalanceRecoveryLevelFamily._allTransitiveDependencies,
        date: date,
      );

  WorkloadBalanceRecoveryLevelProvider._internal(
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
    FutureOr<double?> Function(WorkloadBalanceRecoveryLevelRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WorkloadBalanceRecoveryLevelProvider._internal(
        (ref) => create(ref as WorkloadBalanceRecoveryLevelRef),
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
    return _WorkloadBalanceRecoveryLevelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkloadBalanceRecoveryLevelProvider && other.date == date;
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
mixin WorkloadBalanceRecoveryLevelRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _WorkloadBalanceRecoveryLevelProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with WorkloadBalanceRecoveryLevelRef {
  _WorkloadBalanceRecoveryLevelProviderElement(super.provider);

  @override
  String? get date => (origin as WorkloadBalanceRecoveryLevelProvider).date;
}

String _$workloadBalanceReadinessLevelHash() =>
    r'a7816555e5a1d9c537ebdb27f7d5e376d6d95a2d';

/// See also [workloadBalanceReadinessLevel].
@ProviderFor(workloadBalanceReadinessLevel)
const workloadBalanceReadinessLevelProvider =
    WorkloadBalanceReadinessLevelFamily();

/// See also [workloadBalanceReadinessLevel].
class WorkloadBalanceReadinessLevelFamily extends Family<AsyncValue<double?>> {
  /// See also [workloadBalanceReadinessLevel].
  const WorkloadBalanceReadinessLevelFamily();

  /// See also [workloadBalanceReadinessLevel].
  WorkloadBalanceReadinessLevelProvider call({String? date}) {
    return WorkloadBalanceReadinessLevelProvider(date: date);
  }

  @override
  WorkloadBalanceReadinessLevelProvider getProviderOverride(
    covariant WorkloadBalanceReadinessLevelProvider provider,
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
  String? get name => r'workloadBalanceReadinessLevelProvider';
}

/// See also [workloadBalanceReadinessLevel].
class WorkloadBalanceReadinessLevelProvider
    extends AutoDisposeFutureProvider<double?> {
  /// See also [workloadBalanceReadinessLevel].
  WorkloadBalanceReadinessLevelProvider({String? date})
    : this._internal(
        (ref) => workloadBalanceReadinessLevel(
          ref as WorkloadBalanceReadinessLevelRef,
          date: date,
        ),
        from: workloadBalanceReadinessLevelProvider,
        name: r'workloadBalanceReadinessLevelProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$workloadBalanceReadinessLevelHash,
        dependencies: WorkloadBalanceReadinessLevelFamily._dependencies,
        allTransitiveDependencies:
            WorkloadBalanceReadinessLevelFamily._allTransitiveDependencies,
        date: date,
      );

  WorkloadBalanceReadinessLevelProvider._internal(
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
    FutureOr<double?> Function(WorkloadBalanceReadinessLevelRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WorkloadBalanceReadinessLevelProvider._internal(
        (ref) => create(ref as WorkloadBalanceReadinessLevelRef),
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
    return _WorkloadBalanceReadinessLevelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkloadBalanceReadinessLevelProvider && other.date == date;
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
mixin WorkloadBalanceReadinessLevelRef
    on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _WorkloadBalanceReadinessLevelProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with WorkloadBalanceReadinessLevelRef {
  _WorkloadBalanceReadinessLevelProviderElement(super.provider);

  @override
  String? get date => (origin as WorkloadBalanceReadinessLevelProvider).date;
}

String _$workloadBalanceTrendHash() =>
    r'7302a45c26f63387fc30c5365d383f77aca7c8d9';

/// See also [workloadBalanceTrend].
@ProviderFor(workloadBalanceTrend)
const workloadBalanceTrendProvider = WorkloadBalanceTrendFamily();

/// See also [workloadBalanceTrend].
class WorkloadBalanceTrendFamily extends Family<AsyncValue<int?>> {
  /// See also [workloadBalanceTrend].
  const WorkloadBalanceTrendFamily();

  /// See also [workloadBalanceTrend].
  WorkloadBalanceTrendProvider call({String? date}) {
    return WorkloadBalanceTrendProvider(date: date);
  }

  @override
  WorkloadBalanceTrendProvider getProviderOverride(
    covariant WorkloadBalanceTrendProvider provider,
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
  String? get name => r'workloadBalanceTrendProvider';
}

/// See also [workloadBalanceTrend].
class WorkloadBalanceTrendProvider extends AutoDisposeFutureProvider<int?> {
  /// See also [workloadBalanceTrend].
  WorkloadBalanceTrendProvider({String? date})
    : this._internal(
        (ref) =>
            workloadBalanceTrend(ref as WorkloadBalanceTrendRef, date: date),
        from: workloadBalanceTrendProvider,
        name: r'workloadBalanceTrendProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$workloadBalanceTrendHash,
        dependencies: WorkloadBalanceTrendFamily._dependencies,
        allTransitiveDependencies:
            WorkloadBalanceTrendFamily._allTransitiveDependencies,
        date: date,
      );

  WorkloadBalanceTrendProvider._internal(
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
    FutureOr<int?> Function(WorkloadBalanceTrendRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: WorkloadBalanceTrendProvider._internal(
        (ref) => create(ref as WorkloadBalanceTrendRef),
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
  AutoDisposeFutureProviderElement<int?> createElement() {
    return _WorkloadBalanceTrendProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is WorkloadBalanceTrendProvider && other.date == date;
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
mixin WorkloadBalanceTrendRef on AutoDisposeFutureProviderRef<int?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _WorkloadBalanceTrendProviderElement
    extends AutoDisposeFutureProviderElement<int?>
    with WorkloadBalanceTrendRef {
  _WorkloadBalanceTrendProviderElement(super.provider);

  @override
  String? get date => (origin as WorkloadBalanceTrendProvider).date;
}

String _$consistencyOverallScoreHash() =>
    r'c164bd4bf6f999b6db2e15078d40c5026b804185';

/// See also [consistencyOverallScore].
@ProviderFor(consistencyOverallScore)
const consistencyOverallScoreProvider = ConsistencyOverallScoreFamily();

/// See also [consistencyOverallScore].
class ConsistencyOverallScoreFamily extends Family<AsyncValue<double?>> {
  /// See also [consistencyOverallScore].
  const ConsistencyOverallScoreFamily();

  /// See also [consistencyOverallScore].
  ConsistencyOverallScoreProvider call({String? date}) {
    return ConsistencyOverallScoreProvider(date: date);
  }

  @override
  ConsistencyOverallScoreProvider getProviderOverride(
    covariant ConsistencyOverallScoreProvider provider,
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
  String? get name => r'consistencyOverallScoreProvider';
}

/// See also [consistencyOverallScore].
class ConsistencyOverallScoreProvider
    extends AutoDisposeFutureProvider<double?> {
  /// See also [consistencyOverallScore].
  ConsistencyOverallScoreProvider({String? date})
    : this._internal(
        (ref) => consistencyOverallScore(
          ref as ConsistencyOverallScoreRef,
          date: date,
        ),
        from: consistencyOverallScoreProvider,
        name: r'consistencyOverallScoreProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$consistencyOverallScoreHash,
        dependencies: ConsistencyOverallScoreFamily._dependencies,
        allTransitiveDependencies:
            ConsistencyOverallScoreFamily._allTransitiveDependencies,
        date: date,
      );

  ConsistencyOverallScoreProvider._internal(
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
    FutureOr<double?> Function(ConsistencyOverallScoreRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ConsistencyOverallScoreProvider._internal(
        (ref) => create(ref as ConsistencyOverallScoreRef),
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
    return _ConsistencyOverallScoreProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ConsistencyOverallScoreProvider && other.date == date;
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
mixin ConsistencyOverallScoreRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _ConsistencyOverallScoreProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with ConsistencyOverallScoreRef {
  _ConsistencyOverallScoreProviderElement(super.provider);

  @override
  String? get date => (origin as ConsistencyOverallScoreProvider).date;
}

String _$consistencyStepsScoreHash() =>
    r'cedf343a7f69d5bf9d1895d6ec683d4ce07da9d8';

/// See also [consistencyStepsScore].
@ProviderFor(consistencyStepsScore)
const consistencyStepsScoreProvider = ConsistencyStepsScoreFamily();

/// See also [consistencyStepsScore].
class ConsistencyStepsScoreFamily extends Family<AsyncValue<double?>> {
  /// See also [consistencyStepsScore].
  const ConsistencyStepsScoreFamily();

  /// See also [consistencyStepsScore].
  ConsistencyStepsScoreProvider call({String? date}) {
    return ConsistencyStepsScoreProvider(date: date);
  }

  @override
  ConsistencyStepsScoreProvider getProviderOverride(
    covariant ConsistencyStepsScoreProvider provider,
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
  String? get name => r'consistencyStepsScoreProvider';
}

/// See also [consistencyStepsScore].
class ConsistencyStepsScoreProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [consistencyStepsScore].
  ConsistencyStepsScoreProvider({String? date})
    : this._internal(
        (ref) =>
            consistencyStepsScore(ref as ConsistencyStepsScoreRef, date: date),
        from: consistencyStepsScoreProvider,
        name: r'consistencyStepsScoreProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$consistencyStepsScoreHash,
        dependencies: ConsistencyStepsScoreFamily._dependencies,
        allTransitiveDependencies:
            ConsistencyStepsScoreFamily._allTransitiveDependencies,
        date: date,
      );

  ConsistencyStepsScoreProvider._internal(
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
    FutureOr<double?> Function(ConsistencyStepsScoreRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ConsistencyStepsScoreProvider._internal(
        (ref) => create(ref as ConsistencyStepsScoreRef),
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
    return _ConsistencyStepsScoreProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ConsistencyStepsScoreProvider && other.date == date;
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
mixin ConsistencyStepsScoreRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _ConsistencyStepsScoreProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with ConsistencyStepsScoreRef {
  _ConsistencyStepsScoreProviderElement(super.provider);

  @override
  String? get date => (origin as ConsistencyStepsScoreProvider).date;
}

String _$consistencyEnergyScoreHash() =>
    r'ac758433fa1f5b8d1c1044ac400d49b57e7920dc';

/// See also [consistencyEnergyScore].
@ProviderFor(consistencyEnergyScore)
const consistencyEnergyScoreProvider = ConsistencyEnergyScoreFamily();

/// See also [consistencyEnergyScore].
class ConsistencyEnergyScoreFamily extends Family<AsyncValue<double?>> {
  /// See also [consistencyEnergyScore].
  const ConsistencyEnergyScoreFamily();

  /// See also [consistencyEnergyScore].
  ConsistencyEnergyScoreProvider call({String? date}) {
    return ConsistencyEnergyScoreProvider(date: date);
  }

  @override
  ConsistencyEnergyScoreProvider getProviderOverride(
    covariant ConsistencyEnergyScoreProvider provider,
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
  String? get name => r'consistencyEnergyScoreProvider';
}

/// See also [consistencyEnergyScore].
class ConsistencyEnergyScoreProvider
    extends AutoDisposeFutureProvider<double?> {
  /// See also [consistencyEnergyScore].
  ConsistencyEnergyScoreProvider({String? date})
    : this._internal(
        (ref) => consistencyEnergyScore(
          ref as ConsistencyEnergyScoreRef,
          date: date,
        ),
        from: consistencyEnergyScoreProvider,
        name: r'consistencyEnergyScoreProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$consistencyEnergyScoreHash,
        dependencies: ConsistencyEnergyScoreFamily._dependencies,
        allTransitiveDependencies:
            ConsistencyEnergyScoreFamily._allTransitiveDependencies,
        date: date,
      );

  ConsistencyEnergyScoreProvider._internal(
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
    FutureOr<double?> Function(ConsistencyEnergyScoreRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ConsistencyEnergyScoreProvider._internal(
        (ref) => create(ref as ConsistencyEnergyScoreRef),
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
    return _ConsistencyEnergyScoreProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ConsistencyEnergyScoreProvider && other.date == date;
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
mixin ConsistencyEnergyScoreRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _ConsistencyEnergyScoreProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with ConsistencyEnergyScoreRef {
  _ConsistencyEnergyScoreProviderElement(super.provider);

  @override
  String? get date => (origin as ConsistencyEnergyScoreProvider).date;
}

String _$consistencyStateHash() => r'8c252e58f0a7cc4c5cae8706ae89dce6f742c05b';

/// See also [consistencyState].
@ProviderFor(consistencyState)
const consistencyStateProvider = ConsistencyStateFamily();

/// See also [consistencyState].
class ConsistencyStateFamily extends Family<AsyncValue<int?>> {
  /// See also [consistencyState].
  const ConsistencyStateFamily();

  /// See also [consistencyState].
  ConsistencyStateProvider call({String? date}) {
    return ConsistencyStateProvider(date: date);
  }

  @override
  ConsistencyStateProvider getProviderOverride(
    covariant ConsistencyStateProvider provider,
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
  String? get name => r'consistencyStateProvider';
}

/// See also [consistencyState].
class ConsistencyStateProvider extends AutoDisposeFutureProvider<int?> {
  /// See also [consistencyState].
  ConsistencyStateProvider({String? date})
    : this._internal(
        (ref) => consistencyState(ref as ConsistencyStateRef, date: date),
        from: consistencyStateProvider,
        name: r'consistencyStateProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$consistencyStateHash,
        dependencies: ConsistencyStateFamily._dependencies,
        allTransitiveDependencies:
            ConsistencyStateFamily._allTransitiveDependencies,
        date: date,
      );

  ConsistencyStateProvider._internal(
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
    FutureOr<int?> Function(ConsistencyStateRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ConsistencyStateProvider._internal(
        (ref) => create(ref as ConsistencyStateRef),
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
  AutoDisposeFutureProviderElement<int?> createElement() {
    return _ConsistencyStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ConsistencyStateProvider && other.date == date;
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
mixin ConsistencyStateRef on AutoDisposeFutureProviderRef<int?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _ConsistencyStateProviderElement
    extends AutoDisposeFutureProviderElement<int?>
    with ConsistencyStateRef {
  _ConsistencyStateProviderElement(super.provider);

  @override
  String? get date => (origin as ConsistencyStateProvider).date;
}

String _$consistencyActiveDaysHash() =>
    r'b6989c73487eb33ac2f3c9a861193c1ea6fbb233';

/// See also [consistencyActiveDays].
@ProviderFor(consistencyActiveDays)
const consistencyActiveDaysProvider = ConsistencyActiveDaysFamily();

/// See also [consistencyActiveDays].
class ConsistencyActiveDaysFamily extends Family<AsyncValue<double?>> {
  /// See also [consistencyActiveDays].
  const ConsistencyActiveDaysFamily();

  /// See also [consistencyActiveDays].
  ConsistencyActiveDaysProvider call({String? date}) {
    return ConsistencyActiveDaysProvider(date: date);
  }

  @override
  ConsistencyActiveDaysProvider getProviderOverride(
    covariant ConsistencyActiveDaysProvider provider,
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
  String? get name => r'consistencyActiveDaysProvider';
}

/// See also [consistencyActiveDays].
class ConsistencyActiveDaysProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [consistencyActiveDays].
  ConsistencyActiveDaysProvider({String? date})
    : this._internal(
        (ref) =>
            consistencyActiveDays(ref as ConsistencyActiveDaysRef, date: date),
        from: consistencyActiveDaysProvider,
        name: r'consistencyActiveDaysProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$consistencyActiveDaysHash,
        dependencies: ConsistencyActiveDaysFamily._dependencies,
        allTransitiveDependencies:
            ConsistencyActiveDaysFamily._allTransitiveDependencies,
        date: date,
      );

  ConsistencyActiveDaysProvider._internal(
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
    FutureOr<double?> Function(ConsistencyActiveDaysRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ConsistencyActiveDaysProvider._internal(
        (ref) => create(ref as ConsistencyActiveDaysRef),
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
    return _ConsistencyActiveDaysProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ConsistencyActiveDaysProvider && other.date == date;
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
mixin ConsistencyActiveDaysRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _ConsistencyActiveDaysProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with ConsistencyActiveDaysRef {
  _ConsistencyActiveDaysProviderElement(super.provider);

  @override
  String? get date => (origin as ConsistencyActiveDaysProvider).date;
}

String _$consistencyStreakHash() => r'bd60796491f202f4a0c620ac29c9f52be9c3b788';

/// See also [consistencyStreak].
@ProviderFor(consistencyStreak)
const consistencyStreakProvider = ConsistencyStreakFamily();

/// See also [consistencyStreak].
class ConsistencyStreakFamily extends Family<AsyncValue<double?>> {
  /// See also [consistencyStreak].
  const ConsistencyStreakFamily();

  /// See also [consistencyStreak].
  ConsistencyStreakProvider call({String? date}) {
    return ConsistencyStreakProvider(date: date);
  }

  @override
  ConsistencyStreakProvider getProviderOverride(
    covariant ConsistencyStreakProvider provider,
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
  String? get name => r'consistencyStreakProvider';
}

/// See also [consistencyStreak].
class ConsistencyStreakProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [consistencyStreak].
  ConsistencyStreakProvider({String? date})
    : this._internal(
        (ref) => consistencyStreak(ref as ConsistencyStreakRef, date: date),
        from: consistencyStreakProvider,
        name: r'consistencyStreakProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$consistencyStreakHash,
        dependencies: ConsistencyStreakFamily._dependencies,
        allTransitiveDependencies:
            ConsistencyStreakFamily._allTransitiveDependencies,
        date: date,
      );

  ConsistencyStreakProvider._internal(
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
    FutureOr<double?> Function(ConsistencyStreakRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ConsistencyStreakProvider._internal(
        (ref) => create(ref as ConsistencyStreakRef),
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
    return _ConsistencyStreakProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ConsistencyStreakProvider && other.date == date;
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
mixin ConsistencyStreakRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _ConsistencyStreakProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with ConsistencyStreakRef {
  _ConsistencyStreakProviderElement(super.provider);

  @override
  String? get date => (origin as ConsistencyStreakProvider).date;
}

String _$consistencyBestStreakHash() =>
    r'698fb88489a004fd1ae639524b88f0b8136849e7';

/// See also [consistencyBestStreak].
@ProviderFor(consistencyBestStreak)
const consistencyBestStreakProvider = ConsistencyBestStreakFamily();

/// See also [consistencyBestStreak].
class ConsistencyBestStreakFamily extends Family<AsyncValue<double?>> {
  /// See also [consistencyBestStreak].
  const ConsistencyBestStreakFamily();

  /// See also [consistencyBestStreak].
  ConsistencyBestStreakProvider call({String? date}) {
    return ConsistencyBestStreakProvider(date: date);
  }

  @override
  ConsistencyBestStreakProvider getProviderOverride(
    covariant ConsistencyBestStreakProvider provider,
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
  String? get name => r'consistencyBestStreakProvider';
}

/// See also [consistencyBestStreak].
class ConsistencyBestStreakProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [consistencyBestStreak].
  ConsistencyBestStreakProvider({String? date})
    : this._internal(
        (ref) =>
            consistencyBestStreak(ref as ConsistencyBestStreakRef, date: date),
        from: consistencyBestStreakProvider,
        name: r'consistencyBestStreakProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$consistencyBestStreakHash,
        dependencies: ConsistencyBestStreakFamily._dependencies,
        allTransitiveDependencies:
            ConsistencyBestStreakFamily._allTransitiveDependencies,
        date: date,
      );

  ConsistencyBestStreakProvider._internal(
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
    FutureOr<double?> Function(ConsistencyBestStreakRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ConsistencyBestStreakProvider._internal(
        (ref) => create(ref as ConsistencyBestStreakRef),
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
    return _ConsistencyBestStreakProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ConsistencyBestStreakProvider && other.date == date;
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
mixin ConsistencyBestStreakRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _ConsistencyBestStreakProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with ConsistencyBestStreakRef {
  _ConsistencyBestStreakProviderElement(super.provider);

  @override
  String? get date => (origin as ConsistencyBestStreakProvider).date;
}

String _$chronotypeCategoryHash() =>
    r'f1a0eb84b06e270bc4f820ca0554849341ae6e6a';

/// See also [chronotypeCategory].
@ProviderFor(chronotypeCategory)
const chronotypeCategoryProvider = ChronotypeCategoryFamily();

/// See also [chronotypeCategory].
class ChronotypeCategoryFamily extends Family<AsyncValue<int?>> {
  /// See also [chronotypeCategory].
  const ChronotypeCategoryFamily();

  /// See also [chronotypeCategory].
  ChronotypeCategoryProvider call({String? date}) {
    return ChronotypeCategoryProvider(date: date);
  }

  @override
  ChronotypeCategoryProvider getProviderOverride(
    covariant ChronotypeCategoryProvider provider,
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
  String? get name => r'chronotypeCategoryProvider';
}

/// See also [chronotypeCategory].
class ChronotypeCategoryProvider extends AutoDisposeFutureProvider<int?> {
  /// See also [chronotypeCategory].
  ChronotypeCategoryProvider({String? date})
    : this._internal(
        (ref) => chronotypeCategory(ref as ChronotypeCategoryRef, date: date),
        from: chronotypeCategoryProvider,
        name: r'chronotypeCategoryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$chronotypeCategoryHash,
        dependencies: ChronotypeCategoryFamily._dependencies,
        allTransitiveDependencies:
            ChronotypeCategoryFamily._allTransitiveDependencies,
        date: date,
      );

  ChronotypeCategoryProvider._internal(
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
    FutureOr<int?> Function(ChronotypeCategoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChronotypeCategoryProvider._internal(
        (ref) => create(ref as ChronotypeCategoryRef),
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
  AutoDisposeFutureProviderElement<int?> createElement() {
    return _ChronotypeCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChronotypeCategoryProvider && other.date == date;
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
mixin ChronotypeCategoryRef on AutoDisposeFutureProviderRef<int?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _ChronotypeCategoryProviderElement
    extends AutoDisposeFutureProviderElement<int?>
    with ChronotypeCategoryRef {
  _ChronotypeCategoryProviderElement(super.provider);

  @override
  String? get date => (origin as ChronotypeCategoryProvider).date;
}

String _$chronotypeCategoryLabelHash() =>
    r'8e50b47d4c30d9fad4cbd3a0410f83169a1e4e44';

/// See also [chronotypeCategoryLabel].
@ProviderFor(chronotypeCategoryLabel)
const chronotypeCategoryLabelProvider = ChronotypeCategoryLabelFamily();

/// See also [chronotypeCategoryLabel].
class ChronotypeCategoryLabelFamily extends Family<AsyncValue<String?>> {
  /// See also [chronotypeCategoryLabel].
  const ChronotypeCategoryLabelFamily();

  /// See also [chronotypeCategoryLabel].
  ChronotypeCategoryLabelProvider call({String? date}) {
    return ChronotypeCategoryLabelProvider(date: date);
  }

  @override
  ChronotypeCategoryLabelProvider getProviderOverride(
    covariant ChronotypeCategoryLabelProvider provider,
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
  String? get name => r'chronotypeCategoryLabelProvider';
}

/// See also [chronotypeCategoryLabel].
class ChronotypeCategoryLabelProvider
    extends AutoDisposeFutureProvider<String?> {
  /// See also [chronotypeCategoryLabel].
  ChronotypeCategoryLabelProvider({String? date})
    : this._internal(
        (ref) => chronotypeCategoryLabel(
          ref as ChronotypeCategoryLabelRef,
          date: date,
        ),
        from: chronotypeCategoryLabelProvider,
        name: r'chronotypeCategoryLabelProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$chronotypeCategoryLabelHash,
        dependencies: ChronotypeCategoryLabelFamily._dependencies,
        allTransitiveDependencies:
            ChronotypeCategoryLabelFamily._allTransitiveDependencies,
        date: date,
      );

  ChronotypeCategoryLabelProvider._internal(
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
    FutureOr<String?> Function(ChronotypeCategoryLabelRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChronotypeCategoryLabelProvider._internal(
        (ref) => create(ref as ChronotypeCategoryLabelRef),
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
  AutoDisposeFutureProviderElement<String?> createElement() {
    return _ChronotypeCategoryLabelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChronotypeCategoryLabelProvider && other.date == date;
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
mixin ChronotypeCategoryLabelRef on AutoDisposeFutureProviderRef<String?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _ChronotypeCategoryLabelProviderElement
    extends AutoDisposeFutureProviderElement<String?>
    with ChronotypeCategoryLabelRef {
  _ChronotypeCategoryLabelProviderElement(super.provider);

  @override
  String? get date => (origin as ChronotypeCategoryLabelProvider).date;
}

String _$chronotypeAvgBedtimeHash() =>
    r'c09ca4916bc043f11a7e6ddddb8d13dab59eadb2';

/// See also [chronotypeAvgBedtime].
@ProviderFor(chronotypeAvgBedtime)
const chronotypeAvgBedtimeProvider = ChronotypeAvgBedtimeFamily();

/// See also [chronotypeAvgBedtime].
class ChronotypeAvgBedtimeFamily extends Family<AsyncValue<double?>> {
  /// See also [chronotypeAvgBedtime].
  const ChronotypeAvgBedtimeFamily();

  /// See also [chronotypeAvgBedtime].
  ChronotypeAvgBedtimeProvider call({String? date}) {
    return ChronotypeAvgBedtimeProvider(date: date);
  }

  @override
  ChronotypeAvgBedtimeProvider getProviderOverride(
    covariant ChronotypeAvgBedtimeProvider provider,
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
  String? get name => r'chronotypeAvgBedtimeProvider';
}

/// See also [chronotypeAvgBedtime].
class ChronotypeAvgBedtimeProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [chronotypeAvgBedtime].
  ChronotypeAvgBedtimeProvider({String? date})
    : this._internal(
        (ref) =>
            chronotypeAvgBedtime(ref as ChronotypeAvgBedtimeRef, date: date),
        from: chronotypeAvgBedtimeProvider,
        name: r'chronotypeAvgBedtimeProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$chronotypeAvgBedtimeHash,
        dependencies: ChronotypeAvgBedtimeFamily._dependencies,
        allTransitiveDependencies:
            ChronotypeAvgBedtimeFamily._allTransitiveDependencies,
        date: date,
      );

  ChronotypeAvgBedtimeProvider._internal(
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
    FutureOr<double?> Function(ChronotypeAvgBedtimeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChronotypeAvgBedtimeProvider._internal(
        (ref) => create(ref as ChronotypeAvgBedtimeRef),
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
    return _ChronotypeAvgBedtimeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChronotypeAvgBedtimeProvider && other.date == date;
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
mixin ChronotypeAvgBedtimeRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _ChronotypeAvgBedtimeProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with ChronotypeAvgBedtimeRef {
  _ChronotypeAvgBedtimeProviderElement(super.provider);

  @override
  String? get date => (origin as ChronotypeAvgBedtimeProvider).date;
}

String _$chronotypeAvgWaketimeHash() =>
    r'cf77f247c2f90f561dc7c2b2409498ffa2399d29';

/// See also [chronotypeAvgWaketime].
@ProviderFor(chronotypeAvgWaketime)
const chronotypeAvgWaketimeProvider = ChronotypeAvgWaketimeFamily();

/// See also [chronotypeAvgWaketime].
class ChronotypeAvgWaketimeFamily extends Family<AsyncValue<double?>> {
  /// See also [chronotypeAvgWaketime].
  const ChronotypeAvgWaketimeFamily();

  /// See also [chronotypeAvgWaketime].
  ChronotypeAvgWaketimeProvider call({String? date}) {
    return ChronotypeAvgWaketimeProvider(date: date);
  }

  @override
  ChronotypeAvgWaketimeProvider getProviderOverride(
    covariant ChronotypeAvgWaketimeProvider provider,
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
  String? get name => r'chronotypeAvgWaketimeProvider';
}

/// See also [chronotypeAvgWaketime].
class ChronotypeAvgWaketimeProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [chronotypeAvgWaketime].
  ChronotypeAvgWaketimeProvider({String? date})
    : this._internal(
        (ref) =>
            chronotypeAvgWaketime(ref as ChronotypeAvgWaketimeRef, date: date),
        from: chronotypeAvgWaketimeProvider,
        name: r'chronotypeAvgWaketimeProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$chronotypeAvgWaketimeHash,
        dependencies: ChronotypeAvgWaketimeFamily._dependencies,
        allTransitiveDependencies:
            ChronotypeAvgWaketimeFamily._allTransitiveDependencies,
        date: date,
      );

  ChronotypeAvgWaketimeProvider._internal(
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
    FutureOr<double?> Function(ChronotypeAvgWaketimeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChronotypeAvgWaketimeProvider._internal(
        (ref) => create(ref as ChronotypeAvgWaketimeRef),
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
    return _ChronotypeAvgWaketimeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChronotypeAvgWaketimeProvider && other.date == date;
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
mixin ChronotypeAvgWaketimeRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _ChronotypeAvgWaketimeProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with ChronotypeAvgWaketimeRef {
  _ChronotypeAvgWaketimeProviderElement(super.provider);

  @override
  String? get date => (origin as ChronotypeAvgWaketimeProvider).date;
}

String _$chronotypeMidpointHash() =>
    r'fad35e540d35ab721b2546ad729de4f922385700';

/// See also [chronotypeMidpoint].
@ProviderFor(chronotypeMidpoint)
const chronotypeMidpointProvider = ChronotypeMidpointFamily();

/// See also [chronotypeMidpoint].
class ChronotypeMidpointFamily extends Family<AsyncValue<double?>> {
  /// See also [chronotypeMidpoint].
  const ChronotypeMidpointFamily();

  /// See also [chronotypeMidpoint].
  ChronotypeMidpointProvider call({String? date}) {
    return ChronotypeMidpointProvider(date: date);
  }

  @override
  ChronotypeMidpointProvider getProviderOverride(
    covariant ChronotypeMidpointProvider provider,
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
  String? get name => r'chronotypeMidpointProvider';
}

/// See also [chronotypeMidpoint].
class ChronotypeMidpointProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [chronotypeMidpoint].
  ChronotypeMidpointProvider({String? date})
    : this._internal(
        (ref) => chronotypeMidpoint(ref as ChronotypeMidpointRef, date: date),
        from: chronotypeMidpointProvider,
        name: r'chronotypeMidpointProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$chronotypeMidpointHash,
        dependencies: ChronotypeMidpointFamily._dependencies,
        allTransitiveDependencies:
            ChronotypeMidpointFamily._allTransitiveDependencies,
        date: date,
      );

  ChronotypeMidpointProvider._internal(
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
    FutureOr<double?> Function(ChronotypeMidpointRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChronotypeMidpointProvider._internal(
        (ref) => create(ref as ChronotypeMidpointRef),
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
    return _ChronotypeMidpointProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChronotypeMidpointProvider && other.date == date;
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
mixin ChronotypeMidpointRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _ChronotypeMidpointProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with ChronotypeMidpointRef {
  _ChronotypeMidpointProviderElement(super.provider);

  @override
  String? get date => (origin as ChronotypeMidpointProvider).date;
}

String _$chronotypeVariabilityHash() =>
    r'17450db265aa36f917679c37d01c66dfce25ebc8';

/// See also [chronotypeVariability].
@ProviderFor(chronotypeVariability)
const chronotypeVariabilityProvider = ChronotypeVariabilityFamily();

/// See also [chronotypeVariability].
class ChronotypeVariabilityFamily extends Family<AsyncValue<double?>> {
  /// See also [chronotypeVariability].
  const ChronotypeVariabilityFamily();

  /// See also [chronotypeVariability].
  ChronotypeVariabilityProvider call({String? date}) {
    return ChronotypeVariabilityProvider(date: date);
  }

  @override
  ChronotypeVariabilityProvider getProviderOverride(
    covariant ChronotypeVariabilityProvider provider,
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
  String? get name => r'chronotypeVariabilityProvider';
}

/// See also [chronotypeVariability].
class ChronotypeVariabilityProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [chronotypeVariability].
  ChronotypeVariabilityProvider({String? date})
    : this._internal(
        (ref) =>
            chronotypeVariability(ref as ChronotypeVariabilityRef, date: date),
        from: chronotypeVariabilityProvider,
        name: r'chronotypeVariabilityProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$chronotypeVariabilityHash,
        dependencies: ChronotypeVariabilityFamily._dependencies,
        allTransitiveDependencies:
            ChronotypeVariabilityFamily._allTransitiveDependencies,
        date: date,
      );

  ChronotypeVariabilityProvider._internal(
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
    FutureOr<double?> Function(ChronotypeVariabilityRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChronotypeVariabilityProvider._internal(
        (ref) => create(ref as ChronotypeVariabilityRef),
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
    return _ChronotypeVariabilityProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChronotypeVariabilityProvider && other.date == date;
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
mixin ChronotypeVariabilityRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _ChronotypeVariabilityProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with ChronotypeVariabilityRef {
  _ChronotypeVariabilityProviderElement(super.provider);

  @override
  String? get date => (origin as ChronotypeVariabilityProvider).date;
}

String _$chronotypeAvgDurationHash() =>
    r'277123e2301390b26b75ce16920a1594f5a79a74';

/// See also [chronotypeAvgDuration].
@ProviderFor(chronotypeAvgDuration)
const chronotypeAvgDurationProvider = ChronotypeAvgDurationFamily();

/// See also [chronotypeAvgDuration].
class ChronotypeAvgDurationFamily extends Family<AsyncValue<double?>> {
  /// See also [chronotypeAvgDuration].
  const ChronotypeAvgDurationFamily();

  /// See also [chronotypeAvgDuration].
  ChronotypeAvgDurationProvider call({String? date}) {
    return ChronotypeAvgDurationProvider(date: date);
  }

  @override
  ChronotypeAvgDurationProvider getProviderOverride(
    covariant ChronotypeAvgDurationProvider provider,
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
  String? get name => r'chronotypeAvgDurationProvider';
}

/// See also [chronotypeAvgDuration].
class ChronotypeAvgDurationProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [chronotypeAvgDuration].
  ChronotypeAvgDurationProvider({String? date})
    : this._internal(
        (ref) =>
            chronotypeAvgDuration(ref as ChronotypeAvgDurationRef, date: date),
        from: chronotypeAvgDurationProvider,
        name: r'chronotypeAvgDurationProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$chronotypeAvgDurationHash,
        dependencies: ChronotypeAvgDurationFamily._dependencies,
        allTransitiveDependencies:
            ChronotypeAvgDurationFamily._allTransitiveDependencies,
        date: date,
      );

  ChronotypeAvgDurationProvider._internal(
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
    FutureOr<double?> Function(ChronotypeAvgDurationRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ChronotypeAvgDurationProvider._internal(
        (ref) => create(ref as ChronotypeAvgDurationRef),
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
    return _ChronotypeAvgDurationProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ChronotypeAvgDurationProvider && other.date == date;
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
mixin ChronotypeAvgDurationRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _ChronotypeAvgDurationProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with ChronotypeAvgDurationRef {
  _ChronotypeAvgDurationProviderElement(super.provider);

  @override
  String? get date => (origin as ChronotypeAvgDurationProvider).date;
}

String _$stressLoadScoreHash() => r'81a098d89857b561720c212ea5aca7c121a20dad';

/// See also [stressLoadScore].
@ProviderFor(stressLoadScore)
const stressLoadScoreProvider = StressLoadScoreFamily();

/// See also [stressLoadScore].
class StressLoadScoreFamily extends Family<AsyncValue<double?>> {
  /// See also [stressLoadScore].
  const StressLoadScoreFamily();

  /// See also [stressLoadScore].
  StressLoadScoreProvider call({String? date}) {
    return StressLoadScoreProvider(date: date);
  }

  @override
  StressLoadScoreProvider getProviderOverride(
    covariant StressLoadScoreProvider provider,
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
  String? get name => r'stressLoadScoreProvider';
}

/// See also [stressLoadScore].
class StressLoadScoreProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [stressLoadScore].
  StressLoadScoreProvider({String? date})
    : this._internal(
        (ref) => stressLoadScore(ref as StressLoadScoreRef, date: date),
        from: stressLoadScoreProvider,
        name: r'stressLoadScoreProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$stressLoadScoreHash,
        dependencies: StressLoadScoreFamily._dependencies,
        allTransitiveDependencies:
            StressLoadScoreFamily._allTransitiveDependencies,
        date: date,
      );

  StressLoadScoreProvider._internal(
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
    FutureOr<double?> Function(StressLoadScoreRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StressLoadScoreProvider._internal(
        (ref) => create(ref as StressLoadScoreRef),
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
    return _StressLoadScoreProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StressLoadScoreProvider && other.date == date;
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
mixin StressLoadScoreRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _StressLoadScoreProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with StressLoadScoreRef {
  _StressLoadScoreProviderElement(super.provider);

  @override
  String? get date => (origin as StressLoadScoreProvider).date;
}

String _$stressLoadRatioHash() => r'fbf08b98d096804ea307fbcee1c1111b90676087';

/// See also [stressLoadRatio].
@ProviderFor(stressLoadRatio)
const stressLoadRatioProvider = StressLoadRatioFamily();

/// See also [stressLoadRatio].
class StressLoadRatioFamily extends Family<AsyncValue<double?>> {
  /// See also [stressLoadRatio].
  const StressLoadRatioFamily();

  /// See also [stressLoadRatio].
  StressLoadRatioProvider call({String? date}) {
    return StressLoadRatioProvider(date: date);
  }

  @override
  StressLoadRatioProvider getProviderOverride(
    covariant StressLoadRatioProvider provider,
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
  String? get name => r'stressLoadRatioProvider';
}

/// See also [stressLoadRatio].
class StressLoadRatioProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [stressLoadRatio].
  StressLoadRatioProvider({String? date})
    : this._internal(
        (ref) => stressLoadRatio(ref as StressLoadRatioRef, date: date),
        from: stressLoadRatioProvider,
        name: r'stressLoadRatioProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$stressLoadRatioHash,
        dependencies: StressLoadRatioFamily._dependencies,
        allTransitiveDependencies:
            StressLoadRatioFamily._allTransitiveDependencies,
        date: date,
      );

  StressLoadRatioProvider._internal(
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
    FutureOr<double?> Function(StressLoadRatioRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StressLoadRatioProvider._internal(
        (ref) => create(ref as StressLoadRatioRef),
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
    return _StressLoadRatioProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StressLoadRatioProvider && other.date == date;
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
mixin StressLoadRatioRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _StressLoadRatioProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with StressLoadRatioRef {
  _StressLoadRatioProviderElement(super.provider);

  @override
  String? get date => (origin as StressLoadRatioProvider).date;
}

String _$stressLoadNighttimeBaselineHash() =>
    r'37cac166b5fa99c521c4a80fc8fd6f5836db6927';

/// See also [stressLoadNighttimeBaseline].
@ProviderFor(stressLoadNighttimeBaseline)
const stressLoadNighttimeBaselineProvider = StressLoadNighttimeBaselineFamily();

/// See also [stressLoadNighttimeBaseline].
class StressLoadNighttimeBaselineFamily extends Family<AsyncValue<double?>> {
  /// See also [stressLoadNighttimeBaseline].
  const StressLoadNighttimeBaselineFamily();

  /// See also [stressLoadNighttimeBaseline].
  StressLoadNighttimeBaselineProvider call({String? date}) {
    return StressLoadNighttimeBaselineProvider(date: date);
  }

  @override
  StressLoadNighttimeBaselineProvider getProviderOverride(
    covariant StressLoadNighttimeBaselineProvider provider,
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
  String? get name => r'stressLoadNighttimeBaselineProvider';
}

/// See also [stressLoadNighttimeBaseline].
class StressLoadNighttimeBaselineProvider
    extends AutoDisposeFutureProvider<double?> {
  /// See also [stressLoadNighttimeBaseline].
  StressLoadNighttimeBaselineProvider({String? date})
    : this._internal(
        (ref) => stressLoadNighttimeBaseline(
          ref as StressLoadNighttimeBaselineRef,
          date: date,
        ),
        from: stressLoadNighttimeBaselineProvider,
        name: r'stressLoadNighttimeBaselineProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$stressLoadNighttimeBaselineHash,
        dependencies: StressLoadNighttimeBaselineFamily._dependencies,
        allTransitiveDependencies:
            StressLoadNighttimeBaselineFamily._allTransitiveDependencies,
        date: date,
      );

  StressLoadNighttimeBaselineProvider._internal(
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
    FutureOr<double?> Function(StressLoadNighttimeBaselineRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StressLoadNighttimeBaselineProvider._internal(
        (ref) => create(ref as StressLoadNighttimeBaselineRef),
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
    return _StressLoadNighttimeBaselineProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StressLoadNighttimeBaselineProvider && other.date == date;
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
mixin StressLoadNighttimeBaselineRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _StressLoadNighttimeBaselineProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with StressLoadNighttimeBaselineRef {
  _StressLoadNighttimeBaselineProviderElement(super.provider);

  @override
  String? get date => (origin as StressLoadNighttimeBaselineProvider).date;
}

String _$stressLoadDaytimeHrvHash() =>
    r'279c411a4f97fff930090f24bcb23ccc4584fde5';

/// See also [stressLoadDaytimeHrv].
@ProviderFor(stressLoadDaytimeHrv)
const stressLoadDaytimeHrvProvider = StressLoadDaytimeHrvFamily();

/// See also [stressLoadDaytimeHrv].
class StressLoadDaytimeHrvFamily extends Family<AsyncValue<double?>> {
  /// See also [stressLoadDaytimeHrv].
  const StressLoadDaytimeHrvFamily();

  /// See also [stressLoadDaytimeHrv].
  StressLoadDaytimeHrvProvider call({String? date}) {
    return StressLoadDaytimeHrvProvider(date: date);
  }

  @override
  StressLoadDaytimeHrvProvider getProviderOverride(
    covariant StressLoadDaytimeHrvProvider provider,
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
  String? get name => r'stressLoadDaytimeHrvProvider';
}

/// See also [stressLoadDaytimeHrv].
class StressLoadDaytimeHrvProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [stressLoadDaytimeHrv].
  StressLoadDaytimeHrvProvider({String? date})
    : this._internal(
        (ref) =>
            stressLoadDaytimeHrv(ref as StressLoadDaytimeHrvRef, date: date),
        from: stressLoadDaytimeHrvProvider,
        name: r'stressLoadDaytimeHrvProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$stressLoadDaytimeHrvHash,
        dependencies: StressLoadDaytimeHrvFamily._dependencies,
        allTransitiveDependencies:
            StressLoadDaytimeHrvFamily._allTransitiveDependencies,
        date: date,
      );

  StressLoadDaytimeHrvProvider._internal(
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
    FutureOr<double?> Function(StressLoadDaytimeHrvRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StressLoadDaytimeHrvProvider._internal(
        (ref) => create(ref as StressLoadDaytimeHrvRef),
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
    return _StressLoadDaytimeHrvProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StressLoadDaytimeHrvProvider && other.date == date;
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
mixin StressLoadDaytimeHrvRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _StressLoadDaytimeHrvProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with StressLoadDaytimeHrvRef {
  _StressLoadDaytimeHrvProviderElement(super.provider);

  @override
  String? get date => (origin as StressLoadDaytimeHrvProvider).date;
}

String _$stressLoadCategoryHash() =>
    r'd8bca2e0a0c5a3b1f042edbf7d5f10df0835e6ca';

/// See also [stressLoadCategory].
@ProviderFor(stressLoadCategory)
const stressLoadCategoryProvider = StressLoadCategoryFamily();

/// See also [stressLoadCategory].
class StressLoadCategoryFamily extends Family<AsyncValue<int?>> {
  /// See also [stressLoadCategory].
  const StressLoadCategoryFamily();

  /// See also [stressLoadCategory].
  StressLoadCategoryProvider call({String? date}) {
    return StressLoadCategoryProvider(date: date);
  }

  @override
  StressLoadCategoryProvider getProviderOverride(
    covariant StressLoadCategoryProvider provider,
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
  String? get name => r'stressLoadCategoryProvider';
}

/// See also [stressLoadCategory].
class StressLoadCategoryProvider extends AutoDisposeFutureProvider<int?> {
  /// See also [stressLoadCategory].
  StressLoadCategoryProvider({String? date})
    : this._internal(
        (ref) => stressLoadCategory(ref as StressLoadCategoryRef, date: date),
        from: stressLoadCategoryProvider,
        name: r'stressLoadCategoryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$stressLoadCategoryHash,
        dependencies: StressLoadCategoryFamily._dependencies,
        allTransitiveDependencies:
            StressLoadCategoryFamily._allTransitiveDependencies,
        date: date,
      );

  StressLoadCategoryProvider._internal(
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
    FutureOr<int?> Function(StressLoadCategoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StressLoadCategoryProvider._internal(
        (ref) => create(ref as StressLoadCategoryRef),
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
  AutoDisposeFutureProviderElement<int?> createElement() {
    return _StressLoadCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StressLoadCategoryProvider && other.date == date;
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
mixin StressLoadCategoryRef on AutoDisposeFutureProviderRef<int?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _StressLoadCategoryProviderElement
    extends AutoDisposeFutureProviderElement<int?>
    with StressLoadCategoryRef {
  _StressLoadCategoryProviderElement(super.provider);

  @override
  String? get date => (origin as StressLoadCategoryProvider).date;
}

String _$stressLoadBaselineTrendHash() =>
    r'b1e2a861cc21d8eb76e3b909cb33eeff950941b5';

/// See also [stressLoadBaselineTrend].
@ProviderFor(stressLoadBaselineTrend)
const stressLoadBaselineTrendProvider = StressLoadBaselineTrendFamily();

/// See also [stressLoadBaselineTrend].
class StressLoadBaselineTrendFamily extends Family<AsyncValue<int?>> {
  /// See also [stressLoadBaselineTrend].
  const StressLoadBaselineTrendFamily();

  /// See also [stressLoadBaselineTrend].
  StressLoadBaselineTrendProvider call({String? date}) {
    return StressLoadBaselineTrendProvider(date: date);
  }

  @override
  StressLoadBaselineTrendProvider getProviderOverride(
    covariant StressLoadBaselineTrendProvider provider,
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
  String? get name => r'stressLoadBaselineTrendProvider';
}

/// See also [stressLoadBaselineTrend].
class StressLoadBaselineTrendProvider extends AutoDisposeFutureProvider<int?> {
  /// See also [stressLoadBaselineTrend].
  StressLoadBaselineTrendProvider({String? date})
    : this._internal(
        (ref) => stressLoadBaselineTrend(
          ref as StressLoadBaselineTrendRef,
          date: date,
        ),
        from: stressLoadBaselineTrendProvider,
        name: r'stressLoadBaselineTrendProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$stressLoadBaselineTrendHash,
        dependencies: StressLoadBaselineTrendFamily._dependencies,
        allTransitiveDependencies:
            StressLoadBaselineTrendFamily._allTransitiveDependencies,
        date: date,
      );

  StressLoadBaselineTrendProvider._internal(
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
    FutureOr<int?> Function(StressLoadBaselineTrendRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StressLoadBaselineTrendProvider._internal(
        (ref) => create(ref as StressLoadBaselineTrendRef),
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
  AutoDisposeFutureProviderElement<int?> createElement() {
    return _StressLoadBaselineTrendProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StressLoadBaselineTrendProvider && other.date == date;
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
mixin StressLoadBaselineTrendRef on AutoDisposeFutureProviderRef<int?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _StressLoadBaselineTrendProviderElement
    extends AutoDisposeFutureProviderElement<int?>
    with StressLoadBaselineTrendRef {
  _StressLoadBaselineTrendProviderElement(super.provider);

  @override
  String? get date => (origin as StressLoadBaselineTrendProvider).date;
}

String _$stressLoadRecommendationHash() =>
    r'5cc18fc7bbb75eac190dd28a1dceeec900290f16';

/// See also [stressLoadRecommendation].
@ProviderFor(stressLoadRecommendation)
const stressLoadRecommendationProvider = StressLoadRecommendationFamily();

/// See also [stressLoadRecommendation].
class StressLoadRecommendationFamily extends Family<AsyncValue<String?>> {
  /// See also [stressLoadRecommendation].
  const StressLoadRecommendationFamily();

  /// See also [stressLoadRecommendation].
  StressLoadRecommendationProvider call({String? date}) {
    return StressLoadRecommendationProvider(date: date);
  }

  @override
  StressLoadRecommendationProvider getProviderOverride(
    covariant StressLoadRecommendationProvider provider,
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
  String? get name => r'stressLoadRecommendationProvider';
}

/// See also [stressLoadRecommendation].
class StressLoadRecommendationProvider
    extends AutoDisposeFutureProvider<String?> {
  /// See also [stressLoadRecommendation].
  StressLoadRecommendationProvider({String? date})
    : this._internal(
        (ref) => stressLoadRecommendation(
          ref as StressLoadRecommendationRef,
          date: date,
        ),
        from: stressLoadRecommendationProvider,
        name: r'stressLoadRecommendationProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$stressLoadRecommendationHash,
        dependencies: StressLoadRecommendationFamily._dependencies,
        allTransitiveDependencies:
            StressLoadRecommendationFamily._allTransitiveDependencies,
        date: date,
      );

  StressLoadRecommendationProvider._internal(
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
    FutureOr<String?> Function(StressLoadRecommendationRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: StressLoadRecommendationProvider._internal(
        (ref) => create(ref as StressLoadRecommendationRef),
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
  AutoDisposeFutureProviderElement<String?> createElement() {
    return _StressLoadRecommendationProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StressLoadRecommendationProvider && other.date == date;
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
mixin StressLoadRecommendationRef on AutoDisposeFutureProviderRef<String?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _StressLoadRecommendationProviderElement
    extends AutoDisposeFutureProviderElement<String?>
    with StressLoadRecommendationRef {
  _StressLoadRecommendationProviderElement(super.provider);

  @override
  String? get date => (origin as StressLoadRecommendationProvider).date;
}

String _$forecastPredictedReadinessHash() =>
    r'b963a89d27dc60eb29bb4575fbf177c47ef05b51';

/// See also [forecastPredictedReadiness].
@ProviderFor(forecastPredictedReadiness)
const forecastPredictedReadinessProvider = ForecastPredictedReadinessFamily();

/// See also [forecastPredictedReadiness].
class ForecastPredictedReadinessFamily extends Family<AsyncValue<double?>> {
  /// See also [forecastPredictedReadiness].
  const ForecastPredictedReadinessFamily();

  /// See also [forecastPredictedReadiness].
  ForecastPredictedReadinessProvider call({String? date}) {
    return ForecastPredictedReadinessProvider(date: date);
  }

  @override
  ForecastPredictedReadinessProvider getProviderOverride(
    covariant ForecastPredictedReadinessProvider provider,
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
  String? get name => r'forecastPredictedReadinessProvider';
}

/// See also [forecastPredictedReadiness].
class ForecastPredictedReadinessProvider
    extends AutoDisposeFutureProvider<double?> {
  /// See also [forecastPredictedReadiness].
  ForecastPredictedReadinessProvider({String? date})
    : this._internal(
        (ref) => forecastPredictedReadiness(
          ref as ForecastPredictedReadinessRef,
          date: date,
        ),
        from: forecastPredictedReadinessProvider,
        name: r'forecastPredictedReadinessProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$forecastPredictedReadinessHash,
        dependencies: ForecastPredictedReadinessFamily._dependencies,
        allTransitiveDependencies:
            ForecastPredictedReadinessFamily._allTransitiveDependencies,
        date: date,
      );

  ForecastPredictedReadinessProvider._internal(
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
    FutureOr<double?> Function(ForecastPredictedReadinessRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ForecastPredictedReadinessProvider._internal(
        (ref) => create(ref as ForecastPredictedReadinessRef),
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
    return _ForecastPredictedReadinessProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ForecastPredictedReadinessProvider && other.date == date;
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
mixin ForecastPredictedReadinessRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _ForecastPredictedReadinessProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with ForecastPredictedReadinessRef {
  _ForecastPredictedReadinessProviderElement(super.provider);

  @override
  String? get date => (origin as ForecastPredictedReadinessProvider).date;
}

String _$forecastPredictedMentalHash() =>
    r'f1d0ba03a4501885bcd7cbfd0f81fa0f2abec40d';

/// See also [forecastPredictedMental].
@ProviderFor(forecastPredictedMental)
const forecastPredictedMentalProvider = ForecastPredictedMentalFamily();

/// See also [forecastPredictedMental].
class ForecastPredictedMentalFamily extends Family<AsyncValue<double?>> {
  /// See also [forecastPredictedMental].
  const ForecastPredictedMentalFamily();

  /// See also [forecastPredictedMental].
  ForecastPredictedMentalProvider call({String? date}) {
    return ForecastPredictedMentalProvider(date: date);
  }

  @override
  ForecastPredictedMentalProvider getProviderOverride(
    covariant ForecastPredictedMentalProvider provider,
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
  String? get name => r'forecastPredictedMentalProvider';
}

/// See also [forecastPredictedMental].
class ForecastPredictedMentalProvider
    extends AutoDisposeFutureProvider<double?> {
  /// See also [forecastPredictedMental].
  ForecastPredictedMentalProvider({String? date})
    : this._internal(
        (ref) => forecastPredictedMental(
          ref as ForecastPredictedMentalRef,
          date: date,
        ),
        from: forecastPredictedMentalProvider,
        name: r'forecastPredictedMentalProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$forecastPredictedMentalHash,
        dependencies: ForecastPredictedMentalFamily._dependencies,
        allTransitiveDependencies:
            ForecastPredictedMentalFamily._allTransitiveDependencies,
        date: date,
      );

  ForecastPredictedMentalProvider._internal(
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
    FutureOr<double?> Function(ForecastPredictedMentalRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ForecastPredictedMentalProvider._internal(
        (ref) => create(ref as ForecastPredictedMentalRef),
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
    return _ForecastPredictedMentalProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ForecastPredictedMentalProvider && other.date == date;
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
mixin ForecastPredictedMentalRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _ForecastPredictedMentalProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with ForecastPredictedMentalRef {
  _ForecastPredictedMentalProviderElement(super.provider);

  @override
  String? get date => (origin as ForecastPredictedMentalProvider).date;
}

String _$forecastTrendSlopeHash() =>
    r'f4a3aa368e222553e726d1a5a74bef7cf87e1e89';

/// See also [forecastTrendSlope].
@ProviderFor(forecastTrendSlope)
const forecastTrendSlopeProvider = ForecastTrendSlopeFamily();

/// See also [forecastTrendSlope].
class ForecastTrendSlopeFamily extends Family<AsyncValue<double?>> {
  /// See also [forecastTrendSlope].
  const ForecastTrendSlopeFamily();

  /// See also [forecastTrendSlope].
  ForecastTrendSlopeProvider call({String? date}) {
    return ForecastTrendSlopeProvider(date: date);
  }

  @override
  ForecastTrendSlopeProvider getProviderOverride(
    covariant ForecastTrendSlopeProvider provider,
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
  String? get name => r'forecastTrendSlopeProvider';
}

/// See also [forecastTrendSlope].
class ForecastTrendSlopeProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [forecastTrendSlope].
  ForecastTrendSlopeProvider({String? date})
    : this._internal(
        (ref) => forecastTrendSlope(ref as ForecastTrendSlopeRef, date: date),
        from: forecastTrendSlopeProvider,
        name: r'forecastTrendSlopeProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$forecastTrendSlopeHash,
        dependencies: ForecastTrendSlopeFamily._dependencies,
        allTransitiveDependencies:
            ForecastTrendSlopeFamily._allTransitiveDependencies,
        date: date,
      );

  ForecastTrendSlopeProvider._internal(
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
    FutureOr<double?> Function(ForecastTrendSlopeRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ForecastTrendSlopeProvider._internal(
        (ref) => create(ref as ForecastTrendSlopeRef),
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
    return _ForecastTrendSlopeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ForecastTrendSlopeProvider && other.date == date;
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
mixin ForecastTrendSlopeRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _ForecastTrendSlopeProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with ForecastTrendSlopeRef {
  _ForecastTrendSlopeProviderElement(super.provider);

  @override
  String? get date => (origin as ForecastTrendSlopeProvider).date;
}

String _$forecastConfidenceHash() =>
    r'810f6077e117643ad5e6ef2081ae90e7040dc4f1';

/// See also [forecastConfidence].
@ProviderFor(forecastConfidence)
const forecastConfidenceProvider = ForecastConfidenceFamily();

/// See also [forecastConfidence].
class ForecastConfidenceFamily extends Family<AsyncValue<double?>> {
  /// See also [forecastConfidence].
  const ForecastConfidenceFamily();

  /// See also [forecastConfidence].
  ForecastConfidenceProvider call({String? date}) {
    return ForecastConfidenceProvider(date: date);
  }

  @override
  ForecastConfidenceProvider getProviderOverride(
    covariant ForecastConfidenceProvider provider,
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
  String? get name => r'forecastConfidenceProvider';
}

/// See also [forecastConfidence].
class ForecastConfidenceProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [forecastConfidence].
  ForecastConfidenceProvider({String? date})
    : this._internal(
        (ref) => forecastConfidence(ref as ForecastConfidenceRef, date: date),
        from: forecastConfidenceProvider,
        name: r'forecastConfidenceProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$forecastConfidenceHash,
        dependencies: ForecastConfidenceFamily._dependencies,
        allTransitiveDependencies:
            ForecastConfidenceFamily._allTransitiveDependencies,
        date: date,
      );

  ForecastConfidenceProvider._internal(
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
    FutureOr<double?> Function(ForecastConfidenceRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ForecastConfidenceProvider._internal(
        (ref) => create(ref as ForecastConfidenceRef),
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
    return _ForecastConfidenceProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ForecastConfidenceProvider && other.date == date;
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
mixin ForecastConfidenceRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _ForecastConfidenceProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with ForecastConfidenceRef {
  _ForecastConfidenceProviderElement(super.provider);

  @override
  String? get date => (origin as ForecastConfidenceProvider).date;
}

String _$forecastCategoryHash() => r'bc9494cf6dada6ecb78e40162facecd02a297532';

/// See also [forecastCategory].
@ProviderFor(forecastCategory)
const forecastCategoryProvider = ForecastCategoryFamily();

/// See also [forecastCategory].
class ForecastCategoryFamily extends Family<AsyncValue<int?>> {
  /// See also [forecastCategory].
  const ForecastCategoryFamily();

  /// See also [forecastCategory].
  ForecastCategoryProvider call({String? date}) {
    return ForecastCategoryProvider(date: date);
  }

  @override
  ForecastCategoryProvider getProviderOverride(
    covariant ForecastCategoryProvider provider,
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
  String? get name => r'forecastCategoryProvider';
}

/// See also [forecastCategory].
class ForecastCategoryProvider extends AutoDisposeFutureProvider<int?> {
  /// See also [forecastCategory].
  ForecastCategoryProvider({String? date})
    : this._internal(
        (ref) => forecastCategory(ref as ForecastCategoryRef, date: date),
        from: forecastCategoryProvider,
        name: r'forecastCategoryProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$forecastCategoryHash,
        dependencies: ForecastCategoryFamily._dependencies,
        allTransitiveDependencies:
            ForecastCategoryFamily._allTransitiveDependencies,
        date: date,
      );

  ForecastCategoryProvider._internal(
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
    FutureOr<int?> Function(ForecastCategoryRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ForecastCategoryProvider._internal(
        (ref) => create(ref as ForecastCategoryRef),
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
  AutoDisposeFutureProviderElement<int?> createElement() {
    return _ForecastCategoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ForecastCategoryProvider && other.date == date;
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
mixin ForecastCategoryRef on AutoDisposeFutureProviderRef<int?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _ForecastCategoryProviderElement
    extends AutoDisposeFutureProviderElement<int?>
    with ForecastCategoryRef {
  _ForecastCategoryProviderElement(super.provider);

  @override
  String? get date => (origin as ForecastCategoryProvider).date;
}

String _$forecastRecoveryDebtHash() =>
    r'013d5afc8f463c57ab9b80f10e44a8f8b6cbcf0b';

/// See also [forecastRecoveryDebt].
@ProviderFor(forecastRecoveryDebt)
const forecastRecoveryDebtProvider = ForecastRecoveryDebtFamily();

/// See also [forecastRecoveryDebt].
class ForecastRecoveryDebtFamily extends Family<AsyncValue<double?>> {
  /// See also [forecastRecoveryDebt].
  const ForecastRecoveryDebtFamily();

  /// See also [forecastRecoveryDebt].
  ForecastRecoveryDebtProvider call({String? date}) {
    return ForecastRecoveryDebtProvider(date: date);
  }

  @override
  ForecastRecoveryDebtProvider getProviderOverride(
    covariant ForecastRecoveryDebtProvider provider,
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
  String? get name => r'forecastRecoveryDebtProvider';
}

/// See also [forecastRecoveryDebt].
class ForecastRecoveryDebtProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [forecastRecoveryDebt].
  ForecastRecoveryDebtProvider({String? date})
    : this._internal(
        (ref) =>
            forecastRecoveryDebt(ref as ForecastRecoveryDebtRef, date: date),
        from: forecastRecoveryDebtProvider,
        name: r'forecastRecoveryDebtProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$forecastRecoveryDebtHash,
        dependencies: ForecastRecoveryDebtFamily._dependencies,
        allTransitiveDependencies:
            ForecastRecoveryDebtFamily._allTransitiveDependencies,
        date: date,
      );

  ForecastRecoveryDebtProvider._internal(
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
    FutureOr<double?> Function(ForecastRecoveryDebtRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ForecastRecoveryDebtProvider._internal(
        (ref) => create(ref as ForecastRecoveryDebtRef),
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
    return _ForecastRecoveryDebtProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ForecastRecoveryDebtProvider && other.date == date;
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
mixin ForecastRecoveryDebtRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _ForecastRecoveryDebtProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with ForecastRecoveryDebtRef {
  _ForecastRecoveryDebtProviderElement(super.provider);

  @override
  String? get date => (origin as ForecastRecoveryDebtProvider).date;
}

String _$forecastRecommendationHash() =>
    r'f9e3e0d020321946d0ad10c9e31d7661262cc7fd';

/// See also [forecastRecommendation].
@ProviderFor(forecastRecommendation)
const forecastRecommendationProvider = ForecastRecommendationFamily();

/// See also [forecastRecommendation].
class ForecastRecommendationFamily extends Family<AsyncValue<String?>> {
  /// See also [forecastRecommendation].
  const ForecastRecommendationFamily();

  /// See also [forecastRecommendation].
  ForecastRecommendationProvider call({String? date}) {
    return ForecastRecommendationProvider(date: date);
  }

  @override
  ForecastRecommendationProvider getProviderOverride(
    covariant ForecastRecommendationProvider provider,
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
  String? get name => r'forecastRecommendationProvider';
}

/// See also [forecastRecommendation].
class ForecastRecommendationProvider
    extends AutoDisposeFutureProvider<String?> {
  /// See also [forecastRecommendation].
  ForecastRecommendationProvider({String? date})
    : this._internal(
        (ref) => forecastRecommendation(
          ref as ForecastRecommendationRef,
          date: date,
        ),
        from: forecastRecommendationProvider,
        name: r'forecastRecommendationProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$forecastRecommendationHash,
        dependencies: ForecastRecommendationFamily._dependencies,
        allTransitiveDependencies:
            ForecastRecommendationFamily._allTransitiveDependencies,
        date: date,
      );

  ForecastRecommendationProvider._internal(
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
    FutureOr<String?> Function(ForecastRecommendationRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ForecastRecommendationProvider._internal(
        (ref) => create(ref as ForecastRecommendationRef),
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
  AutoDisposeFutureProviderElement<String?> createElement() {
    return _ForecastRecommendationProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ForecastRecommendationProvider && other.date == date;
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
mixin ForecastRecommendationRef on AutoDisposeFutureProviderRef<String?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _ForecastRecommendationProviderElement
    extends AutoDisposeFutureProviderElement<String?>
    with ForecastRecommendationRef {
  _ForecastRecommendationProviderElement(super.provider);

  @override
  String? get date => (origin as ForecastRecommendationProvider).date;
}

String _$forecastMentalTrendHash() =>
    r'c2044f0482e90c1c7860feacf43bb3cd5d964bca';

/// See also [forecastMentalTrend].
@ProviderFor(forecastMentalTrend)
const forecastMentalTrendProvider = ForecastMentalTrendFamily();

/// See also [forecastMentalTrend].
class ForecastMentalTrendFamily extends Family<AsyncValue<double?>> {
  /// See also [forecastMentalTrend].
  const ForecastMentalTrendFamily();

  /// See also [forecastMentalTrend].
  ForecastMentalTrendProvider call({String? date}) {
    return ForecastMentalTrendProvider(date: date);
  }

  @override
  ForecastMentalTrendProvider getProviderOverride(
    covariant ForecastMentalTrendProvider provider,
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
  String? get name => r'forecastMentalTrendProvider';
}

/// See also [forecastMentalTrend].
class ForecastMentalTrendProvider extends AutoDisposeFutureProvider<double?> {
  /// See also [forecastMentalTrend].
  ForecastMentalTrendProvider({String? date})
    : this._internal(
        (ref) => forecastMentalTrend(ref as ForecastMentalTrendRef, date: date),
        from: forecastMentalTrendProvider,
        name: r'forecastMentalTrendProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$forecastMentalTrendHash,
        dependencies: ForecastMentalTrendFamily._dependencies,
        allTransitiveDependencies:
            ForecastMentalTrendFamily._allTransitiveDependencies,
        date: date,
      );

  ForecastMentalTrendProvider._internal(
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
    FutureOr<double?> Function(ForecastMentalTrendRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ForecastMentalTrendProvider._internal(
        (ref) => create(ref as ForecastMentalTrendRef),
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
    return _ForecastMentalTrendProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ForecastMentalTrendProvider && other.date == date;
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
mixin ForecastMentalTrendRef on AutoDisposeFutureProviderRef<double?> {
  /// The parameter `date` of this provider.
  String? get date;
}

class _ForecastMentalTrendProviderElement
    extends AutoDisposeFutureProviderElement<double?>
    with ForecastMentalTrendRef {
  _ForecastMentalTrendProviderElement(super.provider);

  @override
  String? get date => (origin as ForecastMentalTrendProvider).date;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
