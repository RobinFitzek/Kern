import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/plugins/plugin_interfaces.dart';
import '../derived/derived_providers.dart';
import '../../ui/theme/app_theme.dart';
import '../../ui/widgets/bouncing_card.dart';

class SleepFeature implements KernPlugin {
  @override
  String get id => 'sleep';

  @override
  String get name => 'Sleep';

  @override
  String get description => 'Sleep quality and duration metrics.';

  @override
  List<PluginSlot> get supportedSlots => [PluginSlot.header];

  @override
  Widget buildDashboardWidget(BuildContext context, PluginSlot slot) {
    if (slot == PluginSlot.header) {
      return const _SleepHeaderWidget();
    }
    return const _SleepFooterWidget();
  }

  @override
  Widget? buildDetailPage(BuildContext context) => const SleepDetailScreen();

  @override
  bool get hasDetailPage => true;

  @override
  Widget? buildSettingsPage(BuildContext context) => const SleepSettingsScreen();
}

class _SleepFooterWidget extends ConsumerWidget {
  const _SleepFooterWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreAsync = ref.watch(sleepScoreProvider());
    final minsAsync = ref.watch(sleepMinutesProvider());

    final score = scoreAsync.valueOrNull;
    final mins = minsAsync.valueOrNull;

    return BouncingCard(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const SleepDetailScreen()),
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
                  decoration: const BoxDecoration(
                    color: AppTheme.accentPurple,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.bedtime_rounded, color: AppTheme.textPurple, size: 16),
                ),
                const SizedBox(width: 8),
                const Text('Sleep', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppTheme.textSecondary)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Sleep score', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Text(
                      score?.toStringAsFixed(0) ?? '--',
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.textPrimary),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: (score != null && score >= 70) ? AppTheme.accentMint : (score != null && score >= 50) ? AppTheme.accentOrange : AppTheme.accentPink,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        (score != null && score >= 70) ? 'Gut' : (score != null && score >= 50) ? 'Mittel' : (score != null ? 'Niedrig' : '--'),
                        style: TextStyle(
                          color: (score != null && score >= 70) ? AppTheme.textMint : (score != null && score >= 50) ? AppTheme.textOrange : AppTheme.textPink,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                Container(width: 1, height: 60, color: AppTheme.divider),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Sleep duration', style: TextStyle(fontSize: 13, color: AppTheme.textSecondary, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    minsAsync.when(
                      data: (m) {
                        final hrs = (m.total / 60).floor();
                        final mins = (m.total % 60).floor();
                        return Text('${hrs}h ${mins}m', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppTheme.textPrimary));
                      },
                      loading: () => const CircularProgressIndicator(),
                      error: (_, __) => const SizedBox(),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: (mins != null && mins.total >= 420) ? AppTheme.accentMint : AppTheme.accentOrange,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        (mins != null && mins.total >= 420) ? 'Ziel erreicht' : 'Ziel verfehlt',
                        style: TextStyle(
                          color: (mins != null && mins.total >= 420) ? AppTheme.textMint : AppTheme.textOrange,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
class _SleepHeaderWidget extends ConsumerWidget {
  const _SleepHeaderWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final minsAsync = ref.watch(sleepMinutesProvider());

    return Container(
      width: 140,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.accentPurple,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.bedtime_rounded, color: AppTheme.textPurple, size: 16),
              SizedBox(width: 6),
              Text('Sleep', style: TextStyle(color: AppTheme.textPurple, fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 12),
          minsAsync.when(
            data: (m) {
              final hrs = (m.total / 60).floor();
              final mins = (m.total % 60).floor();
              return Text(
                '${hrs}h ${mins}m',
                style: const TextStyle(color: AppTheme.textPrimary, fontSize: 24, fontWeight: FontWeight.bold),
              );
            },
            loading: () => const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
            error: (_, __) => const Text('!'),
          ),
        ],
      ),
    );
  }
}

