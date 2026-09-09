import 'package:cinemapedia_app/presentation/providers/storage/local_storage_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DarkModeNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  Future<void> loadDarkMode() async {
    state = await ref.read(localStorageRepositoryProvider).isDarkMode();
  }

  Future<void> toggleDarkMode() async {
    await ref.read(localStorageRepositoryProvider).toggleDarkMode();
    state = !state;
  }
}

final isDarkModeProvider = NotifierProvider<DarkModeNotifier, bool>(
  DarkModeNotifier.new,
);
