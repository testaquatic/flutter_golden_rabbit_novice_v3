import 'package:ch17_calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';

class _Time extends StatelessWidget {
  // 시작 시간
  final int startTime;
  // 종료 시간
  final int endTime;

  const _Time({required this.startTime, required this.endTime});

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: PRIMARY_COLOR,
      fontSize: 16.0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 시작 시간 표시
        Text("${startTime.toString().padLeft(2, "0")}:00", style: textStyle),
        // 종료 시간 표시
        Text(
          "${endTime.toString().padLeft(2, "0")}:00",
          style: textStyle.copyWith(fontSize: 10),
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final String content;

  const _Content({required this.content});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Text(content));
  }
}

class ScheduleCard extends StatelessWidget {
  final int startTime;
  final int endTime;
  final String content;

  const ScheduleCard({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: PRIMARY_COLOR),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Time(startTime: startTime, endTime: endTime),
              SizedBox(width: 16.0),
              _Content(content: content),
              SizedBox(width: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
