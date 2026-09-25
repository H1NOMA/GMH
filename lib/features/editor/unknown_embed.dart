import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

import '../../app/theme/gmh_theme.dart';

/// Fallback for embeds this app has no builder for (a pasted video or
/// iframe, a formula from another Quill app). Without it the editor
/// throws on build and the whole page turns red; with it the embed shows
/// as a small inert chip and survives round-trips untouched.
class UnknownEmbedBuilder extends EmbedBuilder {
  const UnknownEmbedBuilder();

  @override
  String get key => '__unknown__';

  @override
  bool get expanded => false;

  @override
  String toPlainText(Embed node) => '';

  @override
  Widget build(BuildContext context, EmbedContext embedContext) {
    final type = embedContext.node.value.type;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: GmhColors.surfaceHigh,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: GmhColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.extension_outlined,
              size: 13, color: GmhColors.parchmentFaint),
          const SizedBox(width: 4),
          Text(type,
              style: TextStyle(fontSize: 12, color: GmhColors.parchmentDim)),
        ],
      ),
    );
  }
}
