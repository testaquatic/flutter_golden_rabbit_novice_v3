import 'package:flutter/material.dart';

/// 상단의 앱바
///
/// 선택 버튼, 저장 버튼, 삭제 버튼이 있다.
class MainAppBar extends StatelessWidget {
  /// 이미지 선택 버튼을 눌렀을 때 실행할 콜백
  final VoidCallback onPickImage;

  /// 이미지 저장 버튼을 눌렀을 때 실행할 콜백
  final VoidCallback onSaveImage;

  /// 이미지 삭제 버튼을 눌렀을 때 실행할 콜백
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
      decoration: BoxDecoration(color: Colors.white.withAlpha(220)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 선택 버튼
          IconButton(
            onPressed: onPickImage,
            icon: Icon(Icons.image_search_outlined, color: Colors.grey[700]),
          ),
          // 삭제 버튼
          IconButton(
            onPressed: onDeleteItem,
            icon: Icon(Icons.delete_forever_outlined, color: Colors.grey[700]),
          ),
          // 저장 버튼
          IconButton(
            onPressed: onSaveImage,
            icon: Icon(Icons.save, color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }
}
