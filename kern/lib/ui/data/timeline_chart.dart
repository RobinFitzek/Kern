import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../core/data/data_type_config.dart';
import '../theme/app_theme.dart';
import 'data_providers.dart';
import 'data_explorer_state.dart';

class TimelineChart extends ConsumerWidget {
  final String dataType;

  const TimelineChart({super.key, required this.dataType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final aggregatedAsync = ref.watch(aggregatedDataQueryProvider(dataType));
    final baselineAsync = ref.watch(baselineAverageProvider(dataType));
    final config = DataTypeRegistry.getConfig(dataType);

    return Container(
      height: 240,
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.only(top: 24, bottom: 16, left: 16, right: 16),
      child: aggregatedAsync.when(
        data: (points) {
          if (points.isEmpty) {
            return const Center(child: Text('No data for this period', style: TextStyle(color: Colors.black45)));
          }

          final baseline = baselineAsync.value;

          return GestureDetector(
            onHorizontalDragEnd: (details) {
              if (details.primaryVelocity! > 0) {
                // Swipe right -> previous period
                ref.read(dataExplorerTimeRangeProvider.notifier).previous();
              } else if (details.primaryVelocity! < 0) {
                // Swipe left -> next period
                ref.read(dataExplorerTimeRangeProvider.notifier).next();
              }
            },
            child: config.chartType == ChartDisplayType.bar
                ? _buildBarChart(points, config, baseline)
                : _buildLineChart(points, config, baseline),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primaryBlue)),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildLineChart(List<dynamic> points, DataTypeConfig config, double? baseline) {
    final spots = <FlSpot>[];
    double minY = double.infinity;
    double maxY = double.negativeInfinity;

    for (int i = 0; i < points.length; i++) {
      final p = points[i];
      if (p.value < minY) minY = p.value;
      if (p.value > maxY) maxY = p.value;
      spots.add(FlSpot(i.toDouble(), p.value));
    }

    if (baseline != null) {
      if (baseline < minY) minY = baseline;
      if (baseline > maxY) maxY = baseline;
    }

    if (minY == double.infinity) return const SizedBox();
    
    // Add some padding to Y axis
    final yRange = (maxY - minY).abs();
    final padding = yRange == 0 ? 10.0 : yRange * 0.15;

    return LineChart(
      LineChartData(
        minY: minY - padding,
        maxY: maxY + padding,
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= points.length) return const SizedBox();
                // Only show every Nth label if too many points
                if (points.length > 10 && index % (points.length ~/ 5) != 0 && index != points.length -1 && index != 0) {
                  return const SizedBox();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    points[index].formattedAxisLabel,
                    style: const TextStyle(color: Colors.black45, fontSize: 10, fontWeight: FontWeight.w600),
                  ),
                );
              },
              reservedSize: 24,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppTheme.primaryBlue,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              color: AppTheme.primaryBlue.withValues(alpha: 0.1),
            ),
          ),
        ],
        extraLinesData: baseline != null
            ? ExtraLinesData(
                horizontalLines: [
                  HorizontalLine(
                    y: baseline,
                    color: Colors.black38,
                    strokeWidth: 1.5,
                    dashArray: [5, 5],
                    label: HorizontalLineLabel(
                      show: true,
                      alignment: Alignment.topRight,
                      padding: const EdgeInsets.only(right: 4, bottom: 4),
                      style: const TextStyle(fontSize: 10, color: Colors.black45, fontWeight: FontWeight.w600),
                      labelResolver: (line) => '30d Avg',
                    ),
                  ),
                ],
              )
            : ExtraLinesData(),
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final p = points[spot.spotIndex];
                final timeFormatted = DateFormat('MMM d, HH:mm').format(p.timestamp);
                return LineTooltipItem(
                  '${config.formatValue(spot.y)} ${config.unit}\n',
                  const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                  children: [
                    TextSpan(
                      text: timeFormatted,
                      style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.normal),
                    ),
                  ],
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBarChart(List<dynamic> points, DataTypeConfig config, double? baseline) {
    double maxY = 0;
    for (var p in points) {
      if (p.value > maxY) maxY = p.value;
    }
    if (baseline != null && baseline > maxY) maxY = baseline;
    final padding = maxY == 0 ? 10.0 : maxY * 0.1;

    return BarChart(
      BarChartData(
        maxY: maxY + padding,
        gridData: FlGridData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= points.length) return const SizedBox();
                if (points.length > 10 && index % (points.length ~/ 5) != 0 && index != points.length -1 && index != 0) {
                  return const SizedBox();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    points[index].formattedAxisLabel,
                    style: const TextStyle(color: Colors.black45, fontSize: 10, fontWeight: FontWeight.w600),
                  ),
                );
              },
              reservedSize: 24,
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: points.asMap().entries.map((e) {
          final i = e.key;
          final p = e.value;
          return BarChartGroupData(
            x: i,
            barRods: [
              BarChartRodData(
                toY: p.value,
                color: AppTheme.primaryBlue,
                width: points.length > 15 ? 4 : 12,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              ),
            ],
          );
        }).toList(),
        extraLinesData: baseline != null
            ? ExtraLinesData(
                horizontalLines: [
                  HorizontalLine(
                    y: baseline,
                    color: Colors.black38,
                    strokeWidth: 1.5,
                    dashArray: [5, 5],
                  ),
                ],
              )
            : ExtraLinesData(),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final p = points[group.x];
              final timeFormatted = DateFormat('MMM d').format(p.timestamp);
              return BarTooltipItem(
                '${config.formatValue(rod.toY)} ${config.unit}\n',
                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                children: [
                  TextSpan(
                    text: timeFormatted,
                    style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.normal),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
