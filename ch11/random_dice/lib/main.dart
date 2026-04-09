import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:random_dice/const/colors.dart';
import 'package:random_dice/router/router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    ProviderScope(
      child: MaterialApp.router(routerConfig: router, theme: theme),
    ),
  );
}

final theme = ThemeData(
  scaffoldBackgroundColor: backGroundColor,
  sliderTheme: SliderThemeData(
    thumbColor: primaryColor,
    activeTrackColor: primaryColor,
    inactiveTrackColor: primaryColor.withAlpha(75),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: primaryColor,
    unselectedItemColor: secondaryColor,
    backgroundColor: backGroundColor,
  ),
);
