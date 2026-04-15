import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

/// 이미지를 선택하는 provider
final pickedImageProvider = AsyncNotifierProvider(_PickedImageNotifier.new);

class _PickedImage {
  XFile? image;

  _PickedImage({this.image});

  static Future<_PickedImage> pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    return _PickedImage(image: image);
  }
}

class _PickedImageNotifier extends AsyncNotifier<_PickedImage> {
  @override
  FutureOr<_PickedImage> build() {
    return _PickedImage();
  }

  /// 이미지를 선택한다.
  void pickedImage() async {
    final pickedImage = await _PickedImage.pickImage();
    state = AsyncValue.data(pickedImage);
  }
}
