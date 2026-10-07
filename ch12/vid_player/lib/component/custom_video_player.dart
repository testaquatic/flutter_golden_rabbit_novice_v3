import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vid_player/component/custom_icon_button.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  final XFile video;
  final GestureTapCallback onNewVideoPressed;

  const CustomVideoPlayer({
    super.key,
    required this.video,
    required this.onNewVideoPressed,
  });

  @override
  State<CustomVideoPlayer> createState() {
    return _CustomVideoPlayerState();
  }
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  VideoPlayerController? videoPlayerController;
  bool showControls = false;

  @override
  void initState() {
    super.initState();

    initializeController();
  }

  void initializeController() async {
    final videoController = VideoPlayerController.file(File(widget.video.path));

    await videoController.initialize();

    videoController.addListener(videoControllerListener);

    setState(() {
      videoPlayerController = videoController;
    });
  }

  void videoControllerListener() {
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant CustomVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.video.path != widget.video.path) {
      videoPlayerController!.pause().then((_) => initializeController());
    }
  }

  @override
  void dispose() {
    videoPlayerController?.removeListener(videoControllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (videoPlayerController == null) {
      return Center(child: CircularProgressIndicator());
    }

    return GestureDetector(
      onTap: () {
        setState(() {
          showControls = !showControls;
        });
      },

      child:
          // 동영상 화면
          AspectRatio(
            aspectRatio: videoPlayerController!.value.aspectRatio,
            child: Stack(
              children: [
                // 재생화면
                VideoPlayer(videoPlayerController!),
                // 아이콘 버튼을 표시하면 화면이 어두워 짐
                if (showControls) Container(color: Colors.black.withAlpha(127)),
                // 하단의 재생시간
                Positioned(
                  bottom: 0,
                  right: 0,
                  left: 0,
                  child: Padding(
                    padding: EdgeInsetsGeometry.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        renderTimeTextFromDuration(
                          videoPlayerController!.value.position,
                        ),
                        Expanded(
                          child: Slider(
                            value: videoPlayerController!
                                .value
                                .position
                                .inSeconds
                                .toDouble(),
                            min: 0,
                            max: videoPlayerController!.value.duration.inSeconds
                                .toDouble(),
                            onChanged: (value) {
                              videoPlayerController!.seekTo(
                                Duration(seconds: value.toInt()),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // 오른쪽 상단의 선택 버튼
                if (showControls)
                  Align(
                    alignment: Alignment.topRight,
                    child: CustomIconButton(
                      onPressed: widget.onNewVideoPressed,
                      iconData: Icons.photo_camera_back,
                    ),
                  ),
                // 화면 중앙의 동영상 컨트롤 버튼
                if (showControls)
                  Align(
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // 뒤로가기 버튼
                        CustomIconButton(
                          onPressed: onReversePressed,
                          iconData: Icons.rotate_left,
                        ),
                        // 재생/중단 버튼
                        CustomIconButton(
                          onPressed: onPlayPressed,
                          iconData: videoPlayerController!.value.isPlaying
                              ? Icons.pause
                              : Icons.play_arrow,
                        ),
                        // 앞으로 가기 버튼
                        CustomIconButton(
                          onPressed: onForwardPressed,
                          iconData: Icons.rotate_right,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
    );
  }

  Widget renderTimeTextFromDuration(Duration duration) {
    return Text(
      "${duration.inMinutes.toString().padLeft(2, "0")}: ${(duration.inSeconds % 60).toString().padLeft(2, "0")}",
      style: TextStyle(color: Colors.white),
    );
  }

  void onReversePressed() {
    final currentPosition = videoPlayerController!.value.position;

    Duration position = Duration();
    if (currentPosition.inSeconds > 3) {
      position = currentPosition - Duration(seconds: 3);
    }

    videoPlayerController!.seekTo(position);
  }

  void onForwardPressed() {
    final maxPosition = videoPlayerController!.value.duration;
    final currentPosition = videoPlayerController!.value.position;

    Duration position = maxPosition;
    if (maxPosition.inSeconds - currentPosition.inSeconds > 3) {
      position = currentPosition + Duration(seconds: 3);
    }

    videoPlayerController!.seekTo(position);
  }

  void onPlayPressed() {
    if (videoPlayerController!.value.isPlaying) {
      videoPlayerController!.pause();
    } else {
      videoPlayerController!.play();
    }
  }
}
