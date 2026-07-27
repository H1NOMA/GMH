import 'package:flutter/material.dart';

import '../../../app/template_l10n.dart';
import '../../../app/theme/gmh_theme.dart';
import '../../../domain/models/custom_category.dart';
import '../../../domain/models/entity.dart';
import '../../../domain/models/entity_kind.dart';
import '../../../domain/models/entity_template.dart';

/// A small context chip shown on section cells.
class ContextBadge {
  final String text;
  final Color color;
  const ContextBadge(this.text, this.color);
}

/// Which attribute keys each section surfaces on its cells — the list card
/// shows what matters for that kind of entry: a character's status and
/// class, an item's rarity, a quest's state, a location's type…
const _badgeKeysByKind = <EntityKind, List<String>>{
  EntityKind.character: ['status', 'race', 'characterClass'],
  EntityKind.location: ['locationType', 'population'],
  EntityKind.item: ['itemType', 'rarity'],
  EntityKind.creature: ['creatureType', 'challenge', 'size'],
  EntityKind.faction: ['factionType'],
  EntityKind.event: ['date'],
  EntityKind.era: ['startDate', 'endDate'],
  EntityKind.religion: ['domains'],
  EntityKind.magicSystem: ['level', 'school', 'castingTime'],
  EntityKind.technology: ['techLevel'],
  EntityKind.concept: ['category'],
  EntityKind.loreDocument: ['chapterNumber'],
  EntityKind.campaign: ['status', 'currentChapter'],
  EntityKind.quest: ['status'],
  EntityKind.session: ['date'],
  EntityKind.custom: ['subtype'],
};

const _positiveValues = {'Alive', 'Active', 'Completed'};
const _negativeValues = {'Dead', 'Failed', 'Abandoned'};

/// Labels that benefit from a prefix so a bare number reads correctly.
const _prefixedKeys = {
  'challenge': 'CR ',
  'chapterNumber': '№',
};

/// Builds the context chips for one cell. For custom sections the
/// category's blueprint decides: its first select/text fields are shown.
List<ContextBadge> contextBadges(
  BuildContext context,
  Entity entity, {
  CustomCategory? category,
  int limit = 3,
}) {
  final keys = <String>[];
  if (entity.kind == EntityKind.custom &&
      category != null &&
      category.blueprint.fields.isNotEmpty) {
    keys.addAll(category.blueprint.fields
        .where((f) =>
            f.type == FieldType.select ||
            f.type == FieldType.text ||
            f.type == FieldType.number)
        .map((f) => f.key));
  } else {
    keys.addAll(_badgeKeysByKind[entity.kind] ?? const []);
  }

  final badges = <ContextBadge>[];
  for (final key in keys) {
    if (badges.length >= limit) break;
    final raw = entity.attributes[key];
    String text;
    if (raw == null) continue;
    if (raw is List) {
      if (raw.isEmpty) continue;
      text = raw.first.toString();
    } else {
      text = raw.toString().trim();
    }
    if (text.isEmpty || text.startsWith('entity:')) continue;
    if (text.length > 28) text = '${text.substring(0, 28)}…';

    final color = _positiveValues.contains(text)
        ? GmhColors.success
        : _negativeValues.contains(text)
            ? GmhColors.danger
            : GmhColors.parchmentDim;
    badges.add(ContextBadge(
        '${_prefixedKeys[key] ?? ''}${trTemplate(context, text)}', color));
  }
  return badges;
}

/// Renders the chips row (empty widget when there is nothing to show).
class ContextBadgesRow extends StatelessWidget {
  final Entity entity;
  final CustomCategory? category;

  const ContextBadgesRow({super.key, required this.entity, this.category});

  @override
  Widget build(BuildContext context) {
    final badges = contextBadges(context, entity, category: category);
    if (badges.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(top: 5),
      child: Wrap(
        spacing: 4,
        runSpacing: 4,
        children: [
          for (final badge in badges)
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: badge.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
                border:
                    Border.all(color: badge.color.withValues(alpha: 0.4)),
              ),
              child: Text(badge.text,
                  style: TextStyle(fontSize: 10.5, color: badge.color)),
            ),
        ],
      ),
    );
  }
}
