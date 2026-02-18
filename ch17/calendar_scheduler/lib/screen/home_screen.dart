import 'package:calendar_scheduler/component/main_calendar.dart';
import 'package:calendar_scheduler/component/schedule_bottom.dart';
import 'package:calendar_scheduler/component/schedule_card.dart';
import 'package:calendar_scheduler/component/today_banner.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  /// 위에는 달력
  /// 아래에는 일정 리스트
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  /// 선택한 날짜
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isDismissible: true,
            builder: (_) => ScheduleBottomSheet(),
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
              onDaySelected: onDaySelected,
            ),
            const SizedBox(height: 8.0),
            // 날짜와 일정수
            TodayBanner(selectedDate: selectedDate, count: 0),
            const SizedBox(height: 8.0),
            // 일정 리스트
            ScheduleCard(startTime: 12, endTime: 14, content: "프로그래밍 공부"),
          ],
        ),
      ),
    );
  }

  // 날짜를 선택했을 때 실행하는 콜백
  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}
