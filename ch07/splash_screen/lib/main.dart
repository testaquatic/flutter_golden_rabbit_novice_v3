import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

void main() {
  runApp(SplashScreen());
}

/// 스플래시 스크린 위젯
class SplashScreen extends StatelessWidget {
  @Preview(name: "SplashScreen")
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          // 이 컨테이너는 배경색은 오랜지이다.
          decoration: BoxDecoration(
            // 배경을 0xfff99231으로 설정한다.
            color: Color(0xfff99231),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 로고이미지
                  Image.asset("assets/logo.png", width: 200),
                  // 돌아가는 원
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
