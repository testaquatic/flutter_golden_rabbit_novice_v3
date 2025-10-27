import 'package:flutter/material.dart';

void main() {
  runApp(SplashScreen());
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          // 배경 색을 오랜지색으로 설정한다.
          decoration: BoxDecoration(color: Color(0xFFF99231)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 여러 위젯을 배치할 수 있다.
              // 세로로 늘어난다.
              Column(
                // 주축을 가운데 정렬한다.
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 화면의 중앙에 이미지를 표시한다."
                  Center(child: Image.asset("assets/logo.png", width: 200)),
                  // 회전하는 원이 표시된다.
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
