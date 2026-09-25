import '../models/world_object.dart';

/// Panels of the GM screen, in their default order.
enum GmPanel { encounter, pinned, notes, dice, tables, conditions, rules }

/// What a world's GM screen holds: pinned entries and tables, the
/// session notes and which panels are hidden. One object per world
/// ([WorldObjectTypes.gmScreen]); missing or garbled data reads as empty.
class GmScreenState {
  final List<String> pinnedEntities;
  final List<String> pinnedTables;
  final String notes;
  final Set<GmPanel> hidden;

  const GmScreenState({
    this.pinnedEntities = const [],
    this.pinnedTables = const [],
    this.notes = '',
    this.hidden = const {},
  });

  static List<String> _ids(Object? raw) => [
        if (raw is List)
          for (final id in raw)
            if (id is String && id.isNotEmpty) id
      ];

  factory GmScreenState.fromObject(WorldObject? object) {
    final data = object?.data ?? const {};
    final hidden = data['hidden'];
    return GmScreenState(
      pinnedEntities: _ids(data['pinnedEntities']),
      pinnedTables: _ids(data['pinnedTables']),
      notes: data['notes'] is String ? data['notes'] as String : '',
      hidden: {
        if (hidden is List)
          for (final name in hidden)
            if (GmPanel.values.where((p) => p.name == name).firstOrNull
                case final GmPanel panel)
              panel
      },
    );
  }

  Map<String, Object?> toData() => {
        'pinnedEntities': pinnedEntities,
        'pinnedTables': pinnedTables,
        'notes': notes,
        'hidden': [for (final p in hidden) p.name],
      };

  GmScreenState copyWith({
    List<String>? pinnedEntities,
    List<String>? pinnedTables,
    String? notes,
    Set<GmPanel>? hidden,
  }) =>
      GmScreenState(
        pinnedEntities: pinnedEntities ?? this.pinnedEntities,
        pinnedTables: pinnedTables ?? this.pinnedTables,
        notes: notes ?? this.notes,
        hidden: hidden ?? this.hidden,
      );
}
