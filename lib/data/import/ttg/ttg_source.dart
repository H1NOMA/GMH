import 'dart:convert';
import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';

import '../../../core/exceptions.dart';
import 'ttg_mapping.dart';

/// Reads a TTG D&D database into a normalized, format-independent model.
///
/// Three physical formats are supported:
///  * a SQLite database (`.db`, `.sqlite`, `.sqlite3`, `.ttg`) — the schema
///    is discovered by introspection, so column naming variations survive;
///  * a JSON export (`.json`) — every top-level array of objects becomes a
///    collection;
///  * a ZIP export (`.zip`) containing the JSON plus media files.
///
/// The reader only *reads*; nothing is written back to the source.

/// One media reference on a record: either a path (resolved lazily against
/// the source location) or inline bytes (SQLite BLOB columns).
class TtgMediaRef {
  final String? ref;
  final List<int>? bytes;
  final String fileName;
  final String caption;

  const TtgMediaRef({
    this.ref,
    this.bytes,
    required this.fileName,
    this.caption = '',
  });
}

/// An outgoing reference to another record, addressed by its source key.
class TtgRelation {
  /// `<collection>#<sourceId>` of the target.
  final String targetKey;
  final String role;

  const TtgRelation({required this.targetKey, required this.role});
}

/// One object from the source database, normalized.
class TtgRecord {
  /// `<collection>#<sourceId>` — globally unique within the source.
  final String key;
  final String collection;
  final String name;
  final String summary;

  /// Rich text body (markdown, HTML, plain text or a Quill delta).
  final String body;
  final Map<String, Object?> attributes;
  final List<TtgRelation> relations;
  final List<String> tags;
  final List<TtgMediaRef> media;
  final bool favorite;
  final int? createdAt;
  final int? updatedAt;

  const TtgRecord({
    required this.key,
    required this.collection,
    required this.name,
    this.summary = '',
    this.body = '',
    this.attributes = const {},
    this.relations = const [],
    this.tags = const [],
    this.media = const [],
    this.favorite = false,
    this.createdAt,
    this.updatedAt,
  });
}

/// The whole source, ready for migration.
class TtgSourceData {
  /// Suggested name for the destination world.
  final String name;

  /// Collection name (as found in the source) -> records.
  final Map<String, List<TtgRecord>> collections;

  /// Resolves a media ref to bytes (file next to the DB, or ZIP entry).
  final Future<List<int>?> Function(String ref) readMedia;

  /// Non-fatal problems found while reading (reported, never thrown).
  final List<String> issues;

  TtgSourceData({
    required this.name,
    required this.collections,
    required this.readMedia,
    required this.issues,
  });

  int get totalRecords =>
      collections.values.fold(0, (sum, list) => sum + list.length);
}

// =========================================================== field heuristics

const _idColumns = {'id', 'uuid', 'guid', '_id', 'pk', 'key'};
const _nameColumns = {'name', 'title', 'label', 'display_name', 'displayname'};
const _summaryColumns = {
  'summary', 'subtitle', 'short_description', 'shortdescription', 'blurb',
  'tagline', 'excerpt',
};
const _bodyColumns = {
  'description', 'body', 'content', 'text', 'notes', 'details', 'bio',
  'biography', 'entry', 'lore', 'fulltext', 'full_text', 'markdown', 'html',
};
const _mediaColumns = {
  'image', 'img', 'portrait', 'avatar', 'cover', 'picture', 'token',
  'image_path', 'imagepath', 'image_url', 'imageurl', 'map_image',
  'mapimage', 'thumbnail', 'banner', 'photo', 'file', 'file_path',
  'filepath', 'path', 'attachment', 'url',
};
const _blobMediaColumns = {'image', 'data', 'bytes', 'blob', 'file_data'};
const _tagColumns = {'tags', 'tag', 'labels', 'keywords', 'categories'};
const _favoriteColumns = {'favorite', 'is_favorite', 'starred', 'pinned'};
const _createdColumns = {'created_at', 'createdat', 'created', 'date_created'};
const _updatedColumns = {
  'updated_at', 'updatedat', 'updated', 'modified', 'modified_at',
  'last_modified',
};

