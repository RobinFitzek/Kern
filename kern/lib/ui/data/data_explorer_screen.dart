import 'package:flutter/material.dart';

// ---------------------------------------------------------------------------
// DataExplorerScreen
// ---------------------------------------------------------------------------
// Raw data viewer. Filtering and export to be added later.
// ---------------------------------------------------------------------------

class DataExplorerScreen extends StatelessWidget {
  const DataExplorerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Explorer'),
      ),
      body: const Center(
        child: Text(
          'Raw Data Viewer\n(Coming soon)',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
