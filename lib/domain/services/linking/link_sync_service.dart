import '../../models/entity.dart';
import '../../models/link.dart';
import '../../repositories/repositories.dart';
import '../templates/entity_templates.dart';
import 'mention_parser.dart';

/// Keeps the links table in sync with the two automatic link sources:
///
/// 1. **Document mentions** — inline entity-link embeds inside rich text
///    (origin: [LinkOrigin.document]).
/// 2. **Structured attributes** — `entityRef` fields defined by templates
///    (origin: [LinkOrigin.attribute]).
///
/// Manual links are owned by the user and never touched here.
class LinkSyncService {
  final LinkRepository _links;

  LinkSyncService(this._links);

  /// Called after a document save: diffs mention embeds against stored
  /// document-origin links (adds new, removes stale).
  Future<void> syncDocumentMentions({
    required String worldId,
    required String entityId,
    required String contentJson,
  }) async {
    final mentionIds = extractMentionIds(contentJson)..remove(entityId);
    await _links.replaceForOrigin(
      worldId: worldId,
      sourceId: entityId,
      origin: LinkOrigin.document,
      targets: {for (final id in mentionIds) id: LinkRoles.mention},
    );
  }

  /// Called after an entity's attributes change: mirrors every entityRef
  /// field into role-labeled links so structured data participates in
  /// backlinks and the graph.
  Future<void> syncAttributeRefs(Entity entity) async {
    final template = EntityTemplates.of(entity.kind);
    final refs = template.extractEntityRefs(entity.attributes)
      ..remove(entity.id);
    await _links.replaceForOrigin(
      worldId: entity.worldId,
      sourceId: entity.id,
      origin: LinkOrigin.attribute,
      targets: refs,
    );
  }
}