const _mediaExtensions = {
  '.png', '.jpg', '.jpeg', '.webp', '.gif', '.svg', '.bmp',
  '.pdf', '.docx', '.doc', '.txt', '.md', '.rtf',
  '.mp3', '.wav', '.ogg', '.flac', '.m4a',
  '.mp4', '.webm', '.mov', '.avi', '.mkv',
  '.zip',
};

String _norm(String s) => s.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]'), '');

bool _looksLikeMediaPath(Object? value) {
  if (value is! String || value.isEmpty || value.length > 1024) return false;
  final ext = p.extension(value.split('?').first).toLowerCase();
  return _mediaExtensions.contains(ext);
}

int? _parseTimestamp(Object? value) {
  if (value is num) {
    final v = value.toInt();
    if (v <= 0) return null;
    if (v > 100000000000) return v; // already milliseconds
    return v * 1000; // seconds
  }
  if (value is String) {
    return DateTime.tryParse(value)?.millisecondsSinceEpoch;
  }
  return null;
}

List<String> _parseTags(Object? value) {
  if (value == null) return const [];
  if (value is List) {
    return value.map((e) => e.toString().trim()).where((s) => s.isNotEmpty).toList();
  }
  final s = value.toString().trim();
  if (s.isEmpty) return const [];
  if (s.startsWith('[')) {
    try {
      final list = jsonDecode(s);
      if (list is List) {
        return list.map((e) => e.toString().trim()).where((t) => t.isNotEmpty).toList();
      }
    } catch (_) {}
  }
  return s
      .split(RegExp(r'[,;|]'))
      .map((t) => t.trim().replaceFirst(RegExp(r'^#'), ''))
      .where((t) => t.isNotEmpty)
      .toList();
}

/// `city_id` -> `city`, `parentLocationId` -> `parentlocation`.
String? _fkBaseName(String column) {
  final n = column.toLowerCase();
  if (n == 'id' || n == 'uuid' || n == 'guid') return null;
  if (n.endsWith('_id')) return _norm(n.substring(0, n.length - 3));
  if (n.endsWith('id') && n.length > 2) return _norm(n.substring(0, n.length - 2));
  if (n.endsWith('_uuid')) return _norm(n.substring(0, n.length - 5));
  return null;
}

// ================================================================== entry

/// Reads any supported TTG source file. Throws [ImportException] when the
/// file is unreadable or matches no supported format.
Future<TtgSourceData> readTtgSource(String path) async {
  final file = File(path);
  if (!await file.exists()) {
    throw const ImportException('Source file not found.');
  }
  final ext = p.extension(path).toLowerCase();
  final baseName = p.basenameWithoutExtension(path);

  if (ext == '.json') {
    final text = await file.readAsString();
    return _readJson(text, baseName, _fileSystemMediaResolver(path));
  }
  if (ext == '.zip') {
    return _readZip(path, baseName);
  }
  // Everything else: try SQLite first (covers .db/.sqlite/.ttg and unknown
  // extensions), then JSON as a fallback for mislabeled exports.
  try {
    return _readSqlite(path, baseName);
  } on ImportException {
    rethrow;
  } catch (_) {
    try {
      final text = await file.readAsString();
      return _readJson(text, baseName, _fileSystemMediaResolver(path));
    } catch (_) {
      throw const ImportException(
          'Unsupported file: not a SQLite database, JSON or ZIP export.');
    }
  }
}

/// Resolves media refs against the source file's directory, also probing
/// the conventional media subfolders.
Future<List<int>?> Function(String ref) _fileSystemMediaResolver(
    String sourcePath) {
  final dir = p.dirname(sourcePath);
  return (String ref) async {
    final cleaned = ref.replaceAll('\\', '/').split('?').first;
    if (cleaned.startsWith('http://') || cleaned.startsWith('https://')) {
      return null; // offline app: remote URLs are reported, never fetched
    }
    final candidates = [
      cleaned,
      p.join(dir, cleaned),
      for (final sub in ['media', 'images', 'files', 'attachments', 'assets'])
        p.join(dir, sub, p.basename(cleaned)),
      p.join(dir, p.basename(cleaned)),
    ];
    for (final candidate in candidates) {
      final f = File(candidate);
      if (await f.exists()) return f.readAsBytes();
    }
    return null;
  };
}

// ================================================================== SQLite

class _TableInfo {
  final String name;
  final List<String> columns;
  final Map<String, String> columnTypes; // lowercased column -> type
  final Map<String, String> foreignKeys; // column -> referenced table
  const _TableInfo(this.name, this.columns, this.columnTypes, this.foreignKeys);

