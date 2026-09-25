import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';

import '../../app/l10n_ext.dart';
import '../../app/template_l10n.dart';
import '../../data/backup/pdf_exporter.dart';
import '../../data/backup/pdf_fonts.dart';
import '../../domain/models/entity_kind.dart';
import '../../domain/models/link.dart';
import '../../domain/models/world.dart';
import '../../app/packs/setting_packs.dart';
import '../worlds/world_editor_dialog.dart';
import '../../app/locale_provider.dart';
import '../../app/theme_provider.dart';
import '../../app/providers.dart';
import '../../app/router.dart';
import '../../app/theme/gmh_theme.dart';
import '../../core/constants.dart';
import '../../core/utils/save_flush.dart';
import '../../data/backup/backup_service.dart';
import '../../domain/repositories/repositories.dart';
import '../shell/history_buttons.dart';
import '../shell/ui_providers.dart';
import '../shell/workspace_tabs.dart';

/// Settings: language, manual/automatic backups, full-project export
/// (.gmhw ZIP), JSON export, PDF world book, and restore/import.
class SettingsScreen extends ConsumerStatefulWidget {
  final String worldId;
  const SettingsScreen({super.key, required this.worldId});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  List<BackupInfo> _backups = const [];
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _refreshBackups();
  }

  Future<void> _refreshBackups() async {
    final backups = await ref
        .read(backupServiceProvider)
        .listBackups(worldId: widget.worldId);
    if (mounted) setState(() => _backups = backups);
  }

  void _notify(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _run(Future<void> Function() action) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      await action();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _backupNow() => _run(() async {
        await flushPendingSaves();
        final result =
            await ref.read(backupServiceProvider).backupNow(widget.worldId);
        if (!mounted) return;
        result.fold(
          (path) {
            _notify(context.l10n.backupSaved);
            _refreshBackups();
          },
          (error) => _notify(localizedError(context, error)),
        );
      });

  Future<void> _shareFile(String path, String message) async {
    try {
      await SharePlus.instance.share(
        ShareParams(files: [XFile(path)], text: message),
      );
    } catch (_) {
      // Sharing is unavailable on some desktops; the file path is shown.
      if (mounted) _notify(context.l10n.savedTo(path));
    }
  }

  Future<void> _exportArchive() => _run(() async {
        await flushPendingSaves();
        final world =
            await ref.read(worldRepositoryProvider).getWorld(widget.worldId);
        final dir = await _exportsDir();
        final name = _fileStem(world);
        final path =
            p.join(dir, '$name.${GmhConstants.projectArchiveExtension}');
        final result = await ref
            .read(projectArchiveServiceProvider)
            .exportArchive(widget.worldId, path);
        if (!mounted) return;
        await result.fold(
          (path) => _shareFile(path, context.l10n.shareArchiveText),
          (error) async => _notify(localizedError(context, error)),
        );
      });

  Future<void> _exportJson() => _run(() async {
        await flushPendingSaves();
        final world =
            await ref.read(worldRepositoryProvider).getWorld(widget.worldId);
        final dir = await _exportsDir();
        final path = p.join(dir, '${_fileStem(world)}.json');
        final result = await ref
            .read(projectArchiveServiceProvider)
            .exportJson(widget.worldId, path);
        if (!mounted) return;
        await result.fold(
          (path) => _shareFile(path, context.l10n.shareJsonText),
          (error) async => _notify(localizedError(context, error)),
        );
      });

  Future<void> _exportPdf() => _run(() async {
        final includeGmOnly = await _askIncludeGmOnly();
        if (includeGmOnly == null || !mounted) return;
        await flushPendingSaves();
        if (!mounted) return;
        // Resolve every label now: the export outlives this frame.
        final l = context.l10n;
        final lang = Localizations.localeOf(context).languageCode;
        final chapterTitles = {
          for (final kind in EntityKind.values)
            kind: kind.localizedPlural(context),
        };
        final labels = PdfBookLabels(
          subtitle: l.pdfBookSubtitle,
          chapterTitle: (kind) => chapterTitles[kind] ?? kind.pluralLabel,
          term: (term) => trTemplateFor(lang, term),
          fieldsSection: l.blueprintFieldsSection,
        );
        final world =
            await ref.read(worldRepositoryProvider).getWorld(widget.worldId);
        final dir = await _exportsDir();
        final fonts = await PdfFonts.load();
        final path = p.join(dir, '${_fileStem(world)}.pdf');
        final result = await ref.read(pdfExporterProvider).exportWorldBook(
              worldId: widget.worldId,
              worldName: world?.name ?? 'World',
              outputPath: path,
              fonts: fonts,
              labels: labels,
              includeGmOnly: includeGmOnly,
            );
        if (!mounted) return;
        await result.fold(
          (path) => _shareFile(path, context.l10n.sharePdfText),
          (error) async => _notify(localizedError(context, error)),
        );
      });

  Future<void> _exportMarkdown() => _run(() async {
        final includeGmOnly =
            await _askIncludeGmOnly(title: context.l10n.exportMarkdownTitle);
        if (includeGmOnly == null || !mounted) return;
        await flushPendingSaves();
        if (!mounted) return;
        final l = context.l10n;
        final lang = Localizations.localeOf(context).languageCode;
        final chapterTitles = {
          for (final kind in EntityKind.values)
            kind: kind.localizedPlural(context),
        };
        final roleLabels = <String, String>{};
        String roleLabel(String role) =>
            roleLabels[role] ??= localizedRoleLabel(context, role);
        for (final role in LinkRoles.suggestions) {
          roleLabel(role);
        }
        final labels = PdfBookLabels(
          subtitle: l.pdfBookSubtitle,
          chapterTitle: (kind) => chapterTitles[kind] ?? kind.pluralLabel,
          term: (term) => trTemplateFor(lang, term),
          fieldsSection: l.blueprintFieldsSection,
        );
        final relationsTitle = l.relationsTitle;
        final world =
            await ref.read(worldRepositoryProvider).getWorld(widget.worldId);
        final dir = await _exportsDir();
        final path = p.join(dir, '${_fileStem(world)}-notes.zip');
        final result =
            await ref.read(markdownExporterProvider).exportVault(
                  worldId: widget.worldId,
                  worldName: world?.name ?? 'World',
                  outputPath: path,
                  labels: labels,
                  includeGmOnly: includeGmOnly,
                  relationsTitle: relationsTitle,
                  roleLabel: (role) => roleLabels[role] ?? role,
                );
        if (!mounted) return;
        await result.fold(
          (path) => _shareFile(path, context.l10n.shareMarkdownText),
          (error) async => _notify(localizedError(context, error)),
        );
      });

  /// null = cancelled; otherwise whether GM-only fields go into the export.
  Future<bool?> _askIncludeGmOnly({String? title}) {
    var include = false;
    return showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(title ?? context.l10n.exportPdfTitle),
          content: SizedBox(
            width: 440,
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              value: include,
              onChanged: (v) => setDialogState(() => include = v),
              title: Text(context.l10n.pdfIncludeGmOnly),
              subtitle: Text(context.l10n.pdfIncludeGmOnlyHint),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(context.l10n.cancel)),
            FilledButton(
                onPressed: () => Navigator.pop(context, include),
                child: Text(context.l10n.exportAction)),
          ],
        ),
      ),
    );
  }

  Future<String> _exportsDir() async {
    final root = ref.read(appRootDirProvider);
    final dir = Directory(p.join(root, 'exports'));
    await dir.create(recursive: true);
    return dir.path;
  }

  String _safeName(String name) => exportFileStem(name);

  /// World name plus a short id, so two worlds with the same name never
  /// overwrite each other's exports.
  String _fileStem(World? world) {
    final base = _safeName(world?.name ?? 'world');
    final id = world?.id ?? '';
    return id.length >= 6 ? '$base-${id.substring(0, 6)}' : base;
  }

  Future<void> _importArchive() => _run(() async {
        final picked = await FilePicker.platform.pickFiles(
          dialogTitle: context.l10n.importPickArchive,
          type: FileType.any,
        );
        final path = picked?.files.firstOrNull?.path;
        if (path == null || !mounted) return;

        final archives = ref.read(projectArchiveServiceProvider);
        final manifest = await archives.inspectArchive(path);
        if (!mounted) return;
        if (manifest.isErr) {
          _notify(localizedError(context, manifest.error));
          return;
        }
        // Importing a world that already exists replaces it: say so.
        final existing = (ref.read(worldsProvider).valueOrNull ?? const [])
            .where((w) => w.id == manifest.value.worldId)
            .firstOrNull;
        if (existing != null) {
          final replace = await _confirm(
            title: context.l10n.importReplaceTitle(existing.name),
            body: context.l10n.importReplaceBody,
            action: context.l10n.importReplaceAction,
          );
          if (!replace || !mounted) return;
        }

        final result = await archives.importArchive(path);
        if (!mounted) return;
        if (result.isErr) {
          _notify(localizedError(context, result.error));
          return;
        }
        final worldId = result.value;
        final indexed = await _rebuildIndex(worldId);
        if (!mounted) return;
        await ref
            .read(settingsRepositoryProvider)
            .set(SettingsKeys.lastOpenedWorld, worldId);
        if (!mounted) return;
        _notify(indexed
            ? context.l10n.worldImported
            : context.l10n.searchIndexFailed);
        context.go(Routes.home(worldId));
      });

  /// Rebuilds a world's search index after its rows were replaced;
  /// false when it failed (the world itself is intact).
  Future<bool> _rebuildIndex(String worldId) async {
    try {
      await ref.read(searchRepositoryProvider).rebuildIndex(worldId);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _confirm({
    required String title,
    required String body,
    required String action,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SizedBox(width: 420, child: Text(body)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.l10n.cancel)),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(action)),
        ],
      ),
    );
    return confirmed == true;
  }

  Future<void> _restoreBackup(BackupInfo backup) => _run(() async {
        final confirmed = await _confirm(
          title: context.l10n.restoreBackupTitle,
          body: context.l10n.restoreBackupBody(backup.fileName),
          action: context.l10n.restore,
        );
        if (!confirmed || !mounted) return;

        // Pending editor edits belong in the safety backup the service
        // writes before replacing the world.
        await flushPendingSaves();
        final result = await ref
            .read(backupServiceProvider)
            .restore(backup.path, worldId: widget.worldId);
        if (!mounted) return;
        if (result.isErr) {
          _notify(localizedError(context, result.error));
          _refreshBackups();
          return;
        }
        final indexed = await _rebuildIndex(result.value);
        if (!mounted) return;
        _notify(indexed
            ? context.l10n.backupRestored
            : context.l10n.searchIndexFailed);
        _refreshBackups();
      });

  @override
  Widget build(BuildContext context) {
    final world = ref.watch(worldProvider(widget.worldId)).valueOrNull;
    final locale = ref.watch(localeControllerProvider);
    final themeMode = ref.watch(themeModeProvider);
    final l = context.l10n;

    return Scaffold(
      appBar: AppBar(
        leading: historyLeading(),
        leadingWidth: kHistoryLeadingWidth,
        title: Text(l.settingsTitle),
      ),
      body: AbsorbPointer(
        absorbing: _busy,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 60),
          children: [
            if (_busy) const LinearProgressIndicator(minHeight: 2),
            if (world != null) ...[
              _SectionCard(
                title: l.worldSection,
                children: [
                  ListTile(
                    leading: Icon(SettingPacks.of(world.style).icon,
                        color: GmhColors.ember),
                    title: Text(world.name),
                    subtitle: Text(
                      '${l.worldStyleLabel}: '
                      '${world.style.localizedName(context)}',
                    ),
                    trailing: const Icon(Icons.edit_outlined, size: 18),
                    onTap: () async {
                      final draft =
                          await showWorldEditor(context, initial: world);
                      if (draft == null) return;
                      await ref.read(worldRepositoryProvider).updateWorld(
                          world.copyWith(
                              name: draft.name,
                              description: draft.description,
                              style: draft.style));
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.delete_outline),
                    title: Text(l.trashTitle),
                    trailing: Text(
                        '${ref.watch(trashProvider(widget.worldId)).valueOrNull?.length ?? 0}',
                        style: TextStyle(color: GmhColors.parchmentDim)),
                    onTap: () => ref
                        .read(workspaceTabsProvider.notifier)
                        .openInNewTab(Routes.trash(widget.worldId)),
                  ),
                ],
              ),
              const SizedBox(height: 14),
            ],
            _SectionCard(
              title: l.languageSection,
              children: [
                _LanguageTile(
                  label: l.languageSystem,
                  selected: locale == null,
                  onTap: () => ref
                      .read(localeControllerProvider.notifier)
                      .setLocale(null),
                ),
                _LanguageTile(
                  label: l.languageEnglish,
                  selected: locale?.languageCode == 'en',
                  onTap: () => ref
                      .read(localeControllerProvider.notifier)
                      .setLocale(const Locale('en')),
                ),
                _LanguageTile(
                  label: l.languageRussian,
                  selected: locale?.languageCode == 'ru',
                  onTap: () => ref
                      .read(localeControllerProvider.notifier)
                      .setLocale(const Locale('ru')),
                ),
                _LanguageTile(
                  label: l.languageGerman,
                  selected: locale?.languageCode == 'de',
                  onTap: () => ref
                      .read(localeControllerProvider.notifier)
                      .setLocale(const Locale('de')),
                ),
                _LanguageTile(
                  label: l.languageFrench,
                  selected: locale?.languageCode == 'fr',
                  onTap: () => ref
                      .read(localeControllerProvider.notifier)
                      .setLocale(const Locale('fr')),
                ),
                _LanguageTile(
                  label: l.languageChinese,
                  selected: locale?.languageCode == 'zh',
                  onTap: () => ref
                      .read(localeControllerProvider.notifier)
                      .setLocale(const Locale('zh')),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _SectionCard(
              title: l.appearanceSection,
              children: [
                _LanguageTile(
                  label: l.themeSystem,
                  selected: themeMode == ThemeMode.system,
                  onTap: () => ref
                      .read(themeModeProvider.notifier)
                      .setMode(ThemeMode.system),
                ),
                _LanguageTile(
                  label: l.themeLight,
                  selected: themeMode == ThemeMode.light,
                  onTap: () => ref
                      .read(themeModeProvider.notifier)
                      .setMode(ThemeMode.light),
                ),
                _LanguageTile(
                  label: l.themeDark,
                  selected: themeMode == ThemeMode.dark,
                  onTap: () => ref
                      .read(themeModeProvider.notifier)
                      .setMode(ThemeMode.dark),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _SectionCard(
              title: l.exportSection(world?.name ?? '…'),
              subtitle: l.exportSubtitle,
              children: [
                ListTile(
                  leading: const Icon(Icons.inventory_2_outlined),
                  title: Text(l.exportArchiveTitle),
                  subtitle: Text(l.exportArchiveSubtitle,
                      style: const TextStyle(fontSize: 11.5)),
                  onTap: _exportArchive,
                ),
                ListTile(
                  leading: const Icon(Icons.data_object),
                  title: Text(l.exportJsonTitle),
                  subtitle: Text(l.exportJsonSubtitle,
                      style: const TextStyle(fontSize: 11.5)),
                  onTap: _exportJson,
                ),
                ListTile(
                  leading: const Icon(Icons.picture_as_pdf_outlined),
                  title: Text(l.exportPdfTitle),
                  subtitle: Text(l.exportPdfSubtitle,
                      style: const TextStyle(fontSize: 11.5)),
                  onTap: _exportPdf,
                ),
                ListTile(
                  leading: const Icon(Icons.notes_outlined),
                  title: Text(l.exportMarkdownTitle),
                  subtitle: Text(l.exportMarkdownSubtitle,
                      style: const TextStyle(fontSize: 11.5)),
                  onTap: _exportMarkdown,
                ),
              ],
            ),
            const SizedBox(height: 14),
            _SectionCard(
              title: l.importSection,
              children: [
                ListTile(
                  leading: const Icon(Icons.unarchive_outlined),
                  title: Text(l.importArchiveTitle),
                  subtitle: Text(l.importArchiveSubtitle,
                      style: const TextStyle(fontSize: 11.5)),
                  onTap: _importArchive,
                ),
              ],
            ),
            const SizedBox(height: 14),
            _SectionCard(
              title: l.backupsSection,
              subtitle: l.backupsSubtitle(GmhConstants.maxAutoBackups),
              children: [
                ListTile(
                  leading:
                      Icon(Icons.save_outlined, color: GmhColors.ember),
                  title: Text(l.backupNow),
                  onTap: _backupNow,
                ),
                if (_backups.isEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                    child: Text(l.noBackups,
                        style: TextStyle(
                            fontSize: 12, color: GmhColors.parchmentFaint)),
                  )
                else
                  for (final backup in _backups)
                    ListTile(
                      leading: const Icon(Icons.history, size: 20),
                      title: Text(
                          localizedDateTime(context,
                              backup.modifiedAt.millisecondsSinceEpoch),
                          style: const TextStyle(fontSize: 13)),
                      subtitle: Text(
                          '${(backup.sizeBytes / 1024).toStringAsFixed(0)} KB',
                          style: const TextStyle(fontSize: 11)),
                      trailing: TextButton(
                        onPressed: () => _restoreBackup(backup),
                        child: Text(l.restore),
                      ),
                    ),
              ],
            ),
            const SizedBox(height: 14),
            _SectionCard(
              title: l.aboutSection,
              children: [
                ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: Text(l.helpTitle),
                  subtitle: Text(l.helpSettingsSubtitle,
                      style: const TextStyle(fontSize: 11.5)),
                  onTap: () => context.go(Routes.help(widget.worldId)),
                ),
                ListTile(
                  leading: const Icon(Icons.shield_outlined),
                  title: Text(l.aboutLocalFirst),
                  subtitle: Text(l.aboutLocalFirstBody,
                      style: const TextStyle(fontSize: 11.5)),
                ),
                ListTile(
                  leading: const Icon(Icons.public),
                  title: Text(l.switchWorld),
                  onTap: () => context.go(Routes.worlds()),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        selected ? Icons.radio_button_checked : Icons.radio_button_off,
        size: 19,
        color: selected ? GmhColors.ember : GmhColors.parchmentDim,
      ),
      title: Text(label, style: const TextStyle(fontSize: 13.5)),
      onTap: onTap,
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> children;

  const _SectionCard({
    required this.title,
    required this.children,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                if (subtitle != null) ...[
                  const SizedBox(height: 3),
                  Text(subtitle!,
                      style: TextStyle(
                          fontSize: 11.5, color: GmhColors.parchmentDim)),
                ],
              ],
            ),
          ),
          ...children,
          const SizedBox(height: 6),
        ],
      ),
    );
  }
}

/// A file-name stem that is valid on every desktop OS: no reserved
/// characters, no Windows device names (CON, NUL, COM1…), never empty.
String exportFileStem(String name) {
  var cleaned = name
      .replaceAll(RegExp(r'''[<>:"/\\|?*\x00-\x1F]'''), '')
      .trim()
      .replaceAll(RegExp(r'\s+'), '-')
      .replaceAll(RegExp(r'^[.\-]+|[.\-]+$'), '')
      .toLowerCase();
  if (cleaned.isEmpty) cleaned = 'world';
  if (RegExp(r'^(con|prn|aux|nul|com[0-9]|lpt[0-9])$').hasMatch(cleaned)) {
    cleaned = '$cleaned-world';
  }
  return cleaned.length > 60 ? cleaned.substring(0, 60) : cleaned;
}
