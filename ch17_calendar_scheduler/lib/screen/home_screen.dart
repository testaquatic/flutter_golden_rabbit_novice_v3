import 'package:ch17_calendar_scheduler/component/main_calendar.dart';
import 'package:ch17_calendar_scheduler/component/schedule_bottom_sheet.dart';
import 'package:ch17_calendar_scheduler/component/schedule_card.dart';
import 'package:ch17_calendar_scheduler/component/today_banner.dart';
import 'package:ch17_calendar_scheduler/const/colors.dart';
import 'package:ch17_calendar_scheduler/model/schedule.dart';
import 'package:ch17_calendar_scheduler/provider/schedule_provider.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:sqlite3/sqlite3.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 프로바이더 변경이 있을 때마다 build()함수 실행
    final provider = context.watch<ScheduleProvider>();
    final selectedDate = provider.selectedDate;
    // 선택된 날짜에 해당하는 일정을 가져오기
    final schedules = provider.cache[selectedDate] ?? [];

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: PRIMARY_COLOR,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isDismissible: true,
            builder: (_) {
              return ScheduleBottomSheet(selectedDate: selectedDate);
            },
            isScrollControlled: true,
          );
        },
        child: Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // 달력
            MainCalendar(
              selectedDate: selectedDate,
              onDaySelected: (selectedDate, focusedDate) =>
                  onDaySelected(selectedDate, focusedDate, context),
            ),
            SizedBox(height: 8.0),
            StreamBuilder(
              stream: Schedule.watchSchedules(
                GetIt.I<Database>(),
                selectedDate,
              ),
              builder: (context, snapshot) {
                return TodayBanner(
                  selectedDate: selectedDate,
                  count: schedules.length,
                );
              },
            ),
            SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: schedules.length,
                itemBuilder: (context, index) {
                  final schedule = schedules[index];

                  return Dismissible(
                    key: ObjectKey(schedule.id),
                    direction: DismissDirection.startToEnd,
                    onDismissed: (direction) {
                      provider.deleteSchedule(
                        date: selectedDate,
                        id: schedule.id,
                      );
                    },
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
            ),
          ],
        ),
      ),
    );
  }

  void onDaySelected(
    DateTime selectedDate,
    DateTime focusedDate,
    BuildContext context,
  ) {
    final provider = context.read<ScheduleProvider>();
    provider.changeSelectedDate(date: selectedDate);
    provider.getSchedules(date: selectedDate);
  }
}
