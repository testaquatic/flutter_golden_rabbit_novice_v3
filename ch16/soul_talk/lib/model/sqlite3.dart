import 'package:soul_talk/model/message_model.dart';
import 'package:sqflite/sqflite.dart';

class Sqlite3DB {
  final Database database;

  Sqlite3DB({required this.database});

  static Future<Sqlite3DB> initDb({required String dbPath}) async {
    final database = await openDatabase(
      dbPath,
      version: 1,
      // db를 생성한다.
      onCreate: (db, version) async {
        await db.execute(
          // is_mine => 내 메시지일 경우 1, 아닐 경우 0
          // message => 메시지 내용
          // date => ISO8601형식 문자열
          // point => 포인트, NULL일 수 있다.
          "CREATE TABLE message (id INTEGER PRIMARY KEY AUTOINCREMENT, is_mine INTEGER NOT NULL, message TEXT NOT NULL, date TEXT NOT NULL, point INTEGER)",
        );
      },
    );
    return Sqlite3DB(database: database);
  }

  void close() => database.close();

  /// 메시지의 수를 센다.
  Future<int?> countMyMessage() async {
    final count = Sqflite.firstIntValue(
      await database.rawQuery("SELECT COUNT(*) FROM message WHERE is_mine = 1"),
    );

    return count;
  }

  /// 메시지를 저장한다.
  Future<int> saveMessage(MessageModel message) async {
    final id = await database.rawInsert(
      "INSERT INTO message (is_mine, message, date, point) VALUES (?, ?, ?, ?)",
      [
        message.isMine ? 1 : 0,
        message.message,
        message.date.toIso8601String(),
        message.point,
      ],
    );

    return id;
  }

  /// 전체 메시지를 불러온다.
  Future<List<MessageModel>> getAllMessages() async {
    final messages = await database.rawQuery(
      "SELECT * FROM message ORDER BY id",
    );

    return messages
        .map(
          (e) => MessageModel(
            id: e["id"] as int,
            isMine: e["is_mine"] as int == 1,
            message: e["message"] as String,
            date: DateTime.parse(e["date"] as String),
            point: e["point"] as int?,
          ),
        )
        .toList();
  }

  /// 메시지를 정해진 수만큼 불러온다.
  Future<List<MessageModel>> getMessages({required int limit}) async {
    final messages = await database.rawQuery(
      "SELECT * FROM message ORDER BY id LIMIT ?",
      [limit],
    );

    return messages
        .map(
          (e) => MessageModel(
            id: e["id"] as int,
            isMine: e["is_mine"] as int == 1,
            message: e["message"] as String,
            date: DateTime.parse(e["date"] as String),
            point: e["point"] as int?,
          ),
        )
        .toList();
  }

  /// 메시지를 업데이트 한다.
  /// message.id < 0 이거나 message.id == null인 때는 업데이트 하지 않고 -1을 반환한다.
  Future<int> updateMessage(MessageModel message) async {
    if (message.id == null || message.id! < 0) {
      return -1;
    }

    return database.rawUpdate(
      "UPDATE message SET is_mine = ?, message = ?, date = ?, point = ? WHERE id = ?",
      [
        message.isMine ? 1 : 0,
        message.message,
        message.date.toIso8601String(),
        message.point,
        message.id,
      ],
    );
  }

  /// 메시지를 삭제한다.
  Future<int> deleteMessage(int id) async {
    return await database.rawDelete("DELETE FROM message WHERE id = ?", [id]);
  }
}
