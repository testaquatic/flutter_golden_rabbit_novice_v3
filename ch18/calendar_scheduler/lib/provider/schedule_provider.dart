import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod/riverpod.dart';
import 'package:sqflite/sqflite.dart';

class ScheduleModel {
  final int id;
  final String content;
  final DateTime date;
  final int startTime;
  final int endTime;

  const ScheduleModel({
    required this.id,
    required this.content,
    required this.date,
    required this.startTime,
    required this.endTime,
  });
}

class ScheduleSqlite3 {
  final Database _db;

  ScheduleSqlite3(this._db);

  static Future<ScheduleSqlite3> init({required String dbPath}) async {
    final db = await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute("""
          CREATE TABLE schedules (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          content TEXT,
          date TEXT,
          start_time INTEGER,
          end_time INTEGER
          )
          """);
      },
    );

    return ScheduleSqlite3(db);
  }

  Future<void> close() async {
    await _db.close();
  }

  String _dateToString(DateTime date) {
    return "${date.year}-${date.month}-${date.day}";
  }

  DateTime _stringToDate(String dateString) {
    final dateStringSplit = dateString.split("-");
    final year = int.parse(dateStringSplit[0]);
    final month = int.parse(dateStringSplit[1]);
    final day = int.parse(dateStringSplit[2]);
    final date = DateTime(year, month, day);

    return date;
  }

  ScheduleModel _dbScheduleToScheduleModel(Map<String, dynamic> dbSchedule) {
    return ScheduleModel(
      id: dbSchedule["id"] as int,
      content: dbSchedule["content"] as String,
      date: _stringToDate(dbSchedule["date"] as String),
      startTime: dbSchedule["start_time"] as int,
      endTime: dbSchedule["end_time"] as int,
    );
  }

  Future<List<ScheduleModel>> getSchedules(DateTime date) async {
    final dbSchedules = await _db.rawQuery(
      "SELECT * FROM schedules WHERE date = ?",
      [_dateToString(date)],
    );
    final schedules = dbSchedules.map(_dbScheduleToScheduleModel).toList();

    return schedules;
  }

  Future<int> addSchedule(ScheduleModel schedule) async {
    return await _db.rawInsert(
      """
      INSERT INTO schedules (content, date, start_time, end_time)
      VALUES (?, ?, ?, ?)
      """,
      [
        schedule.content,
        _dateToString(schedule.date),
        schedule.startTime,
        schedule.endTime,
      ],
    );
  }

  Future<void> updateSchedule(ScheduleModel schedule) async {}

  Future<int> deleteSchedule(int id) async {
    return await _db.rawDelete(
      '''
      DELETE FROM schedules WHERE id = ?
      ''',
      [id],
    );
  }
}

final scheduleNotifierProvider =
    AsyncNotifierProvider<ScheduleNotifier, List<ScheduleModel>>(
      ScheduleNotifier.new,
    );

class ScheduleNotifier extends AsyncNotifier<List<ScheduleModel>> {
  ScheduleSqlite3? scheduleSqlite3;
  DateTime? selectedDate;

  @override
  Future<List<ScheduleModel>> build() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    final dbPath = join(appDocumentDir.path, "schedules.sqlite");

    scheduleSqlite3 = await ScheduleSqlite3.init(dbPath: dbPath);

    return [];
  }

  Future<int> getSchedules(DateTime date) async {
    final schedules = await scheduleSqlite3!.getSchedules(date);
    state = AsyncValue.data(schedules);

    return schedules.length;
  }

  Future<int> addSchedule(ScheduleModel schedule) async {
    state = AsyncValue.loading();
    final id = await scheduleSqlite3!.addSchedule(schedule);
    final schedules = await scheduleSqlite3!.getSchedules(schedule.date);
    state = AsyncValue.data(schedules);

    return id;
  }

  Future<void> deleteSchedule(int id) async {
    final schedules = state.whenData(
      (schedule) => schedule.where((schedule) => schedule.id != id).toList(),
    );
    state = AsyncLoading();
    await scheduleSqlite3!.deleteSchedule(id);
    state = schedules;
  }
}
