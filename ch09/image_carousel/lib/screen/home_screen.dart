import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widget_previews.dart';

class HomeScreen extends StatefulWidget {
  @Preview(name: "HomeScreen")
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  // PageController 생성
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();

    // 타이머 등록
    Timer.periodic(Duration(seconds: 3), (timer) {
      // 현재페이지
      int? nextPage = pageController.page?.toInt();

      // 페이지 값이 없다면 반환
      if (nextPage == null) {
        return;
      }

      // 다음 페이지 설정
      if (nextPage == 4) {
        nextPage = 0;
      } else {
        nextPage = nextPage + 1;
      }

      // 페이지 이동
      pageController.animateToPage(
        nextPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // 상태바 색상 변경
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      body: PageView.builder(
        itemCount: 5,
        controller: pageController,
        itemBuilder: (context, index) {
          return Image.asset(
            "assets/img/image_${index + 1}.jpeg",
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
