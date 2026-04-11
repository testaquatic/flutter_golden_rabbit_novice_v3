import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:video_call/secret/agora.dart';
import 'package:video_call/state/agora_engine_provider.dart';
import 'package:video_call/state/cam_provider.dart';

/// 카메라 화면
class CamScreen extends ConsumerWidget {
  const CamScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permission = ref.watch(permissionProvider);
    final agoraEngine = ref.watch(agoraEngineProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('LIVE')),
      body: permission.when(
        data: (data) => SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    // 상대방이 전송하는 화면
                    renderMainView(ref),
                    // 내 휴대폰이 찍는 화면
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        color: Colors.grey,
                        height: 160,
                        width: 120,
                        child: renderSubview(ref),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    agoraEngine.whenData((data) async {
                      await data.engine.leaveChannel();
                      if (context.mounted) {
                        context.pop();
                      }
                    });
                  },
                  child: const Text("채널 나가기"),
                ),
              ),
            ],
          ),
        ),
        error: (error, stack) => Center(child: Text(error.toString())),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  /// 내 휴대폰이 찍는 화면 렌더링
  Widget renderSubview(WidgetRef ref) {
    final agoraEngine = ref.watch(agoraEngineProvider);

    return agoraEngine.when(
      data: (data) {
        if (data.uid != null) {
          return AgoraVideoView(
            controller: VideoViewController(
              rtcEngine: data.engine,
              // 0을 입력하면 내 영상을 볼 수 있다.
              canvas: const VideoCanvas(uid: 0),
            ),
          );
        } else {
          // 아직 채널에 입장하지 않은 상태이다.
          return Column(
            children: [CircularProgressIndicator(), Text(data.uid.toString())],
          );
        }
      },
      error: (error, stack) => Center(child: Text(error.toString())),
      loading: () => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircularProgressIndicator(),
          SizedBox(height: 16.0),
          Text("채널에 입장할 때까지 기다려주세요."),
        ],
      ),
    );
  }

  /// 상대 휴대폰이 전송한 화면을 렌더링
  Widget renderMainView(WidgetRef ref) {
    final agoraEngine = ref.watch(agoraEngineProvider);

    return agoraEngine.when(
      data: (data) {
        if (data.otherUid != null) {
          return AgoraVideoView(
            controller: VideoViewController.remote(
              rtcEngine: data.engine,
              canvas: VideoCanvas(uid: data.otherUid),
              connection: const RtcConnection(channelId: channelName),
            ),
          );
        } else {
          // 상대가 채널에 입장하지 않은 상태이다.
          // 대기 메시지를 표시한다.
          return const Center(
            child: Text("다른 사용자가 입장할 때까지 대기해주세요.", textAlign: TextAlign.center),
          );
        }
      },
      error: (error, stack) => Center(child: Text(error.toString())),
      loading: () => const CircularProgressIndicator(),
    );
  }
}
