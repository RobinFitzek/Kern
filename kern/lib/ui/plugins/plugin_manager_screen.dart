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
          child: ListTile(
            title: Text(plugin.name, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black87)),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                plugin.description,
                style: const TextStyle(color: Colors.black54, fontSize: 13),
              ),
            ),
            trailing: Switch(
              value: isEnabled,
              activeColor: const Color(0xFF1967D2), // Google Blue
              onChanged: (val) {
                ref.read(pluginConfiguratorProvider.notifier).updateSettings(
                      pluginId: plugin.id,
                      isEnabled: val,
                    );
              },
            ),
            onTap: () {
              _showPluginDetailsPopup(context, plugin, isEnabled, setting, ref);
            },
          ),
        );
      },
    );
  }

  void _showPluginDetailsPopup(BuildContext context, KernPlugin plugin, bool isEnabled, dynamic setting, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(plugin.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                    const Text('v1.0.0', style: TextStyle(color: Colors.black38, fontSize: 12, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(plugin.description, style: const TextStyle(color: Colors.black54, fontSize: 14)),
                const SizedBox(height: 24),
                
                if (isEnabled && plugin.supportedSlots.isNotEmpty) ...[
                  const Text('Dashboard Position', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F7FB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButton<String>(
                      value: setting.dashboardSlot,
                      dropdownColor: Colors.white,
                      isExpanded: true,
                      underline: const SizedBox(),
                      style: const TextStyle(color: Color(0xFF1967D2), fontSize: 14, fontWeight: FontWeight.w600),
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
                          Navigator.pop(context); // Close after selection
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                const Text('Settings', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Colors.black87)),
                const SizedBox(height: 8),
                
                if (plugin.buildSettingsPage(context) != null)
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F7FB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      title: const Text('Open Plugin Settings', style: TextStyle(fontSize: 14, color: Colors.black87)),
                      trailing: const Icon(Icons.chevron_right, color: Colors.black26),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (_) => plugin.buildSettingsPage(context)!));
                      },
                    ),
                  )
                else
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F7FB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.black38, size: 20),
                        SizedBox(width: 12),
                        Text('No advanced settings available.', style: TextStyle(color: Colors.black54, fontSize: 13)),
                      ],
                    ),
                  ),
                  
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }
}
