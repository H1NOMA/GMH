import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/l10n_ext.dart';
import '../../app/providers.dart';
import '../../app/template_l10n.dart';
import '../../app/router.dart';
import '../../app/theme/gmh_theme.dart';
import '../../domain/models/entity.dart';
import '../../domain/models/entity_kind.dart';
import '../../domain/models/link.dart';
import '../../domain/repositories/repositories.dart';
import '../entities/widgets/new_entity_dialog.dart';
import '../shell/ui_providers.dart';

/// Campaign manager: campaigns with their quest board and session log.
/// Campaigns, quests and sessions are ordinary entities — everything here
/// (links, search, graph, export) is shared machinery.
class CampaignsScreen extends ConsumerStatefulWidget {
  final String worldId;
  const CampaignsScreen({super.key, required this.worldId});

  @override
  ConsumerState<CampaignsScreen> createState() => _CampaignsScreenState();
}

class _CampaignsScreenState extends ConsumerState<CampaignsScreen> {
  String? _selectedCampaignId;

  @override
  Widget build(BuildContext context) {
    final campaigns = ref
            .watch(entityListProvider((
              worldId: widget.worldId,
              kind: EntityKind.campaign,
              customCategoryId: null,
              tagId: null,
              favoritesOnly: false,
              sort: EntitySort.updatedDesc,
            )))
            .valueOrNull ??
        [];

    final selected = campaigns
            .where((c) => c.id == _selectedCampaignId)
            .firstOrNull ??
        campaigns.firstOrNull;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.campaignsTitle),
        actions: [
          if (campaigns.length > 1)
            PopupMenuButton<String>(
              tooltip: context.l10n.switchCampaign,
              icon: const Icon(Icons.unfold_more),
              onSelected: (id) => setState(() => _selectedCampaignId = id),
              itemBuilder: (context) => [
                for (final campaign in campaigns)
                  PopupMenuItem(
                      value: campaign.id, child: Text(campaign.name)),
              ],
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'newCampaignItem',
        icon: const Icon(Icons.add),
        label: Text(context.l10n.newButton),
        onPressed: () => showNewEntityDialog(context, ref, widget.worldId,
            initialKind:
                selected == null ? EntityKind.campaign : EntityKind.quest),
      ),
      body: campaigns.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.map_outlined,
                      size: 48,
                      color: GmhColors.ember.withValues(alpha: 0.5)),
                  const SizedBox(height: 12),
                  Text(context.l10n.noCampaigns),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () => showNewEntityDialog(
                        context, ref, widget.worldId,
                        initialKind: EntityKind.campaign),
                    child: Text(context.l10n.startCampaign),
                  ),
                ],
              ),
            )
          : selected == null
              ? const SizedBox.shrink()
              : _CampaignDashboard(
                  key: ValueKey(selected.id),
                  worldId: widget.worldId,
                  campaign: selected,
                ),
    );
  }
}

class _CampaignDashboard extends ConsumerWidget {
  final String worldId;
  final Entity campaign;

  const _CampaignDashboard(
      {super.key, required this.worldId, required this.campaign});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Quests/sessions linked to this campaign via their `campaign` attribute
    // (mirrored as partOf links with the campaign as target).
    final incoming =
        ref.watch(incomingLinksProvider(campaign.id)).valueOrNull ?? [];
    final memberIds = incoming
        .where((l) => l.role == LinkRoles.partOf)
        .map((l) => l.sourceId)
        .toSet();

    final quests = ref
            .watch(entityListProvider((
              worldId: worldId,
              kind: EntityKind.quest,
              customCategoryId: null,
              tagId: null,
              favoritesOnly: false,
              sort: EntitySort.updatedDesc,
            )))
            .valueOrNull
            ?.where((q) => memberIds.contains(q.id))
            .toList() ??
        [];
    final sessions = ref
            .watch(entityListProvider((
              worldId: worldId,
              kind: EntityKind.session,
              customCategoryId: null,
              tagId: null,
              favoritesOnly: false,
              sort: EntitySort.createdDesc,
            )))
            .valueOrNull
            ?.where((s) => memberIds.contains(s.id))
            .toList() ??
        [];

