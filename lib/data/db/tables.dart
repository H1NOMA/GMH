import 'package:drift/drift.dart';

/// drift table definitions. Row classes are suffixed with `Row` so they never
/// collide with domain models (mapping happens in the repositories).

@DataClassName('WorldRow')
class Worlds extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get coverMediaId => text().nullable()();

  /// Visual & terminology flavor: 'fantasy' (default) or 'cyberpunk'.
  TextColumn get style => text().withDefault(const Constant('fantasy'))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// User-defined archive categories. Entities of kind `custom` reference one
/// via `entities.custom_category_id` and otherwise behave exactly like
/// built-in kinds (documents, links, tags, attachments, search, export).
@DataClassName('CustomCategoryRow')
class CustomCategories extends Table {
  TextColumn get id => text()();
  TextColumn get worldId =>
      text().references(Worlds, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();

  /// Key into the UI icon set (see `categoryIcons`).
  TextColumn get icon => text().withDefault(const Constant('folder'))();

  /// ARGB color value.
  IntColumn get color => integer()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('EntityRow')
class Entities extends Table {
  TextColumn get id => text()();
  TextColumn get worldId =>
      text().references(Worlds, #id, onDelete: KeyAction.cascade)();
  TextColumn get kind => text()();

  /// Set when [kind] == 'custom': the user-defined category this entry
  /// belongs to.
  TextColumn get customCategoryId => text().nullable()();
  TextColumn get name => text()();
  TextColumn get summary => text().withDefault(const Constant(''))();
  TextColumn get attributesJson => text().withDefault(const Constant('{}'))();
  TextColumn get coverMediaId => text().nullable()();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();
  IntColumn get deletedAt => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('DocumentRow')
class Documents extends Table {
  TextColumn get id => text()();
  TextColumn get entityId =>
      text().references(Entities, #id, onDelete: KeyAction.cascade)();
  TextColumn get contentJson => text()();
  TextColumn get plainText => text().withDefault(const Constant(''))();
  IntColumn get wordCount => integer().withDefault(const Constant(0))();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {entityId}
      ];
}

@DataClassName('DocumentVersionRow')
class DocumentVersions extends Table {
  TextColumn get id => text()();
  TextColumn get documentId =>
      text().references(Documents, #id, onDelete: KeyAction.cascade)();
  TextColumn get contentJson => text()();
  TextColumn get note => text().withDefault(const Constant(''))();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('LinkRow')
class Links extends Table {
  TextColumn get id => text()();
  TextColumn get worldId =>
      text().references(Worlds, #id, onDelete: KeyAction.cascade)();
  TextColumn get sourceId =>
      text().references(Entities, #id, onDelete: KeyAction.cascade)();
  TextColumn get targetId =>
      text().references(Entities, #id, onDelete: KeyAction.cascade)();
  TextColumn get role => text().withDefault(const Constant('related'))();
  TextColumn get origin => text()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {sourceId, targetId, role, origin}
      ];
}

@DataClassName('TagRow')
class Tags extends Table {
  TextColumn get id => text()();
  TextColumn get worldId =>
      text().references(Worlds, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  IntColumn get color => integer()();

  /// Added in schema v3 (0 for tags created before the migration).
  IntColumn get createdAt => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {worldId, name}
      ];
}

@DataClassName('EntityTagRow')
class EntityTags extends Table {
  TextColumn get entityId =>
      text().references(Entities, #id, onDelete: KeyAction.cascade)();
  TextColumn get tagId =>
      text().references(Tags, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {entityId, tagId};
}

@DataClassName('MediaRow')
class MediaFiles extends Table {
  TextColumn get id => text()();
  TextColumn get worldId =>
      text().references(Worlds, #id, onDelete: KeyAction.cascade)();
  TextColumn get fileName => text()();
  TextColumn get relativePath => text()();
  TextColumn get mimeType => text()();
  IntColumn get sizeBytes => integer()();
  IntColumn get createdAt => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('EntityMediaRow')
class EntityMedia extends Table {
  TextColumn get entityId =>
      text().references(Entities, #id, onDelete: KeyAction.cascade)();
  TextColumn get mediaId =>
      text().references(MediaFiles, #id, onDelete: KeyAction.cascade)();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
  TextColumn get caption => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {entityId, mediaId};
}

@DataClassName('RecentItemRow')
class RecentItems extends Table {
  TextColumn get entityId =>
      text().references(Entities, #id, onDelete: KeyAction.cascade)();
  IntColumn get openedAt => integer()();

  @override
  Set<Column> get primaryKey => {entityId};
}

@DataClassName('SettingRow')
class Settings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
