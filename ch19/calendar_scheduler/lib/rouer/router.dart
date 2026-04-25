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
            final selectedDate = state.extra as String;
            return _ScheduleBottomSheetPage(selectedDate: selectedDate);
          },
        ),
      ],
    ),
  ],
);

class _ScheduleBottomSheetPage<T> extends Page<T> {
  final String selectedDate;

  const _ScheduleBottomSheetPage({required this.selectedDate});

  @override
  Route<T> createRoute(BuildContext context) {
    return ModalBottomSheetRoute<T>(
      settings: this,
      builder: (context) => ScheduleBottomSheet(selectedDate: selectedDate),
      isScrollControlled: true,
      isDismissible: true,
    );
  }
}