class SleepDetailScreen extends ConsumerWidget {
  const SleepDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scoreAsync = ref.watch(sleepScoreProvider());
    final minsAsync = ref.watch(sleepMinutesProvider());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sleep'),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          minsAsync.when(
            data: (m) {
              final hrs = (m.total / 60).floor();
              final mins = (m.total % 60).floor();
              final goalMet = m.total >= 420;
              return Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF2E243A) : AppTheme.accentPurple,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      goalMet ? 'Gute Nacht' : 'Schlaf optimieren',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      goalMet
                          ? 'Du hast genug Schlaf für eine solide Erholung bekommen.'
                          : 'Deine Schlafdauer lag unter dem Ziel von 7 Stunden.',
                      style: TextStyle(
                        fontSize: 15,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Sleep score', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 4),
                            scoreAsync.when(
                              data: (score) => Text(
                                score?.toStringAsFixed(0) ?? '--',
                                style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                              ),
                              loading: () => const CircularProgressIndicator(),
                              error: (_, __) => const Text('--'),
                            ),
                            scoreAsync.when(
                              data: (score) {
                                final label = score != null
                                    ? (score >= 70 ? 'Gut' : score >= 50 ? 'Mittel' : 'Niedrig')
                                    : '--';
                                final labelColor = score != null
                                    ? (score >= 70 ? AppTheme.textMint : score >= 50 ? AppTheme.textOrange : AppTheme.textPink)
                                    : theme.colorScheme.onSurface;
                                return Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: isDark ? const Color(0xFF1B2E24) : AppTheme.accentMint,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(label, style: TextStyle(color: labelColor, fontSize: 12, fontWeight: FontWeight.w600)),
                                );
                              },
                              loading: () => const SizedBox(),
                              error: (_, __) => const SizedBox(),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Sleep duration', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                            const SizedBox(height: 4),
                            Text(
                              '${hrs}h ${mins}m',
                              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: goalMet ? (isDark ? const Color(0xFF1B2E24) : AppTheme.accentMint) : (isDark ? const Color(0xFF3C0D0D) : AppTheme.accentPink),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                goalMet ? 'Ziel erreicht' : 'Ziel: 7h',
                                style: TextStyle(
                                  color: goalMet ? AppTheme.textMint : AppTheme.textPink,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const Center(child: Text('Fehler beim Laden')),
          ),
          const SizedBox(height: 24),
          const Text(
            'Sleep Stages',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          minsAsync.when(
            data: (m) {
              final deep = m.deep;
              final rem = m.rem;
              final light = m.light;
              final awakeMins = (m.total - (deep + rem + light)).clamp(0.0, double.infinity);

              if (deep == 0 && rem == 0 && light == 0) {
                return const Center(
                  child: Text('Keine Schlafphasen-Daten verfügbar', style: TextStyle(color: AppTheme.textTertiary)),
                );
              }

              return Column(
                children: [
                  if (awakeMins > 0)
                    _buildStageCard(context, 'Wach', _formatMinutes(awakeMins), Colors.pinkAccent),
                  if (rem > 0) ...[
                    const SizedBox(height: 12),
                    _buildStageCard(context, 'REM', _formatMinutes(rem), Colors.purpleAccent),
                  ],
                  if (light > 0) ...[
                    const SizedBox(height: 12),
                    _buildStageCard(context, 'Leicht', _formatMinutes(light), Colors.lightBlueAccent),
                  ],
                  if (deep > 0) ...[
                    const SizedBox(height: 12),
                    _buildStageCard(context, 'Tief', _formatMinutes(deep), Colors.blueAccent),
                  ],
                ],
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => const SizedBox(),
          ),
        ],
      ),
    );
  }

  String _formatMinutes(double totalMinutes) {
    final hrs = (totalMinutes / 60).floor();
    final mins = (totalMinutes % 60).floor();
    if (hrs > 0) return '${hrs}h ${mins}m';
    return '${mins}m';
  }

  Widget _buildStageCard(BuildContext context, String title, String duration, Color color) {
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
            width: 16,
            height: 16,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
          ),
          Text(duration, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ],
      ),
    );
  }
}

class SleepSettingsScreen extends StatelessWidget {
  const SleepSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sleep Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            title: const Text('Ziel'),
            subtitle: const Text('7 Stunden'),
            trailing: const Icon(Icons.chevron_right),
            enabled: false,
          ),
          SwitchListTile(
            title: const Text('Schlafenszeit-Erinnerung'),
            subtitle: const Text('Demnächst verfügbar'),
            value: false,
            onChanged: null,
          ),
          SwitchListTile(
            title: const Text('Smart Alarm'),
            subtitle: const Text('Demnächst verfügbar'),
            value: false,
            onChanged: null,
          ),
        ],
      ),
    );
  }
}
