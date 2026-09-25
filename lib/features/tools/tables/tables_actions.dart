import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/providers.dart';
import '../../../domain/models/world_object.dart';
import '../../../domain/repositories/repositories.dart';
import '../../../domain/tables/content/table_library.dart';
import '../../../domain/tables/random_table.dart';
import '../../../domain/tables/table_roller.dart';
import '../../shell/ui_providers.dart';

/// Route segment of the library view (table ids are UUIDs, so it cannot
/// clash with a real table).
const tablesLibraryObjectId = 'library';

/// The world's tables in list order.
final worldTablesProvider = Provider.autoDispose
    .family<AsyncValue<List<RandomTable>>, String>((ref, worldId) {
      return ref
          .watch(
            worldObjectsProvider((
              worldId: worldId,
              type: WorldObjectTypes.randomTable,
              parentId: null,
            )),
          )
          .whenData(
            (objects) => [for (final o in objects) RandomTable.fromObject(o)],
          );
    });

final tablesActionsProvider = Provider<TablesActions>(
  (ref) => TablesActions(ref.watch(worldObjectRepositoryProvider)),
);

/// Every write the random tables tool makes.
class TablesActions {
  final WorldObjectRepository _repo;

  TablesActions(this._repo);

  Future<RandomTable> create(String worldId, RandomTable draft) async {
    final object = await _repo.create(
      worldId: worldId,
      type: WorldObjectTypes.randomTable,
      name: draft.name,
      data: draft.toData(),
    );
    return RandomTable.fromObject(object);
  }

  Future<void> save(RandomTable table) => _repo.update(table.toObject());

  Future<void> delete(String id) => _repo.delete(id);

  /// An editable copy owned by the user.
  Future<RandomTable> duplicate(RandomTable source, String name) => create(
    source.worldId,
    source.copyWith(name: name, source: RandomTableSource.user),
  );

  /// Copies library [tables] into the world in [lang], in the given order.
  Future<List<RandomTable>> addFromLibrary(
    String worldId,
    List<LibraryTable> tables,
    String lang,
  ) async {
    final added = <RandomTable>[];
    for (final t in tables) {
      added.add(await create(worldId, TableLibrary.materialize(t, lang)));
    }
    return added;
  }
}

/// Library tables [table] needs that the world does not have yet (by
/// library origin or by name).
List<LibraryTable> missingDependencies(
  LibraryTable table,
  List<RandomTable> worldTables,
  String lang,
) {
  final sources = {for (final t in worldTables) t.source};
  final names = {for (final t in worldTables) tableNameKey(t.name)};
  return [
    for (final dep in TableLibrary.dependencies(table))
      if (!sources.contains(RandomTableSource.library(dep.id)) &&
          !names.contains(tableNameKey(dep.name.of(lang))))
        dep,
  ];
}
