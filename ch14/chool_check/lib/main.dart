import 'package:chool_check/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(MaterialApp(home: ProviderScope(child: HomeScreen())));
}
