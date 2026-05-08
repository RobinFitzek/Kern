import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/database/app_database.dart';
import 'core/sync/sync_notifier.dart';
import 'plugins/raw/raw_providers.dart';
import 'core/plugins/plugin_registry.dart';
import 'plugins/readiness/readiness_feature.dart';
import 'plugins/sleep/sleep_feature.dart';
import 'plugins/strain/strain_feature.dart';
import 'ui/dashboard/dashboard_screen.dart';
import 'ui/data/data_explorer_screen.dart';
import 'ui/settings/settings_screen.dart';
import 'ui/theme/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Register all plugins
  PluginRegistry.register(ReadinessFeature());
  PluginRegistry.register(SleepFeature());
  PluginRegistry.register(StrainFeature());

  final db = AppDatabase();

  runApp(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
      ],
      child: MaterialApp(
        title: 'Kern',
        theme: AppTheme.lightTheme,
        home: const _AppShell(),
      ),
    ),
  );
}

class KernApp extends StatelessWidget {
  const KernApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kern',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00D4FF),
          brightness: Brightness.dark,
        ),
        fontFamily: 'Inter',
      ),
      home: const _AppShell(),
    );
  }
}

// ---------------------------------------------------------------------------
// App shell — manages bottom navigation and sync on first build
// ---------------------------------------------------------------------------

class _AppShell extends ConsumerStatefulWidget {
  const _AppShell();

  @override
  ConsumerState<_AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<_AppShell> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // 1. Initialize plugin settings defaults in DB
      await ref.read(pluginConfiguratorProvider.notifier).initializeDefaults();
      // 2. Start sync
      ref.read(syncNotifierProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Watch active plugins to know if any have detail pages
    final pluginStateAsync = ref.watch(activePluginsProvider);

    return pluginStateAsync.when(
      data: (state) {
        final navPlugins = state.getNavigablePlugins();
        
        final pages = [
          const DashboardScreen(),
          const DataExplorerScreen(),
          ...navPlugins.map((p) => p.buildDetailPage(context)!),
          const SettingsScreen(),
        ];

        return Scaffold(
          body: pages[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            items: [
              const BottomNavigationBarItem(icon: Icon(Icons.view_agenda_rounded), label: 'Today'),
              const BottomNavigationBarItem(icon: Icon(Icons.analytics_rounded), label: 'Data'),
              ...navPlugins.map((p) => BottomNavigationBarItem(icon: const Icon(Icons.extension), label: p.name)),
              const BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: 'Settings'),
            ],
          ),
        );
      },
      loading: () => const Scaffold(backgroundColor: Color(0xFFF4F7FB), body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
    );
  }
}
