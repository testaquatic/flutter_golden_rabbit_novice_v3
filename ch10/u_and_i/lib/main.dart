import 'package:flutter/material.dart';
import 'package:u_and_i/screen/home_screen.dart';

void main() {
  runApp(MaterialApp(theme: themeData, home: HomeScreen()));
}

final ThemeData themeData = ThemeData(
  fontFamily: "sunflower",
  textTheme: const TextTheme(
    // U&I에 적용한다.
    displayLarge: TextStyle(
      color: Colors.white,
      fontSize: 80.0,
      fontWeight: FontWeight.w700,
      fontFamily: "parisienne",
    ),
    // 경과 기간에 적용한다.
    displayMedium: TextStyle(
      color: Colors.white,
      fontSize: 50.0,
      fontWeight: FontWeight.w700,
    ),
    // 우리 처음 만난 날에 적용한다.
    bodyLarge: TextStyle(color: Colors.white, fontSize: 30.0),
    // 날짜에 적용한다.
    bodyMedium: TextStyle(color: Colors.white, fontSize: 20.0),
  ),
);
