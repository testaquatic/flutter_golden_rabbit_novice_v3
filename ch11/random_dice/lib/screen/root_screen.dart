import 'dart:math';

import 'package:flutter/material.dart';
import 'package:random_dice/screen/home_screen.dart';
import 'package:random_dice/screen/settings_screen.dart';
import 'package:shake/shake.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> with TickerProviderStateMixin {
  late TabController controller;
  double threshold = 2.7;
  int number = 1;
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

  void onPhoneShake(ShakeEvent _) {
    final rand = Random();
    setState(() {
      number = rand.nextInt(5) + 1;
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
      body: renderChildren(),
      bottomNavigationBar: renderBottomNavidation(),
    );
  }

  Widget renderChildren() {
    return TabBarView(
      controller: controller,
      children: [
        HomeScreen(number: number),
        SettingsScreen(
          threshold: threshold,
          onThresholdChange: onThresholdChange,
        ),
      ],
    );
  }

  void onThresholdChange(double val) {
    setState(() {
      threshold = val;
    });
  }

  BottomNavigationBar renderBottomNavidation() {
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
