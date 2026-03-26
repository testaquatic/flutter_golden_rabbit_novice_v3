import 'package:flutter/material.dart';
import 'package:u_and_i/screen/home_screen.dart';

void main() {
  runApp(MaterialApp(theme: theme, home: HomeScreen()));
}

final theme = ThemeData(
  fontFamily: "sunflower",
  textTheme: TextTheme(
    // U&I 글자 스타일
    displayLarge: TextStyle(
      color: Colors.white,
      fontSize: 80.0,
      fontWeight: FontWeight.w700,
      fontFamily: "parisienne",
    ),
    // D+365 글자 스타일
    displayMedium: TextStyle(
      color: Colors.white,
      fontSize: 50.0,
      fontWeight: FontWeight.w700,
    ),
    // 우리 처음 만난날 글자 스타일
    bodyLarge: TextStyle(color: Colors.white, fontSize: 30.0),
    // 날짜 글자
    bodyMedium: TextStyle(color: Colors.white, fontSize: 20.0),
  ),
);
