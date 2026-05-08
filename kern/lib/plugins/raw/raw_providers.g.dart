// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'raw_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$rawHrvHash() => r'9949fb3a2d8ce14ff5df676c991dff281279e768';

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

/// Returns HRV (RMSSD) entries from the Raw Store for the given [window].
/// Pass [sourceName] to restrict to a specific device/app.
///
/// Copied from [rawHrv].
@ProviderFor(rawHrv)
const rawHrvProvider = RawHrvFamily();

/// Returns HRV (RMSSD) entries from the Raw Store for the given [window].
/// Pass [sourceName] to restrict to a specific device/app.
///
/// Copied from [rawHrv].
class RawHrvFamily extends Family<AsyncValue<List<RawEntry>>> {
  /// Returns HRV (RMSSD) entries from the Raw Store for the given [window].
  /// Pass [sourceName] to restrict to a specific device/app.
  ///
  /// Copied from [rawHrv].
  const RawHrvFamily();

  /// Returns HRV (RMSSD) entries from the Raw Store for the given [window].
  /// Pass [sourceName] to restrict to a specific device/app.
  ///
  /// Copied from [rawHrv].
  RawHrvProvider call({
    Duration window = const Duration(days: 30),
    String? sourceName,
  }) {
    return RawHrvProvider(window: window, sourceName: sourceName);
  }

  @override
  RawHrvProvider getProviderOverride(covariant RawHrvProvider provider) {
    return call(window: provider.window, sourceName: provider.sourceName);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'rawHrvProvider';
}

/// Returns HRV (RMSSD) entries from the Raw Store for the given [window].
/// Pass [sourceName] to restrict to a specific device/app.
///
/// Copied from [rawHrv].
class RawHrvProvider extends AutoDisposeFutureProvider<List<RawEntry>> {
  /// Returns HRV (RMSSD) entries from the Raw Store for the given [window].
  /// Pass [sourceName] to restrict to a specific device/app.
  ///
  /// Copied from [rawHrv].
  RawHrvProvider({
    Duration window = const Duration(days: 30),
    String? sourceName,
  }) : this._internal(
         (ref) =>
             rawHrv(ref as RawHrvRef, window: window, sourceName: sourceName),
         from: rawHrvProvider,
         name: r'rawHrvProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$rawHrvHash,
         dependencies: RawHrvFamily._dependencies,
         allTransitiveDependencies: RawHrvFamily._allTransitiveDependencies,
         window: window,
         sourceName: sourceName,
       );

  RawHrvProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.window,
    required this.sourceName,
  }) : super.internal();

  final Duration window;
  final String? sourceName;

  @override
  Override overrideWith(
    FutureOr<List<RawEntry>> Function(RawHrvRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RawHrvProvider._internal(
        (ref) => create(ref as RawHrvRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        window: window,
        sourceName: sourceName,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<RawEntry>> createElement() {
    return _RawHrvProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RawHrvProvider &&
        other.window == window &&
        other.sourceName == sourceName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, window.hashCode);
    hash = _SystemHash.combine(hash, sourceName.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RawHrvRef on AutoDisposeFutureProviderRef<List<RawEntry>> {
  /// The parameter `window` of this provider.
  Duration get window;

  /// The parameter `sourceName` of this provider.
  String? get sourceName;
}

class _RawHrvProviderElement
    extends AutoDisposeFutureProviderElement<List<RawEntry>>
    with RawHrvRef {
  _RawHrvProviderElement(super.provider);

  @override
  Duration get window => (origin as RawHrvProvider).window;
  @override
  String? get sourceName => (origin as RawHrvProvider).sourceName;
}

String _$rawRestingHrHash() => r'9f8c9e81afcac3e8409269da787c7a4f61fa137e';

/// Returns resting HR entries from the Raw Store for the given [window].
///
/// Copied from [rawRestingHr].
@ProviderFor(rawRestingHr)
const rawRestingHrProvider = RawRestingHrFamily();

/// Returns resting HR entries from the Raw Store for the given [window].
///
/// Copied from [rawRestingHr].
class RawRestingHrFamily extends Family<AsyncValue<List<RawEntry>>> {
  /// Returns resting HR entries from the Raw Store for the given [window].
  ///
  /// Copied from [rawRestingHr].
  const RawRestingHrFamily();

  /// Returns resting HR entries from the Raw Store for the given [window].
  ///
  /// Copied from [rawRestingHr].
  RawRestingHrProvider call({
    Duration window = const Duration(days: 30),
    String? sourceName,
  }) {
    return RawRestingHrProvider(window: window, sourceName: sourceName);
  }

  @override
  RawRestingHrProvider getProviderOverride(
    covariant RawRestingHrProvider provider,
  ) {
    return call(window: provider.window, sourceName: provider.sourceName);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'rawRestingHrProvider';
}

/// Returns resting HR entries from the Raw Store for the given [window].
///
/// Copied from [rawRestingHr].
class RawRestingHrProvider extends AutoDisposeFutureProvider<List<RawEntry>> {
  /// Returns resting HR entries from the Raw Store for the given [window].
  ///
  /// Copied from [rawRestingHr].
  RawRestingHrProvider({
    Duration window = const Duration(days: 30),
    String? sourceName,
  }) : this._internal(
         (ref) => rawRestingHr(
           ref as RawRestingHrRef,
           window: window,
           sourceName: sourceName,
         ),
         from: rawRestingHrProvider,
         name: r'rawRestingHrProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$rawRestingHrHash,
         dependencies: RawRestingHrFamily._dependencies,
         allTransitiveDependencies:
             RawRestingHrFamily._allTransitiveDependencies,
         window: window,
         sourceName: sourceName,
       );

  RawRestingHrProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.window,
    required this.sourceName,
  }) : super.internal();

  final Duration window;
  final String? sourceName;

  @override
  Override overrideWith(
    FutureOr<List<RawEntry>> Function(RawRestingHrRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RawRestingHrProvider._internal(
        (ref) => create(ref as RawRestingHrRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        window: window,
        sourceName: sourceName,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<RawEntry>> createElement() {
    return _RawRestingHrProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RawRestingHrProvider &&
        other.window == window &&
        other.sourceName == sourceName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, window.hashCode);
    hash = _SystemHash.combine(hash, sourceName.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RawRestingHrRef on AutoDisposeFutureProviderRef<List<RawEntry>> {
  /// The parameter `window` of this provider.
  Duration get window;

  /// The parameter `sourceName` of this provider.
  String? get sourceName;
}

class _RawRestingHrProviderElement
    extends AutoDisposeFutureProviderElement<List<RawEntry>>
    with RawRestingHrRef {
  _RawRestingHrProviderElement(super.provider);

  @override
  Duration get window => (origin as RawRestingHrProvider).window;
  @override
  String? get sourceName => (origin as RawRestingHrProvider).sourceName;
}

String _$rawSleepDeepHash() => r'd7d5a9970664c6c14abd323a7d0a0234627ccba1';

/// Returns deep sleep entries from the Raw Store for the given [window].
///
/// Copied from [rawSleepDeep].
@ProviderFor(rawSleepDeep)
const rawSleepDeepProvider = RawSleepDeepFamily();

/// Returns deep sleep entries from the Raw Store for the given [window].
///
/// Copied from [rawSleepDeep].
class RawSleepDeepFamily extends Family<AsyncValue<List<RawEntry>>> {
  /// Returns deep sleep entries from the Raw Store for the given [window].
  ///
  /// Copied from [rawSleepDeep].
  const RawSleepDeepFamily();

  /// Returns deep sleep entries from the Raw Store for the given [window].
  ///
  /// Copied from [rawSleepDeep].
  RawSleepDeepProvider call({
    Duration window = const Duration(days: 30),
    String? sourceName,
  }) {
    return RawSleepDeepProvider(window: window, sourceName: sourceName);
  }

  @override
  RawSleepDeepProvider getProviderOverride(
    covariant RawSleepDeepProvider provider,
  ) {
    return call(window: provider.window, sourceName: provider.sourceName);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'rawSleepDeepProvider';
}

/// Returns deep sleep entries from the Raw Store for the given [window].
///
/// Copied from [rawSleepDeep].
class RawSleepDeepProvider extends AutoDisposeFutureProvider<List<RawEntry>> {
  /// Returns deep sleep entries from the Raw Store for the given [window].
  ///
  /// Copied from [rawSleepDeep].
  RawSleepDeepProvider({
    Duration window = const Duration(days: 30),
    String? sourceName,
  }) : this._internal(
         (ref) => rawSleepDeep(
           ref as RawSleepDeepRef,
           window: window,
           sourceName: sourceName,
         ),
         from: rawSleepDeepProvider,
         name: r'rawSleepDeepProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$rawSleepDeepHash,
         dependencies: RawSleepDeepFamily._dependencies,
         allTransitiveDependencies:
             RawSleepDeepFamily._allTransitiveDependencies,
         window: window,
         sourceName: sourceName,
       );

  RawSleepDeepProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.window,
    required this.sourceName,
  }) : super.internal();

  final Duration window;
  final String? sourceName;

  @override
  Override overrideWith(
    FutureOr<List<RawEntry>> Function(RawSleepDeepRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RawSleepDeepProvider._internal(
        (ref) => create(ref as RawSleepDeepRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        window: window,
        sourceName: sourceName,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<RawEntry>> createElement() {
    return _RawSleepDeepProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RawSleepDeepProvider &&
        other.window == window &&
        other.sourceName == sourceName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, window.hashCode);
    hash = _SystemHash.combine(hash, sourceName.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RawSleepDeepRef on AutoDisposeFutureProviderRef<List<RawEntry>> {
  /// The parameter `window` of this provider.
  Duration get window;

  /// The parameter `sourceName` of this provider.
  String? get sourceName;
}

class _RawSleepDeepProviderElement
    extends AutoDisposeFutureProviderElement<List<RawEntry>>
    with RawSleepDeepRef {
  _RawSleepDeepProviderElement(super.provider);

  @override
  Duration get window => (origin as RawSleepDeepProvider).window;
  @override
  String? get sourceName => (origin as RawSleepDeepProvider).sourceName;
}

String _$rawSleepRemHash() => r'732b77bd0684bda8c0f1edbe6e43e705d38002e3';

/// Returns REM sleep entries from the Raw Store for the given [window].
///
/// Copied from [rawSleepRem].
@ProviderFor(rawSleepRem)
const rawSleepRemProvider = RawSleepRemFamily();

/// Returns REM sleep entries from the Raw Store for the given [window].
///
/// Copied from [rawSleepRem].
class RawSleepRemFamily extends Family<AsyncValue<List<RawEntry>>> {
  /// Returns REM sleep entries from the Raw Store for the given [window].
  ///
  /// Copied from [rawSleepRem].
  const RawSleepRemFamily();

  /// Returns REM sleep entries from the Raw Store for the given [window].
  ///
  /// Copied from [rawSleepRem].
  RawSleepRemProvider call({
    Duration window = const Duration(days: 30),
    String? sourceName,
  }) {
    return RawSleepRemProvider(window: window, sourceName: sourceName);
  }

  @override
  RawSleepRemProvider getProviderOverride(
    covariant RawSleepRemProvider provider,
  ) {
    return call(window: provider.window, sourceName: provider.sourceName);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'rawSleepRemProvider';
}

/// Returns REM sleep entries from the Raw Store for the given [window].
///
/// Copied from [rawSleepRem].
class RawSleepRemProvider extends AutoDisposeFutureProvider<List<RawEntry>> {
  /// Returns REM sleep entries from the Raw Store for the given [window].
  ///
  /// Copied from [rawSleepRem].
  RawSleepRemProvider({
    Duration window = const Duration(days: 30),
    String? sourceName,
  }) : this._internal(
         (ref) => rawSleepRem(
           ref as RawSleepRemRef,
           window: window,
           sourceName: sourceName,
         ),
         from: rawSleepRemProvider,
         name: r'rawSleepRemProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$rawSleepRemHash,
         dependencies: RawSleepRemFamily._dependencies,
         allTransitiveDependencies:
             RawSleepRemFamily._allTransitiveDependencies,
         window: window,
         sourceName: sourceName,
       );

  RawSleepRemProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.window,
    required this.sourceName,
  }) : super.internal();

  final Duration window;
  final String? sourceName;

  @override
  Override overrideWith(
    FutureOr<List<RawEntry>> Function(RawSleepRemRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RawSleepRemProvider._internal(
        (ref) => create(ref as RawSleepRemRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        window: window,
        sourceName: sourceName,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<RawEntry>> createElement() {
    return _RawSleepRemProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RawSleepRemProvider &&
        other.window == window &&
        other.sourceName == sourceName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, window.hashCode);
    hash = _SystemHash.combine(hash, sourceName.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RawSleepRemRef on AutoDisposeFutureProviderRef<List<RawEntry>> {
  /// The parameter `window` of this provider.
  Duration get window;

  /// The parameter `sourceName` of this provider.
  String? get sourceName;
}

class _RawSleepRemProviderElement
    extends AutoDisposeFutureProviderElement<List<RawEntry>>
    with RawSleepRemRef {
  _RawSleepRemProviderElement(super.provider);

  @override
  Duration get window => (origin as RawSleepRemProvider).window;
  @override
  String? get sourceName => (origin as RawSleepRemProvider).sourceName;
}

String _$rawSleepLightHash() => r'90a0ad53b30b427d3aee258c8c35c225d6176b72';

/// Returns light sleep entries from the Raw Store for the given [window].
///
/// Copied from [rawSleepLight].
@ProviderFor(rawSleepLight)
const rawSleepLightProvider = RawSleepLightFamily();

/// Returns light sleep entries from the Raw Store for the given [window].
///
/// Copied from [rawSleepLight].
class RawSleepLightFamily extends Family<AsyncValue<List<RawEntry>>> {
  /// Returns light sleep entries from the Raw Store for the given [window].
  ///
  /// Copied from [rawSleepLight].
  const RawSleepLightFamily();

  /// Returns light sleep entries from the Raw Store for the given [window].
  ///
  /// Copied from [rawSleepLight].
  RawSleepLightProvider call({
    Duration window = const Duration(days: 30),
    String? sourceName,
  }) {
    return RawSleepLightProvider(window: window, sourceName: sourceName);
  }

  @override
  RawSleepLightProvider getProviderOverride(
    covariant RawSleepLightProvider provider,
  ) {
    return call(window: provider.window, sourceName: provider.sourceName);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'rawSleepLightProvider';
}

/// Returns light sleep entries from the Raw Store for the given [window].
///
/// Copied from [rawSleepLight].
class RawSleepLightProvider extends AutoDisposeFutureProvider<List<RawEntry>> {
  /// Returns light sleep entries from the Raw Store for the given [window].
  ///
  /// Copied from [rawSleepLight].
  RawSleepLightProvider({
    Duration window = const Duration(days: 30),
    String? sourceName,
  }) : this._internal(
         (ref) => rawSleepLight(
           ref as RawSleepLightRef,
           window: window,
           sourceName: sourceName,
         ),
         from: rawSleepLightProvider,
         name: r'rawSleepLightProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$rawSleepLightHash,
         dependencies: RawSleepLightFamily._dependencies,
         allTransitiveDependencies:
             RawSleepLightFamily._allTransitiveDependencies,
         window: window,
         sourceName: sourceName,
       );

  RawSleepLightProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.window,
    required this.sourceName,
  }) : super.internal();

  final Duration window;
  final String? sourceName;

  @override
  Override overrideWith(
    FutureOr<List<RawEntry>> Function(RawSleepLightRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RawSleepLightProvider._internal(
        (ref) => create(ref as RawSleepLightRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        window: window,
        sourceName: sourceName,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<RawEntry>> createElement() {
    return _RawSleepLightProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RawSleepLightProvider &&
        other.window == window &&
        other.sourceName == sourceName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, window.hashCode);
    hash = _SystemHash.combine(hash, sourceName.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RawSleepLightRef on AutoDisposeFutureProviderRef<List<RawEntry>> {
  /// The parameter `window` of this provider.
  Duration get window;

  /// The parameter `sourceName` of this provider.
  String? get sourceName;
}

class _RawSleepLightProviderElement
    extends AutoDisposeFutureProviderElement<List<RawEntry>>
    with RawSleepLightRef {
  _RawSleepLightProviderElement(super.provider);

  @override
  Duration get window => (origin as RawSleepLightProvider).window;
  @override
  String? get sourceName => (origin as RawSleepLightProvider).sourceName;
}

String _$rawSleepHash() => r'19ba5613900d364c0e1323c199c3b760da05dc0e';

/// Aggregated convenience provider — all three sleep stage lists as a record.
/// Plugins that need the full sleep picture use this instead of three watches.
///
/// Copied from [rawSleep].
@ProviderFor(rawSleep)
const rawSleepProvider = RawSleepFamily();

/// Aggregated convenience provider — all three sleep stage lists as a record.
/// Plugins that need the full sleep picture use this instead of three watches.
///
/// Copied from [rawSleep].
class RawSleepFamily
    extends
        Family<
          AsyncValue<
            ({List<RawEntry> deep, List<RawEntry> rem, List<RawEntry> light})
          >
        > {
  /// Aggregated convenience provider — all three sleep stage lists as a record.
  /// Plugins that need the full sleep picture use this instead of three watches.
  ///
  /// Copied from [rawSleep].
  const RawSleepFamily();

  /// Aggregated convenience provider — all three sleep stage lists as a record.
  /// Plugins that need the full sleep picture use this instead of three watches.
  ///
  /// Copied from [rawSleep].
  RawSleepProvider call({
    Duration window = const Duration(days: 30),
    String? sourceName,
  }) {
    return RawSleepProvider(window: window, sourceName: sourceName);
  }

  @override
  RawSleepProvider getProviderOverride(covariant RawSleepProvider provider) {
    return call(window: provider.window, sourceName: provider.sourceName);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'rawSleepProvider';
}

/// Aggregated convenience provider — all three sleep stage lists as a record.
/// Plugins that need the full sleep picture use this instead of three watches.
///
/// Copied from [rawSleep].
class RawSleepProvider
    extends
        AutoDisposeFutureProvider<
          ({List<RawEntry> deep, List<RawEntry> rem, List<RawEntry> light})
        > {
  /// Aggregated convenience provider — all three sleep stage lists as a record.
  /// Plugins that need the full sleep picture use this instead of three watches.
  ///
  /// Copied from [rawSleep].
  RawSleepProvider({
    Duration window = const Duration(days: 30),
    String? sourceName,
  }) : this._internal(
         (ref) => rawSleep(
           ref as RawSleepRef,
           window: window,
           sourceName: sourceName,
         ),
         from: rawSleepProvider,
         name: r'rawSleepProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$rawSleepHash,
         dependencies: RawSleepFamily._dependencies,
         allTransitiveDependencies: RawSleepFamily._allTransitiveDependencies,
         window: window,
         sourceName: sourceName,
       );

  RawSleepProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.window,
    required this.sourceName,
  }) : super.internal();

  final Duration window;
  final String? sourceName;

  @override
  Override overrideWith(
    FutureOr<({List<RawEntry> deep, List<RawEntry> rem, List<RawEntry> light})>
    Function(RawSleepRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RawSleepProvider._internal(
        (ref) => create(ref as RawSleepRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        window: window,
        sourceName: sourceName,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<
    ({List<RawEntry> deep, List<RawEntry> rem, List<RawEntry> light})
  >
  createElement() {
    return _RawSleepProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RawSleepProvider &&
        other.window == window &&
        other.sourceName == sourceName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, window.hashCode);
    hash = _SystemHash.combine(hash, sourceName.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RawSleepRef
    on
        AutoDisposeFutureProviderRef<
          ({List<RawEntry> deep, List<RawEntry> rem, List<RawEntry> light})
        > {
  /// The parameter `window` of this provider.
  Duration get window;

  /// The parameter `sourceName` of this provider.
  String? get sourceName;
}

class _RawSleepProviderElement
    extends
        AutoDisposeFutureProviderElement<
          ({List<RawEntry> deep, List<RawEntry> rem, List<RawEntry> light})
        >
    with RawSleepRef {
  _RawSleepProviderElement(super.provider);

  @override
  Duration get window => (origin as RawSleepProvider).window;
  @override
  String? get sourceName => (origin as RawSleepProvider).sourceName;
}

String _$rawStepsHash() => r'58dac59002405802ed484172650846ead5cc6ed3';

/// Returns step count entries from the Raw Store for the given [window].
///
/// Copied from [rawSteps].
@ProviderFor(rawSteps)
const rawStepsProvider = RawStepsFamily();

/// Returns step count entries from the Raw Store for the given [window].
///
/// Copied from [rawSteps].
class RawStepsFamily extends Family<AsyncValue<List<RawEntry>>> {
  /// Returns step count entries from the Raw Store for the given [window].
  ///
  /// Copied from [rawSteps].
  const RawStepsFamily();

  /// Returns step count entries from the Raw Store for the given [window].
  ///
  /// Copied from [rawSteps].
  RawStepsProvider call({
    Duration window = const Duration(days: 30),
    String? sourceName,
  }) {
    return RawStepsProvider(window: window, sourceName: sourceName);
  }

  @override
  RawStepsProvider getProviderOverride(covariant RawStepsProvider provider) {
    return call(window: provider.window, sourceName: provider.sourceName);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'rawStepsProvider';
}

/// Returns step count entries from the Raw Store for the given [window].
///
/// Copied from [rawSteps].
class RawStepsProvider extends AutoDisposeFutureProvider<List<RawEntry>> {
  /// Returns step count entries from the Raw Store for the given [window].
  ///
  /// Copied from [rawSteps].
  RawStepsProvider({
    Duration window = const Duration(days: 30),
    String? sourceName,
  }) : this._internal(
         (ref) => rawSteps(
           ref as RawStepsRef,
           window: window,
           sourceName: sourceName,
         ),
         from: rawStepsProvider,
         name: r'rawStepsProvider',
         debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
             ? null
             : _$rawStepsHash,
         dependencies: RawStepsFamily._dependencies,
         allTransitiveDependencies: RawStepsFamily._allTransitiveDependencies,
         window: window,
         sourceName: sourceName,
       );

  RawStepsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.window,
    required this.sourceName,
  }) : super.internal();

  final Duration window;
  final String? sourceName;

  @override
  Override overrideWith(
    FutureOr<List<RawEntry>> Function(RawStepsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: RawStepsProvider._internal(
        (ref) => create(ref as RawStepsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        window: window,
        sourceName: sourceName,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<RawEntry>> createElement() {
    return _RawStepsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is RawStepsProvider &&
        other.window == window &&
        other.sourceName == sourceName;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, window.hashCode);
    hash = _SystemHash.combine(hash, sourceName.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin RawStepsRef on AutoDisposeFutureProviderRef<List<RawEntry>> {
  /// The parameter `window` of this provider.
  Duration get window;

  /// The parameter `sourceName` of this provider.
  String? get sourceName;
}

class _RawStepsProviderElement
    extends AutoDisposeFutureProviderElement<List<RawEntry>>
    with RawStepsRef {
  _RawStepsProviderElement(super.provider);

  @override
  Duration get window => (origin as RawStepsProvider).window;
  @override
  String? get sourceName => (origin as RawStepsProvider).sourceName;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
