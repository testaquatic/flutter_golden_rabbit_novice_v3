import 'package:calendar_scheduler/component/main_calendar.dart';
import 'package:calendar_scheduler/component/schedule_card.dart';
import 'package:calendar_scheduler/component/today_banner.dart';
import 'package:calendar_scheduler/consts/colors.dart';
import 'package:calendar_scheduler/provider/schedule_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// 홈스크린
/// 앱을 실행하면 처음 보인다.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final schedules = ref.watch(scheduleNotifierProvider);
    final schedulesNotifier = ref.read(scheduleNotifierProvider.notifier);
    if (schedules.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            /// 상단의 달력
            MainCalendar(
              selectedDay: DateTime.parse(schedulesNotifier.selectedDate),
              onDaySelected: (selectedDate, focusedDate) =>
                  onDaySelected(selectedDate, focusedDate, ref),
            ),

            const SizedBox(height: 8.0),

            /// 날짜와 일정 수
            TodayBanner(
              selectedDay: DateTime.parse(schedulesNotifier.selectedDate),
              count: schedules.hasValue ? schedules.value!.length : 0,
            ),
            const SizedBox(height: 8.0),

            /// 일정 목록
            Expanded(
              child: schedules.when(
                data: (schedules) => ListView.builder(
                  itemCount: schedules.length,
                  itemBuilder: (context, index) {
                    final schedule = schedules[index];
                    return Dismissible(
                      key: ObjectKey(schedule.id),
                      direction: DismissDirection.startToEnd,
                      onDismissed: (direction) => schedulesNotifier
                          .deleteSchedule(date: schedule.date, id: schedule.id),
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 8.0,
                          left: 8.0,
                          right: 8.0,
                        ),
                        child: ScheduleCard(
                          startTime: schedule.startTime,
                          endTime: schedule.endTime,
                          content: schedule.content,
                        ),
                      ),
                    );
                  },
                ),
                error: (error, stack) => Center(child: Text(error.toString())),
                loading: () => Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
      // 플로팅 액션 버튼을 터치하면 입력 화면이 뜬다.
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          context.push("/add_schedule", extra: schedulesNotifier.selectedDate);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  /// 날짜를 선택했을 때 실행하는 콜백
  void onDaySelected(DateTime selectedDay, DateTime focusedDay, WidgetRef ref) {
    ref
        .read(scheduleNotifierProvider.notifier)
        .changeSelectedDate(dateToString(selectedDay));
  }
}

@Preview(name: 'Home Screen', group: "screen", size: Size.fromWidth(480))
Widget previewHomeScreen() => const HomeScreen();
