import 'package:flutter/material.dart';
import 'package:vector_math/vector_math_64.dart' hide Colors;

class EmoticonSticker extends StatefulWidget {
  final VoidCallback onTransform;
  final String imgPath;
  final bool isSelected;

  const EmoticonSticker({
    required this.onTransform,
    required this.imgPath,
    required this.isSelected,
    super.key,
  });

  @override
  State<EmoticonSticker> createState() => _EmoticonStickerState();
}

class _EmoticonStickerState extends State<EmoticonSticker> {
  /// 확대 비율
  double scale = 1.0;

  /// 가로의 움직임
  double hTransform = 0;

  /// 세로의 움직임
  double vTransform = 0;

  /// 초기 크기 기준 확대 비율
  double actualScale = 1.0;

  @override
  Widget build(BuildContext context) {
    return Transform(
      transform: Matrix4.identity()
        ..translateByVector3(Vector3(hTransform, vTransform, 0))
        ..scaleByVector3(Vector3(scale, scale, 1.0)),
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
            widget.onTransform();
          },
          onScaleUpdate: (details) {
            widget.onTransform();
            setState(() {
              scale = details.scale * actualScale;
              vTransform = vTransform + details.focalPointDelta.dy;
              hTransform = hTransform + details.focalPointDelta.dx;
            });
          },
          onScaleEnd: (details) => {actualScale = scale},
          child: Image.asset(widget.imgPath),
        ),
      ),
    );
  }
}
