import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/sync/sync_notifier.dart';
import '../plugins/plugin_manager_screen.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncState = ref.watch(syncNotifierProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB), // Light background
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 18)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _buildSectionHeader('General'),
          _buildCard([
            ListTile(
              leading: const Icon(Icons.palette_outlined, color: Colors.black54),
              title: const Text('Appearance'),
              subtitle: const Text('Light mode (Default)', style: TextStyle(fontSize: 13)),
              trailing: const Icon(Icons.chevron_right, color: Colors.black26),
              onTap: () {
                // Future: Theme selection
              },
            ),
          ]),
          const SizedBox(height: 24),
          
          _buildSectionHeader('Health Data'),
          _buildCard([
            ListTile(
              leading: const Icon(Icons.favorite_outline, color: Colors.black54),
              title: const Text('Health Connect'),
              subtitle: Text(
                syncState.status == SyncStatus.permissionDenied 
                  ? 'Disconnected - Tap to connect' 
                  : syncState.status == SyncStatus.error 
                    ? 'Error - Tap to retry' 
                    : 'Connected',
                style: TextStyle(
                  fontSize: 13, 
                  color: (syncState.status == SyncStatus.permissionDenied || syncState.status == SyncStatus.error) 
                    ? Colors.red 
                    : Colors.green[700]
                ),
              ),
              trailing: syncState.status == SyncStatus.syncing
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.sync, color: Colors.black54),
              onTap: () {
                ref.read(syncNotifierProvider.notifier).resync();
              },
            ),
          ]),
          const SizedBox(height: 24),

          _buildSectionHeader('Extensions'),
          _buildCard([
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

  Widget _buildCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
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
