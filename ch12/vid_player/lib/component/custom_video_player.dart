import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vid_player/appstate/provider.dart';
import 'package:vid_player/component/custom_icon_button.dart';
import 'package:video_player/video_player.dart';

/// 동영상 재생 화면
class CustomVideoPlayer extends ConsumerStatefulWidget {
  const CustomVideoPlayer({super.key});
  @override
  ConsumerState<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends ConsumerState<CustomVideoPlayer> {
  late CustomVideoController videoController;

  @override
  void dispose() {
    videoController.controller?.removeListener(videoControllerListener);
    videoController.controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    videoController = ref.watch(videoControllerProvider);

    if (videoController.controller == null) {
      ref
          .read(videoControllerProvider.notifier)
          .initializeController(ref.read(videoProvider).value!);
    }

    if (videoController.controller == null) {
      return CircularProgressIndicator();
    }

    videoController.controller?.addListener(videoControllerListener);

    bool showControls = ref.watch(showControlsProvider);

    return GestureDetector(
      onTap: () {
        ref.read(showControlsProvider.notifier).state = !ref.read(
          showControlsProvider,
        );
      },
      child: Center(
        child: AspectRatio(
          aspectRatio: videoController.value!.aspectRatio,
          child: Stack(
            children: [
              VideoPlayer(videoController.controller!),
              if (showControls) Container(color: Colors.black.withAlpha(127)),
              Positioned(
                bottom: 0,
                right: 0,
                left: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      renderTimeTextFromDuration(
                        videoController.value!.position,
                      ),
                      Expanded(
                        child: Slider(
                          value: videoController.value!.position.inSeconds
                              .toDouble(),
                          min: 0,
                          max: videoController.value!.duration.inSeconds
                              .toDouble(),
                          onChanged: (val) {
                            videoController.seekTo(
                              Duration(seconds: val.toInt()),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (showControls)
                Align(
                  alignment: Alignment.topRight,
                  child: CustomIconButton(
                    onPressed: () {
                      ref.read(videoProvider.notifier).pickVideo();
                      final videoFile = ref.watch(videoProvider).value;
                      if (videoFile == null) {
                        return;
                      }
                      videoController.initializeController(videoFile);
                    },
                    iconData: Icons.photo_camera_back,
                  ),
                ),
              if (showControls)
                Align(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      CustomIconButton(
                        onPressed: () {
                          videoController.reverse();
                        },
                        iconData: Icons.rotate_left,
                      ),
                      CustomIconButton(
                        onPressed: () {
                          videoController.play();
                        },
                        iconData: videoController.value!.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                      ),
                      CustomIconButton(
                        onPressed: () {
                          videoController.forward();
                        },
                        iconData: Icons.rotate_right,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void videoControllerListener() {
    if (mounted) {
      setState(() {});
    }
  }

  Widget renderTimeTextFromDuration(Duration duration) {
    return Text(
      "${duration.inMinutes.toString().padLeft(2, "0")}:${(duration.inSeconds % 60).toString().padLeft(2, "0")}",
      style: TextStyle(color: Colors.white),
    );
  }
}
