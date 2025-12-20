import 'package:ch17_calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

// 이 위젯은 달력을 표시한다.
// 시작 날짜는 1800년 1월 1일, 마지막 날짜는 3000년 1월 1일
class MainCalendar extends StatelessWidget {
  // 날짜 선택시 실행할 함수
  final OnDaySelected onDaySelected;
  final DateTime selectedDate;

  const MainCalendar({
    super.key,
    required this.onDaySelected,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: "ko_KR",
      onDaySelected: onDaySelected,
      // 선택된 날짜를 구분할 로직
      selectedDayPredicate: (DateTime date) {
        return isSameDay(date, selectedDate);
      },
      firstDay: DateTime(1800, 1, 1),
      lastDay: DateTime(3000, 1, 1),
      focusedDay: DateTime.now(),
      headerStyle: HeaderStyle(
        titleCentered: true,
        // 달력 선택 버튼 없애기
        formatButtonVisible: false,
        titleTextStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 16.0),
      ),
      calendarStyle: CalendarStyle(
        isTodayHighlighted: false,
        defaultDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: LIGHT_GREY_COLOR,
        ),
        weekendDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: LIGHT_GREY_COLOR,
        ),
        selectedDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(color: PRIMARY_COLOR, width: 1.0),
        ),
        defaultTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: DARK_GREY_COLOR,
        ),
        selectedTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: PRIMARY_COLOR,
        ),
      ),
    );
  }
}
