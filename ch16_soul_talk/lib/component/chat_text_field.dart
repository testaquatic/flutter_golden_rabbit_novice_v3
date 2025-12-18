import 'package:flutter/material.dart';

// 이 위젯은 텍스트 입력 필드를 표시한다.
class ChatTextField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSend;
  final String? error;
  final bool loading;

  const ChatTextField({
    super.key,
    this.error,
    this.loading = false,
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
        // 전송버튼
        suffixIcon: IconButton(
          onPressed: loading ? null : onSend,
          icon: Icon(
            Icons.send_outlined,
            color: loading ? Colors.grey : Colors.blueAccent,
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
