import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';

/// 앱바
/// 이미지 선택 버튼과 스티커 삭제 버튼, 이미지 저장 버튼으로 구성되어 있다.
class MainAppBar extends StatelessWidget {
  final VoidCallback onPickImage;
  final VoidCallback onSavdImage;
  final VoidCallback onDeleteImage;

  @Preview(name: 'MainAppBar')
  static Widget preview() =>
      MainAppBar(onPickImage: () {}, onSavdImage: () {}, onDeleteImage: () {});

  const MainAppBar({
    super.key,
    required this.onPickImage,
    required this.onSavdImage,
    required this.onDeleteImage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(color: Colors.white.withAlpha(220)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 이미지 선택 버튼
          IconButton(
            onPressed: onPickImage,
            icon: Icon(Icons.image_search_outlined, color: Colors.grey[700]),
          ),
          // 스티커 삭제 버튼
          IconButton(
            onPressed: onDeleteImage,
            icon: Icon(Icons.delete_forever_outlined, color: Colors.grey[700]),
          ),
          // 이미지 저장 버튼
          IconButton(
            onPressed: onSavdImage,
            icon: Icon(Icons.save, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}
