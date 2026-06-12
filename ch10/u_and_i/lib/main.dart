import 'package:flutter/material.dart';
import 'package:u_and_i/home_screen.dart';

void main() {
  runApp(MaterialApp(theme: _appTheme(), home: HomeScreen()));
}

ThemeData _appTheme() {
  return ThemeData(
    fontFamily: "sunflower",
    textTheme: TextTheme(
      displayLarge: TextStyle(
        color: Colors.white,
        fontSize: 80.0,
        fontWeight: FontWeight(700),
        fontFamily: "parisienne",
      ),
      displayMedium: TextStyle(
        color: Colors.white,
        fontSize: 50.0,
        fontWeight: FontWeight(700),
      ),
      bodyLarge: TextStyle(color: Colors.white, fontSize: 30.0),
      bodyMedium: TextStyle(color: Colors.white, fontSize: 20.0),
    ),
  );
}
