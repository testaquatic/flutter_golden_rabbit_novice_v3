import 'dart:io';

import 'package:calendar_scheduler/model/schedule.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

part 'drift_database.g.dart';

@DriftDatabase(tables: [Schedules])
class LocalDatabase extends _$LocalDatabase {
  /// sqlite3 데이터베이스 인스턴스
  LocalDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  /// 해당하는 날짜의 스트림을 받는다.
  Stream<List<Schedule>> watchSchedules(DateTime date) {
    return (select(schedules)..where((tbl) => tbl.date.equals(date))).watch();
  }

  /// 일정을 입력한다.
  Future<int> createSchedule(SchedulesCompanion data) {
    return into(schedules).insert(data);
  }

  /// 일정을 삭제한다.
  Future<int> removeSchedule(int id) =>
      (delete(schedules)..where((tbl) => tbl.id.equals(id))).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // 데이터 베이스 파일을 저장할 디렉토리
    final dbDir = await getApplicationDocumentsDirectory();
    final file = File(join(dbDir.path, "db.sqlite"));

    return NativeDatabase(file);
  });
}
