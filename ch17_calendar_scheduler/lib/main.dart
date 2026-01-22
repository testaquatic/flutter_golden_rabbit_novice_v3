import 'package:ch17_calendar_scheduler/firebase_options.dart';
import 'package:ch17_calendar_scheduler/screen/home_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 파이어베이스 프로젝트 설정
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // intl 패키지 초기화
  await initializeDateFormatting();

  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen()));
}
