import 'package:flutter/material.dart';

import '../../../app/template_l10n.dart';
import '../../../app/theme/gmh_theme.dart';
import '../../../domain/models/entity.dart';
import '../../../domain/models/entity_kind.dart';

/// Read-only D&D-style stat card rendered above the editable form for
/// spells (Magic Systems), creatures and items — the classic TTG look:
/// the form below stays the editor, this is the presentation.
class StatBlock extends StatelessWidget {
  final Entity entity;
  const StatBlock({super.key, required this.entity});

  bool get _hasContent {
    const keys = {
      'level', 'school', 'castingTime', 'range', 'components', 'duration',
      'ac', 'hp', 'speed', 'strength', 'dexterity', 'constitution',
      'intelligence', 'wisdom', 'charisma', 'challenge',
      'itemType', 'rarity', 'weight', 'value', 'charges',
    };
    return entity.attributes.entries.any((e) =>
        keys.contains(e.key) &&
        e.value != null &&
        e.value.toString().trim().isNotEmpty);
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasContent) return const SizedBox.shrink();
    final rows = switch (entity.kind) {
      EntityKind.magicSystem => _spell(context),
      EntityKind.creature => _creature(context),
      EntityKind.item => _item(context),
      _ => const <Widget>[],
    };
    if (rows.isEmpty) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: GmhColors.ember.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: GmhColors.ember.withValues(alpha: 0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: rows,
      ),
    );
  }

  String? _s(String key) {
    final raw = entity.attributes[key];
    if (raw == null) return null;
    final text = raw is List ? raw.join(', ') : raw.toString().trim();
    return text.isEmpty ? null : text;
  }

  Widget _divider() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Container(height: 2, color: GmhColors.ember.withValues(alpha: 0.5)),
      );

  Widget _line(BuildContext context, String label, String value,
      {bool translateValue = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3),
      child: Text.rich(
        TextSpan(children: [
          TextSpan(
              text: '${trTemplate(context, label)}. ',
              style: const TextStyle(fontWeight: FontWeight.w700)),
          TextSpan(
              text: translateValue ? trTemplate(context, value) : value),
        ]),
        style: TextStyle(fontSize: 12.5, color: GmhColors.parchment, height: 1.35),
      ),
    );
  }

  Widget _italicHeader(BuildContext context, String text) => Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Text(text,
            style: TextStyle(
                fontSize: 12.5,
                fontStyle: FontStyle.italic,
                color: GmhColors.parchmentDim)),
      );

  // ------------------------------------------------------------- spell
  List<Widget> _spell(BuildContext context) {
    final level = _s('level');
    final school = _s('school');
    final rows = <Widget>[];
    if (level != null || school != null) {
      rows.add(_italicHeader(context, [
        if (level != null) trTemplate(context, level),
        if (school != null) trTemplate(context, school),
        if (_s('ritual') == 'Yes') trTemplate(context, 'Ritual'),
      ].join(' · ')));
      rows.add(_divider());
    }
    for (final (label, key) in [
      ('Casting Time', 'castingTime'),
      ('Range', 'range'),
      ('Components', 'components'),
      ('Duration', 'duration'),
      ('Save / Attack', 'saveAttack'),
      ('Damage / Effect', 'damageEffect'),
      ('Classes', 'classes'),
    ]) {
      final value = _s(key);
      if (value != null) rows.add(_line(context, label, value));
    }
    return rows.length <= 2 && _s('level') == null ? const [] : rows;
  }

  // ----------------------------------------------------------- creature
  List<Widget> _creature(BuildContext context) {
    final rows = <Widget>[];
    final meta = [
      if (_s('size') != null) trTemplate(context, _s('size')!),
      if (_s('creatureType') != null) trTemplate(context, _s('creatureType')!),
    ].join(' · ');
    if (meta.isNotEmpty) rows.add(_italicHeader(context, meta));
    if (rows.isNotEmpty) rows.add(_divider());

    for (final (label, key) in [
      ('Armor Class', 'ac'),
      ('Hit Points', 'hp'),
      ('Speed', 'speed'),
    ]) {
      final value = _s(key);
      if (value != null) rows.add(_line(context, label, value));
    }

    // Classic six-column ability grid with derived modifiers.
    const abilities = [
      ('STR', 'strength'),
      ('DEX', 'dexterity'),
      ('CON', 'constitution'),
      ('INT', 'intelligence'),
      ('WIS', 'wisdom'),
      ('CHA', 'charisma'),
    ];
    final present =
        abilities.where((a) => _s(a.$2) != null).toList();
    if (present.isNotEmpty) {
      rows.add(_divider());
      rows.add(Row(
        children: [
          for (final (label, key) in abilities)
            Expanded(
              child: Column(
                children: [
                  Text(trTemplate(context, label),
                      style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w700,
                          color: GmhColors.parchmentDim)),
                  const SizedBox(height: 2),
                  Text(_abilityText(key),
                      style: TextStyle(
                          fontSize: 12.5, color: GmhColors.parchment)),
                ],
              ),
            ),
        ],
      ));
    }

    final tail = <Widget>[];
    for (final (label, key) in [
      ('Saving Throws', 'savingThrows'),
      ('Skills', 'skills'),
      ('Damage Resistances', 'resistances'),
      ('Damage Immunities', 'immunities'),
      ('Condition Immunities', 'conditionImmunities'),
      ('Senses', 'senses'),
      ('Languages', 'languages'),
    ]) {
      final value = _s(key);
      if (value != null) tail.add(_line(context, label, value));
    }
    final challenge = _s('challenge');
    if (challenge != null) {
      tail.add(_line(context, 'Challenge Rating', challenge));
    }
    if (tail.isNotEmpty) {
      rows.add(_divider());
      rows.addAll(tail);
    }
    return rows;
  }

  String _abilityText(String key) {
    final raw = _s(key);
    if (raw == null) return '—';
    final score = num.tryParse(raw);
    if (score == null) return raw;
    final mod = ((score - 10) / 2).floor();
    return '$raw (${mod >= 0 ? '+' : ''}$mod)';
  }

  // --------------------------------------------------------------- item
  List<Widget> _item(BuildContext context) {
    final rows = <Widget>[];
    final meta = [
      if (_s('itemType') != null) trTemplate(context, _s('itemType')!),
      if (_s('rarity') != null) trTemplate(context, _s('rarity')!),
    ].join(' · ');
    if (meta.isNotEmpty) {
      rows.add(_italicHeader(context, meta));
      rows.add(_divider());
    }
    for (final (label, key) in [
      ('Attunement', 'attunement'),
      ('Weight', 'weight'),
      ('Value', 'value'),
      ('Charges', 'charges'),
    ]) {
      final value = _s(key);
      if (value != null) rows.add(_line(context, label, value));
    }
    // Meta line alone is already shown as chips on cards; only render the
    // block when it adds detail.
    return rows.length <= 2 ? const [] : rows;
  }
}
