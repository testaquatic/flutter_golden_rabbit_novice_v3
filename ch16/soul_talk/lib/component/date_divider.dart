import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

/// 날짜를 출력한다.
class DateDivider extends StatelessWidget {
  final DateTime date;

  const DateDivider({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return Text(
      "${date.year}년 ${date.month}월 ${date.day}일",
      style: const TextStyle(color: Colors.black54, fontSize: 12),
      textAlign: TextAlign.center,
    );
  }
}

/// 프리뷰용 함수
@Preview(name: "DateDivider", group: "components")
Widget previewDateDivider() => Container(
  width: 200,
  color: Colors.white,
  child: DateDivider(date: DateTime.now()),
);