  String? firstColumn(Set<String> wanted) {
    for (final c in columns) {
      if (wanted.contains(c.toLowerCase())) return c;
    }
    return null;
  }
}

TtgSourceData _readSqlite(String path, String defaultName) {
  final Database db;
  try {
    db = sqlite3.open(path, mode: OpenMode.readOnly);
  } catch (e) {
    throw ImportException('Could not open SQLite database: $e');
  }
  try {
    final issues = <String>[];
    final tables = <_TableInfo>[];
    final tableRows = db.select(
        "SELECT name FROM sqlite_master WHERE type = 'table' "
        "AND name NOT LIKE 'sqlite_%'");
    if (tableRows.isEmpty) {
      throw const ImportException('The database contains no tables.');
    }
    for (final row in tableRows) {
      final table = row['name'] as String;
      final info = db.select('PRAGMA table_info("$table")');
      final columns = [for (final c in info) c['name'] as String];
      final types = {
        for (final c in info)
          (c['name'] as String).toLowerCase():
              ((c['type'] as String?) ?? '').toUpperCase(),
      };
      final fks = <String, String>{};
      for (final fk in db.select('PRAGMA foreign_key_list("$table")')) {
        fks[fk['from'] as String] = fk['table'] as String;
      }
      tables.add(_TableInfo(table, columns, types, fks));
    }

    final byNormName = {for (final t in tables) _norm(t.name): t};

    /// Resolves an FK column to its target table: declared FK first, then
    /// the `city_id` -> `cities` naming convention.
    String? fkTargetTable(_TableInfo table, String column) {
      final declared = table.foreignKeys[column];
      if (declared != null) return declared;
      final base = _fkBaseName(column);
      if (base == null) return null;
      for (final candidate in [base, '${base}s', '${base}es']) {
        if (byNormName.containsKey(candidate)) return byNormName[candidate]!.name;
      }
      final ies = base.endsWith('y')
          ? '${base.substring(0, base.length - 1)}ies'
          : null;
      if (ies != null && byNormName.containsKey(ies)) {
        return byNormName[ies]!.name;
      }
      return null;
    }

    // Classify tables: entity collections, join tables, attachment tables.
    final joinTables = <_TableInfo>[];
    final attachmentTables = <_TableInfo>[];
    final entityTables = <_TableInfo>[];
    for (final t in tables) {
      final norm = _norm(t.name);
      final fkColumns = t.columns
          .where((c) => fkTargetTable(t, c) != null && c.toLowerCase() != 'id')
          .toList();
      final hasName = t.firstColumn(_nameColumns) != null;
      final hasPath = t.columns.any((c) =>
          _mediaColumns.contains(c.toLowerCase()) &&
          !t.foreignKeys.containsKey(c));
      final isMediaish = norm.contains('media') ||
          norm.contains('attachment') ||
          norm.contains('image') ||
          norm == 'files';
      if (isMediaish && fkColumns.isNotEmpty && (hasPath || !hasName)) {
        attachmentTables.add(t);
      } else if (fkColumns.length >= 2 && !hasName && t.columns.length <= 5) {
        joinTables.add(t);
      } else {
        entityTables.add(t);
      }
    }

    String rowId(Row row, _TableInfo t, int index) {
      final idCol = t.firstColumn(_idColumns);
      final v = idCol == null ? null : row[idCol];
      return v?.toString() ?? 'row$index';
    }

    // Attachments grouped by "<table>#<ownerId>".
    final attachmentsByOwner = <String, List<TtgMediaRef>>{};
    for (final t in attachmentTables) {
      final rows = db.select('SELECT * FROM "${t.name}"');
      for (final row in rows) {
        String? ownerTable;
        Object? ownerId;
        for (final c in t.columns) {
          final target = fkTargetTable(t, c);
          if (target != null && c.toLowerCase() != 'id') {
            ownerTable = target;
            ownerId = row[c];
            break;
          }
        }
        if (ownerTable == null || ownerId == null) continue;
        String? ref;
        List<int>? bytes;
        for (final c in t.columns) {
          final v = row[c];
          if (v is List<int> && v.isNotEmpty) {
            bytes = v;
          } else if (ref == null && _looksLikeMediaPath(v)) {
            ref = v as String;
          }
        }
        if (ref == null && bytes == null) continue;
        final nameCol = t.firstColumn({..._nameColumns, 'filename', 'file_name'});
        final captionCol = t.firstColumn({'caption', 'description'});
        attachmentsByOwner
            .putIfAbsent('$ownerTable#$ownerId', () => [])
            .add(TtgMediaRef(
              ref: ref,
              bytes: bytes,
              fileName: (nameCol == null ? null : row[nameCol]?.toString()) ??
                  (ref == null ? 'attachment.bin' : p.basename(ref)),
              caption:
                  (captionCol == null ? null : row[captionCol]?.toString()) ??
                      '',
            ));
      }
    }

    // Join-table relations grouped by "<table>#<id>" of the left side.
    final joinRelations = <String, List<TtgRelation>>{};
    for (final t in joinTables) {
      final fkCols = [
        for (final c in t.columns)
          if (c.toLowerCase() != 'id' && fkTargetTable(t, c) != null) c
      ];
      if (fkCols.length < 2) continue;
      final roleCol = t.firstColumn({'role', 'relation', 'type', 'label'});
      final rows = db.select('SELECT * FROM "${t.name}"');
      for (final row in rows) {
        final left = '${fkTargetTable(t, fkCols[0])}#${row[fkCols[0]]}';
        final right = '${fkTargetTable(t, fkCols[1])}#${row[fkCols[1]]}';
        final role = (roleCol == null ? null : row[roleCol]?.toString()) ??
            humanizeRole(t.name);
        joinRelations
            .putIfAbsent(left, () => [])
            .add(TtgRelation(targetKey: right, role: role));
      }
    }

    // Entity tables -> records.
    final collections = <String, List<TtgRecord>>{};
    for (final t in entityTables) {
      final nameCol = t.firstColumn(_nameColumns);
      final rows = db.select('SELECT * FROM "${t.name}"');
      if (rows.isEmpty) continue;
      // A table with no name-like column and no body is likely technical
      // (settings, schema_migrations) — skip it, but say so.
      final bodyCol = t.firstColumn(_bodyColumns);
      if (nameCol == null && bodyCol == null) {
        issues.add('Skipped table "${t.name}" (no name or text columns).');
        continue;
      }

      final records = <TtgRecord>[];
      var index = 0;
      for (final row in rows) {
        index++;
        final id = rowId(row, t, index);
        final key = '${t.name}#$id';
        final attributes = <String, Object?>{};
        final relations = <TtgRelation>[...?joinRelations[key]];
        final media = <TtgMediaRef>[...?attachmentsByOwner[key]];
        var summary = '';
        var body = '';
        var favorite = false;
        int? createdAt;
        int? updatedAt;
        final tags = <String>[];

        for (final c in t.columns) {
          final lc = c.toLowerCase();
          final value = row[c];
          if (value == null) continue;
          if (_idColumns.contains(lc) || c == nameCol) continue;
          if (_summaryColumns.contains(lc)) {
            summary = value.toString();
          } else if (c == bodyCol) {
            body = value.toString();
          } else if (_tagColumns.contains(lc)) {
            tags.addAll(_parseTags(value));
          } else if (_favoriteColumns.contains(lc)) {
            favorite = value == 1 || value == true || value == 'true';
          } else if (_createdColumns.contains(lc)) {
            createdAt = _parseTimestamp(value);
          } else if (_updatedColumns.contains(lc)) {
            updatedAt = _parseTimestamp(value);
          } else if (value is List<int> &&
              _blobMediaColumns.contains(lc) &&
              value.isNotEmpty) {
            media.add(TtgMediaRef(bytes: value, fileName: '$lc.png'));
          } else if (fkTargetTable(t, c) != null) {
            relations.add(TtgRelation(
              targetKey: '${fkTargetTable(t, c)}#$value',
              role: humanizeRole(c),
            ));
          } else if (_mediaColumns.contains(lc) && _looksLikeMediaPath(value)) {
            media.add(TtgMediaRef(
                ref: value as String, fileName: p.basename(value)));
          } else if (value is String || value is num || value is bool) {
            attributes[c] = value;
          }
        }

        records.add(TtgRecord(
          key: key,
          collection: t.name,
          name: (nameCol == null ? null : row[nameCol]?.toString()) ??
              'Unnamed $index',
          summary: summary,
          body: body,
          attributes: attributes,
          relations: relations,
          tags: tags,
          media: media,
          favorite: favorite,
          createdAt: createdAt,
          updatedAt: updatedAt,
        ));
      }
      if (records.isNotEmpty) collections[t.name] = records;
    }

    if (collections.isEmpty) {
      throw const ImportException(
          'No importable tables were found in the database.');
    }

    // World name: a single-row worlds/settings-like table, else file name.
    var worldName = defaultName;
    for (final t in entityTables) {
      final norm = _norm(t.name);
      if ((norm == 'world' || norm == 'worlds' || norm == 'setting' ||
              norm == 'settings' || norm == 'meta') &&
          (collections[t.name]?.length ?? 0) == 1) {
        worldName = collections[t.name]!.first.name;
        collections.remove(t.name);
        break;
      }
    }

    return TtgSourceData(
      name: worldName,
      collections: collections,
      readMedia: _fileSystemMediaResolver(path),
      issues: issues,
    );
  } finally {
    db.dispose();
  }
}

