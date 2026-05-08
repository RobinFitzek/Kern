import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/database/app_database.dart';
import 'core/sync/sync_notifier.dart';
import 'plugins/raw/raw_providers.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final db = AppDatabase();

  runApp(
    ProviderScope(
      overrides: [
        // Single DB connection shared by all providers.
        appDatabaseProvider.overrideWithValue(db),
      ],
      child: const KernApp(),
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
// App shell — triggers sync on first build, passes state to placeholder
// ---------------------------------------------------------------------------

class _AppShell extends ConsumerStatefulWidget {
  const _AppShell();

  @override
  ConsumerState<_AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<_AppShell> {
  @override
  void initState() {
    super.initState();
    // Kick off the permission check + delta sync on first frame.
    // Using addPostFrameCallback so the widget tree is fully built before
    // we trigger async work that reads other providers.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(syncNotifierProvider.notifier).initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    final sync = ref.watch(syncNotifierProvider);
    return _PlaceholderHome(syncState: sync);
  }
}

// ---------------------------------------------------------------------------
// Temporary placeholder — replaced in Phase 3 with the Dashboard screen
// ---------------------------------------------------------------------------

class _PlaceholderHome extends StatelessWidget {
  const _PlaceholderHome({required this.syncState});

  final HealthSyncState syncState;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0F),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'kern',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w700,
                color: Color(0xFF00D4FF),
                letterSpacing: -2,
              ),
            ),
            const SizedBox(height: 16),
            _SyncStatusIndicator(state: syncState),
          ],
        ),
      ),
    );
  }
}

class _SyncStatusIndicator extends StatelessWidget {
  const _SyncStatusIndicator({required this.state});

  final HealthSyncState state;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: switch (state.status) {
        SyncStatus.idle => _label('initializing…'),
        SyncStatus.checkingPermissions => _label('checking permissions…'),
        SyncStatus.syncing => _row(
            const SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 1.5,
                color: Color(0xFF00D4FF),
              ),
            ),
            'syncing health data…',
          ),
        SyncStatus.done => _label('ready', color: const Color(0xFF00D4FF)),
        SyncStatus.permissionDenied => _label(
            'health connect permission required',
            color: Colors.orange,
          ),
        SyncStatus.error => _label(
            'sync error — tap to retry',
            color: Colors.redAccent,
          ),
      },
    );
  }

  Widget _label(String text, {Color? color}) => Text(
        text,
        key: ValueKey(text),
        style: TextStyle(
          fontSize: 12,
          color: color ?? Colors.white.withValues(alpha: 0.4),
          letterSpacing: 1.5,
        ),
      );

  Widget _row(Widget icon, String text) => Row(
        key: const ValueKey('syncing'),
        mainAxisSize: MainAxisSize.min,
        children: [
          icon,
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.4),
              letterSpacing: 1.5,
            ),
          ),
        ],
      );
}
