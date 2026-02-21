import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/widgets.dart';

class ScheduleCard extends StatelessWidget {
  /// 시작 시간
  final int startTime;

  /// 종료 시간
  final int endTime;

  /// 일정 내용
  final String content;

  /// 일정 리스트를 표시하는 위젯
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
              _Time(startTime: startTime, endTime: endTime),
              const SizedBox(width: 16.0),
              _Content(content: content),
              SizedBox(width: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}

class _Time extends StatelessWidget {
  final int startTime;
  final int endTime;

  /// 일정 리스트의 시간을 표시하는 위젯
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
        // 시작 시간
        Text("${startTime.toString().padLeft(2, "0")}:00", style: textStyle),
        // 종료 시간
        Text(
          "${endTime.toString().padLeft(2, "0")}:00",
          style: textStyle.copyWith(fontSize: 10.0),
        ),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final String content;

  /// 일정 리스트의 내용을 표시하는 위젯
  const _Content({required this.content});

  @override
  Widget build(BuildContext context) {
    return Expanded(child: Text(content));
  }
}
