import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/l10n_ext.dart';
import '../../app/nav_state.dart';
import '../../app/providers.dart';
import '../../app/template_l10n.dart';
import '../../app/theme/gmh_theme.dart';
import '../../domain/models/document_model.dart';
import '../../domain/models/entity.dart';
import '../attachments/attachments_panel.dart';
import '../editor/lore_editor.dart';
import 'widgets/attribute_form.dart';
import 'widgets/relations_panel.dart';
import 'widgets/tag_editor.dart';

/// Full character profile: portrait header plus tabbed sections
/// (General, Biography, Statistics, Beliefs, Relationships, Inventory,
/// Abilities & Magic, Timeline, Notes). Every section is optional — empty
/// ones simply stay empty — and all data lives in the same entity
/// attributes/document as before, so existing characters open unchanged.
class CharacterProfile extends ConsumerStatefulWidget {
  final String worldId;
  final Entity entity;

  const CharacterProfile(
      {super.key, required this.worldId, required this.entity});

  @override
  ConsumerState<CharacterProfile> createState() => _CharacterProfileState();
}

class _CharacterProfileState extends ConsumerState<CharacterProfile>
    with SingleTickerProviderStateMixin {
  static const _tabCount = 9;

  late final TabController _tabController = TabController(
    length: _tabCount,
    vsync: this,
    // Restore the tab that was active when this profile was last open.
    initialIndex:
        ref.read(profileTabProvider(widget.entity.id)).clamp(0, _tabCount - 1),
  )..addListener(() {
      ref
          .read(profileTabProvider(widget.entity.id).notifier)
          .set(_tabController.index);
    });

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final worldId = widget.worldId;
    final entity = widget.entity;
    final tabs = <(String, Widget)>[
      (
        trTemplate(context, 'General Information'),
        _SectionList(children: [
          TagEditor(entity: entity),
          const SizedBox(height: 6),
          AttributeForm(
              entity: entity,
              sectionTitles: const ['General Information']),
        ]),
      ),
      (
        context.l10n.tabBiography,
        _BiographyTab(worldId: worldId, entity: entity),
      ),
      (
        trTemplate(context, 'Statistics'),
        _SectionList(children: [
          _AbilityScoreGrid(entity: entity),
          AttributeForm(entity: entity, sectionTitles: const ['Combat']),
        ]),
      ),
      (
        trTemplate(context, 'Beliefs'),
        _SectionList(children: [
          AttributeForm(
              entity: entity, sectionTitles: const ['Beliefs', 'Roleplay']),
        ]),
      ),
      (
        trTemplate(context, 'Relationships'),
        _SectionList(children: [
          AttributeForm(
              entity: entity, sectionTitles: const ['Relationships']),
          const SizedBox(height: 14),
          RelationsPanel(entity: entity),
        ]),
      ),
      (
        trTemplate(context, 'Inventory'),
        _SectionList(children: [
          AttributeForm(entity: entity, sectionTitles: const ['Inventory']),
        ]),
      ),
      (
        trTemplate(context, 'Abilities & Magic'),
        _SectionList(children: [
          AttributeForm(
              entity: entity, sectionTitles: const ['Abilities & Magic']),
        ]),
      ),
      (
        trTemplate(context, 'Timeline'),
        _SectionList(children: [
          AttributeForm(entity: entity, sectionTitles: const ['Timeline']),
        ]),
      ),
      (
        trTemplate(context, 'Notes'),
        _SectionList(children: [
          AttributeForm(entity: entity, sectionTitles: const ['Notes']),
          const SizedBox(height: 14),
          AttachmentsPanel(entity: entity),
        ]),
      ),
    ];

    assert(tabs.length == _tabCount);
    return Column(
      children: [
        _ProfileHeader(entity: entity),
        TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: [for (final (label, _) in tabs) Tab(text: label)],
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [for (final (_, view) in tabs) view],
          ),
        ),
      ],
    );
  }
}

// ------------------------------------------------------------------ header

class _ProfileHeader extends ConsumerWidget {
  final Entity entity;
  const _ProfileHeader({required this.entity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final race = entity.attributes['race'] as String? ?? '';
    final characterClass =
        entity.attributes['characterClass'] as String? ?? '';
    final title = entity.attributes['title'] as String? ?? '';
    final status = entity.attributes['status'] as String? ?? '';

    final subtitleParts = [
      if (title.isNotEmpty) title,
      if (race.isNotEmpty) race,
      if (characterClass.isNotEmpty) characterClass,
    ];

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 12),
      decoration: BoxDecoration(
        color: GmhColors.surface,
        border: Border(bottom: BorderSide(color: GmhColors.border)),
      ),
      child: Row(
        children: [
          _Portrait(entity: entity),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(entity.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.headlineSmall),
                if (subtitleParts.isNotEmpty)
                  Text(subtitleParts.join(' · '),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 12.5,
                          fontStyle: FontStyle.italic,
                          color: GmhColors.parchmentDim)),
                if (entity.summary.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(entity.summary,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 12, color: GmhColors.parchmentFaint)),
                  ),
              ],
            ),
          ),
          if (status.isNotEmpty)
            Chip(
              label: Text(trTemplate(context, status),
                  style: const TextStyle(fontSize: 11.5)),
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    );
  }
}

