import 'dart:async';

import 'package:soul_talk/model/message_model.dart';
import 'package:sqlite3/sqlite3.dart';

enum ChangeStream { needCheck, checked }

class MessageModelSqlite3 {
  /// 데이터베이스가 변경됐는지 확인한다.
  StreamController<ChangeStream> changeStream = StreamController();

  /// 데이터베이스가 변경되면 결과를 반환한다.
  StreamController<List<MessageModel>> resultStream = StreamController();

  /// sqlite3 인스턴스
  late Database db;

  /// MessageModel을 Sqlite3와 연결한다.
  MessageModelSqlite3();

  /// 데이터베이스를 초기화한다.
  static MessageModelSqlite3 initDb(String dbFile) {
    MessageModelSqlite3 messageModelSqlite3 = MessageModelSqlite3();

    // 데이터베이스 파일을 연다.
    messageModelSqlite3.db = sqlite3.open(
      dbFile,
      mode: OpenMode.readWriteCreate,
    );

    // 테이블이 없으면 생성한다.
    // id : id
    // is_mine : 내 메시지이면 1, 아니면 0
    // message : 메시지 내용
    // point : 포인트
    // date : 날짜
    messageModelSqlite3.db.execute('''CREATE TABLE IF NOT EXISTS messages (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      is_mine INTEGER NOT NULL,
      message TEXT NOT NULL,
      point INTEGER,
      date TEXT NOT NULL
      )''');

    messageModelSqlite3.setMessagesStream();

    return messageModelSqlite3;
  }

  /// 내 메시지의 수를 센다.
  int countMine() {
    final stmt = db.prepare(
      "SELECT COUNT(*) AS count FROM messages WHERE is_mine = 1",
    );
    final result = stmt.select().first;

    return result['count'];
  }

  /// 메시지를 저장한다.
  /// message.id가 null 이면 열을 생성하고
  /// message.id가 null 이 아니면 열을 수정한다.
  int saveMessage(MessageModel message) {
    // 열을 수정한다.
    if (message.id != null) {
      final stmt = db.prepare(
        "UPDATE messages SET is_mine = ?, message = ?, point = ?, date = ? WHERE id = ?",
      );
      stmt.execute([
        message.isMine ? 1 : 0,
        message.message,
        message.point,
        message.date.toString(),
        message.id,
      ]);

      // 테이블 변경을 알린다.
      changeStream.sink.add(ChangeStream.needCheck);
      return message.id!;
    }

    // 열을 생성한다.
    final stmt = db.prepare(
      "INSERT INTO messages (is_mine, message, point, date) VALUES (?, ?, ?, ?) RETURNING id",
    );
    final result = stmt.select([
      message.isMine ? 1 : 0,
      message.message,
      message.point,
      message.date.toString(),
    ]);

    // 테이블 변경을 알린다.
    changeStream.sink.add(ChangeStream.needCheck);
    return result.first["id"];
  }

  /// count만큼 message를 가져온다.
  List<MessageModel> getMessages(int count) {
    final stmt = db.prepare("SELECT * FROM messages ORDER BY id DESC LIMIT ?");
    final results = stmt.select([count]);

    return results.map((result) {
      final id = result["id"];
      final isMine = result["is_mine"] == 1;
      final point = result["point"];
      final message = result["message"];
      final date = DateTime.parse(result["date"]);

      return MessageModel(
        id: id,
        isMine: isMine,
        message: message,
        date: date,
        point: point == 0 ? null : point,
      );
    }).toList();
  }

  /// 메시지가 변경되면 스트림으로 메시지를 가져온다.
  void setMessagesStream() {
    final stmt = db.prepare("SELECT * FROM messages ORDER BY id");
    bool needQuery = true;
    changeStream.sink.add(ChangeStream.needCheck);

    changeStream.stream.listen((change) {
      if (change == ChangeStream.needCheck && needQuery) {
        final results = stmt.select();
        final rows = results.map((result) {
          final id = result["id"];
          final isMine = result["is_mine"] == 1;
          final message = result["message"];
          final date = DateTime.parse(result["date"]);
          final point = result["point"];

          changeStream.sink.add(ChangeStream.checked);
          needQuery = false;

          return MessageModel(
            id: id,
            isMine: isMine,
            message: message,
            date: date,
            point: point == 0 ? null : point,
          );
        }).toList();

        resultStream.sink.add(rows);
      } else if (change == ChangeStream.checked) {
        needQuery = true;
      }
    });
  }

  /// 메시지를 삭제한다.
  void deleteMessage(int id) {
    final stmt = db.prepare("DELETE FROM messages WHERE id = ?");
    stmt.execute([id]);

    // 테이블 변경을 알린다.
    changeStream.sink.add(ChangeStream.needCheck);
  }
}
