import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// DataExplorerScreen
// ---------------------------------------------------------------------------
// Raw data viewer. Filtering and export to be added later.
// ---------------------------------------------------------------------------

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'data_providers.dart';
import '../theme/app_theme.dart';
import 'timeline_navigator.dart';
import 'timeline_chart.dart';
import 'data_explorer_state.dart';
import 'aggregated_data_point.dart';
import '../../core/data/data_type_config.dart';

class DataExplorerScreen extends ConsumerStatefulWidget {
  const DataExplorerScreen({super.key});

  @override
  ConsumerState<DataExplorerScreen> createState() => _DataExplorerScreenState();
}

class _DataExplorerScreenState extends ConsumerState<DataExplorerScreen> {
  String? _selectedType;

  @override
  Widget build(BuildContext context) {
    final typesAsync = ref.watch(availableDataTypesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FB),
      appBar: AppBar(
        title: const Text('Data Explorer', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600, fontSize: 18)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildFilterBar(context, typesAsync),
          if (_selectedType != null) ...[
            const TimelineNavigator(),
            TimelineChart(dataType: _selectedType!),
            Expanded(child: _buildAggregatedList(context, ref, _selectedType!)),
          ] else
            Expanded(
              child: const Center(
                child: Text('Please select a data type to explore.', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildAggregatedList(BuildContext context, WidgetRef ref, String type) {
    final aggregatedAsync = ref.watch(aggregatedDataQueryProvider(type));
    final config = DataTypeRegistry.getConfig(type);
    final period = ref.watch(dataExplorerTimeRangeProvider);

    return aggregatedAsync.when(
      data: (points) {
        if (points.isEmpty) return const SizedBox();

        // Sort descending for the list
        final sorted = List<AggregatedDataPoint>.from(points)..sort((a, b) => b.timestamp.compareTo(a.timestamp));

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: sorted.length,
          itemBuilder: (context, index) {
            final p = sorted[index];
            return _buildAggregatedCard(p, config, period.granularity);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator(color: AppTheme.primaryBlue)),
      error: (e, st) => const SizedBox(),
    );
  }

  Widget _buildFilterBar(BuildContext context, AsyncValue<List<String>> typesAsync) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Row(
        children: [
          Expanded(
            child: FilledButton.tonalIcon(
              onPressed: () => _showTypeSelectionModal(context, typesAsync),
              icon: const Icon(Icons.filter_list_rounded, size: 20),
              label: Text(
                _selectedType != null ? _selectedType!.toUpperCase() : 'Select Data Type',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              style: FilledButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTypeSelectionModal(BuildContext context, AsyncValue<List<String>> typesAsync) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Text('Select Data Type', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (typesAsync.value != null) ...[
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: typesAsync.value!.length,
                    itemBuilder: (context, index) {
                      final type = typesAsync.value![index];
                      final isSelected = type == _selectedType;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: InkWell(
                          onTap: () {
                            setState(() => _selectedType = type);
                            Navigator.pop(context);
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: isSelected ? theme.colorScheme.primaryContainer : (isDark ? const Color(0xFF2A2A2A) : const Color(0xFFF4F7FB)),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isSelected ? theme.colorScheme.primary : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.bar_chart_rounded, 
                                  color: isSelected ? theme.colorScheme.primary : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  type.toUpperCase(),
                                  style: TextStyle(
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                    color: isSelected ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurface,
                                    fontSize: 16,
                                  ),
                                ),
                                const Spacer(),
                                if (isSelected)
                                  Icon(Icons.check_circle_rounded, color: theme.colorScheme.primary),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAggregatedCard(AggregatedDataPoint p, DataTypeConfig config, TimeGranularity g) {
    String dateStr;
    switch (g) {
      case TimeGranularity.day:
        dateStr = DateFormat('HH:mm').format(p.timestamp);
        break;
      case TimeGranularity.week:
      case TimeGranularity.month:
        dateStr = DateFormat('E, MMM d').format(p.timestamp);
        break;
      case TimeGranularity.year:
        dateStr = DateFormat('MMMM yyyy').format(p.timestamp);
        break;
    }

    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: p.rawEntries.isNotEmpty ? () => _showRawEntriesPopup(p, config) : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      dateStr,
                      style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: theme.colorScheme.primary),
                    ),
                    if (p.count > 1)
                      Row(
                        children: [
                          Text(
                            '${p.count} entries',
                            style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.5), fontSize: 11),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.chevron_right_rounded, size: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      config.formatValue(p.value),
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      config.unit,
                      style: TextStyle(fontSize: 14, color: theme.colorScheme.onSurface.withValues(alpha: 0.6), fontWeight: FontWeight.w500),
                    ),
                    const Spacer(),
                    if (p.min != null && p.max != null)
                      Text(
                        'Min: ${config.formatValue(p.min!)}  Max: ${config.formatValue(p.max!)}',
                        style: TextStyle(fontSize: 12, color: theme.colorScheme.onSurface.withValues(alpha: 0.5)),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showRawEntriesPopup(AggregatedDataPoint p, DataTypeConfig config) {
    final theme = Theme.of(context);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Text('Raw Data Entries', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
                    const Spacer(),
                    Text('${p.rawEntries.length} items', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  itemCount: p.rawEntries.length,
                  separatorBuilder: (context, index) => Divider(color: theme.colorScheme.onSurface.withValues(alpha: 0.1)),
                  itemBuilder: (context, index) {
                    final entry = p.rawEntries[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Text(
                            DateFormat('MMM d, HH:mm:ss').format(entry.timestamp),
                            style: TextStyle(color: theme.colorScheme.onSurface.withValues(alpha: 0.7), fontSize: 14),
                          ),
                          const Spacer(),
                          Text(
                            '${config.formatValue(entry.value)} ${config.unit}',
                            style: TextStyle(fontWeight: FontWeight.w600, color: theme.colorScheme.onSurface, fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }
}
