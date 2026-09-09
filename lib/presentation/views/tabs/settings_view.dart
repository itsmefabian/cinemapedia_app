import 'package:cinemapedia_app/presentation/providers/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsView extends ConsumerWidget {
  const new({super.key});

  static const name = 'settings-view';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final platformBrightness = MediaQuery.platformBrightnessOf(context);
    final isDarkMode = themeMode == ThemeMode.system
        ? platformBrightness == Brightness.dark
        : themeMode == ThemeMode.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SwitchListTile(
        title: const Text('Dark mode'),
        secondary: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
        value: isDarkMode,
        onChanged: (value) =>
            ref.read(themeModeProvider.notifier).setDarkMode(value),
      ),
    );
  }
}
