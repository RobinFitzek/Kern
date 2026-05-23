import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/app_theme.dart';

class AppearanceSettingsScreen extends ConsumerWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appearance'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          Container(
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: theme.dividerColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Consumer(builder: (context, ref, child) {
                  final isDark = ref.watch(themeModeProvider) == ThemeMode.dark;
                  return SwitchListTile(
                    secondary: const Icon(Icons.palette_outlined),
                    title: const Text('Dark Mode'),
                    subtitle: const Text('Switch between light and dark theme'),
                    value: isDark,
                    activeTrackColor: theme.colorScheme.primary,
                    onChanged: (val) {
                      ref.read(themeModeProvider.notifier).setMode(val ? ThemeMode.dark : ThemeMode.light);
                    },
                  );
                }),
                const Divider(height: 1, indent: 56),
                Consumer(builder: (context, ref, child) {
                  final useDynamicColor = ref.watch(useDynamicColorProvider);
                  return SwitchListTile(
                    secondary: const Icon(Icons.color_lens_outlined),
                    title: const Text('Material 3 Dynamic Colors'),
                    subtitle: const Text('Extract colors from wallpaper'),
                    value: useDynamicColor,
                    activeTrackColor: theme.colorScheme.primary,
                    onChanged: (val) {
                      ref.read(useDynamicColorProvider.notifier).setMode(val);
                    },
                  );
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
