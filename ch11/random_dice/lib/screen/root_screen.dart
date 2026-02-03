import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:random_dice/screen/home_screen.dart';
import 'package:random_dice/screen/settings_screen.dart';
import 'package:shake/shake.dart';

class RootScreen extends StatefulWidget {
  @Preview(name: "RootScreen")
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> with TickerProviderStateMixin {
  // bottomNavigationBar에 전달하는 콜백이다.
  late TabController controller;

  // 주사위의 민감도 설정값이다.
  double threshold = 2.7;

  // 주사의 숫자
  int number = 1;

  // 휴대폰을 흔들었을 때 실행하는 콜백
  late ShakeDetector shakeDetector;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    controller.addListener(tabListener);

    shakeDetector = ShakeDetector.autoStart(
      shakeSlopTimeMS: 100,
      shakeThresholdGravity: threshold,
      onPhoneShake: onPhoneShake,
    );
  }

  void onPhoneShake(_) {
    setState(() {
      number = Random().nextInt(6) + 1;
    });
  }

  void tabListener() {
    setState(() {});
  }

  @override
  void dispose() {
    controller.removeListener(tabListener);
    shakeDetector.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(controller: controller, children: renderChildren()),
      bottomNavigationBar: renderBottomNavigationBar(),
    );
  }

  List<Widget> renderChildren() {
    return [
      // 홈탭
      // 주사위가 나타난다.
      HomeScreen(number: number),
      // 설정 탭
      SettingsScreen(
        threshold: threshold,
        onThresholdChange: onThresholdChange,
      ),
    ];
  }

  void onThresholdChange(double val) {
    setState(() {
      threshold = val;
    });
  }

  BottomNavigationBar renderBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: controller.index,
      onTap: (index) {
        setState(() {
          controller.animateTo(index);
        });
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.edgesensor_high_outlined),
          label: "주사위",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "설정"),
      ],
    );
  }
}
