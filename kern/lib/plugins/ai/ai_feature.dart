import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/plugins/plugin_interfaces.dart';
import '../../ui/widgets/ai_coach_card.dart';

class AiFeature implements KernPlugin {
  @override
  String get id => 'ai_coach';

  @override
  String get name => 'AI Coach';

  @override
  String get description => 'Proactive daily health insights powered by Gemini.';

  @override
  List<PluginSlot> get supportedSlots => [PluginSlot.main];

  @override
  Widget buildDashboardWidget(BuildContext context, PluginSlot slot) {
    return const AiCoachCard();
  }

  @override
  bool get hasDetailPage => false;

  @override
  Widget? buildDetailPage(BuildContext context) => null;

  @override
  Widget? buildSettingsPage(BuildContext context) => const AiSettingsScreen();
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
            'The AI Coach uses Gemini 2.5 Flash to lead a daily conversation about your health. '
            'Your API key is stored on-device and only used for direct communication with Google.',
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
