import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:drift/drift.dart';

import '../database/app_database.dart';
import '../../plugins/raw/raw_providers.dart';
import 'plugin_interfaces.dart';

part 'plugin_registry.g.dart';

/// Holds the list of available plugins in the system.
///
/// We don't make this a provider itself because the list of *available*
/// plugins is static, only their *state* (enabled/disabled/position) changes.
class PluginRegistry {
  static final List<KernPlugin> _plugins = [];

  /// Register a plugin with the system. Call this before runApp.
  static void register(KernPlugin plugin) {
    if (_plugins.any((p) => p.id == plugin.id)) {
      debugPrint('[PluginRegistry] Plugin ${plugin.id} already registered. Skipping.');
      return;
    }
    _plugins.add(plugin);
    debugPrint('[PluginRegistry] Registered: ${plugin.id}');
  }

  static List<KernPlugin> get all => List.unmodifiable(_plugins);
}

/// The state object exposed by [activePluginsProvider].
class PluginRegistryState {
  PluginRegistryState({required this.settings});

  /// The active settings from the database.
  final List<PluginSetting> settings;

  /// Returns whether a plugin is enabled.
  bool isEnabled(String pluginId) {
    final s = settings.firstWhere(
      (s) => s.pluginId == pluginId,
      orElse: () => PluginSetting(
        pluginId: pluginId,
        isEnabled: false,
        dashboardSlot: 'hidden',
        sortOrder: 999,
      ),
    );
    return s.isEnabled;
  }

  /// Returns all enabled plugins that are configured to render in [slot],
  /// sorted by their user-defined [sortOrder].
  List<KernPlugin> getForSlot(PluginSlot slot) {
    final slotName = slot.name;
    final slotSettings = settings
        .where((s) => s.isEnabled && s.dashboardSlot == slotName)
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    final slotPluginIds = slotSettings.map((s) => s.pluginId).toSet();

    return PluginRegistry.all
        .where((p) => slotPluginIds.contains(p.id))
        // Re-sort the actual plugins to match the DB sort order
        .toList()
      ..sort((a, b) {
        final orderA = slotSettings.firstWhere((s) => s.pluginId == a.id).sortOrder;
        final orderB = slotSettings.firstWhere((s) => s.pluginId == b.id).sortOrder;
        return orderA.compareTo(orderB);
      });
  }

  /// Returns all enabled plugins that provide a detail page.
  List<KernPlugin> getNavigablePlugins() {
    return PluginRegistry.all
        .where((p) => isEnabled(p.id) && p.hasDetailPage)
        .toList();
  }
}

/// Watches the PluginSettings table and provides the current [PluginRegistryState].
///
/// The UI watches this to know what to render. When the user toggles a plugin
/// or changes its position in the Plugin Manager, this provider updates automatically.
@riverpod
Stream<PluginRegistryState> activePlugins(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return db.watchAllPluginSettings().map((settings) => PluginRegistryState(settings: settings));
}

/// Utility provider to update plugin settings.
@riverpod
class PluginConfigurator extends _$PluginConfigurator {
  @override
  void build() {}

  /// Upserts a plugin's settings, updating its enabled state, slot, or order.
  Future<void> updateSettings({
    required String pluginId,
    bool? isEnabled,
    String? dashboardSlot,
    int? sortOrder,
  }) async {
    final db = ref.read(appDatabaseProvider);
    final current = await db.getPluginSettings(pluginId);

    await db.upsertPluginSettings(
      PluginSettingsCompanion(
        pluginId: Value(pluginId),
        isEnabled: isEnabled != null ? Value(isEnabled) : (current != null ? Value(current.isEnabled) : const Value.absent()),
        dashboardSlot: dashboardSlot != null ? Value(dashboardSlot) : (current != null ? Value(current.dashboardSlot) : const Value.absent()),
        sortOrder: sortOrder != null ? Value(sortOrder) : (current != null ? Value(current.sortOrder) : const Value.absent()),
      ),
    );
  }

  /// One-time setup: ensures all registered plugins have a default DB row.
  Future<void> initializeDefaults() async {
    final db = ref.read(appDatabaseProvider);
    final existing = await db.watchAllPluginSettings().first;
    final existingIds = existing.map((s) => s.pluginId).toSet();

    final defaults = <PluginSettingsCompanion>[];

    for (final p in PluginRegistry.all) {
      if (!existingIds.contains(p.id)) {
        // By default, enable it, but only put it on the dashboard if it supports main.
        // We do a smart default: if it supports main, put it in main.
        // Else if header, header. Else footer. Else hidden.
        String defaultSlot = 'hidden';
        if (p.supportedSlots.contains(PluginSlot.main)) {
          defaultSlot = PluginSlot.main.name;
        } else if (p.supportedSlots.contains(PluginSlot.header)) {
          defaultSlot = PluginSlot.header.name;
        } else if (p.supportedSlots.contains(PluginSlot.footer)) {
          defaultSlot = PluginSlot.footer.name;
        }

        defaults.add(
          PluginSettingsCompanion.insert(
            pluginId: p.id,
            isEnabled: const Value(true),
            dashboardSlot: Value(defaultSlot),
            sortOrder: const Value(0),
          ),
        );
      }
    }

    if (defaults.isNotEmpty) {
      await db.initDefaultSettings(defaults);
      debugPrint('[PluginConfigurator] Initialized defaults for ${defaults.length} plugins');
    }
  }
}
