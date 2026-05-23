import 'package:flutter_test/flutter_test.dart';

import 'package:kern/plugins/derived/insight_engine.dart';

void main() {
  const engine = InsightEngine();

  group('InsightEngine generates exactly 3 insights', () {
    test('all-null context returns 3 fallback insights', () {
      const ctx = InsightContext();
      final insights = engine.generateInsights(ctx);

      expect(insights.length, 3);
      expect(insights[0].category, InsightCategory.erholung);
      expect(insights[1].category, InsightCategory.schlaf);
      expect(insights[2].category, InsightCategory.belastung);

      expect(insights[0].text, 'Noch keine Erholungsdaten — Wearable tragen');
      expect(insights[0].sentiment, InsightSentiment.neutral);
      expect(insights[1].text, 'Noch keine Schlafdaten — heute Nacht tracken');
      expect(insights[2].text, 'Noch keine Aktivitätsdaten — Schritte tracken');
    });

    test('all-good scenario', () {
      final ctx = InsightContext(
        hrvScore: 80,
        todayHrvMs: 55,
        sleepQualityScore: 80,
        deepMins: 100,
        acwrValue: 0.6,
        stepsYesterday: 15000,
        steps7dAvg: 10000,
        strainScore: 20,
      );
      final insights = engine.generateInsights(ctx);

      expect(insights.length, 3);
      for (final i in insights) {
        expect(i.sentiment, InsightSentiment.good,
            reason: '${i.category} should be good');
      }
    });

    test('all-bad scenario', () {
      final ctx = InsightContext(
        hrvScore: 30,
        todayHrvMs: 25,
        sleepQualityScore: 30,
        deepMins: 30,
        acwrValue: 2.0,
        strainScore: 80,
      );
      final insights = engine.generateInsights(ctx);

      expect(insights.length, 3);
      expect(insights[0].sentiment, InsightSentiment.bad);
      expect(insights[1].sentiment, InsightSentiment.bad);
      expect(insights[2].sentiment, InsightSentiment.bad);
    });

    test('mixed scenario', () {
      final ctx = InsightContext(
        hrvScore: 80,
        todayHrvMs: 55,
        sleepQualityScore: 50,
        deepMins: null,
        totalSleepMins: 400,
        acwrValue: 1.0,
        strainScore: null,
        stepsYesterday: 5000,
      );
      final insights = engine.generateInsights(ctx);

      expect(insights[0].sentiment, InsightSentiment.good);
      expect(insights[1].sentiment, InsightSentiment.neutral);
      expect(insights[2].sentiment, InsightSentiment.neutral);
    });
  });

  // ── Erholung ───────────────────────────────────────────────────────────────

  group('Erholung — HRV', () {
    test('hrvScore >= 75 → good', () {
      final ctx = InsightContext(hrvScore: 75, todayHrvMs: 48);
      final insight = engine.generateInsights(ctx)[0];
      expect(insight.sentiment, InsightSentiment.good);
      expect(insight.text, contains('gute Erholung'));
    });

    test('hrvScore <= 35 → bad', () {
      final ctx = InsightContext(hrvScore: 35, todayHrvMs: 20);
      final insight = engine.generateInsights(ctx)[0];
      expect(insight.sentiment, InsightSentiment.bad);
      expect(insight.text, contains('Erholung nötig'));
    });

    test('hrvScore 50 → neutral', () {
      final ctx = InsightContext(hrvScore: 50, todayHrvMs: 40);
      final insight = engine.generateInsights(ctx)[0];
      expect(insight.sentiment, InsightSentiment.neutral);
      expect(insight.text, contains('Normalbereich'));
    });

    test('hrvScore 76 (just above boundary) → good', () {
      final ctx = InsightContext(hrvScore: 76, todayHrvMs: 50);
      final insight = engine.generateInsights(ctx)[0];
      expect(insight.sentiment, InsightSentiment.good);
    });

    test('hrvScore 34 (just below boundary) → bad', () {
      final ctx = InsightContext(hrvScore: 34, todayHrvMs: 22);
      final insight = engine.generateInsights(ctx)[0];
      expect(insight.sentiment, InsightSentiment.bad);
    });
  });

  group('Erholung — RHR', () {
    test('rhrScore >= 75 → good (when HRV absent)', () {
      final ctx = InsightContext(rhrScore: 80, todayRhrBpm: 48);
      final insight = engine.generateInsights(ctx)[0];
      expect(insight.sentiment, InsightSentiment.good);
      expect(insight.text, contains('entspannt'));
    });

    test('rhrScore <= 35 → bad (when HRV absent)', () {
      final ctx = InsightContext(rhrScore: 30, todayRhrBpm: 75);
      final insight = engine.generateInsights(ctx)[0];
      expect(insight.sentiment, InsightSentiment.bad);
      expect(insight.text, contains('erhöht'));
    });

    test('rhrScore present → neutral', () {
      final ctx = InsightContext(rhrScore: 50, todayRhrBpm: 60);
      final insight = engine.generateInsights(ctx)[0];
      expect(insight.sentiment, InsightSentiment.neutral);
      expect(insight.text, contains('normal'));
    });

    test('HRV takes priority over RHR', () {
      final ctx = InsightContext(
        hrvScore: 50,
        todayHrvMs: 40,
        rhrScore: 80,
        todayRhrBpm: 48,
      );
      final insight = engine.generateInsights(ctx)[0];
      expect(insight.text, contains('HRV'));
      expect(insight.sentiment, InsightSentiment.neutral);
    });
  });

  group('Erholung — Physical Score', () {
    test('physicalScore >= 80 → good (when HRV and RHR absent)', () {
      final ctx = InsightContext(physicalScore: 85);
      final insight = engine.generateInsights(ctx)[0];
      expect(insight.sentiment, InsightSentiment.good);
      expect(insight.text, contains('optimal'));
    });

    test('physicalScore <= 40 → bad', () {
      final ctx = InsightContext(physicalScore: 35);
      final insight = engine.generateInsights(ctx)[0];
      expect(insight.sentiment, InsightSentiment.bad);
      expect(insight.text, contains('niedrig'));
    });

    test('physicalScore present → neutral', () {
      final ctx = InsightContext(physicalScore: 60);
      final insight = engine.generateInsights(ctx)[0];
      expect(insight.sentiment, InsightSentiment.neutral);
      expect(insight.text, contains('mittel'));
    });

    test('physicalScore exactly 80 → good', () {
      final ctx = InsightContext(physicalScore: 80);
      final insight = engine.generateInsights(ctx)[0];
      expect(insight.sentiment, InsightSentiment.good);
    });

    test('physicalScore exactly 40 → bad', () {
      final ctx = InsightContext(physicalScore: 40);
      final insight = engine.generateInsights(ctx)[0];
      expect(insight.sentiment, InsightSentiment.bad);
    });
  });

  // ── Schlaf ──────────────────────────────────────────────────────────────────

  group('Schlaf — Deep Sleep', () {
    test('deepMins >= 90 → good', () {
      final ctx = InsightContext(deepMins: 95);
      final insight = engine.generateInsights(ctx)[1];
      expect(insight.sentiment, InsightSentiment.good);
      expect(insight.text, contains('über dem Ziel'));
    });

    test('deepMins < 60 → bad', () {
      final ctx = InsightContext(deepMins: 45);
      final insight = engine.generateInsights(ctx)[1];
      expect(insight.sentiment, InsightSentiment.bad);
      expect(insight.text, contains('unter dem Ziel'));
    });

    test('deepMins between 60 and 89 → neutral', () {
      final ctx = InsightContext(deepMins: 70);
      final insight = engine.generateInsights(ctx)[1];
      expect(insight.sentiment, InsightSentiment.neutral);
      expect(insight.text, contains('Zielbereich'));
    });

    test('deepMins exactly 90 → good', () {
      final ctx = InsightContext(deepMins: 90);
      final insight = engine.generateInsights(ctx)[1];
      expect(insight.sentiment, InsightSentiment.good);
    });

    test('deepMins exactly 60 → neutral', () {
      final ctx = InsightContext(deepMins: 60);
      final insight = engine.generateInsights(ctx)[1];
      expect(insight.sentiment, InsightSentiment.neutral);
    });

    test('deepMins exactly 59 → bad', () {
      final ctx = InsightContext(deepMins: 59);
      final insight = engine.generateInsights(ctx)[1];
      expect(insight.sentiment, InsightSentiment.bad);
    });

    test('deepMins is 0 → skips to next', () {
      final ctx = InsightContext(deepMins: 0, totalSleepMins: 300);
      final insight = engine.generateInsights(ctx)[1];
      expect(insight.text, contains('Gesamtschlaf'));
    });
  });

  group('Schlaf — Efficiency', () {
    test('sleepEfficiencyPct >= 90 → good', () {
      final ctx = InsightContext(sleepEfficiencyPct: 92);
      final insight = engine.generateInsights(ctx)[1];
      expect(insight.sentiment, InsightSentiment.good);
      expect(insight.text, contains('sehr gut'));
    });

    test('sleepEfficiencyPct < 80 → bad', () {
      final ctx = InsightContext(sleepEfficiencyPct: 75);
      final insight = engine.generateInsights(ctx)[1];
      expect(insight.sentiment, InsightSentiment.bad);
      expect(insight.text, contains('verbesserungswürdig'));
    });

    test('sleepEfficiencyPct 80-89 → neutral', () {
      final ctx = InsightContext(sleepEfficiencyPct: 85);
      final insight = engine.generateInsights(ctx)[1];
      expect(insight.sentiment, InsightSentiment.neutral);
      expect(insight.text, contains('normal'));
    });

    test('efficiency is 0 → skips to next', () {
      final ctx = InsightContext(sleepEfficiencyPct: 0, totalSleepMins: 300);
      final insight = engine.generateInsights(ctx)[1];
      expect(insight.text, contains('Gesamtschlaf'));
    });

    test('deep sleep has priority over efficiency', () {
      final ctx = InsightContext(deepMins: 95, sleepEfficiencyPct: 75);
      final insight = engine.generateInsights(ctx)[1];
      expect(insight.text, contains('Tiefschlaf'));
    });
  });

  group('Schlaf — SRI', () {
    test('sriValue >= 60 → good', () {
      final ctx = InsightContext(sriValue: 65);
      final insight = engine.generateInsights(ctx)[1];
      expect(insight.sentiment, InsightSentiment.good);
      expect(insight.text, contains('+'));
      expect(insight.text, contains('regelmäßig'));
    });

    test('sriValue <= -20 → bad', () {
      final ctx = InsightContext(sriValue: -30);
      final insight = engine.generateInsights(ctx)[1];
      expect(insight.sentiment, InsightSentiment.bad);
      expect(insight.text, contains('unregelmäßig'));
    });

    test('sriValue between -19 and 59 → neutral', () {
      final ctx = InsightContext(sriValue: 10);
      final insight = engine.generateInsights(ctx)[1];
      expect(insight.sentiment, InsightSentiment.neutral);
      expect(insight.text, contains('akzeptabel'));
    });

    test('sriValue exactly 60 → good', () {
      final ctx = InsightContext(sriValue: 60);
      final insight = engine.generateInsights(ctx)[1];
      expect(insight.sentiment, InsightSentiment.good);
    });

    test('sriValue exactly -20 → bad', () {
      final ctx = InsightContext(sriValue: -20);
      final insight = engine.generateInsights(ctx)[1];
      expect(insight.sentiment, InsightSentiment.bad);
    });
  });

  group('Schlaf — Quality Score', () {
    test('sleepQualityScore >= 75 → good', () {
      final ctx = InsightContext(sleepQualityScore: 80);
      final insight = engine.generateInsights(ctx)[1];
      expect(insight.sentiment, InsightSentiment.good);
      expect(insight.text, contains('erholsam'));
    });

    test('sleepQualityScore <= 35 → bad', () {
      final ctx = InsightContext(sleepQualityScore: 25);
      final insight = engine.generateInsights(ctx)[1];
      expect(insight.sentiment, InsightSentiment.bad);
      expect(insight.text, contains('unruhig'));
    });

    test('sleepQualityScore 36-74 → neutral', () {
      final ctx = InsightContext(sleepQualityScore: 50);
      final insight = engine.generateInsights(ctx)[1];
      expect(insight.sentiment, InsightSentiment.neutral);
      expect(insight.text, contains('mittelmäßig'));
    });
  });

  group('Schlaf — Total Sleep', () {
    test('totalSleepMins >= 420 → good', () {
      final ctx = InsightContext(totalSleepMins: 450);
      final insight = engine.generateInsights(ctx)[1];
      expect(insight.sentiment, InsightSentiment.good);
      expect(insight.text, contains('Ziel erreicht'));
    });

    test('totalSleepMins > 0 and < 420 → neutral', () {
      final ctx = InsightContext(totalSleepMins: 360);
      final insight = engine.generateInsights(ctx)[1];
      expect(insight.sentiment, InsightSentiment.neutral);
      expect(insight.text, contains('unter 7 Stunden'));
    });

    test('totalSleepMins formats hours and minutes', () {
      final ctx = InsightContext(totalSleepMins: 455);
      final insight = engine.generateInsights(ctx)[1];
      expect(insight.text, contains('7h 35min'));
    });
  });

  // ── Belastung ───────────────────────────────────────────────────────────────

  group('Belastung — ACWR', () {
    test('acwrValue > 1.5 → bad', () {
      final ctx = InsightContext(acwrValue: 1.8);
      final insight = engine.generateInsights(ctx)[2];
      expect(insight.sentiment, InsightSentiment.bad);
      expect(insight.text, contains('erhöhte Belastung'));
    });

    test('acwrValue < 0.7 → good', () {
      final ctx = InsightContext(acwrValue: 0.5);
      final insight = engine.generateInsights(ctx)[2];
      expect(insight.sentiment, InsightSentiment.good);
      expect(insight.text, contains('Entlastung'));
    });

    test('acwrValue 0.7–1.5 → neutral', () {
      final ctx = InsightContext(acwrValue: 1.0);
      final insight = engine.generateInsights(ctx)[2];
      expect(insight.sentiment, InsightSentiment.neutral);
      expect(insight.text, contains('Sweet Spot'));
    });

    test('acwrValue exactly 1.5 → neutral', () {
      final ctx = InsightContext(acwrValue: 1.5);
      final insight = engine.generateInsights(ctx)[2];
      expect(insight.sentiment, InsightSentiment.neutral);
    });

    test('acwrValue exactly 0.7 → neutral', () {
      final ctx = InsightContext(acwrValue: 0.7);
      final insight = engine.generateInsights(ctx)[2];
      expect(insight.sentiment, InsightSentiment.neutral);
    });
  });

  group('Belastung — Steps', () {
    test('stepsYesterday > avg * 1.3 → good', () {
      final ctx = InsightContext(stepsYesterday: 15000, steps7dAvg: 10000);
      final insight = engine.generateInsights(ctx)[2];
      expect(insight.sentiment, InsightSentiment.good);
      expect(insight.text, contains('überdurchschnittlich aktiv'));
    });

    test('stepsYesterday < avg * 0.7 → neutral (ruhiger Tag)', () {
      final ctx = InsightContext(stepsYesterday: 5000, steps7dAvg: 10000);
      final insight = engine.generateInsights(ctx)[2];
      expect(insight.sentiment, InsightSentiment.neutral);
      expect(insight.text, contains('ruhiger Tag'));
    });

    test('stepsYesterday in normal range → neutral (leichte Belastung)', () {
      final ctx = InsightContext(stepsYesterday: 9000, steps7dAvg: 10000);
      final insight = engine.generateInsights(ctx)[2];
      expect(insight.sentiment, InsightSentiment.neutral);
      expect(insight.text, contains('leichte Belastung'));
    });

    test('stepsYesterday present but avg is 0 → neutral (leichte Belastung)', () {
      final ctx = InsightContext(stepsYesterday: 5000, steps7dAvg: 0);
      final insight = engine.generateInsights(ctx)[2];
      expect(insight.sentiment, InsightSentiment.neutral);
      expect(insight.text, contains('leichte Belastung'));
    });

    test('stepsYesterday present but avg is null → neutral', () {
      final ctx = InsightContext(stepsYesterday: 5000);
      final insight = engine.generateInsights(ctx)[2];
      expect(insight.sentiment, InsightSentiment.neutral);
      expect(insight.text, contains('leichte Belastung'));
    });

    test('ACWR takes priority over steps', () {
      final ctx = InsightContext(
        acwrValue: 1.0,
        stepsYesterday: 15000,
        steps7dAvg: 10000,
      );
      final insight = engine.generateInsights(ctx)[2];
      expect(insight.text, contains('Belastungsverhältnis'));
      expect(insight.sentiment, InsightSentiment.neutral);
    });
  });

  group('Belastung — Strain Score', () {
    test('strainScore >= 70 → bad', () {
      final ctx = InsightContext(strainScore: 75);
      final insight = engine.generateInsights(ctx)[2];
      expect(insight.sentiment, InsightSentiment.bad);
      expect(insight.text, contains('hoch'));
    });

    test('strainScore <= 30 → good', () {
      final ctx = InsightContext(strainScore: 25);
      final insight = engine.generateInsights(ctx)[2];
      expect(insight.sentiment, InsightSentiment.good);
      expect(insight.text, contains('gering'));
    });

    test('strainScore 31-69 → neutral', () {
      final ctx = InsightContext(strainScore: 50);
      final insight = engine.generateInsights(ctx)[2];
      expect(insight.sentiment, InsightSentiment.neutral);
      expect(insight.text, contains('moderat'));
    });

    test('strainScore exactly 70 → bad', () {
      final ctx = InsightContext(strainScore: 70);
      final insight = engine.generateInsights(ctx)[2];
      expect(insight.sentiment, InsightSentiment.bad);
    });

    test('strainScore exactly 30 → good', () {
      final ctx = InsightContext(strainScore: 30);
      final insight = engine.generateInsights(ctx)[2];
      expect(insight.sentiment, InsightSentiment.good);
    });
  });

  // ── Sentiment helpers ───────────────────────────────────────────────────────

  group('InsightSentiment enum', () {
    test('has exactly 3 values', () {
      expect(InsightSentiment.values.length, 3);
    });
  });

  group('InsightCategory enum', () {
    test('has exactly 3 values', () {
      expect(InsightCategory.values.length, 3);
    });
  });

  group('DailyInsight construction', () {
    test('all fields are accessible', () {
      const insight = DailyInsight(
        category: InsightCategory.erholung,
        text: 'Test text',
        sentiment: InsightSentiment.good,
      );
      expect(insight.category, InsightCategory.erholung);
      expect(insight.text, 'Test text');
      expect(insight.sentiment, InsightSentiment.good);
    });
  });
}
