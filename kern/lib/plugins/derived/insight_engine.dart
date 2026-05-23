import 'package:intl/intl.dart';

enum InsightCategory { erholung, schlaf, belastung }

enum InsightSentiment { good, neutral, bad }

class DailyInsight {
  final InsightCategory category;
  final String text;
  final InsightSentiment sentiment;

  const DailyInsight({
    required this.category,
    required this.text,
    required this.sentiment,
  });
}

class InsightContext {
  final double? hrvScore;
  final double? todayHrvMs;
  final double? rhrScore;
  final double? todayRhrBpm;
  final double? physicalScore;
  final double? sleepQualityScore;
  final double? deepMins;
  final double? remMins;
  final double? totalSleepMins;
  final double? sleepEfficiencyPct;
  final double? sriValue;
  final double? strainScore;
  final double? acwrValue;
  final double? stepsYesterday;
  final double? steps7dAvg;

  const InsightContext({
    this.hrvScore,
    this.todayHrvMs,
    this.rhrScore,
    this.todayRhrBpm,
    this.physicalScore,
    this.sleepQualityScore,
    this.deepMins,
    this.remMins,
    this.totalSleepMins,
    this.sleepEfficiencyPct,
    this.sriValue,
    this.strainScore,
    this.acwrValue,
    this.stepsYesterday,
    this.steps7dAvg,
  });
}

class InsightEngine {
  const InsightEngine();

  List<DailyInsight> generateInsights(InsightContext ctx) {
    return [
      _generateErholung(ctx),
      _generateSchlaf(ctx),
      _generateBelastung(ctx),
    ];
  }

  // ---------------------------------------------------------------------------
  // Erholung
  // ---------------------------------------------------------------------------

  DailyInsight _generateErholung(InsightContext ctx) {
    final hrv = ctx.hrvScore;
    final hrvMs = ctx.todayHrvMs;
    if (hrv != null) {
      if (hrv >= 75) {
        return DailyInsight(
          category: InsightCategory.erholung,
          text: 'Deine HRV liegt bei ${hrvMs?.round() ?? '?'} ms — gute Erholung',
          sentiment: InsightSentiment.good,
        );
      }
      if (hrv <= 35) {
        return DailyInsight(
          category: InsightCategory.erholung,
          text: 'Deine HRV liegt bei ${hrvMs?.round() ?? '?'} ms — Erholung nötig',
          sentiment: InsightSentiment.bad,
        );
      }
      return DailyInsight(
        category: InsightCategory.erholung,
        text: 'Deine HRV liegt bei ${hrvMs?.round() ?? '?'} ms — im Normalbereich',
        sentiment: InsightSentiment.neutral,
      );
    }

    final rhr = ctx.rhrScore;
    final rhrBpm = ctx.todayRhrBpm;
    if (rhr != null) {
      if (rhr >= 75) {
        return DailyInsight(
          category: InsightCategory.erholung,
          text: 'Dein Ruhepuls liegt bei ${rhrBpm?.round() ?? '?'} bpm — sehr entspannt',
          sentiment: InsightSentiment.good,
        );
      }
      if (rhr <= 35) {
        return DailyInsight(
          category: InsightCategory.erholung,
          text: 'Dein Ruhepuls liegt bei ${rhrBpm?.round() ?? '?'} bpm — erhöht',
          sentiment: InsightSentiment.bad,
        );
      }
      return DailyInsight(
        category: InsightCategory.erholung,
        text: 'Dein Ruhepuls liegt bei ${rhrBpm?.round() ?? '?'} bpm — normal',
        sentiment: InsightSentiment.neutral,
      );
    }

    final phys = ctx.physicalScore;
    if (phys != null) {
      if (phys >= 80) {
        return DailyInsight(
          category: InsightCategory.erholung,
          text: 'Deine körperliche Bereitschaft: ${phys.round()} — optimal',
          sentiment: InsightSentiment.good,
        );
      }
      if (phys <= 40) {
        return DailyInsight(
          category: InsightCategory.erholung,
          text: 'Deine körperliche Bereitschaft: ${phys.round()} — niedrig',
          sentiment: InsightSentiment.bad,
        );
      }
      return DailyInsight(
        category: InsightCategory.erholung,
        text: 'Deine körperliche Bereitschaft: ${phys.round()} — mittel',
        sentiment: InsightSentiment.neutral,
      );
    }

    return const DailyInsight(
      category: InsightCategory.erholung,
      text: 'Noch keine Erholungsdaten — Wearable tragen',
      sentiment: InsightSentiment.neutral,
    );
  }

  // ---------------------------------------------------------------------------
  // Schlaf
  // ---------------------------------------------------------------------------

