import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 먼저 보이는 홈스크린
/// 로고, 이미지, 버튼이 위치한다.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(child: _Logo()),
              Expanded(child: _Image()),
              Expanded(child: _EntryButton()),
            ],
          ),
        ),
      ),
    );
  }
}

/// 로고를 표시한다
class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue[300],
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.blue[300]!,
              blurRadius: 12.0,
              spreadRadius: 2.0,
            ),
          ],
        ),
        child: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.videocam, color: Colors.white, size: 4.0),
              SizedBox(width: 12.0),
              Text(
                "LIVE",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  letterSpacing: 4.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 이미지
class _Image extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(child: Image.asset("asset/img/home_img.png"));
  }
}

/// 하단의 "입장하기 버튼"
class _EntryButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () {
            context.push("/cam");
          },
          child: const Text("입장하기"),
        ),
      ],
    );
  }
}
