import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:random_dice/provider/provider.dart';
import 'package:shake/shake.dart';

class RootScreen extends ConsumerStatefulWidget {
  final StatefulNavigationShell navigationShell;
  const RootScreen({super.key, required this.navigationShell});

  @override
  ConsumerState<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends ConsumerState<RootScreen>
    with TickerProviderStateMixin {
  late ShakeDetector shakeDetector;

  @override
  void initState() {
    super.initState();

    shakeDetector = ShakeDetector.autoStart(
      onPhoneShake: onPhoneShake,
      shakeSlopTimeMS: 100,
      shakeThresholdGravity: 2.7,
    );
  }

  @override
  void dispose() {
    shakeDetector.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<double>(thresholdProvider, (previous, next) {
      if (previous == next) {
        return;
      }

      shakeDetector.stopListening();

      shakeDetector = ShakeDetector.autoStart(
        onPhoneShake: onPhoneShake,
        shakeSlopTimeMS: 100,
        shakeThresholdGravity: next,
      );
    });

    return Scaffold(
      body: widget.navigationShell,
      bottomNavigationBar: renderBottomNavigationBar(),
    );
  }

  BottomNavigationBar renderBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: widget.navigationShell.currentIndex,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.edgesensor_high_outlined),
          label: "주사위",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: "설정"),
      ],
      onTap: (index) => widget.navigationShell.goBranch(index),
    );
  }

  void onPhoneShake(ShakeEvent _) {
    final rand = Random();
    ref.read(diceNumProvider.notifier).state = rand.nextInt(5) + 1;
  }
}
