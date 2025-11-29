// 스티커를 선택할 때마다 실행할 함수의 시그니쳐
import 'package:flutter/material.dart';

typedef OnEmoticonTap = void Function(int id);

class Footer extends StatelessWidget {
  final OnEmoticonTap onEmoticonTap;

  const Footer({super.key, required this.onEmoticonTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withAlpha(230),
      height: 150,
      // 가로로 스크롤 가능
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            7,
            (index) => Padding(
              padding: const EdgeInsetsGeometry.symmetric(horizontal: 8.0),
              child: GestureDetector(
                onTap: () {
                  onEmoticonTap(index + 1);
                },
                child: Image.asset(
                  "asset/img/emoticon_${index + 1}.png",
                  height: 100,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
