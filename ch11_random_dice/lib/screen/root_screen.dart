import 'dart:math';

import 'package:ch11_random_dice/screen/home_screen.dart';
import 'package:ch11_random_dice/screen/setting_screen.dart';
import 'package:flutter/material.dart';
import 'package:shake/shake.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() {
    return _RootScreenState();
  }
}

// TabController를 초기화하기 위해 TickerProviderStateMixin를 mixin한다.
class _RootScreenState extends State<RootScreen> with TickerProviderStateMixin {
  TabController? controller;
  // 민감도의 기본값
  double threshold = 2.7;
  // 주사위 숫자
  int number = 1;
  ShakeDetector? shakeDetector;

  @override
  void initState() {
    super.initState();

    // 컨트롤러를 초기화한다.
    controller = TabController(length: 2, vsync: this);

    // 컨트롤로 속성이 변경될 때마다 실행할 콜백 등록
    controller!.addListener(tabListener);

    // 흔들림 감지
    shakeDetector = ShakeDetector.autoStart(
      shakeSlopTimeMS: 100,
      shakeThresholdGravity: threshold,
      onPhoneShake: onPhoneShake,
    );
  }

  // 흔들림 감지 후 실행할 함수
  void onPhoneShake(e) {
    final rand = Random();

    setState(() {
      number = rand.nextInt(6) + 1;
    });
  }

  tabListener() {
    setState(() {});
  }

  @override
  void dispose() {
    controller!.removeListener(tabListener);
    shakeDetector!.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        // 컨트롤러를 등록한다.
        controller: controller,
        children: renderChildren(),
      ),
      bottomNavigationBar: renderBottomNavigation(),
    );
  }

  List<Widget> renderChildren() {
    return [
      HomeScreen(number: number),
      SettingScreen(
        threshold: threshold,
        onThresholdChanged: onThresholdChanged,
      ),
    ];
  }

  // 슬라이더값 변경 시 실행 함수
  void onThresholdChanged(double val) {
    setState(() {
      threshold = val;
    });
  }

  BottomNavigationBar renderBottomNavigation() {
    return BottomNavigationBar(
      // 현재 화면에 렌더링되는 탭의 인덱스
      currentIndex: controller!.index,
      onTap: (int index) {
        setState(() {
          controller!.animateTo(index);
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
