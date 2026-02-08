import 'package:flutter/material.dart';
import 'package:video_call/screen/cam_screen.dart';

/// 홈스크린 위젯
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
              // 로고
              Expanded(child: _Logo()),
              // 중앙 이미지
              Expanded(child: _Image()),
              // 영상 통화 시작 버튼
              Expanded(child: _EntryButton()),
            ],
          ),
        ),
      ),
    );
  }
}

/// 로고 위젯
class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.circular(16.0),
          boxShadow: [
            BoxShadow(
              color: Colors.blue[300]!,
              blurRadius: 12.0,
              spreadRadius: 2.0,
            ),
          ],
        ),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 캠코더 아이콘
              Icon(Icons.videocam, color: Colors.white, size: 40.0),
              SizedBox(width: 12.0),
              // 앱 이름
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

/// 중앙 이미지 위젯
class _Image extends StatelessWidget {
  const _Image();

  @override
  Widget build(BuildContext context) {
    return Center(child: Image.asset("asset/img/home_img.png"));
  }
}

/// 하단의 입장하기 버튼
class _EntryButton extends StatelessWidget {
  const _EntryButton();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (_) => CamScreen()));
          },

          child: Text("입장하기"),
        ),
      ],
    );
  }
}
