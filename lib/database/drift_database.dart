// private 값들은 불러올 수 없다.
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:mbl/model/category_color.dart';
import 'package:mbl/model/log_with_color.dart';
import 'package:mbl/model/logs.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

// private 값까지 불러올 수 있다
part 'drift_database.g.dart';

@DriftDatabase(tables: [
  Logs,
  CategoryColors,
])
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  Future<int> createLog(LogsCompanion data) => into(logs).insert(data);

  Future<int> createCategoryColor(CategoryColorsCompanion data) =>
      into(categoryColors).insert(data);

  Future<List<CategoryColor>> getCategoryColors() =>
      select(categoryColors).get();

  Future<int> removeLog(int id) =>
      (delete(logs)..where((tbl) => tbl.id.equals(id))).go();

  Stream<List<LogWithColor>> watchLogs(DateTime date) {
    final query = select(logs).join(
        [innerJoin(categoryColors, categoryColors.id.equalsExp(logs.colorId))]);

    query.where(logs.date.equals(date));

    return query.watch().map(
          (rows) => rows
              .map(
                (row) => LogWithColor(
                  log: row.readTable(logs),
                  categoryColor: row.readTable(categoryColors),
                ),
              )
              .toList(),
        );
  }

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
