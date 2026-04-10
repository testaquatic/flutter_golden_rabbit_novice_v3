import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

final videoProvider = AsyncNotifierProvider<VideoNotifier, XFile?>(
  VideoNotifier.new,
);

class VideoNotifier extends AsyncNotifier<XFile?> {
  @override
  XFile? build() {
    return null;
  }

  void pickVideo() async {
    state = AsyncValue.loading();
    final video = await ImagePicker().pickVideo(source: ImageSource.gallery);
    state = AsyncValue.data(video);
  }
}

class CustomVideoController {
  VideoPlayerController? controller;

  CustomVideoController({this.controller});

  VideoPlayerValue? get value => controller?.value;

  void dispose() {
    if (controller != null) {
      controller!.dispose();
    }
  }

  Future<CustomVideoController> initializeController(XFile file) async {
    if (controller != null) {
      controller!.dispose();
      controller = null;
    }
    if (controller == null) {
      final controller = VideoPlayerController.file(File(file.path));
      await controller.initialize();
      return CustomVideoController(controller: controller);
    }

    return CustomVideoController();
  }

  void seekTo(Duration duration) {
    if (controller == null) {
      return;
    }

    controller!.seekTo(duration);
  }

  void reverse() {
    if (controller == null) {
      return;
    }

    final currentPosition = value!.position;
    Duration position = Duration();

    if (currentPosition.inSeconds > 3) {
      position = currentPosition - Duration(seconds: 3);
    } else {
      position = Duration(seconds: 0);
    }

    seekTo(position);
  }

  void forward() {
    if (controller == null) {
      return;
    }

    final maxPosition = value!.duration;
    final currentPosition = value!.position;

    Duration position = maxPosition;

    if ((maxPosition - Duration(seconds: 3)).inSeconds >
        currentPosition.inSeconds) {
      position = currentPosition + Duration(seconds: 3);
    } else {
      position = maxPosition;
    }

    seekTo(position);
  }

  void play() {
    if (controller == null) {
      return;
    }

    if (controller!.value.isPlaying) {
      controller!.pause();
    } else {
      controller!.play();
    }
  }
}

final videoControllerProvider =
    NotifierProvider<CustomVideoControllerNotifier, CustomVideoController>(
      CustomVideoControllerNotifier.new,
    );

class CustomVideoControllerNotifier extends Notifier<CustomVideoController> {
  @override
  CustomVideoController build() {
    return CustomVideoController();
  }

  @override
  bool updateShouldNotify(
    CustomVideoController previous,
    CustomVideoController next,
  ) {
    return previous.controller != next.controller;
  }

  void initializeController(XFile file) async {
    final newState = await state.initializeController(file);
    state = newState;
  }
}

final showControlsProvider = StateProvider<bool>((ref) => false);
