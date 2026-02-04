import 'package:flutter/material.dart';

/// 동영상 재생을 컨트롤하는 버튼
class CustomIconButton extends StatelessWidget {
  // 아이콘을 눌렀을 때 실행할 함수
  final GestureTapCallback onPressed;
  // 아이콘
  final IconData iconData;

  const CustomIconButton({
    required this.onPressed,
    required this.iconData,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      iconSize: 30.0,
      color: Colors.white,
      icon: Icon(iconData),
    );
  }
}
