import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/data/data_type_config.dart';
import 'data_explorer_state.dart';

class TimelineNavigator extends ConsumerWidget {
  const TimelineNavigator({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(dataExplorerTimeRangeProvider);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          _buildGranularityTabs(context, ref, period.granularity),
          const SizedBox(height: 12),
          _buildPeriodSelector(context, ref, period),
        ],
      ),
    );
  }

  Widget _buildGranularityTabs(BuildContext context, WidgetRef ref, TimeGranularity current) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFFF4F7FB),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: TimeGranularity.values.map((g) {
            final isSelected = g == current;
            return Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  ref.read(dataExplorerTimeRangeProvider.notifier).setGranularity(g);
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            )
                          ]
                        : null,
                  ),
                  margin: const EdgeInsets.all(2),
                  alignment: Alignment.center,
                  child: Text(
                    _granularityLabel(g),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected ? Colors.black87 : Colors.black45,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildPeriodSelector(BuildContext context, WidgetRef ref, DataExplorerPeriod period) {
    final isCurrent = period.isCurrentPeriod;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Colors.black54),
            onPressed: () {
              HapticFeedback.lightImpact();
              ref.read(dataExplorerTimeRangeProvider.notifier).previous();
            },
            visualDensity: VisualDensity.compact,
          ),
          Text(
            _formatPeriodLabel(period),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.chevron_right, 
              color: isCurrent ? Colors.black12 : Colors.black54,
            ),
            onPressed: isCurrent ? null : () {
              HapticFeedback.lightImpact();
              ref.read(dataExplorerTimeRangeProvider.notifier).next();
            },
            visualDensity: VisualDensity.compact,
          ),
        ],
      ),
    );
  }

  String _granularityLabel(TimeGranularity g) {
    switch (g) {
      case TimeGranularity.day: return 'D';
      case TimeGranularity.week: return 'W';
      case TimeGranularity.month: return 'M';
      case TimeGranularity.year: return 'Y';
    }
  }

  String _formatPeriodLabel(DataExplorerPeriod period) {
    final start = period.start;
    final end = period.end.subtract(const Duration(milliseconds: 1));
    
    switch (period.granularity) {
      case TimeGranularity.day:
        if (period.isCurrentPeriod) return 'Today';
        return DateFormat('E, MMM d').format(start);
        
      case TimeGranularity.week:
        if (period.isCurrentPeriod) return 'This Week';
        if (start.month == end.month) {
          return '${start.day} - ${end.day} ${DateFormat('MMM').format(start)}';
        }
        return '${start.day} ${DateFormat('MMM').format(start)} - ${end.day} ${DateFormat('MMM').format(end)}';
        
      case TimeGranularity.month:
        return DateFormat('MMMM yyyy').format(start);
        
      case TimeGranularity.year:
        return DateFormat('yyyy').format(start);
    }
  }
}
