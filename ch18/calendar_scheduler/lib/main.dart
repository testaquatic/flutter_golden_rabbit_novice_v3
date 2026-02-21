import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:calendar_scheduler/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  // 플러터 바인딩 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // intl 초기화
  await initializeDateFormatting();

  // 데이터베이스 생성
  final database = LocalDatabase();

  // 데이터베이스 주입
  GetIt.I.registerSingleton<LocalDatabase>(database);

  runApp(MaterialApp(home: HomeScreen()));
}
