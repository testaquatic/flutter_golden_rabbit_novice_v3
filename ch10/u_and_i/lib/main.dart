import 'package:flutter/material.dart';
import 'package:u_and_i/screen/home_screen.dart';

void main() {
  runApp(MaterialApp(theme: _theme(), home: HomeScreen()));
}

ThemeData _theme() {
  return ThemeData(
    fontFamily: "sunflower",
    textTheme: TextTheme(
      // U&I
      displayLarge: TextStyle(
        color: Colors.white,
        fontSize: 80.0,
        fontWeight: FontWeight(700),
        fontFamily: 'parisienne',
      ),
      // 날짜
      displayMedium: TextStyle(
        color: Colors.white,
        fontSize: 50.0,
        fontWeight: FontWeight(700),
      ),
      // 우리 처음 만난 날
      bodyLarge: TextStyle(color: Colors.white, fontSize: 30.0),
      // 날짜
      bodyMedium: TextStyle(color: Colors.white, fontSize: 20.0),
    ),
  );
}
