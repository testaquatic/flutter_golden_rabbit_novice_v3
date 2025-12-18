import 'package:ch16_soul_talk/component/point_notification.dart';
import 'package:flutter/material.dart';

// 이 위젯은 채팅 버블을 표시한다.
// 내가 보낸 메시지는 오른쪽에, 제미나이가 보낸 메시지는 왼쪽에 표시한다.
class Message extends StatelessWidget {
  final bool alignLeft;
  final String message;
  final int? point;

  const Message({
    super.key,
    this.alignLeft = true,
    this.point,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final alignment = alignLeft ? Alignment.centerLeft : Alignment.centerRight;
    // 왼쪽 정렬일 때 더 어두운 색을 사용한다..
    final bgColor = alignLeft ? Color(0xfff4f4f4) : Colors.white;
    final border = alignLeft ? Color(0xffe7e7e7) : Colors.black12;

    return Column(
      children: [
        Align(
          alignment: alignment,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32.0),
              color: bgColor,
              border: Border.all(color: border, width: 1),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 16.0,
              ),
              child: Text(
                message,
                style: TextStyle(color: Colors.black, fontSize: 16),
              ),
            ),
          ),
        ),
        // point가 입력됐을 때만 표시한다.
        if (point != null)
          Align(
            alignment: alignment,
            child: PointNotification(point: point!),
          ),
      ],
    );
  }
}
