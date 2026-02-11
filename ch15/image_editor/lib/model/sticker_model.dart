class StickerModel {
  final String id;
  final String imgPath;

  StickerModel({required this.id, required this.imgPath});

  /// ID 값이 같은 인스턴스는 같은 스티커로 간주한다.
  @override
  bool operator ==(Object other) {
    return (other is StickerModel && other.id == id);
  }

  @override
  int get hashCode => id.hashCode;
}
