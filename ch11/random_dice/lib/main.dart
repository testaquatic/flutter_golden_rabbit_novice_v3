import 'package:flutter/material.dart';
import 'package:random_dice/const/colors.dart';
import 'package:random_dice/screen/root_screen.dart';

void main() {
  runApp(MaterialApp(theme: _themeData(), home: RootScreen()));
}

ThemeData _themeData() {
  return ThemeData(
    scaffoldBackgroundColor: backgroundColor,
    sliderTheme: SliderThemeData(
      thumbColor: primaryColor,
      activeTrackColor: primaryColor,
      inactiveTrackColor: primaryColor.withAlpha((255 * 0.3).round()),
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      selectedItemColor: primaryColor,
      unselectedItemColor: secondaryColor,
      backgroundColor: backgroundColor,
    ),
  );
}
