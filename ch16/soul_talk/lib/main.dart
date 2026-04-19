import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:soul_talk/firebase_options.dart';
import 'package:soul_talk/screen/home_screen.dart';

void main() async {
  // 실행 준비를 기다린다.
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MaterialApp(home: ProviderScope(child: HomeScreen())));
}
