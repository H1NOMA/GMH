import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/repositories/repositories.dart';
import 'providers.dart';

/// Selected theme mode; defaults to following the system. Persisted in the
/// local settings table; `main()` seeds it before the first frame.
final themeModeProvider =
    NotifierProvider<ThemeModeController, ThemeMode>(ThemeModeController.new);

class ThemeModeController extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  /// Applies a persisted value at startup without writing it back.
  void seed(ThemeMode mode) => state = mode;

  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    final settings = ref.read(settingsRepositoryProvider);
    if (mode == ThemeMode.system) {
      await settings.remove(SettingsKeys.themeMode);
    } else {
      await settings.set(SettingsKeys.themeMode, mode.name);
    }
  }
}

ThemeMode themeModeFromSetting(String? value) => switch (value) {
      'light' => ThemeMode.light,
      'dark' => ThemeMode.dark,
      _ => ThemeMode.system,
    };
