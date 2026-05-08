import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/navigation/navigation_state.dart';
import '../../core/plugins/plugin_registry.dart';

class NavigationManagerScreen extends ConsumerWidget {
  const NavigationManagerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navOrder = ref.watch(navigationStateProvider);
    final pluginStateAsync = ref.watch(activePluginsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text('Navigation Menu', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 18)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: pluginStateAsync.when(
        data: (state) {
          final navPlugins = state.getNavigablePlugins();
          
          // Available items that can be added (not currently in navOrder)
          final availableIds = [
            'dashboard',
            'data',
            'settings',
            ...navPlugins.map((p) => p.id),
          ].where((id) => !navOrder.contains(id)).toList();

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.all(16),
                child: Text('Active Tabs (Drag to reorder)', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black54)),
              ),
              Expanded(
                child: ReorderableListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: navOrder.length,
                  onReorder: (oldIndex, newIndex) {
                    if (newIndex > oldIndex) newIndex -= 1;
                    final list = List<String>.from(navOrder);
                    final item = list.removeAt(oldIndex);
                    list.insert(newIndex, item);
                    ref.read(navigationStateProvider.notifier).updateOrder(list);
                  },
                  itemBuilder: (context, index) {
                    final id = navOrder[index];
                    return _buildNavItem(id, navPlugins, true, () {
                      if (id == 'settings') {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Settings tab cannot be removed')));
                        return;
                      }
                      final list = List<String>.from(navOrder);
                      list.remove(id);
                      ref.read(navigationStateProvider.notifier).updateOrder(list);
                    }, Key(id));
                  },
                ),
              ),
              if (availableIds.isNotEmpty) ...[
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text('Available Tabs', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black54)),
                ),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: availableIds.length,
                    itemBuilder: (context, index) {
                      final id = availableIds[index];
                      return _buildNavItem(id, navPlugins, false, () {
                        if (navOrder.length >= 5) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Maximum 5 tabs allowed')));
                          return;
                        }
                        final list = List<String>.from(navOrder);
                        list.add(id);
                        ref.read(navigationStateProvider.notifier).updateOrder(list);
                      }, Key('avail_$id'));
                    },
                  ),
                ),
              ],
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildNavItem(String id, List<dynamic> navPlugins, bool isActive, VoidCallback onAction, Key key) {
    String title = id;
    IconData icon = Icons.extension_rounded;

    if (id == 'dashboard') {
      title = 'Dashboard';
      icon = Icons.view_agenda_rounded;
    } else if (id == 'data') {
      title = 'Data Explorer';
      icon = Icons.analytics_rounded;
    } else if (id == 'settings') {
      title = 'Settings';
      icon = Icons.settings_rounded;
    } else {
      final plugin = navPlugins.where((p) => p.id == id).firstOrNull;
      if (plugin != null) {
        title = plugin.name;
      }
    }

    return Container(
      key: key,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.black54),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, color: Colors.black87)),
        trailing: IconButton(
          icon: Icon(isActive ? Icons.remove_circle_outline : Icons.add_circle_outline, 
                     color: isActive ? Colors.red[300] : Colors.green[500]),
          onPressed: onAction,
        ),
      ),
    );
  }
}
