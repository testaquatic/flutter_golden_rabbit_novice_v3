// ORM을 사용하면 장기적으로는 유지보수에 오히려 불리한 것 같다.
// 그냥 쿼리로 처리를 생각이다.

import 'dart:async';

import 'package:sqlite3/sqlite3.dart';

// ignore: constant_identifier_names
const String APP_NAME = 'ch17_calendar_scheduler';
// ignore: constant_identifier_names
const int APP_VERSION = 1;

// DB를 초기화한다.
void initDB(Database database) {
  _createTableV1(database);

  if (_getAppVersion(database) == 0) {
    // 추후 마이그레이션을 위해서 1로 설정한다.
    _insertAppVersion(1, database);
  }

  if (_getAppVersion(database) < APP_VERSION) {
    _updateAppVersion(APP_VERSION, database);
  }
}

// APP_VERSION를 삽입한다.
void _insertAppVersion(int version, Database database) {
  database.prepare("INSERT INTO app_version VALUES (?, ?)").execute([
    APP_NAME,
    version,
  ]);
}

// APP_VERSION을 변경한다.
void _updateAppVersion(int version, Database database) {
  database
      .prepare("UPDATE app_version SET version = ? where app_name = ?")
      .execute([version, APP_NAME]);
}

// app_version을 가져온다.
int _getAppVersion(Database database) {
  final result = database.select(
    "SELECT version FROM app_version WHERE app_name = ?",
    [APP_NAME],
  );

  if (result.isEmpty) {
    return 0;
  } else {
    return result[0]["version"];
  }
}

// 테이블 마이그레이션용 함수
void _createTableV1(Database database) {
  const schedulesStatement =
      "CREATE TABLE IF NOT EXISTS schedules ("
      "id INTEGER PRIMARY KEY AUTOINCREMENT,"
      "content TEXT,"
      "date TEXT,"
      "start_time INTEGER,"
      "end_time INTEGER"
      ")";
  const appVersionTable =
      "CREATE TABLE IF NOT EXISTS app_version("
      "app_name TEXT NOT NULL,"
      "version INTEGER NOT NULL"
      ")";
  const createIndex =
      "CREATE INDEX IF NOT EXISTS idx_schedules_date ON schedules (date)";

  database.execute(schedulesStatement);
  database.execute(appVersionTable);
  database.execute(createIndex);
}

// schedules테이블의 데이터를 표현한다.
class Schedule {
  int? id;
  String content;
  DateTime date;
  int startTime;
  int endTime;

  Schedule({
    this.id,
    required this.content,
    required this.date,
    required this.startTime,
    required this.endTime,
  });

  static List<Schedule> _getSchedules(Database database, DateTime date) {
    return database
        .select(
          "SELECT id, content, date, start_time, end_time FROM schedules where date = ?",
          [date.toIso8601String()],
        )
        .map((row) {
          return Schedule(
            id: row["id"],
            content: row["content"],
            date: DateTime.parse(row["date"]),
            startTime: row["start_time"],
            endTime: row["end_time"],
          );
        })
        .toList();
  }

  // 데이터베이스가 변경되면 Stream을 반환한다.
  static Stream<List<Schedule>> watchSchedules(
    Database database,
    DateTime date,
  ) async* {
    yield _getSchedules(database, date);
    yield* database.updates.asyncExpand((update) async* {
      if (update.tableName == "schedules") {
        yield _getSchedules(database, date);
      }
    });
  }

  // 데이터베이스에 일정을 저장한다.
  void insertSchedule(Database database) {
    database
        .prepare(
          "INSERT INTO schedules (content, date, start_time, end_time) VALUES (?, ?, ?, ?)",
        )
        .execute([content, date.toIso8601String(), startTime, endTime]);
  }

  // 데이터베이스에서 일정을 삭제한다.
  void deleteSchedule(Database database) {
    database.prepare("DELETE FROM schedules WHERE id = ?").execute([id]);
  }
}
