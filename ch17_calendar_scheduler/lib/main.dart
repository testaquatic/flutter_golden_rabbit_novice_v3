import 'dart:io';

import 'package:ch17_calendar_scheduler/model/schedule.dart';
import 'package:ch17_calendar_scheduler/provider/schedule_provider.dart';
import 'package:ch17_calendar_scheduler/repository/schedule_repository.dart';
import 'package:ch17_calendar_scheduler/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:sqlite3/sqlite3.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // intl 패키지 초기화
  await initializeDateFormatting();

  final appFolder = await getApplicationDocumentsDirectory();

  // sqlite3 인스턴스를 초기화한다.
  final dbFile = File(join(appFolder.path, "db.sqlite"));
  final database = sqlite3.open(dbFile.path);

  // 데이터베이스를 마이그레이션 한다.
  initDB(database);

  // 의존성을 주입한다.
  GetIt.I.registerSingleton<Database>(database);

  final repository = ScheduleRepository();
  final scheduleProvider = ScheduleProvider(repository: repository);

  runApp(
    ChangeNotifierProvider(
      create: (_) => scheduleProvider,
      child: MaterialApp(home: HomeScreen()),
    ),
  );
}
