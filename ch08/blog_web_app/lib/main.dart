import 'package:blog_web_app/screen/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  // 플러터 프레임워크가 준비되기를 기다린다.
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(home: HomeScreen()));
}
