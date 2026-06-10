import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<StatefulWidget> {
  late Timer _timer;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      int? nextPage = _pageController.page?.toInt();

      if (nextPage == null) {
        return;
      }

      nextPage += 1;

      if (nextPage == 5) {
        nextPage = 0;
      }

      _pageController.animateToPage(
        nextPage,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemBuilder: (context, index) {
          return Image.asset(
            'images/image_${index + 1}.jpeg',
            fit: BoxFit.cover,
          );
        },
        itemCount: 5,
      ),
    );
  }
}
