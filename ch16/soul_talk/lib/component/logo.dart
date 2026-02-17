import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

class Logo extends StatelessWidget {
  /// 너비
  final double width;

  /// 높이
  final double height;

  /// 앱 로고
  @Preview(name: "App Logo")
  const Logo({super.key, this.width = 200, this.height = 200});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 로고 이미지
        Image.asset("asset/img/logo.png", width: width, height: height),
        const SizedBox(height: 32.0),
        // 앱 설명 텍스트
        Text(
          "안녕! 나는 너의 친구 소울챗이야!\n나와 대화를 하며 친밀도를 높여보자!",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }
}
