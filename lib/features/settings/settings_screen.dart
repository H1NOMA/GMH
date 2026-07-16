import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;
import 'package:share_plus/share_plus.dart';

import '../../app/providers.dart';
import '../../app/router.dart';
import '../../app/theme/gmh_theme.dart';
import '../../core/constants.dart';
import '../../core/utils/dates.dart';
import '../../data/backup/backup_service.dart';
import '../shell/ui_providers.dart';

/// Settings: manual/automatic backups, full-project export (.gmhw ZIP),
/// JSON export, PDF world book, and restore/import.
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
        result.fold(
          (path) {
            _notify('Backup saved.');
            _refreshBackups();
          },
          (error) => _notify(error.userMessage),
        );
      });

  Future<void> _shareFile(String path, String message) async {
    try {
      await SharePlus.instance.share(
        ShareParams(files: [XFile(path)], text: message),
      );
    } catch (_) {
      // Sharing is unavailable on some desktops; the file path is shown.
      _notify('Saved to: $path');
    }
  }

  Future<void> _exportArchive() => _run(() async {
        final world =
            await ref.read(worldRepositoryProvider).getWorld(widget.worldId);
        final dir = await _exportsDir();
        final name = _safeName(world?.name ?? 'world');
        final path = p.join(dir,
            '$name.${GmhConstants.projectArchiveExtension}');
        final result = await ref
            .read(projectArchiveServiceProvider)
            .exportArchive(widget.worldId, path);
        await result.fold(
          (path) => _shareFile(path, 'GMH world archive'),
          (error) async => _notify(error.userMessage),
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
        await result.fold(
          (path) => _shareFile(path, 'GMH world data (JSON)'),
          (error) async => _notify(error.userMessage),
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
        await result.fold(
          (path) => _shareFile(path, 'GMH world book (PDF)'),
          (error) async => _notify(error.userMessage),
        );
      });

  Future<String> _exportsDir() async {
    final root = ref.read(appRootDirProvider);
    final dir = Directory(p.join(root, 'exports'));
    await dir.create(recursive: true);
    return dir.path;
  }

  String _safeName(String name) => name
      .replaceAll(RegExp(r'[^\w\s-]'), '')
      .trim()
      .replaceAll(RegExp(r'\s+'), '-')
      .toLowerCase();

  Future<void> _importArchive() => _run(() async {
        final picked = await FilePicker.platform.pickFiles(
          dialogTitle: 'Choose a .gmhw archive',
          type: FileType.any,
        );
        final path = picked?.files.firstOrNull?.path;
        if (path == null) return;

        final result =
            await ref.read(projectArchiveServiceProvider).importArchive(path);
        result.fold(
          (worldId) {
            _notify('World imported.');
            ref.read(searchRepositoryProvider).rebuildIndex(worldId);
            if (mounted) context.go(Routes.home(worldId));
          },
          (error) => _notify(error.userMessage),
        );
      });

  Future<void> _restoreBackup(BackupInfo backup) => _run(() async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Restore this backup?'),
            content: Text(
                'The world will be replaced with the contents of '
                '"${backup.fileName}". A safety backup of the current state '
                'is taken first.'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('Cancel')),
              FilledButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('Restore')),
            ],
          ),
        );
        if (confirmed != true) return;

        // Safety net before a destructive restore.
        await ref.read(backupServiceProvider).backupNow(widget.worldId);
        final result =
            await ref.read(backupServiceProvider).restore(backup.path);
        result.fold(
          (worldId) {
            ref.read(searchRepositoryProvider).rebuildIndex(worldId);
            _notify('Backup restored.');
            _refreshBackups();
          },
          (error) => _notify(error.userMessage),
        );
      });

  @override
  Widget build(BuildContext context) {
    final world = ref.watch(worldProvider(widget.worldId)).valueOrNull;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings & Backup')),
      body: AbsorbPointer(
        absorbing: _busy,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 60),
          children: [
            if (_busy) const LinearProgressIndicator(minHeight: 2),
            _SectionCard(
              title: 'Export "${world?.name ?? '…'}"',
              subtitle:
                  'Everything stays on this device until you share it.',
              children: [
                ListTile(
                  leading: const Icon(Icons.inventory_2_outlined),
                  title: const Text('Full project archive (.gmhw)'),
                  subtitle: const Text(
                      'Database + all media in one file. Use it to move '
                      'between devices.',
                      style: TextStyle(fontSize: 11.5)),
                  onTap: _exportArchive,
                ),
                ListTile(
                  leading: const Icon(Icons.data_object),
                  title: const Text('JSON data export'),
                  subtitle: const Text(
                      'All entries, links and metadata as readable JSON.',
                      style: TextStyle(fontSize: 11.5)),
                  onTap: _exportJson,
                ),
                ListTile(
                  leading: const Icon(Icons.picture_as_pdf_outlined),
                  title: const Text('PDF world book'),
                  subtitle: const Text(
                      'A printable book of your world, chapter per category.',
                      style: TextStyle(fontSize: 11.5)),
                  onTap: _exportPdf,
                ),
              ],
            ),
            const SizedBox(height: 14),
            _SectionCard(
              title: 'Import',
              children: [
                ListTile(
                  leading: const Icon(Icons.unarchive_outlined),
                  title: const Text('Import project archive'),
                  subtitle: const Text(
                      'Restores a .gmhw file, including all media.',
                      style: TextStyle(fontSize: 11.5)),
                  onTap: _importArchive,
                ),
              ],
            ),
            const SizedBox(height: 14),
            _SectionCard(
              title: 'Backups',
              subtitle: 'A backup is taken automatically once a day when '
                  'you open the app. The last ${GmhConstants.maxAutoBackups} '
                  'are kept.',
              children: [
                ListTile(
                  leading: const Icon(Icons.save_outlined,
                      color: GmhColors.ember),
                  title: const Text('Back up now'),
                  onTap: _backupNow,
                ),
                if (_backups.isEmpty)
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16, 4, 16, 12),
                    child: Text('No backups yet.',
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
                        child: const Text('Restore'),
                      ),
                    ),
              ],
            ),
            const SizedBox(height: 14),
            _SectionCard(
              title: 'About',
              children: [
                const ListTile(
                  leading: Icon(Icons.shield_outlined),
                  title: Text('Local-first'),
                  subtitle: Text(
                      'All data is stored on this device. No account, no '
                      'cloud, fully offline.',
                      style: TextStyle(fontSize: 11.5)),
                ),
                ListTile(
                  leading: const Icon(Icons.public),
                  title: const Text('Switch world'),
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
                      style: const TextStyle(
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