/// Portrait = the entity's cover image (set from any image attachment via
/// "Set as cover" on the Notes tab).
class _Portrait extends ConsumerWidget {
  final Entity entity;
  const _Portrait({required this.entity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coverId = entity.coverMediaId;
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: entity.kind.color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: entity.kind.color.withValues(alpha: 0.4)),
      ),
      clipBehavior: Clip.antiAlias,
      child: coverId == null
          ? Icon(entity.kind.icon, color: entity.kind.color, size: 30)
          : FutureBuilder<String?>(
              future: () async {
                final media =
                    await ref.read(mediaRepositoryProvider).get(coverId);
                if (media == null) return null;
                return ref
                    .read(mediaRepositoryProvider)
                    .absolutePath(media);
              }(),
              builder: (context, snapshot) {
                final path = snapshot.data;
                if (path == null) {
                  return Icon(entity.kind.icon,
                      color: entity.kind.color, size: 30);
                }
                return Image.file(File(path),
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => Icon(entity.kind.icon,
                        color: entity.kind.color, size: 30));
              },
            ),
    );
  }
}

// -------------------------------------------------------------------- tabs

class _SectionList extends StatelessWidget {
  final List<Widget> children;
  const _SectionList({required this.children});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 48),
      children: children,
    );
  }
}

class _BiographyTab extends ConsumerWidget {
  final String worldId;
  final Entity entity;

  const _BiographyTab({required this.worldId, required this.entity});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Load once: the editor owns the document while open.
    return FutureBuilder<DocumentModel>(
      future: ref.read(documentRepositoryProvider).getOrCreate(entity.id),
      builder: (context, snapshot) {
        final doc = snapshot.data;
        if (doc == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return LoreEditor(
          key: ValueKey('bio-${entity.id}'),
          worldId: worldId,
          entityId: entity.id,
          initialContentJson: doc.contentJson,
        );
      },
    );
  }
}

// ------------------------------------------------------------- stat grid

const _abilityKeys = [
  ('strength', 'STR'),
  ('dexterity', 'DEX'),
  ('constitution', 'CON'),
  ('intelligence', 'INT'),
  ('wisdom', 'WIS'),
  ('charisma', 'CHA'),
];

/// D&D-style ability score grid: six boxes with score and derived modifier.
/// Tap a box to edit the score.
class _AbilityScoreGrid extends ConsumerWidget {
  final Entity entity;
  const _AbilityScoreGrid({required this.entity});

  String _modifier(num score) {
    final mod = ((score - 10) / 2).floor();
    return mod >= 0 ? '+$mod' : '$mod';
  }

  Future<void> _edit(
      BuildContext context, WidgetRef ref, String key, String label) async {
    final current = entity.attributes[key];
    final controller =
        TextEditingController(text: current?.toString() ?? '');
    final saved = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(label),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          onSubmitted: (_) => Navigator.pop(context, true),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.l10n.cancel)),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(context.l10n.save)),
        ],
      ),
    );
    if (saved != true) return;
    final attributes = Map<String, Object?>.of(entity.attributes);
    final parsed = num.tryParse(controller.text.trim());
    if (parsed == null) {
      attributes.remove(key);
    } else {
      attributes[key] = parsed;
    }
    await ref
        .read(entityServiceProvider)
        .update(entity.copyWith(attributes: attributes));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(top: 14),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final columns = constraints.maxWidth > 560 ? 6 : 3;
          return GridView.count(
            crossAxisCount: columns,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.95,
            children: [
              for (final (key, label) in _abilityKeys)
                _AbilityBox(
                  label: trTemplate(context, label),
                  score: entity.attributes[key],
                  modifier: entity.attributes[key] is num
                      ? _modifier(entity.attributes[key] as num)
                      : null,
                  onTap: () => _edit(
                      context, ref, key, trTemplate(context, label)),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _AbilityBox extends StatelessWidget {
  final String label;
  final Object? score;
  final String? modifier;
  final VoidCallback onTap;

  const _AbilityBox({
    required this.label,
    required this.score,
    required this.modifier,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: GmhColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: GmhColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label,
                style: TextStyle(
                    fontSize: 10.5,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w700,
                    color: GmhColors.parchmentFaint)),
            const SizedBox(height: 2),
            Text(score?.toString() ?? '—',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  fontFamilyFallback: GmhTheme.serifFallback,
                  color: score == null
                      ? GmhColors.parchmentFaint
                      : GmhColors.parchment,
                )),
            if (modifier != null)
              Container(
                margin: const EdgeInsets.only(top: 2),
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 1),
                decoration: BoxDecoration(
                  color: GmhColors.ember.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(modifier!,
                    style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: GmhColors.emberBright)),
              ),
          ],
        ),
      ),
    );
  }
}
