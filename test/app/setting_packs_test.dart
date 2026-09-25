import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gmh/app/packs/setting_packs.dart';
import 'package:gmh/app/theme/gmh_theme.dart';
import 'package:gmh/domain/models/entity_kind.dart';
import 'package:gmh/domain/models/world.dart';
import 'package:gmh/domain/services/templates/entity_templates.dart';
import 'package:gmh/l10n/app_localizations.dart';

const _languages = ['en', 'ru', 'de', 'fr', 'zh'];

final _builtInKinds =
    EntityKind.values.where((k) => k != EntityKind.custom).toList();

/// Every English section title, field label and stat-block heading a pack
/// may re-skin with a `t:` key.
final Set<String> _templateTerms = {
  for (final kind in EntityKind.values) ...[
    for (final section in EntityTemplates.of(kind).sections) ...[
      section.title,
      for (final field in section.fields) field.label,
    ],
  ],
};

void main() {
  test('every world style has exactly one pack', () {
    for (final style in WorldStyle.values) {
      expect(SettingPacks.all.where((p) => p.style == style), hasLength(1),
          reason: 'pack for $style');
    }
    expect(SettingPacks.all, hasLength(WorldStyle.values.length));
  });

  test('pack vocabularies cover every supported locale', () {
    final supported = AppLocalizations.supportedLocales
        .map((l) => l.languageCode)
        .toSet();
    expect(supported, containsAll(_languages));
    for (final pack in SettingPacks.all) {
      for (final lang in supported) {
        final vocab = pack.vocab[lang];
        expect(vocab, isNotNull, reason: '${pack.id}/$lang missing');
        expect(vocab!['name'], isNotEmpty, reason: '${pack.id}/$lang name');
        expect(vocab['hint'], isNotEmpty, reason: '${pack.id}/$lang hint');
      }
    }
  });

  test('re-skinned packs name every kind in every language', () {
    for (final pack in SettingPacks.all) {
      if (pack.style == WorldStyle.fantasy) continue; // base vocabulary
      final englishKeys = pack.vocab['en']!.keys.toSet();
      for (final lang in _languages) {
        final vocab = pack.vocab[lang]!;
        expect(vocab.keys.toSet(), englishKeys,
            reason: '${pack.id}/$lang must use the same keys as English');
        for (final kind in _builtInKinds) {
          expect(vocab['k.${kind.name}'], isNotEmpty,
              reason: '${pack.id}/$lang k.${kind.name}');
          final plural = vocab['kp.${kind.name}'];
          expect(plural, isNotEmpty,
              reason: '${pack.id}/$lang kp.${kind.name}');
          // Plurals are sidebar section titles in a 264px column.
          expect(plural!.length, lessThanOrEqualTo(24),
              reason: '${pack.id}/$lang kp.${kind.name} "$plural" too long');
        }
      }
    }
  });

  test('template skins only target real template terms', () {
    for (final pack in SettingPacks.all) {
      for (final entry in pack.vocab.entries) {
        for (final key in entry.value.keys.where((k) => k.startsWith('t:'))) {
          expect(_templateTerms, contains(key.substring(2)),
              reason: '${pack.id}/${entry.key}: "$key" is not a template term');
        }
      }
    }
  });

  group('palettes keep readable contrast', () {
    for (final pack in SettingPacks.all) {
      for (final brightness in Brightness.values) {
        test('${pack.id} ${brightness.name}', () {
          final p = pack.palette(brightness);
          expect(p.brightness, brightness);
          expect(contrastRatio(p.parchment, p.background),
              greaterThanOrEqualTo(7), reason: 'body text');
          expect(contrastRatio(p.parchment, p.surfaceHigh),
              greaterThanOrEqualTo(4.5), reason: 'body text on raised');
          expect(contrastRatio(p.parchmentDim, p.surfaceHigh),
              greaterThanOrEqualTo(4.5), reason: 'dim text');
          expect(contrastRatio(p.parchmentFaint, p.surfaceHigh),
              greaterThanOrEqualTo(3.0), reason: 'faint labels');
          expect(contrastRatio(p.ember, p.surface),
              greaterThanOrEqualTo(3.0), reason: 'accent on surface');
          expect(contrastRatio(p.onEmber, p.ember),
              greaterThanOrEqualTo(4.5), reason: 'text on accent');
          expect(contrastRatio(p.danger, p.surface),
              greaterThanOrEqualTo(3.0), reason: 'danger');
        });
      }
    }
  });

  test('themes build and are cached per palette', () {
    for (final pack in SettingPacks.all) {
      final theme = GmhStyle.themeFor(pack.style, Brightness.dark);
      expect(identical(theme, GmhStyle.themeFor(pack.style, Brightness.dark)),
          isTrue);
      expect(theme.colorScheme.primary, pack.dark.ember);
    }
  });
}
