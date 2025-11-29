import 'package:flutter/material.dart';

class EmoticonSticker extends StatefulWidget {
  // 스티커 상태 변경을 부모 위젯에게 알린다.
  final VoidCallback onTransform;
  // 이미지 경로
  final String imgPath;
  // 이미지가 선택되었는지 확인한다.
  final bool isSelected;

  const EmoticonSticker({
    super.key,
    required this.onTransform,
    required this.imgPath,
    required this.isSelected,
  });

  @override
  State<EmoticonSticker> createState() {
    return _EmoticonStickerState();
  }
}

class _EmoticonStickerState extends State<EmoticonSticker> {
  // 확대 축소 배율
  double scale = 1;
  // 가로의 움직임
  double hTransform = 0;
  // 세로의 움직임
  double vTransform = 0;
  // 위젯의 최기 크기 기준 확대/축소 배율
  double actualScale = 1;

  @override
  Widget build(BuildContext context) {
    // child 위젯을 변형할 수 있는 위젯
    return Transform(
      transform: Matrix4.identity()
        ..translateByDouble(hTransform, vTransform, 0, 1.0)
        ..scaleByDouble(scale, scale, 1.0, 1.0),
      child: Container(
        // 이모티콘을 선택하면 테두리 색상을 적용한다.
        decoration: widget.isSelected
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(color: Colors.blue, width: 1.0),
              )
            : BoxDecoration(
                // 스티커가 선택, 취소될 때 깜빡이는 현상 제거
                border: Border.all(width: 1.0, color: Colors.transparent),
              ),
        child: GestureDetector(
          // 스티커를 눌렀을 때
          onTap: () {
            widget.onTransform();
          },
          // 스티커 확대 비율이 변경됐을 때
          onScaleUpdate: (details) {
            widget.onTransform();
            setState(() {
              scale = details.scale * actualScale;
              // 세로 이동 거리 계산
              vTransform += details.focalPointDelta.dy;
              // 가로 이동 거리 계산
              hTransform += details.focalPointDelta.dx;
            });
          },
          // 스티커의 확대 비율 변경이 완료됐을 때
          onScaleEnd: (details) {
            // 확대 비율 저장
            actualScale = scale;
          },
          child: Image.asset(widget.imgPath),
        ),
      ),
    );
  }
}
