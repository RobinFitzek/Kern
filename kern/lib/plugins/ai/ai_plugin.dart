import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:convert';

import '../../core/database/app_database.dart';
import '../../core/database/derived_keys.dart';

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
          'Please configure your Gemini API key in the AI Coach settings to receive personalized daily insights.'
        );
        return;
      }

      // Gather context
      final readiness = await _getDerivedValue(DerivedNamespace.readiness, ReadinessKey.score, date);
      final sleep = await _getDerivedValue(DerivedNamespace.sleep, SleepKey.qualityScore, date);
      final strain = await _getDerivedValue(DerivedNamespace.strain, StrainKey.daily, date);

      // If we don't have enough data, skip or write a fallback
      if (readiness == null && sleep == null && strain == null) {
        await _saveInsight(
          date,
          'Gathering Data',
          'Not enough data today to generate an insight. Wear your device to start seeing daily coaching.'
        );
        return;
      }

      final prompt = '''
You are a proactive, knowledgeable, and concise health coach. 
Analyze the following health metrics for the user today and provide a single paragraph insight (max 3 sentences) and a short title (max 4 words).

Readiness Score: ${readiness != null ? readiness.toStringAsFixed(0) : 'Unknown'} (0-100, >70 is good)
Sleep Score: ${sleep != null ? sleep.toStringAsFixed(0) : 'Unknown'} (0-100, >70 is good)
Strain Score: ${strain != null ? strain.toStringAsFixed(0) : 'Unknown'} (0-100)

Return your response strictly in the following JSON format without Markdown formatting or code blocks:
{
  "title": "Your Short Title",
  "text": "Your 3-sentence insight."
}
''';

      final model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: apiKey);
      final response = await model.generateContent([Content.text(prompt)]);
      
      final text = response.text;
      if (text != null) {
        // Clean markdown JSON block if it exists
        String cleanJson = text;
        if (cleanJson.startsWith('```json')) {
          cleanJson = cleanJson.substring(7);
        }
        if (cleanJson.startsWith('```')) {
          cleanJson = cleanJson.substring(3);
        }
        if (cleanJson.endsWith('```')) {
          cleanJson = cleanJson.substring(0, cleanJson.length - 3);
        }

        final data = jsonDecode(cleanJson.trim());
        await _saveInsight(date, data['title'] ?? 'Daily Insight', data['text'] ?? 'Ready for the day!');
      }

    } catch (e) {
      debugPrint('[AiPlugin] Error generating insight: $e');
      // Only save fallback if no cached insight exists for today.
      final cached = await _getInsightForDate(date);
      if (cached == null) {
        await _saveInsight(date, 'Insight Unavailable',
            'Could not generate your daily coaching insight at this time.');
      }
      rethrow;
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

  Future<double?> _getDerivedValue(String namespace, String key, String date) async {
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
