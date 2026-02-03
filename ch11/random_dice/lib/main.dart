import 'package:flutter/material.dart';
import 'package:random_dice/const/color.dart';
import 'package:random_dice/screen/root_screen.dart';

void main() {
  runApp(MaterialApp(theme: theme, home: RootScreen()));
}

final theme = ThemeData(
  scaffoldBackgroundColor: backgroundColor,
  sliderTheme: SliderThemeData(
    // 노브 색
    thumbColor: primaryColor,
    // 활성 트랙 색
    activeTrackColor: primaryColor,
    // 비활성 트랙 색
    inactiveTrackColor: secondaryColor,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    // 선택한 아이콘 색
    selectedItemColor: primaryColor,
    // 선택하지 않은 아이콘 색
    unselectedItemColor: secondaryColor,
    // 배경색
    backgroundColor: backgroundColor,
  ),
);
