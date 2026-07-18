import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;

import '../../app/l10n_ext.dart';
import '../../app/providers.dart';
import '../../app/router.dart';
import '../../app/theme/gmh_theme.dart';
import '../../data/import/ttg/ttg_migration_service.dart';

/// The "Import TTG database" wizard: pick a file, preview what was detected,
/// choose how duplicates are handled, watch progress (with ETA and a live
/// error log), and jump into the imported world at the end. An interrupted
/// import of the same file resumes instead of duplicating records.
Future<void> showTtgImportWizard(BuildContext context) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560, maxHeight: 640),
        child: const _TtgImportWizard(),
      ),
    ),
  );
}

enum _Step { pick, preview, running, done }

class _TtgImportWizard extends ConsumerStatefulWidget {
  const _TtgImportWizard();

  @override
  ConsumerState<_TtgImportWizard> createState() => _TtgImportWizardState();
}

class _TtgImportWizardState extends ConsumerState<_TtgImportWizard> {
  _Step _step = _Step.pick;
  String? _path;
  TtgPreview? _preview;
  String? _pickError;
  TtgDuplicateStrategy _strategy = TtgDuplicateStrategy.skip;
  late final TextEditingController _worldName = TextEditingController();
  TtgImportProgress? _progress;
  TtgMigrationReport? _report;
  String? _runError;
  bool _cancelRequested = false;

  @override
  void dispose() {
    _worldName.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final picked = await FilePicker.platform.pickFiles(
      dialogTitle: context.l10n.ttgPickFile,
      type: FileType.any,
    );
    final path = picked?.files.firstOrNull?.path;
    if (path == null || !mounted) return;
    setState(() {
      _path = path;
      _pickError = null;
    });
    final result = await ref.read(ttgMigrationServiceProvider).analyze(path);
    if (!mounted) return;
    result.fold(
      (preview) => setState(() {
        _preview = preview;
        _worldName.text = preview.suggestedWorldName;
        _step = _Step.preview;
      }),
      (error) => setState(() => _pickError = error.message),
    );
  }

  Future<void> _run() async {
    setState(() {
      _step = _Step.running;
      _cancelRequested = false;
      _runError = null;
    });
    final result = await ref.read(ttgMigrationServiceProvider).migrate(
          _path!,
          TtgImportOptions(
            worldName: _worldName.text.trim().isEmpty
                ? 'Imported World'
                : _worldName.text.trim(),
            duplicates: _strategy,
            onDuplicate: _strategy == TtgDuplicateStrategy.ask
                ? _askAboutDuplicate
                : null,
            isCancelled: () => _cancelRequested,
          ),
          onProgress: (progress) {
            if (mounted) setState(() => _progress = progress);
          },
        );
    if (!mounted) return;
    result.fold(
      (report) => setState(() {
        _report = report;
        _step = _Step.done;
      }),
      (error) => setState(() {
        _runError = error.message;
        _step = _Step.done;
      }),
    );
  }

  TtgDuplicateStrategy? _rememberedChoice;

