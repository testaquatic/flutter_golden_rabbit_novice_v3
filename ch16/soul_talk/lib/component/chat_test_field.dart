import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

class ChatTextField extends StatelessWidget {
  /// 입력값 추출을 위한 controller
  final TextEditingController controller;

  /// 전송 버튼을 눌렀을 때 실행하는 함수
  final VoidCallback onSend;

  /// 에러 메시지
  final String? error;

  /// 로딩중인지 여부
  final bool isLoading;

  const ChatTextField({
    super.key,
    required this.controller,
    required this.onSend,
    this.error,
    this.isLoading = false,
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

        suffixIcon: IconButton(
          onPressed: isLoading ? null : onSend,
          icon: Icon(Icons.send_outlined),
          color: isLoading ? Colors.grey : Colors.blueAccent,
        ),

        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(32.0),
          borderSide: const BorderSide(color: Colors.blueAccent, width: 2.0),
        ),

        hintText: "메시지를 입력해주세요!",
      ),
    );
  }
}

@Preview(name: "ChatTextField", group: "components")
Widget previewChatTextField() => SizedBox(
  width: 400,
  child: Column(
    children: [
      ChatTextField(controller: TextEditingController(), onSend: () {}),
      const SizedBox(height: 16.0),
      ChatTextField(
        controller: TextEditingController(),
        onSend: () {},
        isLoading: true,
      ),
    ],
  ),
);
