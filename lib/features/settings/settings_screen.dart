import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';

import '../../app/l10n_ext.dart';
import '../../app/locale_provider.dart';
import '../../app/theme_provider.dart';
import '../../app/providers.dart';
import '../../app/router.dart';
import '../../app/theme/gmh_theme.dart';
import '../../core/constants.dart';
import '../../core/utils/dates.dart';
import '../../data/backup/backup_service.dart';
import '../import/ttg_import_wizard.dart';
import '../shell/ui_providers.dart';

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
        final world =
            await ref.read(worldRepositoryProvider).getWorld(widget.worldId);
        final dir = await _exportsDir();
        final name = _safeName(world?.name ?? 'world');
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
        final world =
            await ref.read(worldRepositoryProvider).getWorld(widget.worldId);
        final dir = await _exportsDir();
        final path = p.join(dir, '${_safeName(world?.name ?? 'world')}.json');
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
        final world =
            await ref.read(worldRepositoryProvider).getWorld(widget.worldId);
        final dir = await _exportsDir();
        final path = p.join(dir, '${_safeName(world?.name ?? 'world')}.pdf');
        final result = await ref.read(pdfExporterProvider).exportWorldBook(
              worldId: widget.worldId,
              worldName: world?.name ?? 'World',
              outputPath: path,
            );
        if (!mounted) return;
        await result.fold(
          (path) => _shareFile(path, context.l10n.sharePdfText),
          (error) async => _notify(localizedError(context, error)),
        );
      });

  Future<String> _exportsDir() async {
    final root = ref.read(appRootDirProvider);
    final dir = Directory(p.join(root, 'exports'));
    await dir.create(recursive: true);
    return dir.path;
  }

  String _safeName(String name) {
    final cleaned = name
        .replaceAll(RegExp(r'''[<>:"/\\|?*]'''), '')
        .trim()
        .replaceAll(RegExp(r'\s+'), '-')
        .toLowerCase();
    return cleaned.isEmpty ? 'world' : cleaned;
  }

  Future<void> _importArchive() => _run(() async {
        final picked = await FilePicker.platform.pickFiles(
          dialogTitle: context.l10n.importPickArchive,
          type: FileType.any,
        );
        final path = picked?.files.firstOrNull?.path;
        if (path == null || !mounted) return;

        // Importing replaces the archive's world wholesale if it already
        // exists — that is irreversible, so it needs explicit consent.
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(context.l10n.importConfirmTitle),
            content: Text(context.l10n.importConfirmBody),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(context.l10n.cancel)),
              FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(context.l10n.importSection)),
            ],
          ),
        );
        if (confirmed != true || !mounted) return;

        final result =
            await ref.read(projectArchiveServiceProvider).importArchive(path);
        if (!mounted) return;
        if (result.isErr) {
          _notify(localizedError(context, result.error));
          return;
        }
        final worldId = result.value;
        // Await the FTS rebuild while the busy indicator is up: quitting
        // right after import would otherwise leave the world unsearchable.
        await ref.read(searchRepositoryProvider).rebuildIndex(worldId);
        if (!mounted) return;
        _notify(context.l10n.worldImported);
        context.go(Routes.home(worldId));
      });

  Future<void> _restoreBackup(BackupInfo backup) => _run(() async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(context.l10n.restoreBackupTitle),
            content: Text(context.l10n.restoreBackupBody(backup.fileName)),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(context.l10n.cancel)),
              FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(context.l10n.restore)),
            ],
          ),
        );
        if (confirmed != true) return;

        // Safety net before a destructive restore.
        await ref.read(backupServiceProvider).backupNow(widget.worldId);
        final result =
            await ref.read(backupServiceProvider).restore(backup.path);
        if (!mounted) return;
        if (result.isErr) {
          _notify(localizedError(context, result.error));
          return;
        }
        // Await the FTS rebuild while the busy indicator is up: quitting
        // right after restore would otherwise leave the world unsearchable.
        await ref.read(searchRepositoryProvider).rebuildIndex(result.value);
        if (!mounted) return;
        _notify(context.l10n.backupRestored);
        _refreshBackups();
      });

  @override
  Widget build(BuildContext context) {
    final world = ref.watch(worldProvider(widget.worldId)).valueOrNull;
    final locale = ref.watch(localeControllerProvider);
    final themeMode = ref.watch(themeModeProvider);
    final l = context.l10n;

    return Scaffold(
      appBar: AppBar(title: Text(l.settingsTitle)),
      body: AbsorbPointer(
        absorbing: _busy,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 60),
          children: [
            if (_busy) const LinearProgressIndicator(minHeight: 2),
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
                ListTile(
                  leading: const Icon(Icons.move_down_outlined),
                  title: Text(l.ttgSettingsTitle),
                  subtitle: Text(l.ttgSettingsSubtitle,
                      style: const TextStyle(fontSize: 11.5)),
                  onTap: () => showTtgImportWizard(context),
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
                          formatDateTime(
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
