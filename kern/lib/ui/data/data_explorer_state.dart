import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../core/data/data_type_config.dart';

part 'data_explorer_state.g.dart';

class DataExplorerPeriod {
  final DateTime start;
  final DateTime end;
  final TimeGranularity granularity;

  DataExplorerPeriod({
    required this.start,
    required this.end,
    required this.granularity,
  });

  bool get isCurrentPeriod {
    final now = DateTime.now();
    return now.isAfter(start) && now.isBefore(end);
  }

  // Returns previous period
  DataExplorerPeriod previous() {
    return _shift(-1);
  }

  // Returns next period
  DataExplorerPeriod next() {
    return _shift(1);
  }

  DataExplorerPeriod _shift(int direction) {
    switch (granularity) {
      case TimeGranularity.day:
        return _createForDay(start.add(Duration(days: direction)));
      case TimeGranularity.week:
        return _createForWeek(start.add(Duration(days: direction * 7)));
      case TimeGranularity.month:
        final newStart = DateTime(start.year, start.month + direction, 1);
        return _createForMonth(newStart);
      case TimeGranularity.year:
        final newStart = DateTime(start.year + direction, 1, 1);
        return _createForYear(newStart);
    }
  }

  static DataExplorerPeriod _createForDay(DateTime date) {
    final start = DateTime(date.year, date.month, date.day);
    return DataExplorerPeriod(
      start: start,
      end: start.add(const Duration(days: 1)),
      granularity: TimeGranularity.day,
    );
  }

  static DataExplorerPeriod _createForWeek(DateTime date) {
    // Start of week (Monday)
    final start = DateTime(date.year, date.month, date.day).subtract(Duration(days: date.weekday - 1));
    return DataExplorerPeriod(
      start: start,
      end: start.add(const Duration(days: 7)),
      granularity: TimeGranularity.week,
    );
  }

  static DataExplorerPeriod _createForMonth(DateTime date) {
    final start = DateTime(date.year, date.month, 1);
    final nextMonth = DateTime(date.year, date.month + 1, 1);
    return DataExplorerPeriod(
      start: start,
      end: nextMonth,
      granularity: TimeGranularity.month,
    );
  }

  static DataExplorerPeriod _createForYear(DateTime date) {
    final start = DateTime(date.year, 1, 1);
    final nextYear = DateTime(date.year + 1, 1, 1);
    return DataExplorerPeriod(
      start: start,
      end: nextYear,
      granularity: TimeGranularity.year,
    );
  }

  static DataExplorerPeriod current(TimeGranularity g) {
    final now = DateTime.now();
    switch (g) {
      case TimeGranularity.day: return _createForDay(now);
      case TimeGranularity.week: return _createForWeek(now);
      case TimeGranularity.month: return _createForMonth(now);
      case TimeGranularity.year: return _createForYear(now);
    }
  }
}

@riverpod
class DataExplorerTimeRange extends _$DataExplorerTimeRange {
  @override
  DataExplorerPeriod build() {
    return DataExplorerPeriod.current(TimeGranularity.week);
  }

  void setGranularity(TimeGranularity g) {
    state = DataExplorerPeriod.current(g);
  }

  void previous() {
    state = state.previous();
  }

  void next() {
    if (!state.isCurrentPeriod) {
      state = state.next();
    }
  }
}
