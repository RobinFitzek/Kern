import 'package:flutter/widgets.dart';

/// The specific dashboard zone where a plugin wants to render its main UI.
enum PluginSlot {
  /// Top area, typically for quick metrics or status (e.g. current strain).
  /// Rendered as a carousel if multiple plugins compete for it.
  header,

  /// The primary focus area of the dashboard (e.g. the large Readiness ring).
  /// Only one main plugin is fully visible at a time.
  main,

  /// Bottom area for secondary details (e.g. sleep duration breakdown).
  /// Rendered as a carousel or list.
  footer,
}

/// The base interface that all Kern features (Readiness, Sleep, AI) must implement.
///
/// This isolates the Shell from the feature logic. The Shell only knows
/// about this interface.
abstract class KernPlugin {
  /// Unique identifier used in the DB (e.g. 'readiness', 'sleep_score').
  String get id;

  /// Human-readable name for the Plugin Manager UI.
  String get name;

  /// Short description of what this plugin does.
  String get description;

  /// Which slots this plugin can meaningfully occupy on the dashboard.
  /// If empty, it doesn't render on the dashboard at all.
  List<PluginSlot> get supportedSlots;

  /// Builds the widget to render in the dashboard [slot].
  /// Will only be called for slots declared in [supportedSlots].
  Widget buildDashboardWidget(BuildContext context, PluginSlot slot);

  /// Optional: Builds a full-page detail view for this plugin.
  /// If provided, this plugin will be listed in the bottom navigation.
  /// Ensure [hasDetailPage] is true if this is implemented.
  Widget? buildDetailPage(BuildContext context) => null;

  /// Whether this plugin provides a detail page.
  bool get hasDetailPage => false;

  /// Optional: Builds a settings screen for configuring this specific plugin.
  Widget? buildSettingsPage(BuildContext context) => null;
}
