import 'package:flutter/material.dart';

// 이 위젯은 파란 구슬 방울 모양의 로고를 표시한다.
class Logo extends StatelessWidget {
  final double width;
  final double height;

  const Logo({super.key, this.width = 200, this.height = 200});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 로고 이미지
        Image.asset("asset/img/logo.png", width: width, height: height),
        SizedBox(height: 32.0),
        // 앱 설명 텍스트
        Text(
          "안녕! 나는 너의 친구 소울챗이야!\n나와 대화를 하며 친밀도를 높여보자!",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
