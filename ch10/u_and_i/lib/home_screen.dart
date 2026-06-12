import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  var firstDay = DateTime.now();

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
            _CounpleImage(),
          ],
        ),
      ),
    );
  }

  /// 하트 아이콘을 누르면 실행하는 콜백
  void onHeartPressed() {
    showCupertinoDialog(
      context: context,
      builder: (context) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white,
            height: 300,
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

/// 상단의 정보
class _DDay extends StatelessWidget {
  // 아이콘을 누르면 실행하는 콜백
  final GestureTapCallback onHeartPressed;
  final DateTime firstDay;

  const _DDay({required this.onHeartPressed, required this.firstDay});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final now = DateTime.now();

    return Column(
      children: [
        const SizedBox(height: 16.0),
        // 최상단 U&I 글자
        // displayLarge
        Text("U&I", style: textTheme.displayLarge),
        const SizedBox(height: 16.0),
        // 두번째 글자
        // bodyLarge
        Text("우리 처음 만난 날", style: textTheme.bodyLarge),
        // 만난 날짜
        // bodyMedium
        Text(
          "${firstDay.year}.${firstDay.month}.${firstDay.day}",
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: 16.0),
        // 하트 아이콘 버튼
        IconButton(
          iconSize: 60.0,
          onPressed: onHeartPressed,
          icon: Icon(Icons.favorite, color: Colors.red),
        ),
        const SizedBox(height: 16.0),
        // D-Day
        // displayMedium
        Text(
          "D+${DateTime(now.year, now.month, now.day).difference(firstDay).inDays + 1}",
          style: textTheme.displayMedium,
        ),
      ],
    );
  }
}

/// 하단의 커플 이미지
/// 화면 높이의 1/2을 차지하거나, _DDay의 높이가 높으면 작아진다
class _CounpleImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Image.asset(
          "assets/images/middle_image.png",
          height: MediaQuery.of(context).size.height / 2,
        ),
      ),
    );
  }
}