// ==================================================================== JSON

TtgSourceData _readJson(
  String text,
  String defaultName,
  Future<List<int>?> Function(String ref) readMedia, {
  List<String>? issues,
}) {
  final Object? root;
  try {
    root = jsonDecode(text);
  } catch (e) {
    throw ImportException('Not valid JSON: $e');
  }
  if (root is! Map) {
    throw const ImportException(
        'Unsupported JSON layout: expected an object at the top level.');
  }
  final problems = issues ?? <String>[];
  var map = root.cast<String, Object?>();
  if (map['collections'] is Map) {
    map = (map['collections'] as Map).cast<String, Object?>();
  } else if (map['data'] is Map) {
    map = (map['data'] as Map).cast<String, Object?>();
  }

  final rawCollections = <String, List<Map<String, Object?>>>{};
  for (final entry in map.entries) {
    final value = entry.value;
    if (value is List && value.isNotEmpty && value.every((e) => e is Map)) {
      rawCollections[entry.key] =
          value.map((e) => (e as Map).cast<String, Object?>()).toList();
    }
  }
  if (rawCollections.isEmpty) {
    throw const ImportException(
        'The JSON contains no collections (arrays of objects).');
  }

  String? scalarKey(Map<String, Object?> obj, Set<String> wanted) {
    for (final k in obj.keys) {
      if (wanted.contains(_norm(k)) && obj[k] != null) return k;
    }
    return null;
  }

  final normSets = {
    for (final e in {
      'name': _nameColumns,
      'summary': _summaryColumns,
      'body': _bodyColumns,
      'tags': _tagColumns,
      'favorite': _favoriteColumns,
      'created': _createdColumns,
      'updated': _updatedColumns,
    }.entries)
      e.key: e.value.map(_norm).toSet(),
  };
  final mediaNorm = _mediaColumns.map(_norm).toSet();

  // collection lookup for `cityId` -> collection 'cities'.
  final collectionByNorm = <String, String>{};
  for (final name in rawCollections.keys) {
    final norm = _norm(name);
    collectionByNorm[norm] = name;
    collectionByNorm[singularizeType(norm)] = name;
  }

  final collections = <String, List<TtgRecord>>{};
  rawCollections.forEach((collectionName, objects) {
    final records = <TtgRecord>[];
    var index = 0;
    for (final obj in objects) {
      index++;
      final idKey = scalarKey(obj, _idColumns.map(_norm).toSet());
      final id = (idKey == null ? null : obj[idKey]?.toString()) ?? 'row$index';
      final key = '$collectionName#$id';
      final nameKey = scalarKey(obj, normSets['name']!);
      final attributes = <String, Object?>{};
      final relations = <TtgRelation>[];
      final media = <TtgMediaRef>[];
      final tags = <String>[];
      var summary = '';
      var body = '';
      var favorite = false;
      int? createdAt;
      int? updatedAt;

      for (final entry in obj.entries) {
        final k = entry.key;
        final nk = _norm(k);
        final value = entry.value;
        if (value == null || k == idKey || k == nameKey) continue;
        if (normSets['summary']!.contains(nk)) {
          summary = value.toString();
        } else if (normSets['body']!.contains(nk)) {
          body = value.toString();
        } else if (normSets['tags']!.contains(nk)) {
          tags.addAll(_parseTags(value));
        } else if (normSets['favorite']!.contains(nk)) {
          favorite = value == true || value == 1 || value == 'true';
        } else if (normSets['created']!.contains(nk)) {
          createdAt = _parseTimestamp(value);
        } else if (normSets['updated']!.contains(nk)) {
          updatedAt = _parseTimestamp(value);
        } else if (mediaNorm.contains(nk) && _looksLikeMediaPath(value)) {
          media.add(
              TtgMediaRef(ref: value as String, fileName: p.basename(value)));
        } else if (value is List &&
            (k.endsWith('_ids') || k.endsWith('Ids')) &&
            value.every((e) => e is String || e is num)) {
          final base = _fkBaseName(
              k.substring(0, k.length - 1)); // strip trailing 's'
          final target = base == null ? null : collectionByNorm[base];
          if (target != null) {
            for (final tid in value) {
              relations.add(TtgRelation(
                  targetKey: '$target#$tid', role: humanizeRole(k)));
            }
          } else {
            attributes[k] = jsonEncode(value);
          }
        } else if ((value is String || value is num) &&
            _fkBaseName(k) != null &&
            collectionByNorm.containsKey(_fkBaseName(k))) {
          relations.add(TtgRelation(
            targetKey: '${collectionByNorm[_fkBaseName(k)]}#$value',
            role: humanizeRole(k),
          ));
        } else if (value is String || value is num || value is bool) {
          attributes[k] = value;
        } else if (value is List &&
            value.every((e) => e is String || e is num || e is bool)) {
          attributes[k] = value.join(', ');
        } else {
          attributes[k] = jsonEncode(value);
        }
      }

      records.add(TtgRecord(
        key: key,
        collection: collectionName,
        name: (nameKey == null ? null : obj[nameKey]?.toString()) ??
            'Unnamed $index',
        summary: summary,
        body: body,
        attributes: attributes,
        relations: relations,
        tags: tags,
        media: media,
        favorite: favorite,
        createdAt: createdAt,
        updatedAt: updatedAt,
      ));
    }
    collections[collectionName] = records;
  });

  final rawWorldName = root['worldName'] ?? root['world'] ?? root['name'];
  final worldName =
      rawWorldName is String && rawWorldName.trim().isNotEmpty
          ? rawWorldName.trim()
          : defaultName;

  return TtgSourceData(
    name: worldName,
    collections: collections,
    readMedia: readMedia,
    issues: problems,
  );
}

