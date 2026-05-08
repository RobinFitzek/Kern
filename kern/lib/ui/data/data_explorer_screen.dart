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
      backgroundColor: const Color(0xFF0A0A0F),
      appBar: AppBar(
        title: const Text('Data Explorer', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'Raw Data Viewer\n(Coming soon)',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white.withOpacity(0.5)),
        ),
      ),
    );
  }
}
