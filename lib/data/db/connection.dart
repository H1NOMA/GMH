import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;

/// Opens the SQLite database at `{root}/gmh.db` on a background isolate.
/// Tests use `NativeDatabase.memory()` instead.
QueryExecutor openConnection(String rootDir) {
  return LazyDatabase(() async {
    final file = File(p.join(rootDir, 'gmh.db'));
    await file.parent.create(recursive: true);
    return NativeDatabase.createInBackground(file);
  });
}
