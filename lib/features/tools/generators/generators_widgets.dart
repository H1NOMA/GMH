import 'package:flutter/material.dart';

import '../../../app/l10n_ext.dart';
import '../../../app/theme/gmh_theme.dart';
import '../../../domain/generators/generator_engine.dart';
import 'generators_l10n.dart';
import 'generators_state.dart';

TextStyle generatorSectionStyle() => TextStyle(
  fontSize: 12,
  fontWeight: FontWeight.w700,
  letterSpacing: 0.4,
  color: GmhColors.parchmentDim,
);

BoxDecoration _panel({bool highlight = false}) => BoxDecoration(
  color: GmhColors.surface,
  borderRadius: BorderRadius.circular(12),
  border: Border.all(
    color: highlight
        ? GmhColors.ember.withValues(alpha: 0.6)
        : GmhColors.border,
  ),
);

/// One generator in the wide picker.
class GeneratorKindTile extends StatelessWidget {
  final GeneratorKind kind;
  final bool selected;
  final VoidCallback onTap;

  const GeneratorKindTile({
    super.key,
    required this.kind,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? GmhColors.ember : GmhColors.parchmentDim;
    return Material(
      color: selected
          ? GmhColors.ember.withValues(alpha: 0.12)
          : Colors.transparent,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        key: ValueKey('gen-kind-${kind.name}'),
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              Icon(generatorKindIcon(kind), size: 20, color: color),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  generatorKindLabel(context.l10n, kind),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: selected ? GmhColors.parchment : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// A structured result: title, labeled fields with per-field rerolls and
/// the card actions.
class GeneratorResultCard extends StatelessWidget {
  final GeneratedResult result;
  final String packName;
  final bool kept;
  final bool saving;

  /// Id of the entity this result was saved as.
  final String? savedEntityId;
  final void Function(String fieldKey) onRerollField;
  final VoidCallback onRerollAll;
  final VoidCallback onCopy;
  final VoidCallback onKeep;
  final VoidCallback onSave;
  final VoidCallback onOpen;
  final VoidCallback? onDismiss;

  const GeneratorResultCard({
    super.key,
    required this.result,
    required this.packName,
    required this.kept,
    required this.saving,
    required this.savedEntityId,
    required this.onRerollField,
    required this.onRerollAll,
    required this.onCopy,
    required this.onKeep,
    required this.onSave,
    required this.onOpen,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final id = result.id;
    String label(String key) => generatorFieldLabel(l, key, kind: result.kind);
    final titleKey = result.titleKey;
    final title = result.title.isEmpty
        ? generatorKindLabel(l, result.kind)
        : result.title;
    return Container(
      key: ValueKey('gen-card-$id'),
      decoration: _panel(highlight: kept),
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(
                generatorKindIcon(result.kind),
                size: 20,
                color: GmhColors.ember,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                      title,
                      key: ValueKey('gen-title-$id'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      [
                        generatorKindLabel(l, result.kind),
                        packName,
                        if (savedEntityId != null) l.generatorsSavedBadge,
                      ].join('  ·  '),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: GmhColors.parchmentDim,
                      ),
                    ),
                  ],
                ),
              ),
              if (kept)
                Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: Icon(Icons.push_pin, size: 16, color: GmhColors.ember),
                ),
              if (titleKey != null)
                IconButton(
                  key: ValueKey('gen-reroll-$id-$titleKey'),
                  tooltip: l.generatorsRerollField(label(titleKey)),
                  icon: const Icon(Icons.refresh, size: 18),
                  visualDensity: VisualDensity.compact,
                  onPressed: () => onRerollField(titleKey),
                ),
            ],
          ),
          const SizedBox(height: 8),
          for (final f in result.bodyFields)
            _FieldRow(
              key: ValueKey('gen-field-$id-${f.key}'),
              label: label(f.label),
              value: f.value,
              rerollKey: ValueKey('gen-reroll-$id-${f.key}'),
              onReroll: () => onRerollField(f.key),
            ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                OutlinedButton.icon(
                  key: ValueKey('gen-reroll-all-$id'),
                  onPressed: onRerollAll,
                  icon: const Icon(Icons.casino_outlined, size: 18),
                  label: Text(l.generatorsRerollAll),
                ),
                OutlinedButton.icon(
                  key: ValueKey('gen-copy-$id'),
                  onPressed: onCopy,
                  icon: const Icon(Icons.copy_outlined, size: 18),
                  label: Text(l.generatorsCopy),
                ),
                OutlinedButton.icon(
                  key: ValueKey('gen-keep-$id'),
                  onPressed: onKeep,
                  icon: Icon(
                    kept ? Icons.push_pin : Icons.push_pin_outlined,
                    size: 18,
                  ),
                  label: Text(kept ? l.generatorsUnkeep : l.generatorsKeep),
                ),
                if (savedEntityId != null)
                  FilledButton.tonalIcon(
                    key: ValueKey('gen-open-$id'),
                    onPressed: onOpen,
                    icon: const Icon(Icons.open_in_new, size: 18),
                    label: Text(l.open),
                  )
                else
                  FilledButton.icon(
                    key: ValueKey('gen-save-$id'),
                    onPressed: saving ? null : onSave,
                    icon: const Icon(Icons.bookmark_add_outlined, size: 18),
                    label: Text(l.generatorsSave),
                  ),
                if (onDismiss != null)
                  TextButton(
                    key: ValueKey('gen-dismiss-$id'),
                    onPressed: onDismiss,
                    child: Text(l.generatorsDismiss),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FieldRow extends StatelessWidget {
  final String label;
  final String value;
  final Key rerollKey;
  final VoidCallback onReroll;

  const _FieldRow({
    super.key,
    required this.label,
    required this.value,
    required this.rerollKey,
    required this.onReroll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                      color: GmhColors.parchmentFaint,
                    ),
                  ),
                  const SizedBox(height: 2),
                  SelectableText(
                    value,
                    style: const TextStyle(fontSize: 14, height: 1.35),
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            key: rerollKey,
            tooltip: context.l10n.generatorsRerollField(label),
            icon: const Icon(Icons.refresh, size: 18),
            visualDensity: VisualDensity.compact,
            onPressed: onReroll,
          ),
        ],
      ),
    );
  }
}

