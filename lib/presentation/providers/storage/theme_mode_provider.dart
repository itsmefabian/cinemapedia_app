import 'package:cinemapedia_app/presentation/providers/storage/local_storage_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  Future<void> loadThemeMode() async {
    final isDarkMode = await ref
        .read(localStorageRepositoryProvider)
        .getDarkModePreference();

    if (isDarkMode == null) return;

    state = isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  Future<void> setDarkMode(bool isDarkMode) async {
    await ref
        .read(localStorageRepositoryProvider)
        .setDarkModePreference(isDarkMode);

    state = isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(
  ThemeModeNotifier.new,
);
