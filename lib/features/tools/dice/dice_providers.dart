import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../domain/dice/dice_history.dart';
import '../../../domain/models/world_object.dart';
import '../../shell/ui_providers.dart';

/// The randomness behind every roll in the app; tests override it with a
/// scripted sequence.
final diceRandomProvider = Provider<Random>((ref) => Random.secure());

/// A world's roll log, newest first.
final diceHistoryProvider = Provider.autoDispose
    .family<AsyncValue<List<DiceHistoryEntry>>, String>((ref, worldId) {
  return ref
      .watch(worldObjectsProvider(
          (worldId: worldId, type: WorldObjectTypes.diceRoll, parentId: null)))
      .whenData(DiceHistory.fromObjects);
});

/// Appends [entry] to the world's roll log (capped).
Future<void> logDiceRoll(
        WidgetRef ref, String worldId, DiceHistoryEntry entry) =>
    DiceHistory.log(ref.read(worldObjectRepositoryProvider), worldId, entry);