/// The latest batch of names, one row each with copy and save.
class GeneratorNamesCard extends StatelessWidget {
  final NameBatch batch;
  final String packName;
  final Map<String, String> cultureLabels;
  final Map<String, String> saved;
  final Set<String> saving;
  final VoidCallback onCopyAll;
  final void Function(int index) onCopy;
  final void Function(int index) onSave;
  final void Function(String entityId) onOpen;

  const GeneratorNamesCard({
    super.key,
    required this.batch,
    required this.packName,
    required this.cultureLabels,
    required this.saved,
    required this.saving,
    required this.onCopyAll,
    required this.onCopy,
    required this.onSave,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Container(
      key: ValueKey('gen-names-${batch.id}'),
      decoration: _panel(),
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    generatorKindIcon(GeneratorKind.names),
                    size: 20,
                    color: GmhColors.ember,
                  ),
                  const SizedBox(width: 12),
                  Flexible(
                    child: Text(
                      '${l.generatorsKindNames}  ·  $packName',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
              TextButton.icon(
                key: const ValueKey('gen-names-copy-all'),
                onPressed: onCopyAll,
                icon: const Icon(Icons.copy_all_outlined, size: 18),
                label: Text(l.generatorsCopyAll),
              ),
            ],
          ),
          const SizedBox(height: 4),
          for (var i = 0; i < batch.names.length; i++) ...[
            if (i > 0) Divider(height: 1, color: GmhColors.border),
            _NameRow(
              index: i,
              name: batch.names[i],
              culture: cultureLabels[batch.names[i].cultureId],
              savedEntityId: saved[GeneratorsState.nameKey(batch, i)],
              saving: saving.contains(GeneratorsState.nameKey(batch, i)),
              onCopy: () => onCopy(i),
              onSave: () => onSave(i),
              onOpen: onOpen,
            ),
          ],
        ],
      ),
    );
  }
}

