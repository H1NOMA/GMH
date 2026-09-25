import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/l10n_ext.dart';
import '../../../app/providers.dart';
import '../../../app/router.dart';
import '../../../app/theme/gmh_theme.dart';
import '../../../app/tools.dart';
import '../../../domain/models/entity.dart';
import '../../../domain/models/entity_kind.dart';
import '../../../domain/models/world_object.dart';
import '../../../domain/repositories/repositories.dart';
import '../../../domain/timeline/timeline.dart';
import '../../../domain/timeline/world_date.dart';
import '../../shell/ui_providers.dart';
import '../tool_scaffold.dart';

/// The world's history: eras as chapters, events in date order inside
/// them, an overview strip on top, and the entries still missing a date.
/// Dates are the free-text in-world dates of Events and Eras, read with
/// the world's own calendar (month names, year suffix).
class TimelineScreen extends ConsumerStatefulWidget {
  final String worldId;

  const TimelineScreen({super.key, required this.worldId});

  @override
  ConsumerState<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends ConsumerState<TimelineScreen> {
  final _eraKeys = <String, GlobalKey>{};

  List<Entity> _entries(EntityKind kind) =>
      ref
          .watch(entityListProvider((
            worldId: widget.worldId,
            kind: kind,
            customCategoryId: null,
            tagId: null,
            favoritesOnly: false,
            sort: EntitySort.nameAsc,
          )))
          .valueOrNull ??
      const [];

  WorldObject? _calendarObject() => (ref
              .watch(worldObjectsProvider((
                worldId: widget.worldId,
                type: WorldObjectTypes.calendar,
                parentId: null,
              )))
              .valueOrNull ??
          const <WorldObject>[])
      .firstOrNull;

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final calendarObject = _calendarObject();
    final calendar = WorldCalendar.fromData(calendarObject?.data);
    final timeline = Timeline.build(
        [..._entries(EntityKind.era), ..._entries(EntityKind.event)],
        calendar: calendar);
    String fmt(WorldDate d) => formatWorldDate(d, calendar);

    return ToolScaffold(
      toolId: 'timeline',
      actions: [
        IconButton(
          tooltip: l.timelineCalendar,
          icon: const Icon(Icons.calendar_month_outlined),
          onPressed: () => _editCalendar(calendarObject, calendar),
        ),
      ],
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'timelineNewEvent',
        icon: const Icon(Icons.add),
        label: Text(l.timelineNewEvent),
        onPressed: () => _newEvent(calendar),
      ),
      body: timeline.isEmpty
          ? ToolEmptyState(
              icon: toolById('timeline')!.icon,
              title: l.timelineEmptyTitle,
              hint: l.timelineEmptyHint,
            )
          : ListView(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
              children: [
                if (timeline.dates.length >= 2)
                  _Overview(
                    timeline: timeline,
                    onEra: (era) {
                      final key = _eraKeys[era.entity.id];
                      if (key?.currentContext != null) {
                        Scrollable.ensureVisible(key!.currentContext!,
                            duration: const Duration(milliseconds: 250));
                      }
                    },
                  ),
                for (final era in timeline.eras)
                  _EraSection(
                    key: _eraKeys.putIfAbsent(era.entity.id, GlobalKey.new),
                    worldId: widget.worldId,
                    era: era,
                    format: fmt,
                    onSetDate: (e) => _setDate(e, calendar),
                  ),
                if (timeline.loose.isNotEmpty)
                  _Section(
                    title: l.timelineOutsideEras,
                    children: [
                      for (final event in timeline.loose)
                        _EventTile(
                            worldId: widget.worldId,
                            event: event,
                            format: fmt,
                            onSetDate: (e) => _setDate(e, calendar)),
                    ],
                  ),
                if (timeline.undated.isNotEmpty)
                  _Section(
                    title: l.timelineUndated,
                    subtitle: l.timelineUndatedHint,
                    children: [
                      for (final entity in timeline.undated)
                        _EventTile(
                            worldId: widget.worldId,
                            event: TimelineEvent(entity, null),
                            format: fmt,
                            onSetDate: (e) => _setDate(e, calendar)),
                    ],
                  ),
              ],
            ),
    );
  }

  /// Asks for a date; null when cancelled. Warns (without blocking) when
  /// no year can be read from the text.
  Future<String?> _askDate(
      {required String title,
      String initial = '',
      TextEditingController? name,
      required WorldCalendar calendar}) async {
    final l = context.l10n;
    final date = TextEditingController(text: initial);
    ModalRoute<Object?>? route;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) {
        route ??= ModalRoute.of(context);
        return AlertDialog(
          title: Text(title),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (name != null) ...[
                  TextField(
                    controller: name,
                    autofocus: true,
                    decoration:
                        InputDecoration(labelText: l.timelineEventName),
                  ),
                  const SizedBox(height: 12),
                ],
                ListenableBuilder(
                  listenable: date,
                  builder: (context, _) => TextField(
                    controller: date,
                    autofocus: name == null,
                    decoration: InputDecoration(
                      labelText: l.timelineDateLabel,
                      hintText: l.timelineDateHint,
                      helperText: date.text.trim().isNotEmpty &&
                              parseWorldDate(date.text, calendar: calendar) ==
                                  null
                          ? l.timelineDateUnreadable
                          : null,
                      helperMaxLines: 2,
                    ),
                    onSubmitted: (_) => Navigator.pop(context, true),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l.cancel)),
            ListenableBuilder(
              listenable: name ?? date,
              builder: (context, _) => FilledButton(
                onPressed: name != null && name.text.trim().isEmpty
                    ? null
                    : () => Navigator.pop(context, true),
                child: Text(l.save),
              ),
            ),
          ],
        );
      },
    );
    final text = date.text.trim();
    route?.completed.whenComplete(date.dispose);
    return ok == true ? text : null;
  }

  Future<void> _newEvent(WorldCalendar calendar) async {
    final service = ref.read(entityServiceProvider);
    final router = GoRouter.of(context);
    final name = TextEditingController();
    final date = await _askDate(
        title: context.l10n.timelineNewEvent, name: name, calendar: calendar);
    final eventName = name.text.trim();
    WidgetsBinding.instance.addPostFrameCallback((_) => name.dispose());
    if (date == null || eventName.isEmpty) return;
    final result = await service.create(
      worldId: widget.worldId,
      kind: EntityKind.event,
      name: eventName,
      attributes: {if (date.isNotEmpty) 'date': date},
    );
    if (result.isOk) router.go(Routes.entity(widget.worldId, result.value.id));
  }

  Future<void> _setDate(Entity entity, WorldCalendar calendar) async {
    final service = ref.read(entityServiceProvider);
    final key = entity.kind == EntityKind.era ? 'startDate' : 'date';
    final date = await _askDate(
        title: '${context.l10n.timelineSetDate}: ${entity.name}',
        initial: entity.attributes[key]?.toString() ?? '',
        calendar: calendar);
    if (date == null) return;
    await service.setAttribute(entity.id, key, date);
  }

  Future<void> _editCalendar(WorldObject? existing, WorldCalendar current) async {
    final l = context.l10n;
    final objects = ref.read(worldObjectRepositoryProvider);
    final months = TextEditingController(
        text: current.isGregorian
            ? ''
            : [for (final m in current.months) '${m.name}: ${m.days}']
                .join('\n'));
    final suffix = TextEditingController(text: current.yearSuffix);
    ModalRoute<Object?>? route;
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) {
        route ??= ModalRoute.of(context);
        return AlertDialog(
          title: Text(l.timelineCalendar),
          content: SizedBox(
            width: 440,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l.timelineCalendarHint,
                      style: TextStyle(
                          fontSize: 12, color: GmhColors.parchmentDim)),
                  const SizedBox(height: 12),
                  TextField(
                    controller: months,
                    minLines: 4,
                    maxLines: 12,
                    decoration: InputDecoration(labelText: l.timelineMonths),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: suffix,
                    decoration:
                        InputDecoration(labelText: l.timelineYearSuffix),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(l.cancel)),
            FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(l.save)),
          ],
        );
      },
    );
    final monthText = months.text;
    final suffixText = suffix.text.trim();
    route?.completed.whenComplete(() {
      months.dispose();
      suffix.dispose();
    });
    if (ok != true) return;
    final data = WorldCalendar.fromData({
      'months': [
        for (final line in monthText.split('\n'))
          if (line.trim().isNotEmpty)
            {
              'name': line.split(':').first.trim(),
              'days': int.tryParse(
                      line.contains(':') ? line.split(':').last.trim() : '') ??
                  30,
            }
      ],
      'yearSuffix': suffixText,
    }).toData();
    if (existing == null) {
      await objects.create(
          worldId: widget.worldId, type: WorldObjectTypes.calendar, data: data);
    } else {
      await objects.update(existing.copyWith(data: data));
    }
  }
}

