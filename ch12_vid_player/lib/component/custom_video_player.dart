// 동영상 위젯
import 'dart:io';

import 'package:ch12_vid_player/component/custom_icon_button.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class CustomVideoPlayer extends StatefulWidget {
  // 선택한 동영상
  final XFile video;

  // 새로운 동영상을 선택하면 실행되는 함수
  final GestureTapCallback onNewVidioPressed;

  const CustomVideoPlayer({
    required this.video,
    required this.onNewVidioPressed,
    super.key,
  });

  @override
  State<StatefulWidget> createState() {
    return _CustomVideoPlayerState();
  }
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  // 동영상을 조작하는 오버레이를 보일지 여부
  bool showControls = false;
  // 동영상을 조작하는 컨트롤러
  VideoPlayerController? videoController;

  @override
  void didUpdateWidget(covariant CustomVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 선택한 동영상이 같은 동영상인지 확인한다.
    if (oldWidget.video.path != widget.video.path) {
      initializeController();
    }
  }

  @override
  void initState() {
    // 컨트롤러 초기화
    initializeController();

    super.initState();
  }

  dynamic initializeController() async {
    final videoController = VideoPlayerController.file(File(widget.video.path));

    await videoController.initialize();

    // 컨트롤러의 속성이 변경될 때마다 실행할 함수 등록
    videoController.addListener(videoControllerListener);

    setState(() {
      this.videoController = videoController;
    });
  }

  // 동영상의 재생 상태가 변경될 때마다 실행되는 함수
  void videoControllerListener() {
    setState(() {});
  }

  // State가 페기될 때 같이 폐기할 함수들
  @override
  void dispose() {
    videoController?.removeListener(videoControllerListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 동영상 컨트롤러가 준비중일 때
    if (videoController == null) {
      // 로딩 표시
      return Center(child: CircularProgressIndicator());
    }

    // 동영상 비율에 따른 화면 렌더링
    return GestureDetector(
      onTap: () {
        setState(() {
          showControls = !showControls;
        });
      },
      child: AspectRatio(
        aspectRatio: videoController!.value.aspectRatio,
        child: Stack(
          children: [
            VideoPlayer(videoController!),
            // 아이콘 버튼이 보일 때 화면을 어둡게 변경
            if (showControls) Container(color: Colors.black.withAlpha(127)),
            Positioned(
              bottom: 0,
              right: 0,
              left: 0,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    renderTimeTextFromDuration(videoController!.value.position),
                    Expanded(
                      child: Slider(
                        // 동영상 재상 위치를 초 단위로 표현
                        value: videoController!.value.position.inSeconds
                            .toDouble(),
                        min: 0,
                        max: videoController!.value.duration.inSeconds
                            .toDouble(),
                        onChanged: (double val) {
                          videoController!.seekTo(
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
                // 카메라 아이콘을 선택하면 새로운 동영상 선택 함수 실행
                child: CustomIconButton(
                  onPressed: widget.onNewVidioPressed,
                  iconData: Icons.photo_camera_back,
                ),
              ),
            if (showControls)
              // 동영상 컨트롤 버튼
              Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // 3초 뒤로 버튼
                    CustomIconButton(
                      onPressed: onReversePressed,
                      iconData: Icons.rotate_left,
                    ),
                    // 재생/중지 버튼
                    CustomIconButton(
                      onPressed: onPlayPressed,
                      iconData: videoController!.value.isPlaying
                          ? Icons.pause
                          : Icons.play_arrow,
                    ),
                    // 3초 앞으로 버튼
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
      '${duration.inMinutes.toString().padLeft(2, "0")}: ${(duration.inSeconds % 60).toString().padLeft(2, "0")}',
      style: TextStyle(color: Colors.white),
    );
  }

  // 되감기 버튼을 눌렀을 때 실행하는 콜백
  void onReversePressed() {
    final currentPosition = videoController!.value.position;

    // 0초로 재생 위치 설정
    Duration position = Duration();

    // 현재 실행 위치가 3초보다 길 때 3초 빼기
    if (currentPosition.inSeconds > 3) {
      position = currentPosition - Duration(seconds: 3);
    }

    videoController!.seekTo(position);
  }

  // 앞으로 감기 버튼을 눌렀을 때 실행하는 콜백
  void onForwardPressed() {
    // 동영상의 길이
    final maxPosition = videoController!.value.duration;
    final currentPosition = videoController!.value.position;

    // 동영상의 길이로 실행 위치 초기화
    Duration position = maxPosition;

    // 동영상의 길이에서 3초를 뺀 값보다 현재 위치가 짧을 때만 3초 더하기
    if ((maxPosition - Duration(seconds: 3)).inSeconds >
        currentPosition.inSeconds) {
      position = currentPosition + Duration(seconds: 3);
    }

    videoController!.seekTo(position);
  }

  // 재생 버튼을 눌렀을 때 실행하는 콜백
  void onPlayPressed() {
    if (videoController!.value.isPlaying) {
      videoController!.pause();
    } else {
      videoController!.play();
    }
  }
}
