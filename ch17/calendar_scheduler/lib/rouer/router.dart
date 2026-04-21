import 'package:calendar_scheduler/component/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler/screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: "/",
  routes: [
    GoRoute(
      path: "/",
      builder: (context, state) => const HomeScreen(),
      routes: [
        GoRoute(
          path: "add_schedule",
          pageBuilder: (context, state) {
            return _ScheduleBottomSheetPage();
          },
        ),
      ],
    ),
  ],
);

class _ScheduleBottomSheetPage<T> extends Page<T> {
  @override
  Route<T> createRoute(BuildContext context) {
    return ModalBottomSheetRoute<T>(
      settings: this,
      builder: (context) => const ScheduleBottomSheet(),
      isScrollControlled: true,
      isDismissible: true,
    );
  }
}
