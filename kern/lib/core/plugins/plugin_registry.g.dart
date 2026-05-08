// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plugin_registry.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activePluginsHash() => r'bf87539aa259443952f7a0dccc95483cbc868286';

/// Watches the PluginSettings table and provides the current [PluginRegistryState].
///
/// The UI watches this to know what to render. When the user toggles a plugin
/// or changes its position in the Plugin Manager, this provider updates automatically.
///
/// Copied from [activePlugins].
@ProviderFor(activePlugins)
final activePluginsProvider =
    AutoDisposeStreamProvider<PluginRegistryState>.internal(
      activePlugins,
      name: r'activePluginsProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$activePluginsHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ActivePluginsRef = AutoDisposeStreamProviderRef<PluginRegistryState>;
String _$pluginConfiguratorHash() =>
    r'30cb5499951f3ed537a71bc8d5eb57676e4855af';

/// Utility provider to update plugin settings.
///
/// Copied from [PluginConfigurator].
@ProviderFor(PluginConfigurator)
final pluginConfiguratorProvider =
    AutoDisposeNotifierProvider<PluginConfigurator, void>.internal(
      PluginConfigurator.new,
      name: r'pluginConfiguratorProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$pluginConfiguratorHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PluginConfigurator = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
