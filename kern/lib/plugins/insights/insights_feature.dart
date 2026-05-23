import 'package:flutter/material.dart';

import '../../core/plugins/plugin_interfaces.dart';
import '../../ui/widgets/daily_insights_card.dart';

class InsightsFeature implements KernPlugin {
  @override
  String get id => 'insights';

  @override
  String get name => 'Tägliche Insights';

  @override
  String get description => 'Drei datenbasierte Beobachtungen zu Erholung, Schlaf und Belastung.';

  @override
  List<PluginSlot> get supportedSlots => [PluginSlot.main, PluginSlot.header];

  @override
  Widget buildDashboardWidget(BuildContext context, PluginSlot slot) {
    return const DailyInsightsCard();
  }

  @override
  bool get hasDetailPage => false;

  @override
  Widget? buildDetailPage(BuildContext context) => null;

  @override
  Widget? buildSettingsPage(BuildContext context) => null;
}
