import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AiCoachContext {
  const AiCoachContext({
    required this.date,
    this.physicalScore,
    this.mentalScore,
    this.hrvMs,
    this.hrvScore,
    this.restingHrBpm,
    this.rhrScore,
    this.deepSleepMins,
    this.remSleepMins,
    this.lightSleepMins,
    this.totalSleepMins,
    this.sleepQualityScore,
    this.sleepEfficiencyPct,
    this.sriValue,
    this.hrvCvScore,
    this.strainScore,
    this.stepsYesterday,
    this.steps7dAvg,
    this.acwrValue,
    this.acwrPenalty,
    this.isCalibrating = false,
    this.recentReadinessTrend = const [],
  });

  final String date;
  final double? physicalScore;
  final double? mentalScore;
  final double? hrvMs;
  final double? hrvScore;
  final double? restingHrBpm;
  final double? rhrScore;
  final double? deepSleepMins;
  final double? remSleepMins;
  final double? lightSleepMins;
  final double? totalSleepMins;
  final double? sleepQualityScore;
  final double? sleepEfficiencyPct;
  final double? sriValue;
  final double? hrvCvScore;
  final double? strainScore;
  final double? stepsYesterday;
  final double? steps7dAvg;
  final double? acwrValue;
  final double? acwrPenalty;
  final bool isCalibrating;
  final List<double> recentReadinessTrend;

  String buildPrompt() {
    final buf = StringBuffer();
    buf.writeln('=== HEALTH DATA FOR $date ===');
    buf.writeln();

    buf.writeln('READINESS:');
    if (physicalScore != null) {
      buf.writeln('  Physical Readiness: ${physicalScore!.toInt()}/100 (>70 good, <40 rest day)');
    }
    if (mentalScore != null) {
      buf.writeln('  Mental Readiness: ${mentalScore!.toInt()}/100');
    }
    buf.writeln();

    buf.writeln('HEART METRICS:');
    if (hrvMs != null) buf.writeln('  HRV (RMSSD): ${hrvMs!.toInt()} ms');
    if (hrvScore != null) buf.writeln('  HRV Score: ${hrvScore!.toInt()}/100');
    if (restingHrBpm != null) buf.writeln('  Resting HR: ${restingHrBpm!.toInt()} bpm');
    if (rhrScore != null) buf.writeln('  RHR Score: ${rhrScore!.toInt()}/100');
    if (hrvCvScore != null) buf.writeln('  HRV Stability: ${hrvCvScore!.toInt()}/100');
    buf.writeln();

    buf.writeln('SLEEP:');
    if (sleepQualityScore != null) buf.writeln('  Quality: ${sleepQualityScore!.toInt()}/100');
    if (totalSleepMins != null) {
      final h = (totalSleepMins! / 60).floor();
      final m = (totalSleepMins! % 60).floor();
      buf.writeln('  Duration: ${h}h ${m}m');
    }
    if (deepSleepMins != null) buf.writeln('  Deep Sleep: ${deepSleepMins!.toInt()} min');
    if (remSleepMins != null) buf.writeln('  REM Sleep: ${remSleepMins!.toInt()} min');
    if (lightSleepMins != null) buf.writeln('  Light Sleep: ${lightSleepMins!.toInt()} min');
    if (sleepEfficiencyPct != null) buf.writeln('  Efficiency: ${sleepEfficiencyPct!.toInt()}%');
    if (sriValue != null) buf.writeln('  Sleep Regularity (SRI): ${sriValue!.toInt()} (-100 to +100)');
    buf.writeln();

    buf.writeln('ACTIVITY:');
    if (strainScore != null) buf.writeln('  Strain: ${strainScore!.toInt()}/100');
    if (stepsYesterday != null) buf.writeln('  Steps Yesterday: ${stepsYesterday!.toInt()}');
    if (steps7dAvg != null) buf.writeln('  Steps 7-day Avg: ${steps7dAvg!.toInt()}');
    if (acwrValue != null) buf.writeln('  ACWR: ${acwrValue!.toStringAsFixed(2)} (0.8-1.3 optimal, >1.5 overreaching)');
    if (acwrPenalty != null && acwrPenalty! > 0) buf.writeln('  ACWR Penalty: -${acwrPenalty!.toInt()} points');
    buf.writeln();

    if (recentReadinessTrend.isNotEmpty) {
      buf.writeln('READINESS TREND (last ${recentReadinessTrend.length} days):');
      final trend = recentReadinessTrend.map((s) => s.toInt().toString()).join(', ');
      buf.writeln('  Scores: $trend');
      if (recentReadinessTrend.length >= 2) {
        final first = recentReadinessTrend.first.toInt();
        final last = recentReadinessTrend.last.toInt();
        final dir = last > first ? 'rising' : last < first ? 'falling' : 'stable';
        buf.writeln('  Direction: $dir');
      }
    }

    if (isCalibrating) {
      buf.writeln('STATUS: Still calibrating — baseline being built.');
    }

    return buf.toString();
  }
}

