import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../plugins/derived/derived_providers.dart';
import '../theme/app_theme.dart';

class HistoricalReadinessChart extends ConsumerStatefulWidget {
  const HistoricalReadinessChart({super.key});

  @override
  ConsumerState<HistoricalReadinessChart> createState() => _HistoricalReadinessChartState();
}

class _HistoricalReadinessChartState extends ConsumerState<HistoricalReadinessChart> {
  int _days = 14;

  @override
  Widget build(BuildContext context) {
    final scoresAsync = ref.watch(historicalReadinessScoresProvider(days: _days));
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.trending_up_rounded, color: AppTheme.primaryBlue, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Readiness Trend',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
              _RangeChip(
                label: '7T',
                selected: _days == 7,
                onTap: () => setState(() => _days = 7),
              ),
              const SizedBox(width: 6),
              _RangeChip(
                label: '14T',
                selected: _days == 14,
                onTap: () => setState(() => _days = 14),
              ),
              const SizedBox(width: 6),
              _RangeChip(
                label: '30T',
                selected: _days == 30,
                onTap: () => setState(() => _days = 30),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: scoresAsync.when(
              data: (scores) => scores.isEmpty
                  ? const Center(child: Text('Keine Daten', style: TextStyle(color: AppTheme.textTertiary)))
                  : _buildChart(scores, isDark),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => const Center(child: Text('Fehler', style: TextStyle(color: AppTheme.textPink))),
            ),
          ),
          if (scoresAsync.valueOrNull != null && scoresAsync.value!.isNotEmpty) ...[
            const SizedBox(height: 14),
            _buildSummary(scoresAsync.value!, isDark),
          ],
        ],
      ),
    );
  }

  Widget _buildChart(
    List<({String date, double? physical, double? mental})> scores,
    bool isDark,
  ) {
    final physSpots = <FlSpot>[];
    final mentSpots = <FlSpot>[];

    for (int i = 0; i < scores.length; i++) {
      final s = scores[i];
      if (s.physical != null) physSpots.add(FlSpot(i.toDouble(), s.physical!));
      if (s.mental != null) mentSpots.add(FlSpot(i.toDouble(), s.mental!));
    }

    if (physSpots.isEmpty && mentSpots.isEmpty) {
      return const Center(child: Text('Keine Daten', style: TextStyle(color: AppTheme.textTertiary)));
    }

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 100,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: 25,
          getDrawingHorizontalLine: (value) => FlLine(
            color: isDark ? Colors.white10 : AppTheme.divider,
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 28,
              interval: 25,
              getTitlesWidget: (value, meta) => Text(
                value.toInt().toString(),
                style: TextStyle(fontSize: 10, color: isDark ? Colors.white38 : AppTheme.textTertiary),
              ),
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 22,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= scores.length) return const SizedBox();
                final step = scores.length > 10 ? (scores.length / 4).ceil() : 1;
                if (index % step != 0 && index != scores.length - 1) return const SizedBox();
                try {
                  final date = DateTime.parse(scores[index].date);
                  return Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat('d.M.').format(date),
                      style: TextStyle(fontSize: 9, color: isDark ? Colors.white38 : AppTheme.textTertiary),
                    ),
                  );
                } catch (_) {
                  return const SizedBox();
                }
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          if (physSpots.isNotEmpty)
            LineChartBarData(
              spots: physSpots,
              isCurved: true,
              curveSmoothness: 0.3,
              color: AppTheme.textMint,
              barWidth: 2.5,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: AppTheme.textMint.withValues(alpha: 0.08),
              ),
            ),
          if (mentSpots.isNotEmpty)
            LineChartBarData(
              spots: mentSpots,
              isCurved: true,
              curveSmoothness: 0.3,
              color: AppTheme.primaryBlue,
              barWidth: 2.5,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: AppTheme.primaryBlue.withValues(alpha: 0.08),
              ),
            ),
        ],
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: 70,
              color: AppTheme.textMint.withValues(alpha: 0.35),
              strokeWidth: 1,
              dashArray: [4, 4],
            ),
            HorizontalLine(
              y: 40,
              color: AppTheme.textPink.withValues(alpha: 0.35),
              strokeWidth: 1,
              dashArray: [4, 4],
            ),
          ],
        ),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final index = spot.spotIndex;
                if (index >= scores.length) return null;
                final s = scores[index];
                String dateStr = s.date;
                try {
                  dateStr = DateFormat('d. MMM').format(DateTime.parse(s.date));
                } catch (_) {}
                final isPhys = spot.bar.color == AppTheme.textMint;
                return LineTooltipItem(
                  '${isPhys ? 'Physisch' : 'Mental'}: ${spot.y.toInt()}\n$dateStr',
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSummary(
    List<({String date, double? physical, double? mental})> scores,
    bool isDark,
  ) {
    final physValues = scores.where((s) => s.physical != null).map((s) => s.physical!).toList();
    final physAvg = physValues.isEmpty ? null : physValues.reduce((a, b) => a + b) / physValues.length;

    String trend = '—';
    if (physValues.length >= 2) {
      final firstHalf = physValues.sublist(0, physValues.length ~/ 2);
      final secondHalf = physValues.sublist(physValues.length ~/ 2);
      final firstAvg = firstHalf.reduce((a, b) => a + b) / firstHalf.length;
      final secondAvg = secondHalf.reduce((a, b) => a + b) / secondHalf.length;
      final diff = secondAvg - firstAvg;
      trend = diff > 2 ? '↗' : diff < -2 ? '↘' : '→';
    }

    return Row(
      children: [
        _buildLegend(color: AppTheme.textMint, label: 'Physisch'),
        const SizedBox(width: 16),
        _buildLegend(color: AppTheme.primaryBlue, label: 'Mental'),
        const Spacer(),
        Text(
          'Ø ${physAvg?.toStringAsFixed(0) ?? '--'}  $trend',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white60 : AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildLegend({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecondary)),
      ],
    );
  }
}

class _RangeChip extends StatelessWidget {
  const _RangeChip({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? AppTheme.primaryBlue : AppTheme.primaryBlue.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : AppTheme.primaryBlue,
          ),
        ),
      ),
    );
  }
}
