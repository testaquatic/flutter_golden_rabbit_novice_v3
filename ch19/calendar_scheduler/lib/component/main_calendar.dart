import 'package:calendar_scheduler/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:table_calendar/table_calendar.dart';

class MainCalendar extends StatelessWidget {
  final OnDaySelected onDaySelected;
  final DateTime selectedDay;

  /// 상단의 달력
  const MainCalendar({
    super.key,
    required this.onDaySelected,
    required this.selectedDay,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: "ko_KR",
      onDaySelected: onDaySelected,
      selectedDayPredicate: (date) =>
          date.year == selectedDay.year &&
          date.month == selectedDay.month &&
          date.day == selectedDay.day,

      focusedDay: DateTime.now(),
      firstDay: DateTime(1800, 1, 1),
      lastDay: DateTime(3000, 1, 1),
      headerStyle: const HeaderStyle(
        titleCentered: true,
        formatButtonVisible: false,
        titleTextStyle: TextStyle(fontWeight: FontWeight.w700, fontSize: 16.0),
      ),
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
          color: darkGreyColor,
          fontWeight: FontWeight.w600,
        ),
        weekendTextStyle: TextStyle(
          color: darkGreyColor,
          fontWeight: FontWeight.w600,
        ),
        selectedTextStyle: TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

@Preview(name: 'Main Calendar', group: "component", size: Size.fromWidth(400))
Widget previewMainCalendar() =>
    MainCalendar(onDaySelected: (_, _) {}, selectedDay: DateTime.now());
