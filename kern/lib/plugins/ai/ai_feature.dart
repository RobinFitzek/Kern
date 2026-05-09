import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/plugins/plugin_interfaces.dart';
import '../../core/plugins/plugin_registry.dart';
import '../derived/derived_providers.dart';

class AiFeature implements KernPlugin {
  @override
  String get id => 'ai_coach';

  @override
  String get name => 'AI Coach';

  @override
  String get description => 'Proactive daily health insights powered by Gemini.';

  @override
  IconData get icon => Icons.auto_awesome_rounded;

  @override
  Color get accentColor => const Color(0xFF673AB7); // Deep Purple

  @override
  List<PluginSlot> get supportedSlots => [PluginSlot.header, PluginSlot.main];

  @override
  PluginSlot get defaultSlot => PluginSlot.header;

  @override
  int get defaultSortOrder => 0;

  @override
  Widget buildDashboardWidget(BuildContext context, PluginSlot slot) {
    return const _AiDashboardWidget();
  }

  @override
  bool get hasDetailPage => false;

  @override
  Widget? buildDetailPage(BuildContext context) => null;

  @override
  Widget? buildSettingsPage(BuildContext context) => const AiSettingsScreen();
}

class _AiDashboardWidget extends ConsumerWidget {
  const _AiDashboardWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final insightAsync = ref.watch(aiInsightProvider());

    return insightAsync.when(
      data: (insight) {
        if (insight == null) {
          return const SizedBox();
        }

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF673AB7).withValues(alpha: 0.15),
                const Color(0xFF9C27B0).withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFF673AB7).withValues(alpha: 0.2)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF673AB7).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.auto_awesome_rounded, color: Color(0xFF673AB7), size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        insight['title'] ?? 'Daily Insight',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  insight['text'] ?? '',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        height: 100,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => const SizedBox(),
    );
  }
}

class AiSettingsScreen extends ConsumerStatefulWidget {
  const AiSettingsScreen({super.key});

  @override
  ConsumerState<AiSettingsScreen> createState() => _AiSettingsScreenState();
}

class _AiSettingsScreenState extends ConsumerState<AiSettingsScreen> {
  final _controller = TextEditingController();
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    _loadKey();
  }

  Future<void> _loadKey() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _controller.text = prefs.getString('gemini_api_key') ?? '';
    });
  }

  Future<void> _saveKey() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('gemini_api_key', _controller.text.trim());
    setState(() => _saved = true);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('API Key saved')));
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) setState(() => _saved = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AI Coach Settings')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Icon(Icons.auto_awesome_rounded, size: 48, color: Color(0xFF673AB7)),
          const SizedBox(height: 16),
          const Text(
            'Gemini API Key',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'To generate personalized insights, the AI Coach requires a Google Gemini API key. Your key is stored securely on this device and is only used to communicate directly with Google.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 32),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: 'API Key',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              prefixIcon: const Icon(Icons.key),
            ),
            obscureText: true,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _saveKey,
            icon: Icon(_saved ? Icons.check : Icons.save),
            label: Text(_saved ? 'Saved' : 'Save Key'),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: const Color(0xFF673AB7),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
          ),
        ],
      ),
    );
  }
}