// ===================================================================== ZIP

Future<TtgSourceData> _readZip(String path, String defaultName) async {
  final Archive archive;
  try {
    archive = ZipDecoder().decodeBytes(await File(path).readAsBytes());
  } catch (e) {
    throw ImportException('Not a valid ZIP archive: $e');
  }

  ArchiveFile? jsonFile;
  for (final preferred in ['data.json', 'db.json', 'export.json', 'world.json']) {
    jsonFile = archive.files
        .where((f) => f.isFile && p.basename(f.name) == preferred)
        .firstOrNull;
    if (jsonFile != null) break;
  }
  jsonFile ??= archive.files
      .where((f) => f.isFile && f.name.toLowerCase().endsWith('.json'))
      .fold<ArchiveFile?>(null, (best, f) =>
          best == null || f.size > best.size ? f : best);
  if (jsonFile == null) {
    throw const ImportException('The ZIP contains no JSON database.');
  }

  // Media entries are matched by full path first, then by basename.
  final byPath = <String, ArchiveFile>{};
  final byBase = <String, ArchiveFile>{};
  for (final f in archive.files) {
    if (!f.isFile) continue;
    final normalized = f.name.replaceAll('\\', '/');
    byPath[normalized] = f;
    byBase.putIfAbsent(p.basename(normalized), () => f);
  }

  Future<List<int>?> readMedia(String ref) async {
    final cleaned = ref.replaceAll('\\', '/').split('?').first;
    final entry = byPath[cleaned] ??
        byPath[cleaned.startsWith('/') ? cleaned.substring(1) : cleaned] ??
        byBase[p.basename(cleaned)];
    if (entry == null) return null;
    return entry.content as List<int>;
  }

  return _readJson(
    utf8.decode(jsonFile.content as List<int>),
    defaultName,
    readMedia,
  );
}
