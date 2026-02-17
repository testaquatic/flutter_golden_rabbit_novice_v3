import 'package:flutter/material.dart';

class ChatTextField extends StatelessWidget {
  /// 입력값 추출을 위한 controller
  final TextEditingController controller;

  /// 전송 버튼을 눌렀을 때 실행하는 콜백
  final VoidCallback onSend;

  /// 오류 메시지
  final String? error;

  /// 로딩 중 표시
  final bool isLoading;

  /// 채팅 입력을 표시한다.
  const ChatTextField({
    super.key,
    this.error,
    this.isLoading = false,
    required this.onSend,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      cursorColor: Colors.blueAccent,
      textAlignVertical: TextAlignVertical.center,
      minLines: 1,
      maxLines: 4,
      decoration: InputDecoration(
        errorText: error,

        // 텍스트 필드 전송 버튼
        suffixIcon: IconButton(
          onPressed: isLoading ? null : onSend,
          icon: Icon(
            Icons.send_outlined,
            color: isLoading ? Colors.grey : Colors.blueAccent,
          ),
        ),

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
        ),

        hintText: "메시지를 입력해주세요!",
      ),
    );
  }
}
