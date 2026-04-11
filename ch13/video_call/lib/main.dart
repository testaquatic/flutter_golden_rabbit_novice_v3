import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_call/router/go_router.dart';

void main() {
  runApp(ProviderScope(child: MaterialApp.router(routerConfig: router)));
}
