import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:intl/intl.dart';

import '../../core/sync/sync_notifier.dart';
import '../plugins/plugin_manager_screen.dart';
import '../theme/app_theme.dart';
import 'navigation_manager_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncNotifierProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _buildSectionHeader('General'),
          _buildCard(context, [
            Consumer(builder: (context, ref, child) {
              final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
              return SwitchListTile(
                secondary: const Icon(Icons.palette_outlined),
                title: const Text('Dark Mode'),
                subtitle: const Text('Switch between light and dark theme'),
                value: isDark,
                onChanged: (val) {
                  ref.read(themeModeProvider.notifier).toggle();
                },
              );
            }),
            const Divider(height: 1, indent: 56),
            Consumer(builder: (context, ref, child) {
              final useDynamicColor = ref.watch(useDynamicColorProvider);
              return SwitchListTile(
                secondary: const Icon(Icons.color_lens_outlined),
                title: const Text('Material 3 Dynamic Colors'),
                subtitle: const Text('Extract colors from wallpaper'),
                value: useDynamicColor,
                onChanged: (val) {
                  ref.read(useDynamicColorProvider.notifier).setMode(val);
                },
              );
            }),
          ]),
          const SizedBox(height: 24),
          
          _buildSectionHeader('Health Data'),
          _buildCard(context, [
            SwitchListTile(
              secondary: const Icon(Icons.favorite_outline, color: Colors.redAccent),
              title: const Text('Health Connect'),
              subtitle: Text(
                syncState.status == SyncStatus.permissionDenied 
                  ? 'Disconnected' 
                  : syncState.status == SyncStatus.error 
                    ? 'Error - Check permissions' 
                    : 'Connected & active',
                style: TextStyle(
                  fontSize: 13, 
                  color: (syncState.status == SyncStatus.permissionDenied || syncState.status == SyncStatus.error) 
                    ? Colors.red 
                    : Colors.green[700]
                ),
              ),
              value: syncState.status != SyncStatus.permissionDenied && syncState.status != SyncStatus.error,
              onChanged: (val) async {
                if (val) {
                  await ref.read(syncNotifierProvider.notifier).resync();
                  if (context.mounted && ref.read(syncNotifierProvider).status == SyncStatus.permissionDenied) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please open Android Settings -> Health Connect and grant permissions manually.'))
                    );
                  }
                }
              },
            ),
            if (syncState.status != SyncStatus.permissionDenied)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
                      foregroundColor: theme.colorScheme.primary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    icon: syncState.status == SyncStatus.syncing || syncState.status == SyncStatus.checkingPermissions
                        ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Icon(Icons.sync),
                    label: Text(syncState.lastSyncTime != null 
                        ? 'Sync Now (Last: ${DateFormat('HH:mm').format(syncState.lastSyncTime!)})'
                        : 'Sync Now'),
                    onPressed: (syncState.status == SyncStatus.syncing || syncState.status == SyncStatus.checkingPermissions) 
                        ? null 
                        : () => ref.read(syncNotifierProvider.notifier).resync(),
                  ),
                ),
              ),
          ]),
          const SizedBox(height: 24),

          _buildSectionHeader('Extensions & Layout'),
          _buildCard(context, [
            ListTile(
              leading: const Icon(Icons.extension_outlined, color: Colors.black54),
              title: const Text('Plugins'),
              subtitle: const Text('Manage dashboard widgets and features', style: TextStyle(fontSize: 13)),
              trailing: const Icon(Icons.chevron_right, color: Colors.black26),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const PluginManagerScreen()),
                );
              },
            ),
            const Divider(height: 1, color: Colors.black12),
            ListTile(
              leading: const Icon(Icons.view_column_rounded, color: Colors.black54),
              title: const Text('Navigation Menu'),
              subtitle: const Text('Customize your bottom bar tabs', style: TextStyle(fontSize: 13)),
              trailing: const Icon(Icons.chevron_right, color: Colors.black26),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NavigationManagerScreen()),
                );
              },
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          color: Colors.black45,
          fontSize: 12,
          fontWeight: FontWeight.w600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, List<Widget> children) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: theme.brightness == Brightness.dark ? 0.2 : 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: children,
      ),
    );
  }
}
