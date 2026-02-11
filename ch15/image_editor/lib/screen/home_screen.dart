import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_editor/component/emoticon_sticker.dart';
import 'package:image_editor/component/footer.dart';
import 'package:image_editor/component/main_app_bar.dart';
import 'package:image_editor/model/sticker_model.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  /// 선택한 이미지를 저장한다.
  XFile? image;

  /// 화면에 표시된 스티커를 저장한다.
  Set<StickerModel> stickers = {};

  /// 현재 선택된 스티커의 ID
  String? selectedId;

  /// 이미지 캡쳐를 위한 key
  GlobalKey imgKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 이미지
          renderBody(),
          // 앱바
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: MainAppBar(
              onPickImage: onPickImage,
              onSaveImage: onSaveImage,
              onDeleteItem: onDeleteItem,
            ),
          ),
          // 푸터 탭버튼
          // 이미지를 선택해야 표시한다.
          if (image != null)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Footer(onEmoticonTab: onEmoticonTab),
            ),
        ],
      ),
    );
  }

  /// 이미지가 선택됐을 경우에는 이미지를 표시한다.
  /// 그렇지 않으면 이미지 선택 버튼을 표시한다.
  Widget renderBody() {
    if (image != null) {
      // 이미지가 선택됐을 경우에는 이미지를 표시한다.
      return RepaintBoundary(
        key: imgKey,
        child: Positioned.fill(
          child: InteractiveViewer(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.file(File(image!.path), fit: BoxFit.cover),
                ...stickers.map(
                  (sticker) => Center(
                    child: EmoticonSticker(
                      key: ObjectKey(sticker.id),
                      onTransForm: () {
                        onTransForm(sticker.id);
                      },
                      imgPath: sticker.imgPath,
                      isSelected: selectedId == sticker.id,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      // 그렇지 않다면 이미지 선택 버튼을 표시한다.
      return Center(
        child: TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.grey),
          onPressed: onPickImage,
          child: Text("이미지 선택하기"),
        ),
      );
    }
  }

  /// 갤러리에서 이미지를 선택한다.
  void onPickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      this.image = image;
    });
  }

  void onSaveImage() async {
    if (imgKey.currentContext == null) {
      throw Exception("imgKey.currentContext is null");
    }
    // 이하로 image.currentContext는 null이 아니다.

    var boundary = imgKey.currentContext!.findRenderObject();
    if (boundary == null || boundary is! RenderRepaintBoundary) {
      throw Exception("boundary is null or not RenderRepaintBoundary");
    }
    // 이하로 boundary는 RenderRepaintBoundary의 인스턴스이다.

    final image = await boundary.toImage();
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    if (byteData == null) {
      throw Exception("byteData is null");
    }
    // 이하로 byteData는 null이 아니다.

    final pngBytes = byteData.buffer.asUint8List();
    await ImageGallerySaverPlus.saveImage(pngBytes, quality: 100);

    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("저장되었습니다.")));
    }
  }

  void onDeleteItem() {
    setState(() {
      stickers.removeWhere((sticker) {
        if (selectedId == null) {
          return false;
        }
        return sticker.id == selectedId;
      });
    });
  }

  void onEmoticonTab(int index) async {
    setState(() {
      stickers.add(
        StickerModel(id: Uuid().v4(), imgPath: "asset/img/emoticon_$index.png"),
      );
    });
  }

  void onTransForm(String id) {
    setState(() {
      selectedId = id;
    });
  }
}
