import '../../domain/repositories/repositories.dart';
import '../db/app_database.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final AppDatabase _db;

  SettingsRepositoryImpl(this._db);

  @override
  Future<String?> get(String key) async {
    final row = await (_db.select(_db.settings)
          ..where((s) => s.key.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  @override
  Future<void> set(String key, String value) async {
    await _db
        .into(_db.settings)
        .insertOnConflictUpdate(SettingsCompanion.insert(key: key, value: value));
  }

  @override
  Future<void> remove(String key) async {
    await (_db.delete(_db.settings)..where((s) => s.key.equals(key))).go();
  }
}
