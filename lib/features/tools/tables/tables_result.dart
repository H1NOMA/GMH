import 'package:flutter/material.dart';

import '../../../app/l10n_ext.dart';
import '../../../app/theme/gmh_theme.dart';
import '../../../domain/tables/table_roller.dart';
import 'tables_l10n.dart';

/// `1d20 → 14` for formula rolls; null for weighted ones.
String? tableTotalText(TableRollResult r) =>
    r.total == null ? null : '${r.formula} → ${r.total}';

/// The latest roll: final text, dice total and the tree of nested rolls
/// that produced it.
class TableResultCard extends StatelessWidget {
  final TableRollResult? result;
  final VoidCallback? onRollAgain;
  final VoidCallback? onCopy;

  const TableResultCard(
      {super.key, this.result, this.onRollAgain, this.onCopy});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final result = this.result;
    final decoration = BoxDecoration(
      color: GmhColors.surface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: GmhColors.ember.withValues(alpha: 0.35)),
    );
    if (result == null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 28),
        decoration: decoration,
        child: Column(
          children: [
            Icon(Icons.table_rows_outlined,
                size: 40, color: GmhColors.parchmentFaint),
            const SizedBox(height: 10),
            Text(l.tablesResultEmpty,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: GmhColors.parchmentDim)),
          ],
        ),
      );
    }
    final total = tableTotalText(result);
    final failure = result.failure;
    final hasTree = result.parts.isNotEmpty;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 8, 8),
      decoration: decoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 6,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                if (total != null)
                  _Pill(
                      key: const ValueKey('tables-result-total'),
                      label: total,
                      color: GmhColors.ember),
                if (result.clamped)
                  _Pill(
                      label: l.tablesClamped,
                      color: GmhColors.danger,
                      icon: Icons.warning_amber_rounded),
              ],
            ),
          ),
          if (total != null || result.clamped) const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: failure != null
                ? Text(tableFailureText(l, failure),
                    style: TextStyle(fontSize: 15, color: GmhColors.danger))
                : SelectableText(
                    result.text,
                    key: const ValueKey('tables-result-text'),
                    style: const TextStyle(
                        fontSize: 17, height: 1.45, fontWeight: FontWeight.w500),
                  ),
          ),
          if (hasTree) ...[
            const SizedBox(height: 12),
            Text(l.tablesWhy.toUpperCase(),
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                    color: GmhColors.parchmentFaint)),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: RollTree(parts: result.parts),
            ),
          ],
          const SizedBox(height: 4),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: 4,
            children: [
              if (onCopy != null)
                TextButton.icon(
                  key: const ValueKey('tables-result-copy'),
                  onPressed: onCopy,
                  icon: const Icon(Icons.copy_outlined, size: 18),
                  label: Text(l.tablesCopy),
                ),
              TextButton.icon(
                key: const ValueKey('tables-roll-again'),
                onPressed: onRollAgain,
                icon: const Icon(Icons.replay, size: 18),
                label: Text(l.tablesRollAgain),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Nested expansions, one line each, indented by depth.
class RollTree extends StatelessWidget {
  final List<TableRollPart> parts;
  final int depth;

  const RollTree({super.key, required this.parts, this.depth = 0});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final lines = <Widget>[];
    void add(List<TableRollPart> parts, int depth) {
      for (final part in parts) {
        switch (part) {
          case DicePart():
            lines.add(_TreeLine(
              depth: depth,
              icon: Icons.casino_outlined,
              lead: '{${part.expression}} = ${part.total}',
              text: part.breakdown,
            ));
          case ChoicePart():
            lines.add(_TreeLine(
              depth: depth,
              icon: Icons.call_split,
              lead: l.tablesChoice(part.options.length),
              text: part.text,
            ));
            add(part.parts, depth + 1);
          case TablePart():
            final r = part.result;
            final failure = r.failure;
            lines.add(_TreeLine(
              depth: depth,
              icon: failure == null
                  ? Icons.subdirectory_arrow_right
                  : Icons.warning_amber_rounded,
              lead: [r.tableName, ?tableTotalText(r)].join(' · '),
              text: failure == null ? r.text : tableFailureText(l, failure),
              failed: failure != null,
            ));
            add(r.parts, depth + 1);
        }
      }
    }

    add(parts, depth);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch, children: lines);
  }
}

class _TreeLine extends StatelessWidget {
  final int depth;
  final IconData icon;
  final String lead;
  final String text;
  final bool failed;

  const _TreeLine({
    required this.depth,
    required this.icon,
    required this.lead,
    required this.text,
    this.failed = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = failed ? GmhColors.danger : GmhColors.parchmentDim;
    return Padding(
      padding: EdgeInsets.only(left: 14.0 * depth.clamp(0, 6), top: 3),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(icon, size: 14, color: color),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text.rich(
              TextSpan(children: [
                TextSpan(
                    text: lead,
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: color)),
                if (text.isNotEmpty) TextSpan(text: '  $text'),
              ]),
              style: TextStyle(
                  fontSize: 12.5, height: 1.35, color: GmhColors.parchmentDim),
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;

  const _Pill({super.key, required this.label, required this.color, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.45)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: color),
            const SizedBox(width: 4),
          ],
          Flexible(
            child: Text(label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w700, color: color)),
          ),
        ],
      ),
    );
  }
}

/// One earlier roll in the page's log.
class TableLogTile extends StatelessWidget {
  final TableRollResult result;
  final VoidCallback onCopy;

  const TableLogTile({super.key, required this.result, required this.onCopy});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final total = tableTotalText(result);
    final failure = result.failure;
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 8, 4, 8),
      decoration: BoxDecoration(
        color: GmhColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: GmhColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (total != null)
                  Text(total,
                      style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: GmhColors.ember)),
                Text(
                  failure == null ? result.text : tableFailureText(l, failure),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 13, height: 1.35),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: l.tablesCopy,
            visualDensity: VisualDensity.compact,
            icon: const Icon(Icons.copy_outlined, size: 18),
            onPressed: onCopy,
          ),
        ],
      ),
    );
  }
}