  DailyInsight _generateSchlaf(InsightContext ctx) {
    final deep = ctx.deepMins;
    if (deep != null && deep > 0) {
      if (deep >= 90) {
        return DailyInsight(
          category: InsightCategory.schlaf,
          text: 'Tiefschlaf: ${deep.round()} min — über dem Ziel',
          sentiment: InsightSentiment.good,
        );
      }
      if (deep < 60) {
        return DailyInsight(
          category: InsightCategory.schlaf,
          text: 'Tiefschlaf: ${deep.round()} min — unter dem Ziel',
          sentiment: InsightSentiment.bad,
        );
      }
      return DailyInsight(
        category: InsightCategory.schlaf,
        text: 'Tiefschlaf: ${deep.round()} min — im Zielbereich',
        sentiment: InsightSentiment.neutral,
      );
    }

    final eff = ctx.sleepEfficiencyPct;
    if (eff != null && eff > 0) {
      if (eff >= 90) {
        return DailyInsight(
          category: InsightCategory.schlaf,
          text: 'Schlafeffizienz: ${eff.round()}% — sehr gut',
          sentiment: InsightSentiment.good,
        );
      }
      if (eff < 80) {
        return DailyInsight(
          category: InsightCategory.schlaf,
          text: 'Schlafeffizienz: ${eff.round()}% — verbesserungswürdig',
          sentiment: InsightSentiment.bad,
        );
      }
      return DailyInsight(
        category: InsightCategory.schlaf,
        text: 'Schlafeffizienz: ${eff.round()}% — normal',
        sentiment: InsightSentiment.neutral,
      );
    }

    final sri = ctx.sriValue;
    if (sri != null) {
      if (sri >= 60) {
        return DailyInsight(
          category: InsightCategory.schlaf,
          text: 'Schlafregularität: +${sri.round()} — sehr regelmäßig',
          sentiment: InsightSentiment.good,
        );
      }
      if (sri <= -20) {
        return DailyInsight(
          category: InsightCategory.schlaf,
          text: 'Schlafregularität: ${sri.round()} — unregelmäßig',
          sentiment: InsightSentiment.bad,
        );
      }
      return DailyInsight(
        category: InsightCategory.schlaf,
        text: 'Schlafregularität: ${sri.round()} — akzeptabel',
        sentiment: InsightSentiment.neutral,
      );
    }

    final sq = ctx.sleepQualityScore;
    if (sq != null) {
      if (sq >= 75) {
        return DailyInsight(
          category: InsightCategory.schlaf,
          text: 'Schlafqualität: ${sq.round()} — erholsam',
          sentiment: InsightSentiment.good,
        );
      }
      if (sq <= 35) {
        return DailyInsight(
          category: InsightCategory.schlaf,
          text: 'Schlafqualität: ${sq.round()} — unruhig',
          sentiment: InsightSentiment.bad,
        );
      }
      return DailyInsight(
        category: InsightCategory.schlaf,
        text: 'Schlafqualität: ${sq.round()} — mittelmäßig',
        sentiment: InsightSentiment.neutral,
      );
    }

    final total = ctx.totalSleepMins;
    if (total != null && total > 0) {
      final h = total ~/ 60;
      final m = (total % 60).round();
      if (total >= 420) {
        return DailyInsight(
          category: InsightCategory.schlaf,
          text: 'Gesamtschlaf: ${h}h ${m}min — Ziel erreicht',
          sentiment: InsightSentiment.good,
        );
      }
      return DailyInsight(
        category: InsightCategory.schlaf,
        text: 'Gesamtschlaf: ${h}h ${m}min — unter 7 Stunden',
        sentiment: InsightSentiment.neutral,
      );
    }

    return const DailyInsight(
      category: InsightCategory.schlaf,
      text: 'Noch keine Schlafdaten — heute Nacht tracken',
      sentiment: InsightSentiment.neutral,
    );
  }

  // ---------------------------------------------------------------------------
  // Belastung
  // ---------------------------------------------------------------------------

  DailyInsight _generateBelastung(InsightContext ctx) {
    final acwr = ctx.acwrValue;
    if (acwr != null) {
      if (acwr > 1.5) {
        return DailyInsight(
          category: InsightCategory.belastung,
          text: 'Belastungsverhältnis: ${acwr.toStringAsFixed(1)} — erhöhte Belastung',
          sentiment: InsightSentiment.bad,
        );
      }
      if (acwr < 0.7) {
        return DailyInsight(
          category: InsightCategory.belastung,
          text: 'Belastungsverhältnis: ${acwr.toStringAsFixed(1)} — Entlastung',
          sentiment: InsightSentiment.good,
        );
      }
      return DailyInsight(
        category: InsightCategory.belastung,
        text: 'Belastungsverhältnis: ${acwr.toStringAsFixed(1)} — im Sweet Spot',
        sentiment: InsightSentiment.neutral,
      );
    }

    final steps = ctx.stepsYesterday;
    final avg7d = ctx.steps7dAvg;
    if (steps != null && steps > 0) {
      final fmt = NumberFormat('#,###');
      if (avg7d != null && avg7d > 0 && steps > avg7d * 1.3) {
        return DailyInsight(
          category: InsightCategory.belastung,
          text: 'Gestern ${fmt.format(steps.round())} Schritte — überdurchschnittlich aktiv',
          sentiment: InsightSentiment.good,
        );
      }
      if (avg7d != null && avg7d > 0 && steps < avg7d * 0.7) {
        return DailyInsight(
          category: InsightCategory.belastung,
          text: 'Gestern ${fmt.format(steps.round())} Schritte — ruhiger Tag',
          sentiment: InsightSentiment.neutral,
        );
      }
      return DailyInsight(
        category: InsightCategory.belastung,
        text: 'Gestern ${fmt.format(steps.round())} Schritte — leichte Belastung',
        sentiment: InsightSentiment.neutral,
      );
    }

    final strain = ctx.strainScore;
    if (strain != null) {
      if (strain >= 70) {
        return DailyInsight(
          category: InsightCategory.belastung,
          text: 'Belastung: ${strain.round()}/100 — hoch',
          sentiment: InsightSentiment.bad,
        );
      }
      if (strain <= 30) {
        return DailyInsight(
          category: InsightCategory.belastung,
          text: 'Belastung: ${strain.round()}/100 — gering',
          sentiment: InsightSentiment.good,
        );
      }
      return DailyInsight(
        category: InsightCategory.belastung,
        text: 'Belastung: ${strain.round()}/100 — moderat',
        sentiment: InsightSentiment.neutral,
      );
    }

    return const DailyInsight(
      category: InsightCategory.belastung,
      text: 'Noch keine Aktivitätsdaten — Schritte tracken',
      sentiment: InsightSentiment.neutral,
    );
  }
}
