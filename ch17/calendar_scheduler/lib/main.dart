import 'package:calendar_scheduler/rouer/router.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  // 플러터 준비 대기
  WidgetsFlutterBinding.ensureInitialized();

  // intl 패키지 초기화
  await initializeDateFormatting();
  runApp(MaterialApp.router(routerConfig: router));
}
