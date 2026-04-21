import 'package:calendar_scheduler/component/main_calendar.dart';
import 'package:calendar_scheduler/component/schedule_card.dart';
import 'package:calendar_scheduler/component/today_banner.dart';
import 'package:calendar_scheduler/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:go_router/go_router.dart';

/// 홈스크린
/// 앱을 실행하면 처음 보인다.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            /// 상단의 달력
            MainCalendar(
              selectedDay: selectedDay,
              onDaySelected: onDaySelected,
            ),

            const SizedBox(height: 8.0),

            /// 날짜와 일정 수
            TodayBanner(selectedDay: selectedDay, count: 0),
            const SizedBox(height: 8.0),

            /// 일정 목록
            ScheduleCard(startTime: 12, endTime: 14, content: "프로그래밍 공부"),
          ],
        ),
      ),
      // 플로팅 액션 버튼을 터치하면 입력 화면이 뜬다.
      floatingActionButton: FloatingActionButton(
        backgroundColor: primaryColor,
        onPressed: () {
          context.push("/add_schedule");
        },
        child: Icon(Icons.add),
      ),
    );
  }

  /// 날짜를 선택했을 때 실행하는 콜백
  void onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    setState(() {
      this.selectedDay = selectedDay;
    });
  }
}

@Preview(name: 'Home Screen', group: "screen", size: Size.fromWidth(480))
Widget previewHomeScreen() => const HomeScreen();
