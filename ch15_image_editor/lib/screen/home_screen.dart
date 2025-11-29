import 'dart:io';
import 'dart:ui';

import 'package:ch15_image_editor/component/emoticon_sticker.dart';
import 'package:ch15_image_editor/component/footer.dart';
import 'package:ch15_image_editor/component/main_app_bar.dart';
import 'package:ch15_image_editor/model/sticker_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

// 홈스크린
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  // 선택한 이미지를 저장할 변수
  XFile? image;
  // 화면에 추가한 스티커를 저장하는 변수
  Set<StickerModel> stickers = {};
  // 현재 선택된 스티커의 ID
  String? selectedID;
  // 이미지로 전환할 위젯의 키값
  GlobalKey imgKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          renderBody(),
          Positioned(
            // 책의 내용과 다르에 이 부분을 삭제하면 안된다.
            top: 0,
            left: 0,
            right: 0,
            child: MainAppBar(
              onPickImage: onPickImage,
              onSaveImage: onSaveImage,
              onDeleteItem: onDeleteItem,
            ),
          ),
          // 이미지가 선택될 경우에 Footer를 표시한다.
          if (image != null)
            Positioned(
              // 아래에 Footer를 위치시킨다.
              bottom: 0,
              left: 0,
              right: 0,
              child: Footer(onEmoticonTap: onEmoticonTap),
            ),
        ],
      ),
    );
  }

  Widget renderBody() {
    if (image != null) {
      return RepaintBoundary(
        key: imgKey,
        child: Positioned.fill(
          // 위젯 확대 및 좌우 이동을 가능하게 하는 위젯
          child: InteractiveViewer(
            child: Stack(
              // 크기를 최대한으로 늘린다.
              fit: StackFit.expand,
              children: [
                Image.file(
                  File(image!.path),
                  // 이미지가 부모 위젯 크기 최대를 차지하도록 하기
                  fit: BoxFit.cover,
                ),
                ...stickers.map(
                  (sticker) => Center(
                    key: Key(sticker.id),
                    child: EmoticonSticker(
                      onTransform: () => onTransform(sticker.id),
                      imgPath: sticker.imgPath,
                      isSelected: selectedID == sticker.id,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    } else {
      // 이미지가 선택이 안된 경우 이미지 선택 버튼 표시
      return Center(
        child: TextButton(
          style: TextButton.styleFrom(foregroundColor: Colors.grey),
          onPressed: onPickImage,
          child: Text("이미지 선택하기"),
        ),
      );
    }
  }

  // 스티커의 상태가 변경됐을 때 실행하는 콜백
  void onTransform(String id) {
    setState(() {
      // 스티커가 변형될 때마다 변형 중인 스티커를 현재 선택한 스티커로 변경
      selectedID = id;
    });
  }

  // 스티커를 선택할 때마다 실행할 콜백
  void onEmoticonTap(int index) async {
    setState(() {
      stickers = {
        ...stickers,
        StickerModel(id: Uuid().v4(), imgPath: "asset/img/emoticon_$index.png"),
      };
    });
  }

  void onPickImage() async {
    // 갤러리에서 이미지를 선택한다.
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    // 선택한 이미지를 저장한다.
    setState(() {
      this.image = image;
    });
  }

  void onSaveImage() async {
    RenderRepaintBoundary boundary =
        imgKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final byteData = await image.toByteData(format: ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();
    await ImageGallerySaverPlus.saveImage(pngBytes, quality: 100);

    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("저장되었습니다.")));
    }
  }

  void onDeleteItem() async {
    setState(() {
      stickers = stickers.where((sticker) => sticker.id != selectedID).toSet();
      selectedID = null;
    });
  }
}
