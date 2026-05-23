import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../core/database/app_database.dart';
import '../../core/database/derived_keys.dart';
import 'ai_coach_service.dart';

class AiPlugin {
  AiPlugin(this.db);

  final AppDatabase db;

  Future<void> run(String date) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final apiKey = prefs.getString('gemini_api_key');

      if (apiKey == null || apiKey.isEmpty) {
        await _saveInsight(
          date,
          'Setup Required',
          'Please configure your Gemini API key in the AI Coach settings to receive personalized daily insights.',
        );
        return;
      }

      // Build full context using the new service
      final context = await _buildContext(date);

      if (context == null ||
          (context.physicalScore == null &&
              context.sleepQualityScore == null &&
              context.strainScore == null)) {
        await _saveInsight(
          date,
          'Gathering Data',
          'Not enough data today to generate an insight. Wear your device to start seeing daily coaching.',
        );
        return;
      }

      // Use the new AiCoachService for the greeting
      final service = AiCoachService();
      final greeting = await service.generateGreeting(context);

      if (greeting != null) {
        final combined = '${greeting.observation}\n\n${greeting.question}';
        await _saveInsight(date, 'Daily Insight', combined);
      }
    } catch (e) {
      debugPrint('[AiPlugin] Error generating insight: $e');
      final cached = await _getInsightForDate(date);
      if (cached == null) {
        await _saveInsight(date, 'Insight Unavailable',
            'Could not generate your daily coaching insight at this time.');
      }
      rethrow;
    }
  }

  Future<AiCoachContext?> _buildContext(String date) async {
    try {
      final physScore = await _getDerivedValue(
          DerivedNamespace.readiness, ReadinessKey.physicalScore, date);
      final mentScore = await _getDerivedValue(
          DerivedNamespace.readiness, ReadinessKey.mentalScore, date);
      final sleepScore = await _getDerivedValue(
          DerivedNamespace.sleep, SleepKey.qualityScore, date);
      final strainScore = await _getDerivedValue(
          DerivedNamespace.strain, StrainKey.daily, date);
      final deepMins = await _getDerivedValue(
          DerivedNamespace.sleep, SleepKey.deepMinutes, date);
      final remMins = await _getDerivedValue(
          DerivedNamespace.sleep, SleepKey.remMinutes, date);
      final lightMins = await _getDerivedValue(
          DerivedNamespace.sleep, SleepKey.lightMinutes, date);
      final totalMins = await _getDerivedValue(
          DerivedNamespace.sleep, SleepKey.totalMinutes, date);
      final stepsY = await _getDerivedValue(
          DerivedNamespace.strain, StrainKey.stepsYesterday, date);
      final stepsA = await _getDerivedValue(
          DerivedNamespace.strain, StrainKey.steps7dAvg, date);
      final acwr = await _getDerivedValue(
          DerivedNamespace.readiness, ReadinessKey.acwr, date);
      final sri = await _getDerivedValue(
          DerivedNamespace.readiness, ReadinessKey.sri, date);
      final cal = await _getDerivedValue(
          DerivedNamespace.readiness, ReadinessKey.isCalibrating, date);

      return AiCoachContext(
        date: date,
        physicalScore: physScore,
        mentalScore: mentScore,
        deepSleepMins: deepMins,
        remSleepMins: remMins,
        lightSleepMins: lightMins,
        totalSleepMins: totalMins,
        sleepQualityScore: sleepScore,
        strainScore: strainScore,
        stepsYesterday: stepsY,
        steps7dAvg: stepsA,
        acwrValue: acwr,
        sriValue: sri,
        isCalibrating: cal == 1.0,
      );
    } catch (e) {
      debugPrint('[AiPlugin] context error: $e');
      return null;
    }
  }

  Future<Map<String, String>?> _getInsightForDate(String date) async {
    final entry = await db.latestDerived(
      namespace: DerivedNamespace.ai,
      key: 'todays_insight',
      date: date,
    );
    if (entry == null || entry.metadata == null) return null;
    try {
      final Map<String, dynamic> data = jsonDecode(entry.metadata!);
      return {
        'title': data[AiKey.insightTitle] as String? ?? 'Daily Insight',
        'text': data[AiKey.insightText] as String? ?? '',
      };
    } catch (_) {
      return null;
    }
  }

  Future<double?> _getDerivedValue(
      String namespace, String key, String date) async {
    final query = db.select(db.derivedEntries)
      ..where((t) => t.namespace.equals(namespace))
      ..where((t) => t.key.equals(key))
      ..where((t) => t.date.equals(date));
    final entry = await query.getSingleOrNull();
    return entry?.value;
  }

  Future<void> _saveInsight(String date, String title, String text) async {
    final metadataJson = jsonEncode({
      AiKey.insightTitle: title,
      AiKey.insightText: text,
    });

    await db.upsertDerived(
      DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.ai,
        key: 'todays_insight',
        value: 1.0,
        date: date,
        computedAt: DateTime.now(),
        metadata: Value(metadataJson),
      ),
    );
  }
}
