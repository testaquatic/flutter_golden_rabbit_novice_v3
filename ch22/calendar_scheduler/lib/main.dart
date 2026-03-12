import 'package:calendar_scheduler/firebase_options.dart';
import 'package:calendar_scheduler/screen/auth_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  // 플러터 바인딩 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // 파이어베이스 초기화
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // intl 초기화
  await initializeDateFormatting();

  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: AuthScreen()));
}
