import '../../core/utils/ids.dart';
import '../models/entity.dart';
import '../models/entity_kind.dart';
import 'world_date.dart';

/// An era: a named span of history.
class TimelineEra {
  final Entity entity;
  final WorldDate? start;
  final WorldDate? end;

  /// Events inside the era, in order.
  final List<TimelineEvent> events;

  TimelineEra(this.entity, this.start, this.end) : events = [];

  /// Whether [date] falls inside the era's known bounds.
  bool contains(WorldDate date) =>
      start != null &&
      !(date < start!) &&
      (end == null || date <= end! || date.year == end!.year);
}

/// A dated (or era-placed) event.
class TimelineEvent {
  final Entity entity;
  final WorldDate? date;
  const TimelineEvent(this.entity, this.date);
}

/// The world's history, assembled from its eras and events.
class Timeline {
  /// Eras in order of their start (undated eras last, by name).
  final List<TimelineEra> eras;

  /// Dated events outside every era, in order.
  final List<TimelineEvent> loose;

  /// Events and eras without a readable date and no era to place them in.
  final List<Entity> undated;

  const Timeline(
      {required this.eras, required this.loose, required this.undated});

  bool get isEmpty => eras.isEmpty && loose.isEmpty && undated.isEmpty;

  /// Every dated point, for the overview strip.
  Iterable<WorldDate> get dates sync* {
    for (final era in eras) {
      if (era.start != null) yield era.start!;
      if (era.end != null) yield era.end!;
      for (final e in era.events) {
        if (e.date != null) yield e.date!;
      }
    }
    for (final e in loose) {
      if (e.date != null) yield e.date!;
    }
  }

  /// Builds the timeline from a world's entries. An event belongs to the
  /// era its "era" field names; otherwise to the era whose span holds its
  /// date. Events with an era but no date keep their era (listed after
  /// its dated events).
  static Timeline build(Iterable<Entity> entities,
      {WorldCalendar calendar = WorldCalendar.gregorian}) {
    WorldDate? read(Entity e, String key) =>
        parseWorldDate(e.attributes[key]?.toString(), calendar: calendar);

    final eras = <TimelineEra>[];
    final events = <TimelineEvent>[];
    final undated = <Entity>[];
    for (final e in entities) {
      if (e.isDeleted) continue;
      switch (e.kind) {
        case EntityKind.era:
          eras.add(TimelineEra(e, read(e, 'startDate'), read(e, 'endDate')));
        case EntityKind.event:
          events.add(TimelineEvent(e, read(e, 'date')));
        default:
          break;
      }
    }
    eras.sort((a, b) {
      if (a.start == null || b.start == null) {
        if (a.start != b.start) return a.start == null ? 1 : -1;
        return a.entity.name.compareTo(b.entity.name);
      }
      return a.start!.compareTo(b.start!);
    });
    final eraById = {for (final era in eras) era.entity.id: era};

    final loose = <TimelineEvent>[];
    for (final event in events) {
      final ref = event.entity.attributes['era']?.toString();
      final named = ref != null && ref.startsWith(entityRefPrefix)
          ? eraById[ref.substring(entityRefPrefix.length)]
          : null;
      final era = named ??
          (event.date == null
              ? null
              : eras.where((e) => e.contains(event.date!)).firstOrNull);
      if (era != null) {
        era.events.add(event);
      } else if (event.date != null) {
        loose.add(event);
      } else {
        undated.add(event.entity);
      }
    }

    int byDate(TimelineEvent a, TimelineEvent b) {
      if (a.date == null || b.date == null) {
        if (a.date != b.date) return a.date == null ? 1 : -1;
        return a.entity.name.compareTo(b.entity.name);
      }
      final c = a.date!.compareTo(b.date!);
      return c != 0 ? c : a.entity.name.compareTo(b.entity.name);
    }

    for (final era in eras) {
      era.events.sort(byDate);
    }
    loose.sort(byDate);
    // Undated eras with nothing in them are still worth listing (so the
    // user can date them); they stay in [eras], ordered last.
    undated.sort((a, b) => a.name.compareTo(b.name));
    return Timeline(eras: eras, loose: loose, undated: undated);
  }
}
