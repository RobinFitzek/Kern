/// Riverpod providers for core services.
///
/// Separating service providers from the database provider keeps the
/// dependency graph explicit: database → service → plugins.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'health_connect_service.dart';
import '../../plugins/raw/raw_providers.dart';

export 'health_connect_service.dart';

/// Shared [HealthConnectService] instance.
///
/// Depends on [appDatabaseProvider] so it automatically uses the same
/// database connection as the rest of the app. Override in tests.
final healthConnectServiceProvider = Provider<HealthConnectService>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return HealthConnectService(db);
});
