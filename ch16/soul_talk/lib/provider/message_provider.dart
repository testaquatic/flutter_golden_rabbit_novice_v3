import 'dart:async';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:soul_talk/model/message_model.dart';
import 'package:soul_talk/model/sqlite3.dart';

final messageNotifierProvider =
    StreamNotifierProvider<MessageNotifier, List<MessageModel>>(
      MessageNotifier.new,
      isAutoDispose: true,
    );

class MessageNotifier extends StreamNotifier<List<MessageModel>> {
  late Sqlite3DB db;

  @override
  Stream<List<MessageModel>> build() async* {
    db = await _getDb();
    ref.onDispose(() => db.close());
    await _updateState();

    yield await db.getAllMessages();
  }

  /// 모든 메시지를 불러오고 state를 업데이트 한다.
  Future<void> _updateState() async {
    final messages = await db.getAllMessages();
    state = AsyncValue.data(messages);
  }

  /// 메시지를 저장한다.
  Future<int> saveMessage(MessageModel message) async {
    final id = await db.saveMessage(message);
    await _updateState();
    return id;
  }

  /// 메세지를 업데이트 한다.
  Future<int> updateMessage(MessageModel message) async {
    final result = await db.updateMessage(message);
    if (result > 0) {
      await _updateState();
    }
    return result;
  }

  /// 메세지를 삭제한다.
  Future<int> deleteMessage(int id) async {
    final result = await db.deleteMessage(id);
    if (result > 0) {
      await _updateState();
    }
    return result;
  }

  /// 메시지를 전송한다.
  Future<void> sendMessage({
    required List<MessageModel> contextMessages,
    VoidCallback? onDone,
    Function(Object)? onError,
  }) async {
    // 제미나이로부터 받은 메시지
    String message = "";
    // 현재 응답받고 있는 메시지 ID
    int? currentModelMessageId;

    final List<Content> promptContext = contextMessages
        .map((e) => Content(e.isMine ? "user" : "model", [TextPart(e.message)]))
        .toList();

    final model = FirebaseAI.googleAI().generativeModel(
      model: "gemini-2.5-flash",
      systemInstruction: Content.system(
        "너는 이제부터 착하고 친절한 친구의 역할을 할 거야. 앞으로 채팅을 하면서 긍적적인 말만 할 수 있도록 해줘",
      ),
    );

    currentModelMessageId = await saveMessage(
      MessageModel(isMine: false, message: "잠시 기다려주세요!", date: DateTime.now()),
    );

    model
        .generateContentStream(promptContext)
        .listen(
          (event) async {
            if (event.text != null) {
              message += event.text!;
            }

            final MessageModel model = MessageModel(
              id: currentModelMessageId,
              isMine: false,
              message: message,
              date: DateTime.now(),
            );

            await updateMessage(model);
          },
          onDone: onDone,
          onError: onError,
        );
  }
}

Future<Sqlite3DB> _getDb() async {
  // 앱에 배정된 경로를 가져온다.
  final dir = await getApplicationDocumentsDirectory();
  final dbPath = "${dir.path}/message.db";
  final db = await Sqlite3DB.initDb(dbPath: dbPath);

  return db;
}
