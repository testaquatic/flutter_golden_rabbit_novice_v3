import 'package:flutter/material.dart';

class EmoticonSticker extends StatefulWidget {
  /// 스티커의 상태가 변경될 때마다 실행하는 콜백
  final VoidCallback onTransForm;

  /// 이미지 경로
  final String imgPath;

  /// 스티커가 선택되었는지 여부
  final bool isSelected;

  /// 이모티콘 스티커
  const EmoticonSticker({
    super.key,
    required this.onTransForm,
    required this.imgPath,
    required this.isSelected,
  });

  @override
  State<EmoticonSticker> createState() => _EmoticonStickerState();
}

class _EmoticonStickerState extends State<EmoticonSticker> {
  /// 확대 축소 배율
  double scale = 1;

  /// 가로의 움직임
  double hTransform = 0;

  /// 세로의 움직임
  double vTransform = 0;

  /// 위젯의 초기 크기 기준 확대/축소 배율
  double actualScale = 1;

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        // https://api.flutter.dev/flutter/package-vector_math_vector_math_64/Matrix4/translate.html
        ..translateByDouble(hTransform, vTransform, 0, 1.0)
        // https://api.flutter.dev/flutter/package-vector_math_vector_math_64/Matrix4/scale.html
        ..scaleByDouble(scale, scale, scale, 1.0),
      child: Container(
        decoration: widget.isSelected
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(4.0),
                border: Border.all(color: Colors.blue, width: 1.0),
              )
            : BoxDecoration(
                border: Border.all(width: 1.0, color: Colors.transparent),
              ),
        child: GestureDetector(
          onTap: () {
            widget.onTransForm();
          },

          onScaleUpdate: (details) {
            // widget.onTransForm();
            setState(() {
              scale = details.scale * actualScale;
              vTransform = vTransform + details.focalPointDelta.dy;
              hTransform = hTransform + details.focalPointDelta.dx;
            });
          },

          onScaleEnd: (details) {
            actualScale = scale;
          },

          child: Image.asset(widget.imgPath),
        ),
      ),
    );
  }
}
