import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/sync/sync_notifier.dart';
import '../../plugins/derived/derived_providers.dart';
import '../theme/app_theme.dart';

class RecommendationCard extends ConsumerWidget {
  const RecommendationCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final insightAsync = ref.watch(aiInsightProvider());
    final scoresAsync = ref.watch(readinessBimodalScoresProvider());
    final sleepAsync = ref.watch(sleepScoreProvider());
    final strainAsync = ref.watch(strainScoreProvider());
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final insight = insightAsync.valueOrNull;

    if (insight != null) {
      return _buildAiCard(context, insight, isDark);
    }

    final phys = scoresAsync.valueOrNull?.physical;
    final sleepScore = sleepAsync.valueOrNull;
    final strainScore = strainAsync.valueOrNull;

    if (phys == null && sleepScore == null && strainScore == null) {
      return const SizedBox.shrink();
    }

    return _buildRuleCard(context, phys, sleepScore, strainScore, isDark, ref);
  }

  Widget _buildAiCard(BuildContext context, Map<String, String> insight, bool isDark) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF673AB7).withValues(alpha: isDark ? 0.25 : 0.12),
              const Color(0xFF9C27B0).withValues(alpha: isDark ? 0.08 : 0.04),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFF673AB7).withValues(alpha: 0.25),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF673AB7).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.auto_awesome_rounded, color: Color(0xFF673AB7), size: 16),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Empfehlung',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF673AB7),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF673AB7).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'AI',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF673AB7)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              insight['title'] ?? '',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              insight['text'] ?? '',
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRuleCard(
    BuildContext context,
    double? phys,
    double? sleepScore,
    double? strainScore,
    bool isDark,
    WidgetRef ref,
  ) {
    final recommendation = _generateRecommendation(phys, sleepScore, strainScore);

    return GestureDetector(
      onTap: () => ref.read(syncNotifierProvider.notifier).resync(),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A2E1A) : AppTheme.accentMint,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppTheme.textMint.withValues(alpha: 0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppTheme.textMint.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.tips_and_updates_rounded, color: AppTheme.textMint, size: 16),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Empfehlung',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textMint,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppTheme.textMint.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    'Regel',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppTheme.textMint),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              recommendation.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black87,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              recommendation.text,
              style: TextStyle(
                fontSize: 13,
                height: 1.5,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _Recommendation _generateRecommendation(double? phys, double? sleepScore, double? strainScore) {
    if (phys != null) {
      if (phys < 40) {
        return const _Recommendation(
          title: 'Ruhetag empfohlen',
          text: 'Deine Readiness ist niedrig. Fokussiere heute auf Erholung, leichte Bewegung und ausreichend Schlaf.',
        );
      }
      if (phys < 60) {
        return const _Recommendation(
          title: 'Moderate Belastung',
          text: 'Deine Erholung ist okay, aber noch nicht optimal. Ein leichtes Training ist in Ordnung — vermeide hohe Intensität.',
        );
      }
      if (phys >= 70) {
        return const _Recommendation(
          title: 'Voll einsatzbereit',
          text: 'Dein Körper ist gut erholt. Heute ist ein guter Tag für intensives Training oder eine neue Bestleistung.',
        );
      }
    }

    if (sleepScore != null && sleepScore < 50) {
      return const _Recommendation(
        title: 'Schlaf priorisieren',
        text: 'Deine Schlafqualität war niedrig. Versuche heute früher ins Bett zu gehen und Bildschirmzeit vor dem Schlafen zu reduzieren.',
      );
    }

    if (strainScore != null && strainScore > 80) {
      return const _Recommendation(
        title: 'Aktive Erholung',
        text: 'Deine gestrige Belastung war hoch. Gönn deinem Körper aktive Erholung — ein Spaziergang oder leichtes Stretching.',
      );
    }

    return const _Recommendation(
      title: 'Tracke weiter',
      text: 'Trage dein Wearable, um genauere Empfehlungen zu erhalten. Jeder Tag mit Daten verbessert deine personalisierten Insights.',
    );
  }
}

class _Recommendation {
  final String title;
  final String text;
  const _Recommendation({required this.title, required this.text});
}
