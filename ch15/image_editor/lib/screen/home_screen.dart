import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_editor/component/emoticon_sticker.dart';
import 'package:image_editor/component/footer.dart';
import 'package:image_editor/component/main_app_bar.dart';
import 'package:image_editor/model/sticker_model.dart';
import 'package:image_editor/provider/image_provider.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:uuid/uuid.dart';

import 'dart:ui' as ui;

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @Preview(name: 'HomeScreen')
  static Widget preview() => const HomeScreen();

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  /// 화면에 추가될 스티커
  Set<StickerModel> stickers = {};
  String? selectedId;

  /// 이미지로 전환할 위젯에 입력된 키
  GlobalKey imgKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final image = ref.watch(pickedImageProvider);
    return SafeArea(
      top: false,
      bottom: true,
      child: Scaffold(
        body: Stack(
          children: [
            renderBody(),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: MainAppBar(
                onPickImage: () {
                  pickImage();
                },
                onSavdImage: onSavdImage,
                onDeleteImage: onDeleteImage,
              ),
            ),
            if (image.hasValue && image.value!.image != null)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Footer(onEmoticonTap: onEmoticonTap),
              ),
          ],
        ),
      ),
    );
  }

  void pickImage() {
    final pickedImageNotifier = ref.read(pickedImageProvider.notifier);
    pickedImageNotifier.pickedImage();
  }

  void onSavdImage() async {
    if (imgKey.currentContext == null ||
        imgKey.currentContext!.findRenderObject() is! RenderRepaintBoundary) {
      return;
    }

    RenderRepaintBoundary boundary =
        imgKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final pngBytes = byteData!.buffer.asUint8List();

    await ImageGallerySaverPlus.saveImage(pngBytes, quality: 100);

    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("저장되었습니다.")));
    }
  }

  void onDeleteImage() async {
    setState(() {
      stickers = stickers.where((sticker) => sticker.id != selectedId).toSet();
    });
  }

  void onEmoticonTap(int index) async {
    setState(() {
      stickers = {
        ...stickers,
        StickerModel(
          id: Uuid().v4(),
          imgPath: "asset/img/emoticon_${index + 1}.png",
        ),
      };
    });
  }

  Widget renderBody() {
    final image = ref.watch(pickedImageProvider);

    return image.when(
      data: (data) {
        if (data.image != null) {
          return RepaintBoundary(
            key: imgKey,
            child: Positioned.fill(
              child: InteractiveViewer(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.file(File(data.image!.path), fit: BoxFit.cover),
                    ...stickers.map(
                      (sticker) => Center(
                        child: EmoticonSticker(
                          onTransform: () {
                            onTransform(sticker.id);
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
          return Center(
            child: TextButton(
              onPressed: () {
                pickImage();
              },
              child: const Text("이미지 선택하기"),
            ),
          );
        }
      },
      error: (error, stackTrace) => Center(child: Text(error.toString())),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }

  void onTransform(String id) {
    setState(() {
      selectedId = id;
    });
  }
}
