import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/generators/generator_engine.dart';
import '../../../domain/models/world.dart';

/// The randomness behind every generator; tests override it with a seeded
/// or scripted source.
final generatorRandomProvider = Provider<Random>((ref) => Random.secure());

final generatorEngineProvider = Provider<GeneratorEngine>(
  (ref) => GeneratorEngine(random: ref.watch(generatorRandomProvider)),
);

/// How many replaced, unsaved results the session remembers.
const generatorHistoryLimit = 30;

/// One batch of names with the pack and language it was made in.
@immutable
class NameBatch {
  final String id;
  final WorldStyle style;
  final String language;
  final List<GeneratedName> names;

  const NameBatch({
    required this.id,
    required this.style,
    required this.language,
    required this.names,
  });
}

/// A result or a name batch that left the screen without being saved.
@immutable
class GeneratorHistoryEntry {
  final GeneratedResult? result;
  final NameBatch? names;

  const GeneratorHistoryEntry.result(GeneratedResult this.result)
    : names = null;
  const GeneratorHistoryEntry.names(NameBatch this.names) : result = null;

  String get id => result?.id ?? names!.id;
  GeneratorKind get kind => result?.kind ?? GeneratorKind.names;
  WorldStyle get style => result?.style ?? names!.style;
}

@immutable
class GeneratorsState {
  final GeneratorKind kind;

  /// The chosen pack; null follows the world's style.
  final WorldStyle? style;
  final NameGender gender;
  final int count;

  /// Naming style for the names generator; null mixes all of them.
  final String? cultureId;
  final bool epithets;

  /// The latest result per generator.
  final Map<GeneratorKind, GeneratedResult> current;

  /// Pinned results, oldest first.
  final List<GeneratedResult> kept;

  /// The latest names.
  final NameBatch? names;

  /// Newest first, at most [generatorHistoryLimit].
  final List<GeneratorHistoryEntry> history;

  /// Result ids and name keys ([nameKey]) already saved, with the id of
  /// the entity they became.
  final Map<String, String> saved;

  const GeneratorsState({
    this.kind = GeneratorKind.npc,
    this.style,
    this.gender = NameGender.any,
    this.count = 5,
    this.cultureId,
    this.epithets = false,
    this.current = const {},
    this.kept = const [],
    this.names,
    this.history = const [],
    this.saved = const {},
  });

  GeneratedResult? get currentResult => current[kind];

  bool isKept(String id) => kept.any((r) => r.id == id);

  static String nameKey(NameBatch batch, int index) => '${batch.id}#$index';

  GeneratorsState copyWith({
    GeneratorKind? kind,
    WorldStyle? style,
    bool clearStyle = false,
    NameGender? gender,
    int? count,
    String? cultureId,
    bool clearCulture = false,
    bool? epithets,
    Map<GeneratorKind, GeneratedResult>? current,
    List<GeneratedResult>? kept,
    NameBatch? names,
    List<GeneratorHistoryEntry>? history,
    Map<String, String>? saved,
  }) => GeneratorsState(
    kind: kind ?? this.kind,
    style: clearStyle ? null : style ?? this.style,
    gender: gender ?? this.gender,
    count: count ?? this.count,
    cultureId: clearCulture ? null : cultureId ?? this.cultureId,
    epithets: epithets ?? this.epithets,
    current: current ?? this.current,
    kept: kept ?? this.kept,
    names: names ?? this.names,
    history: history ?? this.history,
    saved: saved ?? this.saved,
  );
}

/// Session state of the generators tool for one world (kept while the app
/// runs, never written to the world until the user saves a result).
class GeneratorsController extends FamilyNotifier<GeneratorsState, String> {
  static int _batchSeq = 0;

  @override
  GeneratorsState build(String worldId) => const GeneratorsState();

  GeneratorEngine get _engine => ref.read(generatorEngineProvider);

  void select(GeneratorKind kind) => state = state.copyWith(kind: kind);

  void setStyle(WorldStyle? style) => state = style == null
      ? state.copyWith(clearStyle: true, clearCulture: true)
      : state.copyWith(style: style, clearCulture: true);

  void setGender(NameGender gender) => state = state.copyWith(gender: gender);

  void setCount(int count) => state = state.copyWith(count: count.clamp(1, 10));

  void setCulture(String? id) => state = id == null
      ? state.copyWith(clearCulture: true)
      : state.copyWith(cultureId: id);

  void setEpithets(bool on) => state = state.copyWith(epithets: on);

