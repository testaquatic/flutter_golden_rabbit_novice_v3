import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

class Logo extends StatelessWidget {
  final double width;
  final double height;

  /// 로고 위젯
  /// 기본값은 200 x 200 이다.
  const Logo({super.key, this.width = 200, this.height = 200});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 구글 f이미지
        Image.asset("asset/img/logo.png", width: width, height: height),
        const SizedBox(height: 32.0),
        // 텍스트
        const Text(
          "안녕! 나는 너의 친구 소울챗이야!\n나와 대화를 하며 친밀도를 높여보자!",
          textAlign: TextAlign.center,
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

/// 프리뷰
@Preview(name: "Logo", brightness: Brightness.light, group: "components")
Widget previewLogo() {
  return Container(color: Colors.white, child: Logo());
}