/// The whole history at a glance: era bands and event ticks on one line;
/// tapping a band scrolls to that era.
class _Overview extends StatelessWidget {
  final Timeline timeline;
  final void Function(TimelineEra era) onEra;

  const _Overview({required this.timeline, required this.onEra});

  @override
  Widget build(BuildContext context) {
    final years = [for (final d in timeline.dates) d.year];
    final min = years.reduce((a, b) => a < b ? a : b);
    final max = years.reduce((a, b) => a > b ? a : b);
    final span = (max - min).clamp(1, 1 << 30);
    final eraColor = EntityKind.era.color;
    final eventColor = EntityKind.event.color;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 34,
            child: LayoutBuilder(builder: (context, constraints) {
              final width = constraints.maxWidth;
              double x(int year) => (year - min) / span * width;
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 16,
                    child: Container(height: 2, color: GmhColors.border),
                  ),
                  for (final (i, era) in timeline.eras.indexed)
                    if (era.start != null)
                      Positioned(
                        left: x(era.start!.year),
                        width: (x(era.end?.year ?? max) - x(era.start!.year))
                            .clamp(6.0, width),
                        top: 8,
                        height: 18,
                        child: Tooltip(
                          message: era.entity.name,
                          child: InkWell(
                            onTap: () => onEra(era),
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              decoration: BoxDecoration(
                                color: eraColor.withValues(
                                    alpha: i.isEven ? 0.28 : 0.16),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(
                                    color: eraColor.withValues(alpha: 0.6)),
                              ),
                            ),
                          ),
                        ),
                      ),
                  for (final date in [
                    for (final era in timeline.eras)
                      for (final e in era.events)
                        if (e.date != null) e.date!,
                    for (final e in timeline.loose) e.date!,
                  ])
                    Positioned(
                      left: x(date.year) - 1.5,
                      top: 4,
                      width: 3,
                      height: 26,
                      child: ColoredBox(color: eventColor),
                    ),
                ],
              );
            }),
          ),
          Row(
            children: [
              Text('$min',
                  style: TextStyle(
                      fontSize: 11, color: GmhColors.parchmentFaint)),
              const Spacer(),
              Text('$max',
                  style: TextStyle(
                      fontSize: 11, color: GmhColors.parchmentFaint)),
            ],
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> children;

  const _Section({required this.title, this.subtitle, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          if (subtitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(subtitle!,
                  style: TextStyle(
                      fontSize: 12, color: GmhColors.parchmentDim)),
            ),
          const SizedBox(height: 8),
          ...children,
        ],
      ),
    );
  }
}

