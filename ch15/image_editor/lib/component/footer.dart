import 'package:flutter/material.dart';

typedef OnEmoticonTap = void Function(int id);

class Footer extends StatelessWidget {
  final OnEmoticonTap _onEmoticonTap;

  static Widget preview() => Footer(onEmoticonTap: (_) {});

  const Footer({super.key, required OnEmoticonTap onEmoticonTap})
    : _onEmoticonTap = onEmoticonTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withAlpha(230),
      height: 150,
      child: ListView.builder(
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: () {
                _onEmoticonTap(index);
              },
              child: Image.asset(
                "asset/img/emoticon_${index + 1}.png",
                height: 100,
              ),
            ),
          );
        },
        itemCount: 7,
        scrollDirection: Axis.horizontal,
      ),
    );
  }
}
