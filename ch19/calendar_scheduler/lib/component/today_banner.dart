import 'package:calendar_scheduler/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

class TodayBanner extends StatelessWidget {
  final DateTime selectedDay;

  /// 일정 수
  final int count;

  const TodayBanner({
    required this.selectedDay,
    required this.count,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );

    return Container(
      color: primaryColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 날짜
            Text(
              '${selectedDay.year}년 ${selectedDay.month}월 ${selectedDay.day}일',
              style: textStyle,
            ),
            // 일정의 수
            Text('$count개', style: textStyle),
          ],
        ),
      ),
    );
  }
}

@Preview(name: 'Today Banner', group: "component", size: Size.fromWidth(400))
Widget previewTodayBanner() =>
    IntrinsicHeight(child: TodayBanner(selectedDay: DateTime.now(), count: 3));
