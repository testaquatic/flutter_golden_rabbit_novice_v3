import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // 페이지뷰 컨트롤러
  final pageController = PageController();

  @override
  void initState() {
    super.initState();

    Timer.periodic(Duration(seconds: 5), (timer) {
      final currentPageCount = pageController.page?.toInt();
      if (currentPageCount == null) {
        return;
      }

      final nextPageCount = (currentPageCount + 1) % 5;
      pageController.animateToPage(
        nextPageCount,
        duration: Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    // 상태바 색상 변경
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      // 이미지 페이지 뷰
      body: PageView.builder(
        controller: pageController,
        itemCount: 5,
        itemBuilder: (context, index) {
          return Image.asset(
            'asset/img/image_${index + 1}.jpeg',
            fit: BoxFit.cover,
          );
        },
      ),
    );
  }
}
