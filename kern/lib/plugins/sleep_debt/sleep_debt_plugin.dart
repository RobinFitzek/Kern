import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/database/app_database.dart';
import '../../core/database/derived_keys.dart';

class SleepDebtPlugin {
  SleepDebtPlugin(this._db);

  final AppDatabase _db;

  static const String _goalPrefKey = 'sleep_debt_goal_minutes';
  static const double _defaultGoal = 480.0;

  static const double _decayRate = 0.93;
  static const double _maxDebtMultiplier = 2.0;

  Future<void> run(String date) async {
    final now = DateTime.now();
    final lookbackEnd = now;
    final lookbackStart = now.subtract(const Duration(days: 30));

    final startStr = _fmtDate(lookbackStart);
    final endStr = _fmtDate(lookbackEnd);

    final sleepEntries = await _db.derivedForDateRange(
      namespace: DerivedNamespace.sleep,
      key: SleepKey.totalMinutes,
      startDate: startStr,
      endDate: endStr,
    );

    final prefs = await SharedPreferences.getInstance();
    final goal = prefs.getDouble(_goalPrefKey) ?? _defaultGoal;

    final maxDebtCap = goal * _maxDebtMultiplier;

    double bank = 0.0;
    double dailyShortfall = 0.0;
    double lastNightSurplus = 0.0;
    final List<double> dailyBalances = [];

    final sorted = sleepEntries.toList()
      ..sort((a, b) => a.date.compareTo(b.date));

    for (final entry in sorted) {
      final actual = entry.value;

      bank *= _decayRate;

      final balance = actual - goal;

      if (entry.date == date) {
        dailyShortfall = balance < 0 ? balance.abs() : 0.0;
        lastNightSurplus = balance > 0 ? balance : 0.0;
      }

      bank += balance;
      bank = bank.clamp(-maxDebtCap, 0.0);

      dailyBalances.add(bank);
    }

    final score = _bankToScore(bank, maxDebtCap);
    final severity = _computeSeverity(bank);
    final recoveryDays = _computeRecoveryDays(bank, actualSleep: _recentAvg(sorted, goal));
    final trend = _computeTrend(dailyBalances);
    final weeklyTrend = _computeWeeklyTrend(dailyBalances);

    final detail = jsonEncode({
      'daily_balances': dailyBalances,
      'dates': sorted.map((e) => e.date).toList(),
    });

    debugPrint(
      '[SleepDebtPlugin] date=$date goal=${goal.toInt()}m '
      'bank=${bank.toInt()}m score=${score.toInt()} '
      'severity=$severity recovery=${recoveryDays}d trend=$trend',
    );

    final ts = DateTime.now();
    await Future.wait([
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.sleepDebt,
        key: SleepDebtKey.bankBalance,
        value: bank,
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.sleepDebt,
        key: SleepDebtKey.bankScore,
        value: score,
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.sleepDebt,
        key: SleepDebtKey.dailyShortfall,
        value: dailyShortfall,
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.sleepDebt,
        key: SleepDebtKey.debtSeverity,
        value: severity.toDouble(),
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.sleepDebt,
        key: SleepDebtKey.recoveryDays,
        value: recoveryDays,
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.sleepDebt,
        key: SleepDebtKey.trendDirection,
        value: trend.toDouble(),
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.sleepDebt,
        key: SleepDebtKey.sleepGoal,
        value: goal,
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.sleepDebt,
        key: SleepDebtKey.weeklyBalanceTrend,
        value: weeklyTrend,
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.sleepDebt,
        key: SleepDebtKey.lastNightSurplus,
        value: lastNightSurplus,
        date: date,
        computedAt: ts,
      )),
      _db.upsertDerived(DerivedEntriesCompanion.insert(
        namespace: DerivedNamespace.sleepDebt,
        key: SleepDebtKey.detailJson,
        value: 0.0,
        date: date,
        computedAt: ts,
        metadata: Value(detail),
      )),
    ]);
  }

  static double bankToScoreStatic(double bank, double maxDebtCap) =>
      _bankToScore(bank, maxDebtCap);

  static double _bankToScore(double bank, double maxDebtCap) {
    if (maxDebtCap <= 0) return 100.0;
    return (100.0 * (1.0 + bank / maxDebtCap)).clamp(0.0, 100.0);
  }

  static int _computeSeverity(double bank) {
    if (bank >= -(30.0 / 60.0 * _defaultGoal / 8.0)) return 0;
    if (bank > -90.0) return 1;
    if (bank > -180.0) return 2;
    if (bank > -360.0) return 3;
    return 4;
  }

  static double _computeRecoveryDays(double bank, {double actualSleep = 480.0}) {
    if (bank >= 0) return 0.0;
    final surplusPerNight = (_defaultGoal - actualSleep).clamp(0.0, 120.0);
    if (surplusPerNight <= 0) return (bank.abs() / 60.0).ceilToDouble();
    return (bank.abs() / surplusPerNight).ceilToDouble();
  }

  static int _computeTrend(List<double> dailyBalances) {
    if (dailyBalances.length < 7) return 1;
    final recent = dailyBalances.sublist(dailyBalances.length - 7);
    final older = dailyBalances.sublist(0, dailyBalances.length - 7);
    if (older.isEmpty) return 1;

    final recentAvg = recent.reduce((a, b) => a + b) / recent.length;
    final olderAvg = older.reduce((a, b) => a + b) / older.length;

    if (olderAvg < -0.01) {
      final relativeChange = (recentAvg - olderAvg) / olderAvg.abs();
      if (relativeChange > 0.05) return 2;
      if (relativeChange < -0.05) return 0;
    } else if (recentAvg > olderAvg + 5) {
      return 2;
    } else if (recentAvg < olderAvg - 5) {
      return 0;
    }
    return 1;
  }

  static double _computeWeeklyTrend(List<double> dailyBalances) {
    if (dailyBalances.length < 14) return 0.0;
    final recent = dailyBalances.sublist(dailyBalances.length - 7);
    final older = dailyBalances.sublist(dailyBalances.length - 14, dailyBalances.length - 7);

    final recentAvg = recent.reduce((a, b) => a + b) / recent.length;
    final olderAvg = older.reduce((a, b) => a + b) / older.length;

    return recentAvg - olderAvg;
  }

  static double _recentAvg(List<dynamic> entries, double goal) {
    if (entries.isEmpty) return goal;
    final recent = entries.length > 7
        ? entries.sublist(entries.length - 7)
        : entries;
    return recent.map((e) => (e as dynamic).value as double).reduce((a, b) => a + b) / recent.length;
  }

  static String _fmtDate(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
}
