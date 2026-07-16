import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/providers.dart';
import '../../app/router.dart';
import '../../app/theme/gmh_theme.dart';
import '../../domain/models/entity.dart' as domain;
import '../../domain/services/linking/mention_parser.dart';
import '../shell/ui_providers.dart';

/// Inserts an inline entity-link embed at the current cursor position.
/// Serialized as `{"insert": {"entityLink": "{\"id\":…,\"label\":…}"}}` —
/// exactly what the mention parser and link sync service consume.
void insertEntityLink(QuillController controller, domain.Entity target) {
  final index = controller.selection.baseOffset;
  final length = controller.selection.extentOffset - index;
  controller.replaceText(
    index,
    length,
    Embeddable(
      entityLinkEmbedKey,
      jsonEncode({'id': target.id, 'label': target.name}),
    ),
    TextSelection.collapsed(offset: index + 1),
  );
  // A trailing space keeps typing natural after the chip.
  controller.replaceText(
      index + 1, 0, ' ', TextSelection.collapsed(offset: index + 2));
}

/// Renders the inline entity-link chip; tapping navigates to the entity.
class EntityLinkEmbedBuilder extends EmbedBuilder {
  final String worldId;

  EntityLinkEmbedBuilder({required this.worldId});

  @override
  String get key => entityLinkEmbedKey;

  @override
  bool get expanded => false;

  @override
  String toPlainText(Embed node) {
    final payload = _decode(node);
    return payload?['label'] as String? ?? '';
  }

  Map<String, Object?>? _decode(Embed node) {
    final data = node.value.data;
    if (data is Map) return data.cast<String, Object?>();
    if (data is String) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map) return decoded.cast<String, Object?>();
      } catch (_) {}
    }
    return null;
  }

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    final payload = _decode(embedContext.node);
    final id = payload?['id'] as String?;
    final label = payload?['label'] as String? ?? 'unknown';
    return _EntityLinkChip(worldId: worldId, entityId: id, fallback: label);
  }
}

class _EntityLinkChip extends ConsumerWidget {
  final String worldId;
  final String? entityId;
  final String fallback;

  const _EntityLinkChip({
    required this.worldId,
    required this.entityId,
    required this.fallback,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entity = entityId == null
        ? null
        : ref.watch(entityProvider(entityId!)).valueOrNull;
    final label = entity?.name ?? fallback;
    final color = entity?.kind.color ?? GmhColors.parchmentDim;
    final broken = entityId == null || (entity?.isDeleted ?? false);

    return GestureDetector(
      onTap: broken
          ? null
          : () {
              ref.read(searchRepositoryProvider).recordOpened(entityId!);
              context.go(Routes.entity(worldId, entityId!));
            },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
        decoration: BoxDecoration(
          color: color.withValues(alpha: broken ? 0.06 : 0.14),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: color.withValues(alpha: 0.45)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (entity != null) ...[
              Icon(entity.kind.icon, size: 12, color: color),
              const SizedBox(width: 3),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                color: broken ? GmhColors.parchmentFaint : color,
                decoration: broken ? TextDecoration.lineThrough : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
