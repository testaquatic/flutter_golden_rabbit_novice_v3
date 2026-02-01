import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

class HomeScreen extends StatefulWidget {
  @Preview(name: "Home Screen")
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  // 처음 만난 날
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
            const _CoupleImage(),
          ],
        ),
      ),
    );
  }

  /// 하트 버튼을 눌렀을 때 실행되는 콜백
  /// CupertinoDatePicker를 화면에 띄운다.
  void onHeartPressed() {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        // 위젯의 위치를 아래로 조정
        return Align(
          alignment: Alignment.bottomCenter,
          // 위젯의 색과 크기를 지정
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
    );
  }
}

class _DDay extends StatelessWidget {
  // 하트 버튼을 눌렀을 때 실행하는 콜백
  final VoidCallback onHeartPressed;
  // 처음 만난 날
  final DateTime firstDay;

  const _DDay({required this.onHeartPressed, required this.firstDay});

  @override
  Widget build(BuildContext context) {
    // 테마 불러오기
    final textTheme = Theme.of(context).textTheme;
    // 현재 날짜
    final now = DateTime.now();

    return Column(
      children: [
        const SizedBox(height: 16.0),
        // 최상단 U&I 글자
        Text("U&I", style: textTheme.displayLarge),
        const SizedBox(height: 16.0),
        // 두 번째 글자
        Text("우리 처음 만난 날", style: textTheme.bodyLarge),
        // 만난 날짜
        Text(
          "${firstDay.year}.${firstDay.month}.${firstDay.day}",
          style: textTheme.bodyMedium,
        ),
        const SizedBox(height: 16.0),
        // 하트아이콘 버튼
        IconButton(
          iconSize: 60.0,
          color: Colors.red,
          onPressed: onHeartPressed,
          icon: Icon(Icons.favorite),
        ),
        const SizedBox(height: 16.0),
        // 경과한 기간
        Text(
          "D+${now.difference(firstDay).inDays + 1}",
          style: textTheme.displayMedium,
        ),
      ],
    );
  }
}

class _CoupleImage extends StatelessWidget {
  const _CoupleImage();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Image.asset(
          "assets/img/middle_image.png",
          height: MediaQuery.of(context).size.height * 0.5,
        ),
      ),
    );
  }
}
