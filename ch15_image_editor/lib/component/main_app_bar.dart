import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget {
  // 이미지 선택 버튼 콜백
  final VoidCallback onPickImage;
  // 이미지 저장 버튼 콜백
  final VoidCallback onSaveImage;
  // 이미지 삭제 버튼 콜백
  final VoidCallback onDeleteItem;

  const MainAppBar({
    super.key,
    required this.onPickImage,
    required this.onSaveImage,
    required this.onDeleteItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(color: Colors.white.withAlpha(230)),
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
            onPressed: onDeleteItem,
            icon: Icon(Icons.delete_outline, color: Colors.grey[700]),
          ),
          // 이미지 저장 버튼
          IconButton(
            onPressed: onSaveImage,
            icon: Icon(Icons.save, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}
