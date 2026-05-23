import 'package:flutter/material.dart';

import '../../core/plugins/plugin_interfaces.dart';
import '../../ui/widgets/historical_readiness_chart.dart';

class TrendsFeature implements KernPlugin {
  @override
  String get id => 'trends';

  @override
  String get name => 'Trend';

  @override
  String get description => '7/14/30-Tage Readiness Trend als Liniendiagramm.';

  @override
  List<PluginSlot> get supportedSlots => [PluginSlot.footer, PluginSlot.main];

  @override
  Widget buildDashboardWidget(BuildContext context, PluginSlot slot) {
    return const HistoricalReadinessChart();
  }

  @override
  bool get hasDetailPage => false;

  @override
  Widget? buildDetailPage(BuildContext context) => null;

  @override
  Widget? buildSettingsPage(BuildContext context) => null;
}
