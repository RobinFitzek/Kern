import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/plugins/plugin_interfaces.dart';
import '../derived/derived_providers.dart';
import '../../ui/theme/app_theme.dart';
import '../../ui/widgets/bouncing_card.dart';

class ReadinessFeature implements KernPlugin {
  @override
  String get id => 'readiness';

  @override
  String get name => 'Readiness Score';

  @override
  String get description => 'Daily readiness score based on HRV, Sleep, and Strain.';

  @override
  List<PluginSlot> get supportedSlots => [PluginSlot.main, PluginSlot.header];

  @override
  Widget buildDashboardWidget(BuildContext context, PluginSlot slot) {
    if (slot == PluginSlot.main) {
      return const _ReadinessMainWidget();
    }
    return const _ReadinessHeaderWidget();
  }

  @override
  Widget? buildDetailPage(BuildContext context) => const ReadinessDetailScreen();

  @override
  bool get hasDetailPage => true;

  @override
  Widget? buildSettingsPage(BuildContext context) => const ReadinessSettingsScreen();
}

class _ReadinessMainWidget extends ConsumerWidget {
  const _ReadinessMainWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreAsync = ref.watch(readinessScoreProvider());
    final calibratingAsync = ref.watch(readinessIsCalibratingProvider());

    return BouncingCard(
      onTap: () {},
      child: Card(
        child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.bolt_rounded, color: AppTheme.textMint, size: 20),
                const SizedBox(width: 8),
                const Text('Readiness', style: TextStyle(color: AppTheme.textSecondary, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 24),
            scoreAsync.when(
              data: (score) {
                final isCalibrating = calibratingAsync.value ?? false;
                if (isCalibrating || score == null) {
                  return _buildScoreRing('--', 'Calibrating...');
                }
                return _buildScoreRing(score.toStringAsFixed(0), 'Good');
              },
              loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primaryBlue)),
              error: (_, __) => const Text('Error', style: TextStyle(color: AppTheme.textPink)),
            ),
          ],
        ),
      ),
    ));
  }

  Widget _buildScoreRing(String score, String label) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 120,
              height: 120,
              child: CircularProgressIndicator(
                value: score == '--' ? 0 : double.parse(score) / 100,
                strokeWidth: 12,
                backgroundColor: AppTheme.divider,
                color: AppTheme.primaryBlue,
                strokeCap: StrokeCap.round,
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  score,
                  style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold, color: AppTheme.textPrimary, height: 1),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.accentMint,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(label, style: const TextStyle(color: AppTheme.textMint, fontWeight: FontWeight.w600, fontSize: 12)),
        ),
      ],
    );
  }
}

class _ReadinessHeaderWidget extends ConsumerWidget {
  const _ReadinessHeaderWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreAsync = ref.watch(readinessScoreProvider());
    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.accentMint,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.bolt_rounded, color: AppTheme.textMint, size: 16),
              SizedBox(width: 6),
              Text('Readiness', style: TextStyle(color: AppTheme.textMint, fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          scoreAsync.when(
            data: (score) => Text(
              score?.toStringAsFixed(0) ?? '--',
              style: const TextStyle(color: AppTheme.textPrimary, fontSize: 28, fontWeight: FontWeight.bold),
            ),
            loading: () => const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
            error: (_, __) => const Text('!'),
          ),
        ],
      ),
    );
  }
}

class ReadinessDetailScreen extends ConsumerWidget {
  const ReadinessDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreAsync = ref.watch(readinessScoreProvider());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Readiness'),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1B2E24) : AppTheme.accentMint,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Column(
              children: [
                const Text(
                  'Here\'s your readiness',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 32),
                scoreAsync.when(
                  data: (score) {
                    final value = score ?? 0;
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 200,
                          height: 200,
                          child: CircularProgressIndicator(
                            value: score == null ? 0 : value / 100,
                            strokeWidth: 20,
                            backgroundColor: theme.dividerColor,
                            color: isDark ? AppTheme.accentMint : AppTheme.textMint,
                            strokeCap: StrokeCap.round,
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              score == null ? '--' : value.toStringAsFixed(0),
                              style: TextStyle(
                                fontSize: 64,
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.onSurface,
                                height: 1,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: isDark ? AppTheme.textMint : Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                'Good',
                                style: TextStyle(
                                  color: isDark ? Colors.white : AppTheme.textMint,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                  loading: () => const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (_, __) => const Text('Error loading readiness'),
                ),
                const SizedBox(height: 32),
                Text(
                  'You\'re well rested and ready to take on the day. Your HRV and sleep have recovered beautifully.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Contributing Factors',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildFactorCard(context, 'Sleep Recovery', 'Optimal', Icons.bedtime_rounded, isDark ? AppTheme.textPurple : AppTheme.accentPurple),
          const SizedBox(height: 12),
          _buildFactorCard(context, 'HRV Balance', 'In range', Icons.favorite_rounded, isDark ? AppTheme.textPink : AppTheme.accentPink),
        ],
      ),
    );
  }

  Widget _buildFactorCard(BuildContext context, String title, String status, IconData icon, Color color) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                const SizedBox(height: 4),
                Text(status, style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.6), fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ReadinessSettingsScreen extends StatelessWidget {
  const ReadinessSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Readiness Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            title: const Text('Include HRV Data'),
            subtitle: const Text('Use heart rate variability in calculation'),
            value: true,
            onChanged: (val) {},
          ),
          SwitchListTile(
            title: const Text('Include Sleep Data'),
            subtitle: const Text('Factor sleep score into readiness'),
            value: true,
            onChanged: (val) {},
          ),
          SwitchListTile(
            title: const Text('Morning Notifications'),
            subtitle: const Text('Remind me when my score is ready'),
            value: false,
            onChanged: (val) {},
          ),
        ],
      ),
    );
  }
}