    final players =
        (campaign.attributes['players'] as List?)?.cast<Object?>() ?? [];
    final status = campaign.attributes['status'] as String? ?? 'Planning';
    final chapter = campaign.attributes['currentChapter'] as String? ?? '';

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 96),
      children: [
        Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: () => context.go(Routes.entity(worldId, campaign.id)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(campaign.name,
                            style:
                                Theme.of(context).textTheme.headlineSmall),
                      ),
                      Chip(
                        label: Text(trTemplate(context, status),
                            style: const TextStyle(fontSize: 11.5)),
                        visualDensity: VisualDensity.compact,
                      ),
                    ],
                  ),
                  if (campaign.summary.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(campaign.summary,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 14,
                    runSpacing: 4,
                    children: [
                      if (chapter.isNotEmpty)
                        _MetaItem(
                            icon: Icons.bookmark_outline,
                            text: context.l10n.chapterLabel(chapter)),
                      _MetaItem(
                          icon: Icons.group_outlined,
                          text: players.isEmpty
                              ? context.l10n.noPlayers
                              : players.join(', ')),
                      _MetaItem(
                          icon: Icons.flag_outlined,
                          text: context.l10n.questsCount(quests.length)),
                      _MetaItem(
                          icon: Icons.event_note_outlined,
                          text:
                              context.l10n.sessionsCount(sessions.length)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(context.l10n.questBoard,
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        if (quests.isEmpty)
          Text(context.l10n.noQuestsLinked,
              style: const TextStyle(
                  fontSize: 12.5, color: GmhColors.parchmentDim))
        else
          _QuestBoard(worldId: worldId, quests: quests),
        const SizedBox(height: 24),
        Text(context.l10n.sessionLog,
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 10),
        if (sessions.isEmpty)
          Text(context.l10n.noSessions,
              style: const TextStyle(
                  fontSize: 12.5, color: GmhColors.parchmentDim))
        else
          for (final session in sessions)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _SessionCard(worldId: worldId, session: session),
            ),
      ],
    );
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const _MetaItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: GmhColors.parchmentDim),
        const SizedBox(width: 4),
        Text(text,
            style: const TextStyle(
                fontSize: 12, color: GmhColors.parchmentDim)),
      ],
    );
  }
}

const _questStatusOrder = [
  'Active',
  'Available',
  'Idea',
  'Completed',
  'Failed',
  'Abandoned',
];

Color _questStatusColor(String status) => switch (status) {
      'Active' => GmhColors.ember,
      'Available' => GmhColors.success,
      'Completed' => GmhColors.parchmentFaint,
      'Failed' || 'Abandoned' => GmhColors.danger,
      _ => GmhColors.arcane,
    };

class _QuestBoard extends StatelessWidget {
  final String worldId;
  final List<Entity> quests;

  const _QuestBoard({required this.worldId, required this.quests});

  @override
  Widget build(BuildContext context) {
    final byStatus = <String, List<Entity>>{};
    for (final quest in quests) {
      final status = quest.attributes['status'] as String? ?? 'Idea';
      byStatus.putIfAbsent(status, () => []).add(quest);
    }
    final statuses = [
      ..._questStatusOrder.where(byStatus.containsKey),
      ...byStatus.keys.where((s) => !_questStatusOrder.contains(s)),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final status in statuses) ...[
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 6),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _questStatusColor(status),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 7),
                Text(trTemplate(context, status),
                    style: const TextStyle(
                        fontSize: 12.5, fontWeight: FontWeight.w600)),
                const SizedBox(width: 6),
                Text('${byStatus[status]!.length}',
                    style: const TextStyle(
                        fontSize: 12, color: GmhColors.parchmentFaint)),
              ],
            ),
          ),
          for (final quest in byStatus[status]!)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _QuestCard(worldId: worldId, quest: quest),
            ),
        ],
      ],
    );
  }
}

class _QuestCard extends ConsumerWidget {
  final String worldId;
  final Entity quest;

  const _QuestCard({required this.worldId, required this.quest});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final objectives = (quest.attributes['objectives'] as List?)
            ?.whereType<Map>()
            .toList() ??
        [];
    final done = objectives.where((o) => o['done'] == true).length;

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          ref.read(searchRepositoryProvider).recordOpened(quest.id);
          context.go(Routes.entity(worldId, quest.id));
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(EntityKind.quest.icon,
                      size: 17, color: EntityKind.quest.color),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(quest.name,
                        style: Theme.of(context).textTheme.titleMedium),
                  ),
                  if (objectives.isNotEmpty)
                    Text('$done/${objectives.length}',
                        style: const TextStyle(
                            fontSize: 12, color: GmhColors.parchmentDim)),
                ],
              ),
              if (quest.summary.isNotEmpty) ...[
                const SizedBox(height: 3),
                Text(quest.summary,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall),
              ],
              if (objectives.isNotEmpty) ...[
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: objectives.isEmpty ? 0 : done / objectives.length,
                    minHeight: 4,
                    backgroundColor: GmhColors.surfaceHigh,
                    color: _questStatusColor(
                        quest.attributes['status'] as String? ?? 'Idea'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SessionCard extends ConsumerWidget {
  final String worldId;
  final Entity session;

  const _SessionCard({required this.worldId, required this.session});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = session.attributes['date'] as String? ?? '';
    return Card(
      child: ListTile(
        leading: Icon(EntityKind.session.icon,
            size: 20, color: EntityKind.session.color),
        title: Text(session.name),
        subtitle: Text(
          [
            if (date.isNotEmpty) date.split('T').first,
            if (session.summary.isNotEmpty) session.summary,
          ].join(' — '),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(Icons.chevron_right, size: 18),
        onTap: () {
          ref.read(searchRepositoryProvider).recordOpened(session.id);
          context.go(Routes.entity(worldId, session.id));
        },
      ),
    );
  }
}
