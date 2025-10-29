import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState();

    Timer.periodic(Duration(seconds: 3), (timer) {
      // 현재 페이지 확인
      int? nextPage = pageController.page?.toInt();

      // 페이지 값이 없을 때
      if (nextPage == null) {
        return;
      }

      // 마지막 페이지인 때는 첫 페이지로 돌아간다.
      if (nextPage == 4) {
        nextPage = 0;
      } else {
        // 다음 페이지로 넘어간다.
        nextPage = nextPage + 1;
      }

      // 페이지를 변경한다.
      pageController.animateToPage(
        nextPage,
        duration: Duration(microseconds: 500),
        curve: Curves.ease,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // 상태바의 아이콘을 흰색으로 변경
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      body: PageView(
        controller: pageController,
        children: [1, 2, 3, 4, 5]
            .map(
              (number) => Image.asset(
                'asset/img/image_$number.jpeg',
                fit: BoxFit.cover,
              ),
            )
            .toList(),
      ),
    );
  }
}