  Future<TtgDuplicateStrategy> _askAboutDuplicate(
      TtgDuplicate duplicate) async {
    if (_rememberedChoice != null) return _rememberedChoice!;
    if (!mounted) return TtgDuplicateStrategy.skip;
    var remember = false;
    final choice = await showDialog<TtgDuplicateStrategy>(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(context.l10n.ttgDuplicateTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(context.l10n
                  .ttgDuplicateBody(duplicate.name, duplicate.collection)),
              const SizedBox(height: 8),
              CheckboxListTile(
                value: remember,
                contentPadding: EdgeInsets.zero,
                title: Text(context.l10n.ttgApplyToAll,
                    style: const TextStyle(fontSize: 13)),
                onChanged: (v) => setDialogState(() => remember = v ?? false),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.pop(context, TtgDuplicateStrategy.skip),
              child: Text(context.l10n.ttgSkip),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pop(context, TtgDuplicateStrategy.merge),
              child: Text(context.l10n.ttgMerge),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.pop(context, TtgDuplicateStrategy.replace),
              child: Text(context.l10n.ttgReplace),
            ),
          ],
        ),
      ),
    );
    final resolved = choice ?? TtgDuplicateStrategy.skip;
    if (remember) _rememberedChoice = resolved;
    return resolved;
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Icon(Icons.move_down_outlined, color: GmhColors.ember, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(l.ttgImportTitle,
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              if (_step != _Step.running)
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: () => Navigator.pop(context),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Flexible(child: _body(l)),
        ],
      ),
    );
  }

  Widget _body(AppLocalizations l) {
    switch (_step) {
      case _Step.pick:
        return _pickStep(l);
      case _Step.preview:
        return _previewStep(l);
      case _Step.running:
        return _runningStep(l);
      case _Step.done:
        return _doneStep(l);
    }
  }

  Widget _pickStep(AppLocalizations l) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l.ttgImportIntro,
            style: TextStyle(fontSize: 13, color: GmhColors.parchmentDim)),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: _pickFile,
          icon: const Icon(Icons.folder_open, size: 18),
          label: Text(l.ttgPickFile),
        ),
        if (_pickError != null) ...[
          const SizedBox(height: 12),
          Text(_pickError!,
              style: TextStyle(fontSize: 12.5, color: GmhColors.danger)),
        ],
      ],
    );
  }

  Widget _previewStep(AppLocalizations l) {
    final preview = _preview!;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(p.basename(_path!),
              style:
                  const TextStyle(fontSize: 12.5, fontStyle: FontStyle.italic)),
          const SizedBox(height: 10),
          if (preview.resumable)
            Card(
              color: GmhColors.ember.withValues(alpha: 0.1),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(l.ttgResumeBanner,
                    style: const TextStyle(fontSize: 12.5)),
              ),
            ),
          Text(l.ttgPreviewCount(preview.totalRecords),
              style: const TextStyle(
                  fontSize: 13.5, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          for (final entry in preview.collectionCounts.entries)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Expanded(
                      child: Text(entry.key,
                          style: const TextStyle(fontSize: 12.5))),
                  Text('${entry.value}',
                      style: const TextStyle(
                          fontSize: 12.5, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 12),
                  Icon(Icons.arrow_forward,
                      size: 12, color: GmhColors.parchmentFaint),
                  const SizedBox(width: 12),
                  Text(preview.collectionTargets[entry.key] ?? '',
                      style: TextStyle(
                          fontSize: 12.5, color: GmhColors.parchmentDim)),
                ],
              ),
            ),
          if (preview.issues.isNotEmpty) ...[
            const SizedBox(height: 8),
            for (final issue in preview.issues)
              Text('• $issue',
                  style: TextStyle(
                      fontSize: 11.5, color: GmhColors.parchmentFaint)),
          ],
          const SizedBox(height: 14),
          TextField(
            controller: _worldName,
            decoration: InputDecoration(labelText: l.ttgWorldName),
          ),
          const SizedBox(height: 14),
          Text(l.ttgDuplicatesLabel,
              style: const TextStyle(
                  fontSize: 12.5, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          for (final (strategy, label) in [
            (TtgDuplicateStrategy.skip, l.ttgSkip),
            (TtgDuplicateStrategy.merge, l.ttgMerge),
            (TtgDuplicateStrategy.replace, l.ttgReplace),
            (TtgDuplicateStrategy.ask, l.ttgAsk),
          ])
            RadioListTile<TtgDuplicateStrategy>(
              value: strategy,
              groupValue: _strategy,
              dense: true,
              contentPadding: EdgeInsets.zero,
              title: Text(label, style: const TextStyle(fontSize: 13)),
              onChanged: (v) => setState(() => _strategy = v!),
            ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => setState(() => _step = _Step.pick),
                child: Text(l.ttgBack),
              ),
              const SizedBox(width: 8),
              FilledButton.icon(
                onPressed: _run,
                icon: const Icon(Icons.play_arrow, size: 18),
                label: Text(preview.resumable ? l.ttgResume : l.ttgStart),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _runningStep(AppLocalizations l) {
    final progress = _progress;
    final fraction = progress?.fraction ?? 0.0;
    final phaseLabels = <String, String>{
      'reading': l.ttgPhaseReading,
      'entities': l.ttgPhaseEntities,
      'links': l.ttgPhaseLinks,
      'validating': l.ttgPhaseValidating,
      'indexing': l.ttgPhaseIndexing,
    };
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LinearProgressIndicator(value: fraction == 0 ? null : fraction),
        const SizedBox(height: 10),
        Text(
          '${phaseLabels[progress?.phase] ?? l.ttgPhaseReading} — '
          '${progress?.processed ?? 0} / ${progress?.total ?? 0}'
          '${progress?.etaSeconds != null ? '  ·  ${l.ttgEta(progress!.etaSeconds!)}' : ''}',
          style: const TextStyle(fontSize: 12.5),
        ),
        if ((progress?.currentLabel ?? '').isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(progress!.currentLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    fontSize: 12, color: GmhColors.parchmentDim)),
          ),
        if ((progress?.errors ?? const []).isNotEmpty) ...[
          const SizedBox(height: 10),
          Text(l.ttgErrorLog,
              style: const TextStyle(
                  fontSize: 12.5, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final e in progress!.errors)
                    Text('• $e',
                        style: TextStyle(
                            fontSize: 11.5, color: GmhColors.danger)),
                ],
              ),
            ),
          ),
        ],
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: _cancelRequested
                ? null
                : () => setState(() => _cancelRequested = true),
            child: Text(l.cancel),
          ),
        ),
      ],
    );
  }

  Widget _doneStep(AppLocalizations l) {
    final report = _report;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_runError != null)
            Text(_runError!,
                style: TextStyle(fontSize: 13, color: GmhColors.danger))
          else if (report != null) ...[
            Row(
              children: [
                Icon(
                  report.completed
                      ? Icons.check_circle_outline
                      : Icons.pause_circle_outline,
                  color: report.completed
                      ? GmhColors.success
                      : GmhColors.ember,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                      report.completed
                          ? l.ttgDoneTitle
                          : l.ttgInterruptedTitle,
                      style: const TextStyle(
                          fontSize: 14.5, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _stat(l.ttgStatImported, report.imported),
            _stat(l.ttgStatLinks, report.linksCreated),
            _stat(l.ttgStatMedia, report.mediaImported),
            _stat(l.ttgStatDocuments, report.documentsCreated),
            _stat(l.ttgStatTags, report.tagsCreated),
            _stat(l.ttgStatRepaired, report.repairedReferences),
            _stat(l.ttgStatSkipped, report.skippedDuplicates),
            if (report.mergedDuplicates > 0)
              _stat(l.ttgMerge, report.mergedDuplicates),
            if (report.replacedDuplicates > 0)
              _stat(l.ttgReplace, report.replacedDuplicates),
            if (report.errors.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(l.ttgErrorLog,
                  style: const TextStyle(
                      fontSize: 12.5, fontWeight: FontWeight.w600)),
              for (final e in report.errors.take(30))
                Text('• $e',
                    style: TextStyle(
                        fontSize: 11.5, color: GmhColors.parchmentDim)),
            ],
          ],
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l.close),
              ),
              if (report != null && report.completed) ...[
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.go(Routes.home(report.worldId));
                  },
                  child: Text(l.ttgOpenWorld),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _stat(String label, int value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 13))),
          Text('$value',
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
