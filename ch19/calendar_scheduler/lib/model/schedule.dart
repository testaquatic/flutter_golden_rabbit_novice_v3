import 'package:drift/drift.dart';

/// Schedules 테이블 정의
class Schedules extends Table {
  /// 키
  IntColumn get id => integer().autoIncrement()();

  /// 내용
  TextColumn get content => text()();

  /// 날짜
  DateTimeColumn get date => dateTime()();

  /// 시작 시간
  IntColumn get startTime => integer()();

  /// 종료 시간
  IntColumn get endTime => integer()();
}
