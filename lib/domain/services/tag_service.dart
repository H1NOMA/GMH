import '../../core/exceptions.dart';
import '../../core/result.dart';
import '../repositories/repositories.dart';

/// Tag edits that keep the search index honest: tag names are indexed with
/// every entry that carries them, so renames, merges and deletes reindex
/// the affected entries. Names are unique per world, case-insensitively.
class TagService {
  final TagRepository _tags;
  final SearchRepository _search;

  TagService(this._tags, this._search);

  Future<Result<void>> rename(
      String worldId, String tagId, String name) {
    return guard(() async {
      final trimmed = name.trim();
      if (trimmed.isEmpty) {
        throw const ValidationException('Name cannot be empty.');
      }
      final clash = (await _tags.tags(worldId)).any((t) =>
          t.id != tagId && t.name.toLowerCase() == trimmed.toLowerCase());
      if (clash) throw const ValidationException('Tag name already exists.');
      await _tags.rename(tagId, trimmed);
      await _reindex(await _tags.entityIdsWithTag(tagId));
    });
  }

  Future<Result<void>> merge(
      {required String fromTagId, required String intoTagId}) {
    return guard(() async {
      final affected = await _tags.entityIdsWithTag(fromTagId);
      await _tags.merge(fromTagId: fromTagId, intoTagId: intoTagId);
      await _reindex(affected);
    });
  }

  Future<Result<void>> delete(String tagId) {
    return guard(() async {
      final affected = await _tags.entityIdsWithTag(tagId);
      await _tags.delete(tagId);
      await _reindex(affected);
    });
  }

  Future<void> _reindex(List<String> entityIds) async {
    for (final id in entityIds) {
      await _search.reindexEntity(id);
    }
  }
}
