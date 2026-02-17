import 'package:flutter/material.dart';
import 'package:soul_talk/component/point_notification.dart';

/// 메시지 정렬
enum MessageAlign { left, right }

class Message extends StatelessWidget {
  /// 메시지 정렬
  final MessageAlign align;

  /// 메시지
  final String message;

  /// 현재까지 적립된 포인트
  final int? point;

  /// 메시지를 표시한다.
  const Message({
    super.key,
    this.align = MessageAlign.left,
    this.point,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final (
      alignment: alignment,
      bgColor: bgColor,
      border: border,
    ) = switch (align) {
      // 왼쪽정렬
      MessageAlign.left => (
        alignment: Alignment.centerLeft,
        bgColor: Color(0xfff4f4f4),
        border: Color(0xffe7e7e7),
      ),
      // 오른쪽정렬
      MessageAlign.right => (
        alignment: Alignment.centerRight,
        bgColor: Colors.white,
        border: Colors.black12,
      ),
    };

    return Column(
      children: [
        // 메시지 컨테이너
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
        // 포인트 알림
        if (point != null)
          Align(
            alignment: alignment,
            child: PointNotification(point: point!),
          ),
      ],
    );
  }
}
