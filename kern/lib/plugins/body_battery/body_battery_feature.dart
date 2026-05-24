import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/plugins/plugin_interfaces.dart';
import '../derived/derived_providers.dart';
import '../../ui/theme/app_theme.dart';
import '../../ui/widgets/bouncing_card.dart';

class BodyBatteryFeature implements KernPlugin {
  @override
  String get id => 'body_battery';

  @override
  String get name => 'Body Battery';

  @override
  String get description => 'Energie-Level Schätzung basierend auf Schlaf, Belastung und Tageszeit.';

  @override
  List<PluginSlot> get supportedSlots => [PluginSlot.header, PluginSlot.footer];

  @override
  Widget buildDashboardWidget(BuildContext context, PluginSlot slot) {
    return const _BodyBatteryWidget();
  }

  @override
  bool get hasDetailPage => true;

  @override
  Widget? buildDetailPage(BuildContext context) => const _BodyBatteryDetailScreen();

  @override
  Widget? buildSettingsPage(BuildContext context) => const _BodyBatterySettingsScreen();
}

class _BodyBatteryWidget extends ConsumerWidget {
  const _BodyBatteryWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final levelAsync = ref.watch(bodyBatteryCurrentLevelProvider());
    final morningAsync = ref.watch(bodyBatteryMorningLevelProvider());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final level = levelAsync.valueOrNull;
    final morning = morningAsync.valueOrNull;

    return BouncingCard(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const _BodyBatteryDetailScreen()),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: _batteryColor(level ?? 50, isDark).withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.battery_charging_full_rounded,
                      color: _batteryColor(level ?? 50, isDark),
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Body Battery',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppTheme.textSecondary),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          level?.toStringAsFixed(0) ?? '--',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _batteryLabel(level ?? 50),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _batteryColor(level ?? 50, isDark),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (morning != null) ...[
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: SizedBox(
                            width: 100,
                            height: 28,
                            child: Stack(
                              children: [
                                Container(color: isDark ? Colors.white12 : AppTheme.divider),
                                FractionallySizedBox(
                                  widthFactor: (level ?? 50) / 100,
                                  child: Container(color: _batteryColor(level ?? 50, isDark)),
                                ),
                                Center(
                                  child: Text(
                                    '${level?.toStringAsFixed(0) ?? "--"}%',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Start: ${morning.toInt()}%',
                          style: TextStyle(fontSize: 10, color: isDark ? Colors.white38 : AppTheme.textTertiary),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _batteryColor(double level, bool isDark) {
    if (level > 60) return isDark ? const Color(0xFF34A853) : AppTheme.textMint;
    if (level > 30) return isDark ? const Color(0xFFFBBC04) : AppTheme.textOrange;
    return isDark ? const Color(0xFFEA4335) : AppTheme.textPink;
  }

  String _batteryLabel(double level) {
    if (level > 60) return 'Geladen';
    if (level > 30) return 'Mittel';
    return 'Niedrig';
  }
}

class _BodyBatteryDetailScreen extends ConsumerWidget {
  const _BodyBatteryDetailScreen();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final levelAsync = ref.watch(bodyBatteryCurrentLevelProvider());
    final morningAsync = ref.watch(bodyBatteryMorningLevelProvider());
    final drainAsync = ref.watch(bodyBatteryDrainRateProvider());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Body Battery'),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Column(
              children: [
                levelAsync.when(
                  data: (level) {
                    final l = level ?? 50;
                    return Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 160,
                              height: 160,
                              child: CircularProgressIndicator(
                                value: l / 100,
                                strokeWidth: 16,
                                backgroundColor: isDark ? Colors.white12 : AppTheme.divider,
                                color: _batteryColor(l, isDark),
                                strokeCap: StrokeCap.round,
                              ),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  l > 60 ? Icons.battery_full_rounded : l > 30 ? Icons.battery_3_bar_rounded : Icons.battery_1_bar_rounded,
                                  size: 32,
                                  color: _batteryColor(l, isDark),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${l.toInt()}%',
                                  style: TextStyle(
                                    fontSize: 36,
                                    fontWeight: FontWeight.bold,
                                    color: _batteryColor(l, isDark),
                                  ),
                                ),
                                Text(
                                  _batteryLabel(l),
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: _batteryColor(l, isDark).withValues(alpha: 0.8),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Aktuelles Energie-Level',
                          style: TextStyle(
                            fontSize: 14,
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    );
                  },
                  loading: () => const SizedBox(height: 160, child: Center(child: CircularProgressIndicator())),
                  error: (_, __) => const SizedBox(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          morningAsync.when(
            data: (morning) => morning != null
                  ? _BodyBatteryMetricTile(
                    icon: Icons.wb_sunny_rounded,
                    label: 'Morgen-Level',
                    value: '${morning.toInt()}%',
                    color: AppTheme.textOrange,
                    isDark: isDark,
                  )
                : const SizedBox(),
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          ),
          const SizedBox(height: 8),
          drainAsync.when(
            data: (drain) => drain != null
                  ? _BodyBatteryMetricTile(
                    icon: Icons.speed_rounded,
                    label: 'Entlade-Rate',
                    value: '${drain.toStringAsFixed(1)}% / h',
                    color: AppTheme.textBlue,
                    isDark: isDark,
                  )
                : const SizedBox(),
            loading: () => const SizedBox(),
            error: (_, __) => const SizedBox(),
          ),
        ],
      ),
    );
  }

  Color _batteryColor(double level, bool isDark) {
    if (level > 60) return isDark ? const Color(0xFF34A853) : AppTheme.textMint;
    if (level > 30) return isDark ? const Color(0xFFFBBC04) : AppTheme.textOrange;
    return isDark ? const Color(0xFFEA4335) : AppTheme.textPink;
  }

  String _batteryLabel(double level) {
    if (level > 60) return 'Geladen';
    if (level > 30) return 'Mittel';
    return 'Niedrig';
  }
}

class _BodyBatteryMetricTile extends StatelessWidget {
  const _BodyBatteryMetricTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    required this.isDark,
  });
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14))),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: color)),
        ],
      ),
    );
  }
}

class _BodyBatterySettingsScreen extends StatelessWidget {
  const _BodyBatterySettingsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Body Battery Einstellungen')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const ListTile(
            title: Text('Berechnungs-Methode'),
            subtitle: Text('Schlaf + Belastung + Tageszeit'),
            trailing: Icon(Icons.chevron_right),
            enabled: false,
          ),
          SwitchListTile(
            title: const Text('Niedrig-Warnung'),
            subtitle: const Text('Demnächst verfügbar'),
            value: false,
            onChanged: null,
          ),
        ],
      ),
    );
  }
}