  /// Runs the selected generator in [style] and [language]; whatever it
  /// replaces goes to the history unless it was kept or saved.
  void generate(WorldStyle style, String language) {
    if (state.kind == GeneratorKind.names) {
      final batch = NameBatch(
        id: 'n${_batchSeq++}',
        style: style,
        language: language,
        names: _engine.names(
          style: style,
          language: language,
          gender: state.gender,
          count: state.count,
          cultureId: state.cultureId,
          epithets: state.epithets,
        ),
      );
      final old = state.names;
      state = state.copyWith(
        names: batch,
        history: old == null ? null : _pushNames(old),
      );
      return;
    }
    final result = _engine.generate(
      state.kind,
      style: style,
      language: language,
    );
    final old = state.current[state.kind];
    state = state.copyWith(
      current: {...state.current, state.kind: result},
      history: old == null ? null : _pushResult(old),
    );
  }

  void rerollField(String id, String fieldKey) =>
      _replace(id, (r) => _engine.rerollField(r, fieldKey));

  void rerollAll(String id) => _replace(id, _engine.rerollAll);

  void toggleKeep(String id) {
    final kept = state.kept;
    if (state.isKept(id)) {
      final result = kept.firstWhere((r) => r.id == id);
      final stillShown = state.current.values.any((r) => r.id == id);
      state = state.copyWith(
        kept: [
          for (final r in kept)
            if (r.id != id) r,
        ],
        history: stillShown ? null : _pushResult(result),
      );
      return;
    }
    final result = _find(id);
    if (result == null) return;
    state = state.copyWith(kept: [...kept, result]);
  }

  /// Removes a result from the screen (to the history unless saved).
  void dismiss(String id) {
    final result = _find(id);
    if (result == null) return;
    state = state.copyWith(
      current: {
        for (final e in state.current.entries)
          if (e.value.id != id) e.key: e.value,
      },
      kept: [
        for (final r in state.kept)
          if (r.id != id) r,
      ],
      history: _pushResult(result, force: true),
    );
  }

  void markSaved(String key, String entityId) =>
      state = state.copyWith(saved: {...state.saved, key: entityId});

  /// Brings a history entry back as the current result of its generator.
  void restore(String historyId) {
    final entry = state.history.where((e) => e.id == historyId).firstOrNull;
    if (entry == null) return;
    final rest = [
      for (final e in state.history)
        if (e.id != historyId) e,
    ];
    final result = entry.result;
    if (result != null) {
      final old = state.current[result.kind];
      state = state.copyWith(
        kind: result.kind,
        current: {...state.current, result.kind: result},
        history: old == null ? rest : _pushResult(old, into: rest),
      );
    } else {
      final old = state.names;
      state = state.copyWith(
        kind: GeneratorKind.names,
        names: entry.names,
        history: old == null ? rest : _pushNames(old, into: rest),
      );
    }
  }

  void clearHistory() => state = state.copyWith(history: const []);

  GeneratedResult? _find(String id) {
    for (final r in [...state.current.values, ...state.kept]) {
      if (r.id == id) return r;
    }
    return null;
  }

  void _replace(String id, GeneratedResult Function(GeneratedResult) update) {
    final result = _find(id);
    if (result == null) return;
    final next = update(result);
    state = state.copyWith(
      current: {
        for (final e in state.current.entries)
          e.key: e.value.id == id ? next : e.value,
      },
      kept: [for (final r in state.kept) r.id == id ? next : r],
    );
  }

  List<GeneratorHistoryEntry> _pushResult(
    GeneratedResult result, {
    List<GeneratorHistoryEntry>? into,
    bool force = false,
  }) {
    final history = into ?? state.history;
    final keep = !force && state.isKept(result.id);
    if (keep || state.saved.containsKey(result.id)) return history;
    return _cap([GeneratorHistoryEntry.result(result), ...history]);
  }

  List<GeneratorHistoryEntry> _pushNames(
    NameBatch batch, {
    List<GeneratorHistoryEntry>? into,
  }) {
    final history = into ?? state.history;
    final unsaved = [
      for (var i = 0; i < batch.names.length; i++)
        if (!state.saved.containsKey(GeneratorsState.nameKey(batch, i))) i,
    ];
    if (unsaved.isEmpty) return history;
    return _cap([GeneratorHistoryEntry.names(batch), ...history]);
  }

  static List<GeneratorHistoryEntry> _cap(List<GeneratorHistoryEntry> list) =>
      list.length <= generatorHistoryLimit
      ? list
      : list.sublist(0, generatorHistoryLimit);
}

final generatorsProvider =
    NotifierProvider.family<GeneratorsController, GeneratorsState, String>(
      GeneratorsController.new,
    );
