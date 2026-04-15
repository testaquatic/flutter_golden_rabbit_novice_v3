import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_editor/screen/home_screen.dart';

void main() {
  runApp(MaterialApp(home: ProviderScope(child: HomeScreen())));
}
