import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';

class TodayBanner extends StatelessWidget {
  /// 선택한 날짜
  final DateTime selectedDate;

  /// 일정의 수
  final int count;

  /// 오늘의 일정을 표시하는 위젯
  /// 왼쪽에는 날짜, 오른쪽에는 일정의 수를 표시
  const TodayBanner({
    super.key,
    required this.selectedDate,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: Colors.white,
    );

    return Container(
      color: primaryColor,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 날짜
            Text(
              "${selectedDate.year}년 ${selectedDate.month}월 ${selectedDate.day}일",
              style: textStyle,
            ),
            // 일정의 수
            Text("$count개", style: textStyle),
          ],
        ),
      ),
    );
  }
}
