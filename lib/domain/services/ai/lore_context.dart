import '../../models/entity.dart';
import '../../models/link.dart';
import '../../repositories/repositories.dart';

/// A bounded, model-agnostic serialization of a slice of the world —
/// the payload every future AI feature will consume.
class LoreContext {
  /// The focal entity (if any).
  final Entity? focus;

  /// Entities in the n-hop neighborhood of [focus] (or a whole-world sample).
  final List<Entity> entities;

  /// Links among [entities].
  final List<Link> links;

  /// Plain-text document excerpts keyed by entity id, already truncated.
  final Map<String, String> excerpts;

  const LoreContext({
    this.focus,
    required this.entities,
    required this.links,
    required this.excerpts,
  });
}

/// Builds [LoreContext] payloads by walking the link graph — this is the
/// heavy lifting of AI grounding, implemented now and reused by every future
/// capability.
class LoreContextBuilder {
  final EntityRepository _entities;
  final LinkRepository _links;
  final DocumentRepository _documents;

  static const _maxEntities = 60;
  static const _excerptChars = 1200;

  LoreContextBuilder(this._entities, this._links, this._documents);

  /// Context = [entityId] plus its neighborhood up to [hops] link-hops away.
  Future<LoreContext> aroundEntity(String entityId, {int hops = 2}) async {
    final focus = await _entities.getEntity(entityId);
    if (focus == null) {
      return const LoreContext(entities: [], links: [], excerpts: {});
    }

    final all = await _links.allForWorld(focus.worldId);
    final included = <String>{entityId};
    var frontier = <String>{entityId};
    for (var hop = 0; hop < hops && included.length < _maxEntities; hop++) {
      final next = <String>{};
      for (final link in all) {
        if (frontier.contains(link.sourceId)) next.add(link.targetId);
        if (frontier.contains(link.targetId)) next.add(link.sourceId);
      }
      next.removeAll(included);
      included.addAll(next.take(_maxEntities - included.length));
      frontier = next;
    }

    final entities = await _entities.getEntitiesByIds(included.toList());
    final links = [
      for (final l in all)
        if (included.contains(l.sourceId) && included.contains(l.targetId)) l
    ];

    final excerpts = <String, String>{};
    for (final entity in entities.take(20)) {
      final doc = await _documents.getOrCreate(entity.id);
      if (doc.plainText.trim().isNotEmpty) {
        excerpts[entity.id] = doc.plainText.length > _excerptChars
            ? doc.plainText.substring(0, _excerptChars)
            : doc.plainText;
      }
    }

    return LoreContext(
        focus: focus, entities: entities, links: links, excerpts: excerpts);
  }
}