class _EraSection extends StatelessWidget {
  final String worldId;
  final TimelineEra era;
  final String Function(WorldDate) format;
  final void Function(Entity) onSetDate;

  const _EraSection({
    super.key,
    required this.worldId,
    required this.era,
    required this.format,
    required this.onSetDate,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final span = era.start == null
        ? null
        : l.timelineEraSpan(format(era.start!),
            era.end == null ? l.timelineOngoing : format(era.end!));
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: InkWell(
              borderRadius: BorderRadius.circular(14),
              onTap: () => context.go(Routes.entity(worldId, era.entity.id)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 8, 12),
                child: Row(
                  children: [
                    Icon(EntityKind.era.icon, color: EntityKind.era.color),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(era.entity.name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleLarge),
                          Text(
                            [
                              ?span,
                              l.timelineEventsCount(era.events.length),
                            ].join(' · '),
                            style: TextStyle(
                                fontSize: 12, color: GmhColors.parchmentDim),
                          ),
                          if (era.entity.summary.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(era.entity.summary,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 12.5,
                                      fontStyle: FontStyle.italic,
                                      color: GmhColors.parchmentDim)),
                            ),
                        ],
                      ),
                    ),
                    if (era.start == null)
                      TextButton(
                        onPressed: () => onSetDate(era.entity),
                        child: Text(l.timelineSetDate),
                      ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          for (final event in era.events)
            _EventTile(
                worldId: worldId,
                event: event,
                format: format,
                onSetDate: onSetDate),
        ],
      ),
    );
  }
}

/// One event on the rail: its date on the left (above on narrow
/// screens), a dot on the line, the entry card on the right.
class _EventTile extends ConsumerWidget {
  final String worldId;
  final TimelineEvent event;
  final String Function(WorldDate) format;
  final void Function(Entity) onSetDate;

  const _EventTile({
    required this.worldId,
    required this.event,
    required this.format,
    required this.onSetDate,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entity = event.entity;
    final date = event.date == null ? null : format(event.date!);
    final color = entity.kind.color;
    final card = Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: () {
          ref.read(searchRepositoryProvider).recordOpened(entity.id);
          context.go(Routes.entity(worldId, entity.id));
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 10, 6, 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(entity.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall),
                    if (entity.summary.isNotEmpty)
                      Text(entity.summary,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 12, color: GmhColors.parchmentDim)),
                  ],
                ),
              ),
              if (date == null)
                TextButton(
                  onPressed: () => onSetDate(entity),
                  child: Text(context.l10n.timelineSetDate),
                ),
            ],
          ),
        ),
      ),
    );

    return LayoutBuilder(builder: (context, constraints) {
      final narrow = constraints.maxWidth < 560;
      final dateText = Text(
        date ?? '—',
        textAlign: narrow ? TextAlign.start : TextAlign.end,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: date == null ? GmhColors.parchmentFaint : color),
      );
      if (narrow) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
                padding: const EdgeInsets.only(left: 4, bottom: 2),
                child: dateText),
            card,
          ],
        );
      }
      return IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
                width: 150,
                child: Padding(
                    padding: const EdgeInsets.only(top: 14), child: dateText)),
            SizedBox(
              width: 28,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Positioned.fill(
                    child: Center(
                      child: Container(width: 2, color: GmhColors.border),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration:
                          BoxDecoration(color: color, shape: BoxShape.circle),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(child: card),
          ],
        ),
      );
    });
  }
}
