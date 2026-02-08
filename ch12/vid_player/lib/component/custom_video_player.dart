// 동영상 위젯
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vid_player/component/custom_icon_button.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  // 선택한 동영상
  final XFile video;

  // 새로운 동영상을 선택하면 실행하는 함수
  final GestureTapCallback onNewVideoPressed;

  const CustomVideoPlayer({
    required this.video,
    required this.onNewVideoPressed,
    super.key,
  });

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  // 동영상 컨트롤러
  VideoPlayerController? videoPlayerController;

  // 동영상 조작 버튼의 표시 여부
  bool showControls = false;

  @override
  void initState() {
    super.initState();

    initializeController();
  }

  // 동영상 컨트롤러 초기화
  void initializeController() async {
    final videoController = VideoPlayerController.file(File(widget.video.path));

    await videoController.initialize();

    // 컨트롤러의 속성이 변경될 때마다 실행할 콜백 등록
    videoController.addListener(videoPlayerControllerListener);

    setState(() {
      videoPlayerController = videoController;
    });
  }

  // 컨트롤러의 속성이 변경될 때마다 실행하는 함수
  void videoPlayerControllerListener() {
    setState(() {});
  }

  @override
  void didUpdateWidget(covariant CustomVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.video.path != widget.video.path) {
      videoPlayerController?.pause();
      initializeController();
    }
  }

  @override
  void dispose() {
    videoPlayerController?.removeListener(videoPlayerControllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (videoPlayerController == null) {
      return Center(child: CircularProgressIndicator());
    }

    // 이 아래로 videoPlayerController는 null이 아니다.

    return GestureDetector(
      onTap: () {
        setState(() {
          showControls = !showControls;
        });
      },

      child: AspectRatio(
        aspectRatio: videoPlayerController!.value.aspectRatio,
        child: Stack(
          children: [
            // 동영상
            VideoPlayer(videoPlayerController!),
            // 아이콘 버튼이 표시됐을 때 화면이 어두워진다.
            if (showControls) Container(color: Colors.black.withAlpha(127)),
            // 하단 슬라이더
            if (showControls)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    children: [
                      // 동영상 현재 위치
                      renderTimeFromDuration(
                        videoPlayerController!.value.position,
                      ),
                      // 슬라이더
                      Expanded(
                        child: Slider(
                          value: videoPlayerController!.value.position.inSeconds
                              .toDouble(),
                          min: 0,
                          max: videoPlayerController!.value.duration.inSeconds
                              .toDouble(),
                          onChanged: (val) {
                            videoPlayerController!.seekTo(
                              Duration(seconds: val.toInt()),
                            );
                          },
                        ),
                      ),
                      // 동영상 전체 길이
                      renderTimeFromDuration(
                        videoPlayerController!.value.duration,
                      ),
                    ],
                  ),
                ),
              ),

            // 새 동영상 선택 버튼
            if (showControls)
              Align(
                alignment: Alignment.topRight,
                child: CustomIconButton(
                  onPressed: widget.onNewVideoPressed,
                  iconData: Icons.photo_camera_back,
                ),
              ),
            // 동영상 컨트롤 버튼
            if (showControls)
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // 뒤로 감기 버튼
                    CustomIconButton(
                      onPressed: onReversePressed,
                      iconData: Icons.rotate_left,
                    ),
                    // 재생 버튼
                    CustomIconButton(
                      onPressed: onPlayPressed,
                      iconData: videoPlayerController!.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                    // 앞으로 감기 버튼
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

  // 되감기 버튼을 눌렀을 때 실행하는 콜백
  // 3초 앞으로 간다.
  void onReversePressed() {
    final currentPosition = videoPlayerController!.value.position;

    var position = Duration();

    if (currentPosition.inSeconds > 3) {
      position = currentPosition - Duration(seconds: 3);
    }
    videoPlayerController!.seekTo(position);
  }

  // 앞으로 감기 버튼을 눌렀을 때 실행하는 콜백
  // 3초 뒤로 간다.
  void onForwardPressed() {
    final maxPosition = videoPlayerController!.value.duration;
    final currentPosition = videoPlayerController!.value.position;

    var position = maxPosition;
    if (maxPosition.inSeconds - currentPosition.inSeconds > 3) {
      position = currentPosition + Duration(seconds: 3);
    }
    videoPlayerController!.seekTo(position);
  }

  // 재생/중지 버튼을 눌렀을 때 실행하는 콜백
  void onPlayPressed() {
    if (videoPlayerController!.value.isPlaying) {
      videoPlayerController!.pause();
    } else {
      videoPlayerController!.play();
    }
  }

  Widget renderTimeFromDuration(Duration duration) {
    return Text(
      "${duration.inDays.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, "0")}",
      style: TextStyle(color: Colors.white, fontSize: 12.0),
    );
  }
}
