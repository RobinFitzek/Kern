import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/plugins/plugin_registry.dart';
import '../../core/plugins/plugin_interfaces.dart';

// ---------------------------------------------------------------------------
// PluginManagerScreen
// ---------------------------------------------------------------------------
// Allows the user to toggle plugins on/off, change their dashboard slots,
// and access individual plugin settings.
// ---------------------------------------------------------------------------

class PluginManagerScreen extends ConsumerWidget {
  const PluginManagerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pluginStateAsync = ref.watch(activePluginsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text('Plugins', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: Colors.black87)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: pluginStateAsync.when(
        data: (state) => _buildList(context, state, ref),
        loading: () => const Center(child: CircularProgressIndicator(color: Color(0xFF1967D2))),
        error: (e, st) => Center(child: Text('Error loading plugins: $e')),
      ),
    );
  }

  Widget _buildList(BuildContext context, PluginRegistryState state, WidgetRef ref) {
    final plugins = PluginRegistry.all;

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: plugins.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final plugin = plugins[index];
        final isEnabled = state.isEnabled(plugin.id);
        final setting = state.settings.firstWhere(
          (s) => s.pluginId == plugin.id,
          orElse: () => throw StateError('Missing default settings for ${plugin.id}'),
        );

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              SwitchListTile(
                title: Text(plugin.name, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    plugin.description,
                    style: const TextStyle(color: Colors.black54, fontSize: 13),
                  ),
                ),
                value: isEnabled,
                activeColor: const Color(0xFF1967D2), // Google Blue
                onChanged: (val) {
                  ref.read(pluginConfiguratorProvider.notifier).updateSettings(
                        pluginId: plugin.id,
                        isEnabled: val,
                      );
                },
              ),
              if (isEnabled && plugin.supportedSlots.isNotEmpty) ...[
                const Divider(height: 1, color: Colors.black12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Dashboard Slot', style: TextStyle(color: Colors.black54, fontSize: 14)),
                      DropdownButton<String>(
                        value: setting.dashboardSlot,
                        dropdownColor: Colors.white,
                        underline: const SizedBox(),
                        style: const TextStyle(color: Color(0xFF1967D2), fontSize: 14, fontWeight: FontWeight.w500),
                        items: [
                          const DropdownMenuItem(value: 'hidden', child: Text('Hidden')),
                          ...plugin.supportedSlots.map((slot) => DropdownMenuItem(
                                value: slot.name,
                                child: Text(slot.name.toUpperCase()),
                              )),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            ref.read(pluginConfiguratorProvider.notifier).updateSettings(
                                  pluginId: plugin.id,
                                  dashboardSlot: val,
                                );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ],
              if (isEnabled && plugin.buildSettingsPage(context) != null) ...[
                const Divider(height: 1, color: Colors.black12),
                ListTile(
                  title: const Text('Plugin Settings', style: TextStyle(fontSize: 14, color: Colors.black87)),
                  trailing: const Icon(Icons.chevron_right, color: Colors.black26),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => plugin.buildSettingsPage(context)!),
                    );
                  },
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