class AiCoachResponse {
  const AiCoachResponse({
    required this.observation,
    required this.question,
    required this.options,
  });

  final String observation;
  final String question;
  final List<String> options;
}

class AiCoachService {
  static const _systemPrompt = '''
You are Kern, a proactive and motivating health coach. Your personality: warm, brief, encouraging, and scientifically grounded. You speak German.

CRITICAL RULES:
1. You LEAD the conversation. Never wait for the user to ask — you observe data and ask THEM questions.
2. Keep observations to 1-2 sentences. Keep questions to 1 sentence.
3. Offer exactly 2-3 brief answer options (3-5 words each, in German).
4. Be specific — reference actual numbers from the data when relevant.
5. If data is sparse or calibrating, acknowledge it and focus on what IS known.
6. Never suggest medical advice. Frame everything as training/recovery guidance.

RESPONSE FORMAT (strict JSON, no markdown):
{
  "observation": "1-2 sentence data observation in German",
  "question": "1 sentence question in German",
  "options": ["Short option 1", "Short option 2"]
}
''';

  static const _advicePrompt = '''
You are Kern, a proactive and motivating health coach. Your personality: warm, brief, encouraging, and scientifically grounded. You speak German.

The user has seen your observation and answered your question. Now give them a personalized, actionable recommendation.

DATA YOU ALREADY HAVE:
{d}

USER'S ANSWER: "{a}"

CRITICAL RULES:
1. Provide exactly 3-4 sentences of advice in German.
2. Reference specific metrics from the data.
3. Be encouraging but honest. If data suggests rest, say so.
4. Include one concrete, actionable suggestion.
5. Never suggest medical advice.

RESPONSE FORMAT (strict JSON, no markdown):
{
  "advice": "Your 3-4 sentence recommendation in German"
}
''';

  Future<AiCoachResponse?> generateGreeting(AiCoachContext context) async {
    final apiKey = await _getApiKey();
    if (apiKey == null) return null;

    final dataBlock = context.buildPrompt();
    final model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
      systemInstruction: Content.system(_systemPrompt),
    );

    final prompt = 'Generate your coaching greeting based on this data:\n\n$dataBlock';
    final response = await model.generateContent([Content.text(prompt)]);
    final text = response.text;
    if (text == null) return null;

    try {
      final json = _cleanAndParse(text);
      return AiCoachResponse(
        observation: json['observation'] as String? ?? '',
        question: json['question'] as String? ?? '',
        options: (json['options'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
      );
    } catch (e) {
      debugPrint('[AiCoachService] parse error: $e, raw: $text');
      return null;
    }
  }

  Future<String?> generateAdvice({
    required AiCoachContext context,
    required String userAnswer,
  }) async {
    final apiKey = await _getApiKey();
    if (apiKey == null) return null;

    final dataBlock = context.buildPrompt();
    final prompt = _advicePrompt
        .replaceFirst('{d}', dataBlock)
        .replaceFirst('{a}', userAnswer);

    final model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
    );
    final response = await model.generateContent([Content.text(prompt)]);
    final text = response.text;
    if (text == null) return null;

    try {
      final json = _cleanAndParse(text);
      return json['advice'] as String?;
    } catch (e) {
      debugPrint('[AiCoachService] advice parse error: $e');
      return null;
    }
  }

  Future<String?> _getApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    final key = prefs.getString('gemini_api_key');
    if (key == null || key.isEmpty) return null;
    return key;
  }

  Map<String, dynamic> _cleanAndParse(String raw) {
    String clean = raw.trim();
    if (clean.startsWith('```json')) {
      clean = clean.substring(7);
    } else if (clean.startsWith('```')) {
      clean = clean.substring(3);
    }
    if (clean.endsWith('```')) {
      clean = clean.substring(0, clean.length - 3);
    }
    return jsonDecode(clean.trim()) as Map<String, dynamic>;
  }
}
