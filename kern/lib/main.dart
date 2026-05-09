import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dynamic_color/dynamic_color.dart';

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
import 'ui/onboarding/onboarding_screen.dart';
import 'ui/onboarding/onboarding_provider.dart';
import 'ui/theme/app_theme.dart';
import 'core/navigation/navigation_state.dart';

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
      child: const KernApp(),
    ),
  );
}

class KernApp extends ConsumerWidget {
  const KernApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasCompletedOnboarding = ref.watch(onboardingCompletedProvider);
    final themeMode = ref.watch(themeModeProvider);
    final useDynamicColor = ref.watch(useDynamicColorProvider);

    return DynamicColorBuilder(
      builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
        return MaterialApp(
          title: 'Kern',
          debugShowCheckedModeBanner: false,
          themeMode: themeMode,
          theme: AppTheme.lightTheme(useDynamicColor ? lightDynamic : null),
          darkTheme: AppTheme.darkTheme(useDynamicColor ? darkDynamic : null),
          home: hasCompletedOnboarding ? const _AppShell() : const OnboardingScreen(),
        );
      },
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
    final navOrder = ref.watch(navigationStateProvider);

    return pluginStateAsync.when(
      data: (state) {
        final navPlugins = state.getNavigablePlugins();
        
        final List<Widget> pages = [];
        final List<BottomNavigationBarItem> items = [];

        for (final id in navOrder) {
          if (id == 'dashboard') {
            pages.add(const DashboardScreen());
            items.add(const BottomNavigationBarItem(icon: Icon(Icons.view_agenda_rounded), label: 'Today'));
          } else if (id == 'data') {
            pages.add(const DataExplorerScreen());
            items.add(const BottomNavigationBarItem(icon: Icon(Icons.analytics_rounded), label: 'Data'));
          } else if (id == 'settings') {
            pages.add(const SettingsScreen());
            items.add(const BottomNavigationBarItem(icon: Icon(Icons.settings_rounded), label: 'Settings'));
          } else {
            // It might be a plugin
            final plugin = navPlugins.where((p) => p.id == id).firstOrNull;
            if (plugin != null) {
              pages.add(plugin.buildDetailPage(context)!);
              items.add(BottomNavigationBarItem(icon: const Icon(Icons.extension_rounded), label: plugin.name));
            }
          }
        }

        // Failsafe if empty
        if (pages.isEmpty) {
          pages.add(const DashboardScreen());
          items.add(const BottomNavigationBarItem(icon: Icon(Icons.view_agenda_rounded), label: 'Today'));
        }

        // Ensure current index is valid
        if (_currentIndex >= pages.length) {
          _currentIndex = 0;
        }

        return Scaffold(
          body: pages[_currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (index) => setState(() => _currentIndex = index),
            items: items,
          ),
        );
      },
      loading: () => const Scaffold(backgroundColor: Color(0xFFF4F7FB), body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Error: $e'))),
    );
  }
}
