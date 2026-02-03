import 'package:flutter/material.dart';
import 'package:random_dice/const/color.dart';

class SettingsScreen extends StatelessWidget {
  // Slider의 값
  final double threshold;

  // Slider가 변경될 때 실행하는 콜백
  final ValueChanged<double> onThresholdChange;

  const SettingsScreen({
    required this.threshold,
    required this.onThresholdChange,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 25.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "민감도",
                style: TextStyle(
                  color: secondaryColor,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                threshold.toStringAsFixed(1),
                style: TextStyle(
                  color: secondaryColor,
                  fontSize: 15.0,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Slider(
          min: 0.1,
          max: 10.0,
          divisions: 101,
          value: threshold,
          onChanged: onThresholdChange,
          label: threshold.toStringAsFixed(1),
        ),
      ],
    );
  }
}
