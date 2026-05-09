import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/database/app_database.dart';
import '../../core/database/tables.dart';
import '../../plugins/derived/derived_providers.dart';
import '../../plugins/plugin_runner.dart' show todayDateString;
import '../../plugins/raw/raw_providers.dart';
import '../theme/app_theme.dart';

// ---------------------------------------------------------------------------
// ReadinessCheckInSheet
// ---------------------------------------------------------------------------
// Morning self-assessment based on the Hooper Index / ARMS questionnaire.
// Collects Soreness (1–10), Energy (1–10) and Stress (1–10) ratings.
// On submit, persists to UserFeedback table and triggers plugin re-run.
// ---------------------------------------------------------------------------

class ReadinessCheckInSheet extends ConsumerStatefulWidget {
  const ReadinessCheckInSheet({super.key});

  /// Shows the bottom sheet if no feedback has been submitted today yet.
  static Future<void> showIfNeeded(BuildContext context, WidgetRef ref) async {
    // todayFeedbackProvider is a StreamProvider — read its current value.
    final feedbackState = ref.read(todayFeedbackProvider);
    if (!context.mounted) return;
    // If already submitted today or still loading, skip
    if (feedbackState.value != null) return;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const ReadinessCheckInSheet(),
    );
  }

  @override
  ConsumerState<ReadinessCheckInSheet> createState() =>
      _ReadinessCheckInSheetState();
}

class _ReadinessCheckInSheetState extends ConsumerState<ReadinessCheckInSheet>
    with SingleTickerProviderStateMixin {
  double _soreness = 3.0;
  double _energy = 7.0;
  double _stress = 3.0;
  bool _saving = false;

  late AnimationController _animController;
  late Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeIn = CurvedAnimation(parent: _animController, curve: Curves.easeOut);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _saving = true);
    final db = ref.read(appDatabaseProvider);
    final today = todayDateString();

    await db.upsertFeedback(
      UserFeedbackCompanion.insert(
        date: today,
        soreness: _soreness,
        energy: _energy,
        stress: _stress,
        recordedAt: DateTime.now().toUtc(),
      ),
    );

    // Invalidate providers so UI rebuilds with Bayesian-fused scores
    ref.invalidate(todayFeedbackProvider);
    ref.invalidate(readinessPhysicalScoreProvider());
    ref.invalidate(readinessMentalScoreProvider());
    ref.invalidate(readinessBimodalScoresProvider());
    ref.invalidate(readinessScoreProvider());

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return FadeTransition(
      opacity: _fadeIn,
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.2),
              blurRadius: 40,
              offset: const Offset(0, -8),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.dividerColor,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Header
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1B2E24)
                            : AppTheme.accentMint,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.wb_sunny_rounded,
                          color: AppTheme.textMint, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Morgen-Check',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                          Text(
                            'Wie fühlst du dich heute?',
                            style: TextStyle(
                              fontSize: 13,
                              color: theme.colorScheme.onSurface
                                  .withValues(alpha: 0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        foregroundColor:
                            theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                      child: const Text('Überspringen'),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Sliders
                _buildSlider(
                  context: context,
                  isDark: isDark,
                  label: 'Muskelkater & Erschöpfung',
                  icon: Icons.fitness_center_rounded,
                  iconColor: AppTheme.textPink,
                  accentColor: const Color(0xFFC5221F),
                  lowLabel: 'Kein Schmerz',
                  highLabel: 'Extrem',
                  value: _soreness,
                  onChanged: (v) => setState(() => _soreness = v),
                  invert: true, // Low is good
                ),
                const SizedBox(height: 20),
                _buildSlider(
                  context: context,
                  isDark: isDark,
                  label: 'Energie & Motivation',
                  icon: Icons.bolt_rounded,
                  iconColor: AppTheme.textMint,
                  accentColor: AppTheme.textMint,
                  lowLabel: 'Lethargisch',
                  highLabel: 'Voller Energie',
                  value: _energy,
                  onChanged: (v) => setState(() => _energy = v),
                  invert: false, // High is good
                ),
                const SizedBox(height: 20),
                _buildSlider(
                  context: context,
                  isDark: isDark,
                  label: 'Mentaler Stress',
                  icon: Icons.psychology_rounded,
                  iconColor: AppTheme.textPurple,
                  accentColor: AppTheme.textPurple,
                  lowLabel: 'Entspannt',
                  highLabel: 'Massiver Stress',
                  value: _stress,
                  onChanged: (v) => setState(() => _stress = v),
                  invert: true, // Low is good
                ),
                const SizedBox(height: 28),

                // Save button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: FilledButton(
                    onPressed: _saving ? null : _save,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppTheme.primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: _saving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : const Text(
                            'Readiness aktualisieren',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSlider({
    required BuildContext context,
    required bool isDark,
    required String label,
    required IconData icon,
    required Color iconColor,
    required Color accentColor,
    required String lowLabel,
    required String highLabel,
    required double value,
    required ValueChanged<double> onChanged,
    required bool invert, // true = low value means "good"
  }) {
    final theme = Theme.of(context);

    // Compute semantic color: green when value is in a "good" range
    Color valueColor;
    final goodValue = invert ? (value <= 4) : (value >= 7);
    final badValue = invert ? (value >= 7) : (value <= 4);
    if (goodValue) {
      valueColor = AppTheme.textMint;
    } else if (badValue) {
      valueColor = AppTheme.textPink;
    } else {
      valueColor = AppTheme.textOrange;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: iconColor, size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: valueColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                value.toStringAsFixed(0),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: valueColor,
                ),
              ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: accentColor,
            inactiveTrackColor: accentColor.withValues(alpha: 0.15),
            thumbColor: accentColor,
            overlayColor: accentColor.withValues(alpha: 0.1),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: Slider(
            value: value,
            min: 1,
            max: 10,
            divisions: 9,
            onChanged: onChanged,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              lowLabel,
              style: TextStyle(
                fontSize: 11,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
            Text(
              highLabel,
              style: TextStyle(
                fontSize: 11,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
