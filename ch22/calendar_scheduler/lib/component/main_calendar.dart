import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MainCalendar extends StatelessWidget {
  /// 달력에서 달짜를 선택하면 실행하는 콜백
  final OnDaySelected onDaySelected;

  /// 선택한 날짜
  final DateTime selectedDate;

  /// 달력을 표시하는 위젯
  const MainCalendar({
    super.key,
    required this.onDaySelected,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      // 날짜를 선택했을 때 실행하는 콜백
      onDaySelected: onDaySelected,
      // 선택한 날짜
      selectedDayPredicate: (date) =>
          date.year == selectedDate.year &&
          date.month == selectedDate.month &&
          date.day == selectedDate.day,
      focusedDay: DateTime.now(),
      // 달력 관련 설정
      locale: "ko_KR",
      firstDay: DateTime(1800, 1, 1),
      lastDay: DateTime(3000, 1, 1),
      headerStyle: HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 16.0),
      ),
      daysOfWeekHeight: 20.0,
      calendarStyle: CalendarStyle(
        isTodayHighlighted: false,
        defaultDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: lightGreyColor,
        ),
        weekendDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: lightGreyColor,
        ),
        selectedDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(color: primaryColor, width: 1.0),
        ),
        defaultTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: darkGreyColor,
        ),
        weekendTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: darkGreyColor,
        ),
        selectedTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: primaryColor,
        ),
      ),
    );
  }
}
