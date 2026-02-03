import 'package:flutter/material.dart';
import 'package:random_dice/const/color.dart';

class HomeScreen extends StatelessWidget {
  // 주사위 숫자
  final int number;

  const HomeScreen({required this.number, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 주사위 이미지
        Center(child: Image.asset("assets/img/$number.png")),
        const SizedBox(height: 32.0),
        // 행운의 숫자
        Text(
          "행운의 숫자",
          style: TextStyle(
            color: secondaryColor,
            fontSize: 20.0,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 12.0),
        // 주사위 숫자
        Text(
          "$number",
          style: TextStyle(
            color: primaryColor,
            fontSize: 60.0,
            fontWeight: FontWeight.w200,
          ),
        ),
      ],
    );
  }
}
