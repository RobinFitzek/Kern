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

String _$dailyInsightsHash() => r'808ce84e97ac21d8a497b0b73c7a0657091dc169';

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

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
