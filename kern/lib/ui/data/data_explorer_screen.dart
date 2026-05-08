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
          Expanded(
            child: entriesAsync.when(
              data: (entries) {
                if (entries.isEmpty) {
                  return const Center(
                    child: Text('No data found.\nConnect Health Connect and Sync.', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54)),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: entries.length,
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    return _buildDataCard(entry);
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, st) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
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

  Widget _buildDataCard(dynamic entry) {
    final dateFormat = DateFormat('MMM d, HH:mm');
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
                entry.type.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppTheme.primaryBlue),
              ),
              Text(
                dateFormat.format(entry.timestamp),
                style: const TextStyle(color: Colors.black45, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            entry.value.toStringAsFixed(2),
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.source_outlined, size: 14, color: Colors.black38),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  entry.sourceName,
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          if (entry.metadata != null && entry.metadata!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: const Color(0xFFF4F7FB), borderRadius: BorderRadius.circular(8)),
              width: double.infinity,
              child: Text(
                entry.metadata!,
                style: const TextStyle(fontSize: 11, color: Colors.black54, fontFamily: 'monospace'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
