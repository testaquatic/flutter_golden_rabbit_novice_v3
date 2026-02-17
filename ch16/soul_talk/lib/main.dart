import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:path_provider/path_provider.dart';
import 'package:soul_talk/firebase_options.dart';
import 'package:soul_talk/model/message_model_sqlite3.dart';
import 'package:soul_talk/screen/home_screen.dart';

void main() async {
  // 초기화 대기
  WidgetsFlutterBinding.ensureInitialized();

  // DB 초기화
  final appDir = await getApplicationDocumentsDirectory();
  final messageModelSqlite3 = MessageModelSqlite3.initDb(
    "${appDir.path}/messages.db",
  );

  // GetIt에 주입
  GetIt.I.registerSingleton<MessageModelSqlite3>(messageModelSqlite3);

  // FirebaseAI 초기화
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MaterialApp(home: HomeScreen()));
}
