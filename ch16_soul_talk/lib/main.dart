import 'package:ch16_soul_talk/firebase_options.dart';
import 'package:ch16_soul_talk/model/message_model.dart';
import 'package:ch16_soul_talk/screen/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  // 플러터 프레임워크가 실행될 때까지 대기한다.
  WidgetsFlutterBinding.ensureInitialized();

  // 앱에 배정된 경로를 가져온다.
  final dir = await getApplicationDocumentsDirectory();

  // Isar 데이터베이스 초기화
  final isar = await Isar.open([MessageModelSchema], directory: dir.path);

  // GetIt에 Isar를 주입한다.
  GetIt.I.registerSingleton<Isar>(isar);

  // FireBase를 초기화한다.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MaterialApp(home: HomeScreen()));
}
