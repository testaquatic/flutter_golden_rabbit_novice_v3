import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:soul_talk/component/point_notification.dart';

class Message extends StatelessWidget {
  /// true 이면 왼쪽 정렬
  final bool alignLeft;
  final String message;

  /// 현재까지 적립된 포인트
  final int? point;

  /// 메시지 위젯
  /// 왼쪽 정렬이면 더 배경과 테두리가 더 어둡다.
  const Message({
    super.key,
    this.alignLeft = true,
    required this.message,
    this.point,
  });

  @override
  Widget build(BuildContext context) {
    final alignment = alignLeft ? Alignment.centerLeft : Alignment.centerRight;

    // 왼쪽 정렬이면 더 어두운 배경 사용
    final bgColor = alignLeft ? Color(0xfff4f4f4) : Colors.white;

    // 왼쪽 정렬이면 더 어두운 테두리 사용
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
                style: TextStyle(color: Colors.black, fontSize: 16.0),
              ),
            ),
          ),
        ),
        if (point != null)
          Align(
            alignment: alignment,
            child: PointNotification(point: point!),
          ),
      ],
    );
  }
}

// 프리뷰용 함수
@Preview(name: "Message", group: "components")
Widget previewMessage() {
  return const SizedBox(
    width: 400,
    child: Column(
      children: [
        Message(message: "안녕하세요?"),
        Message(message: "어서오세요!", alignLeft: false, point: 100),
      ],
    ),
  );
}
