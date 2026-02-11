import 'package:flutter/material.dart';

typedef OnEmoticonTab = void Function(int id);

class Footer extends StatelessWidget {
  final OnEmoticonTab onEmoticonTab;

  /// 하단의 이미지를 선택하는 탭
  const Footer({super.key, required this.onEmoticonTab});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withAlpha(230),
      height: 150,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () {
                onEmoticonTab(index + 1);
              },
              child: Image.asset(
                "asset/img/emoticon_${index + 1}.png",
                height: 100,
              ),
            ),
          );
        },
        itemCount: 7,
      ),
    );
  }
}
