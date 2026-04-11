import 'package:go_router/go_router.dart';
import 'package:video_call/screen/cam_screen.dart';
import 'package:video_call/screen/home_screen.dart';

final router = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(path: "/", builder: (context, state) => HomeScreen()),
    GoRoute(path: "/cam", builder: (context, state) => CamScreen()),
  ],
);
