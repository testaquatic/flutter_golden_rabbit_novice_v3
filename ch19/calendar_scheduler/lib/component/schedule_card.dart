import 'package:calendar_scheduler/consts/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

class ScheduleCard extends StatelessWidget {
  final int startTime;
  final int endTime;
  final String content;

  /// 개별 스케줄을 표시한다.
  /// 왼쪽에는 시간이 있고 오른쪽에는 내용이 있다.
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
        border: Border.all(width: 1.0, color: primaryColor),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 시간
              _Time(startTime: startTime, endTime: endTime),
              const SizedBox(width: 16.0),
              // 내용
              _Content(content: content),
              const SizedBox(width: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}

@Preview(name: 'Schedule Card', group: "component", size: Size.fromWidth(400))
Widget previewScheduleCard() =>
    ScheduleCard(startTime: 1, endTime: 2, content: "일정");

/// 일정의 시간을 표시한다.
class _Time extends StatelessWidget {
  final int startTime;
  final int endTime;

  const _Time({required this.startTime, required this.endTime});

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: primaryColor,
      fontSize: 16.0,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 시작시간
        Text("${startTime.toString().padLeft(2, '0')}:00", style: textStyle),
        // 종료시간
        Text(
          "${endTime.toString().padLeft(2, '0')}:00",
          style: textStyle.copyWith(fontSize: 10.0),
        ),
      ],
    );
  }
}

/// 일정의 내용을 표시한다.
class _Content extends StatelessWidget {
  /// 일정의 내용
  final String content;

  const _Content({required this.content});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Text(content));
  }
}
