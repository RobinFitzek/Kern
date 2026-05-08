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
    final entriesAsync = ref.watch(recentRawEntriesProvider(filterType: _selectedType));
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
          _buildFilterBar(typesAsync),
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

  Widget _buildFilterBar(AsyncValue<List<String>> typesAsync) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      width: double.infinity,
      child: Row(
        children: [
          const Icon(Icons.filter_list, color: Colors.black54, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedType,
                hint: const Text('All Data Types', style: TextStyle(color: Colors.black54)),
                isExpanded: true,
                items: [
                  const DropdownMenuItem<String>(value: null, child: Text('All Data Types')),
                  if (typesAsync.value != null)
                    ...typesAsync.value!.map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type.toUpperCase()),
                        )),
                ],
                onChanged: (val) {
                  setState(() {
                    _selectedType = val;
                  });
                },
              ),
            ),
          ),
        ],
      ),
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

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                dateStr,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: AppTheme.primaryBlue),
              ),
              if (p.count > 1)
                Text(
                  '${p.count} entries',
                  style: const TextStyle(color: Colors.black45, fontSize: 11),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                config.formatValue(p.value),
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(width: 4),
              Text(
                config.unit,
                style: const TextStyle(fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              if (p.min != null && p.max != null)
                Text(
                  'Min: ${config.formatValue(p.min!)}  Max: ${config.formatValue(p.max!)}',
                  style: const TextStyle(fontSize: 12, color: Colors.black45),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