class _NameRow extends StatelessWidget {
  final int index;
  final GeneratedName name;
  final String? culture;
  final String? savedEntityId;
  final bool saving;
  final VoidCallback onCopy;
  final VoidCallback onSave;
  final void Function(String entityId) onOpen;

  const _NameRow({
    required this.index,
    required this.name,
    required this.culture,
    required this.savedEntityId,
    required this.saving,
    required this.onCopy,
    required this.onSave,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final details = [?culture, ?name.note].join('  ·  ');
    final saved = savedEntityId;
    return Padding(
      key: ValueKey('gen-name-$index'),
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(
                  name.display,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (details.isNotEmpty)
                  Text(
                    details,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: GmhColors.parchmentDim,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            key: ValueKey('gen-name-copy-$index'),
            tooltip: l.generatorsCopyName,
            icon: const Icon(Icons.copy_outlined, size: 18),
            visualDensity: VisualDensity.compact,
            onPressed: onCopy,
          ),
          if (saved != null)
            IconButton(
              key: ValueKey('gen-name-open-$index'),
              tooltip: l.open,
              icon: Icon(Icons.open_in_new, size: 18, color: GmhColors.ember),
              visualDensity: VisualDensity.compact,
              onPressed: () => onOpen(saved),
            )
          else
            IconButton(
              key: ValueKey('gen-name-save-$index'),
              tooltip: l.generatorsSaveAsCharacter,
              icon: const Icon(Icons.person_add_alt_outlined, size: 18),
              visualDensity: VisualDensity.compact,
              onPressed: saving ? null : onSave,
            ),
        ],
      ),
    );
  }
}

/// Shown where a result will appear.
class GeneratorEmptyHint extends StatelessWidget {
  final GeneratorKind kind;
  const GeneratorEmptyHint({super.key, required this.kind});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Container(
      key: const ValueKey('gen-empty'),
      decoration: _panel(),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(
            generatorKindIcon(kind),
            size: 36,
            color: GmhColors.parchmentFaint,
          ),
          const SizedBox(height: 12),
          Text(
            l.generatorsEmptyTitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 4),
          Text(
            l.generatorsEmptyHint,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              height: 1.4,
              color: GmhColors.parchmentDim,
            ),
          ),
        ],
      ),
    );
  }
}

class GeneratorSectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final int count;
  final Widget? trailing;

  const GeneratorSectionHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.count,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: GmhColors.parchmentDim),
        const SizedBox(width: 8),
        // One flexible child: a Flexible title beside a Spacer would split
        // the free space with it and leave [trailing] short of the edge.
        Expanded(
          child: Row(
            children: [
              Flexible(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              if (count > 0) ...[
                const SizedBox(width: 8),
                Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 12,
                    color: GmhColors.parchmentFaint,
                  ),
                ),
              ],
            ],
          ),
        ),
        ?trailing,
      ],
    );
  }
}

/// One replaced, unsaved result; tapping brings it back.
class GeneratorHistoryTile extends StatelessWidget {
  final int index;
  final GeneratorHistoryEntry entry;
  final String packName;
  final VoidCallback onRestore;

  const GeneratorHistoryTile({
    super.key,
    required this.index,
    required this.entry,
    required this.packName,
    required this.onRestore,
  });

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final result = entry.result;
    final title = result != null
        ? (result.title.isNotEmpty
              ? result.title
              : result.fields.firstOrNull?.value ?? '')
        : entry.names!.names.map((n) => n.name).join(', ');
    return Material(
      color: GmhColors.surface,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        key: ValueKey('gen-history-$index'),
        borderRadius: BorderRadius.circular(10),
        onTap: onRestore,
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: GmhColors.border),
          ),
          child: Row(
            children: [
              Icon(
                generatorKindIcon(entry.kind),
                size: 18,
                color: GmhColors.parchmentDim,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${generatorKindLabel(l, entry.kind)}  ·  $packName',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12,
                        color: GmhColors.parchmentDim,
                      ),
                    ),
                  ],
                ),
              ),
              Tooltip(
                message: l.generatorsRestore,
                child: Icon(
                  Icons.undo,
                  size: 18,
                  color: GmhColors.parchmentDim,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
