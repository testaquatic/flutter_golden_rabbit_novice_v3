import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  /// 홈 화면을 구성하는 위젯
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 계산을 시작하는 날짜
  DateTime firstDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100],
      body: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _DDay(onHeartPressed: onHeartPressed, firstDay: firstDay),
            _CoupleImage(),
          ],
        ),
      ),
    );
  }

  /// 하트 아이콘 버튼을 눌렀을 때 실행하는 콜백
  /// 쿠퍼티노 날짜 선택 다이얼로그를 표시한다.
  void onHeartPressed() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white,
            height: 300.0,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (date) {
                setState(() {
                  firstDay = date;
                });
              },
            ),
          ),
        );
      },
      barrierDismissible: true,
    );
  }
}

class _DDay extends StatelessWidget {
  // 하트 아이콘 버튼을 눌렀을 때 실행하는 콜백
  final VoidCallback onHeartPressed;
  // 계산을 시작하는 날짜
  final DateTime firstDay;

  /// 상단의 지난간 날짜수를 표시하는 위젯
  const _DDay({required this.onHeartPressed, required this.firstDay});

  @override
  Widget build(BuildContext context) {
    // 폰트 스타일
    final textTheme = Theme.of(context).textTheme;
    final now = DateTime.now();

    return Column(
      children: [
        const SizedBox(height: 16.0),
        // 최상단의 U&I 글자
        Text("U&I", style: textTheme.displayLarge),
        const SizedBox(height: 16.0),
        // 우리 처음 만난날 글자
        Text("우리 처음 만난날", style: textTheme.bodyLarge),
        // 만난 날짜
        Text(
          "${firstDay.year}.${firstDay.month}.${firstDay.day}",
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: 16.0),
        // 하트 아이콘 버튼
        IconButton(
          onPressed: onHeartPressed,
          icon: Icon(Icons.favorite, color: Colors.red),
          iconSize: 60.0,
        ),
        const SizedBox(height: 16.0),
        // 지나간 날짜 수
        Text(
          "D+${DateTime(now.year, now.month, now.day).difference(firstDay).inDays + 1}",
          style: textTheme.displayMedium,
        ),
      ],
    );
  }
}

class _CoupleImage extends StatelessWidget {
  /// 하단의 이미지를 표시하는 위젯
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Image.asset(
          "asset/img/middle_image.png",
          height: MediaQuery.of(context).size.height / 2,
        ),
      ),
    );
  }
}
