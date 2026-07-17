import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/repositories/repositories.dart';
import 'providers.dart';

/// Selected app locale. `null` = follow the system language (the default on
/// first launch — so a Russian system gets Russian automatically, because
/// Flutter resolves against `supportedLocales` [en, ru]).
///
/// The explicit choice persists in the local settings table; `main()` seeds
/// the controller before the first frame.
final localeControllerProvider =
    NotifierProvider<LocaleController, Locale?>(LocaleController.new);

class LocaleController extends Notifier<Locale?> {
  @override
  Locale? build() => null;

  /// Applies a persisted value at startup without writing it back.
  void seed(Locale locale) => state = locale;

  /// [locale] = null resets to the system language.
  Future<void> setLocale(Locale? locale) async {
    state = locale;
    final settings = ref.read(settingsRepositoryProvider);
    if (locale == null) {
      await settings.remove(SettingsKeys.appLocale);
    } else {
      await settings.set(SettingsKeys.appLocale, locale.languageCode);
    }
  }
}

/// Parses the persisted setting value into a [Locale].
Locale? localeFromSetting(String? value) => switch (value) {
      'en' => const Locale('en'),
      'ru' => const Locale('ru'),
      _ => null,
    };
