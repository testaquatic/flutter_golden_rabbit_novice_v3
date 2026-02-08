import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_call/secret/agora.dart';

/// 영상통화를 담당하는 위젯
class CamScreen extends StatefulWidget {
  const CamScreen({super.key});

  @override
  State<CamScreen> createState() => _CamScreenState();
}

class _CamScreenState extends State<CamScreen> {
  /// 아고라 엔진
  RtcEngine? engine;

  /// 내 ID
  int? uid;

  /// 상대방 ID
  int? otherUid;

  /// 위젯 사용에 필요한 설정을 한다.
  /// ## 카메라와 마이크
  /// 권한 설정을 하지 못하면 오류를 발생시킨다.
  /// ## agora RtcEngine
  /// 아고라 엔진을 초기화한다.
  Future<bool> init() async {
    // 카메라 권한을 요청한다.
    final resp = await [Permission.camera, Permission.microphone].request();

    final cameraPermission = resp[Permission.camera];
    final micPermission = resp[Permission.microphone];

    if (cameraPermission != PermissionStatus.granted ||
        micPermission != PermissionStatus.granted) {
      throw "카메라 또는 마이크 권한이 없습니다.";
    }

    // engine이 null이라면 아고라 엔진을 초기화한다.
    if (engine == null) {
      // agora RtcEngine을 생성한다.
      engine = createAgoraRtcEngine();
      await engine!.initialize(
        RtcEngineContext(
          appId: appID,
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        ),
      );
      //
      engine!.leaveChannel();

      // agora RtcEngine에 이벤트 핸들러를 등록한다.
      engine!.registerEventHandler(
        RtcEngineEventHandler(
          onJoinChannelSuccess: (connection, elapsed) {
            print("채널에 입장했습니다. uid : ${connection.localUid}");
            setState(() {
              uid = connection.localUid;
            });
          },
          onLeaveChannel: (connection, stats) {
            print("채널 퇴장");
            setState(() {
              uid = null;
            });
          },
          onUserJoined: (connection, remoteUid, elapsed) {
            print("상대가 채널에 입장했습니다. uid : $remoteUid");
            setState(() {
              otherUid = remoteUid;
            });
          },
          onUserOffline: (connection, remoteUid, reason) {
            print("상대가 채널에서 나갔습니다. uid : $remoteUid");
            setState(() {
              otherUid = null;
            });
          },
        ),
      );

      // agora RtcEngine을 설정한다.
      await engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
      await engine!.enableVideo();
      await engine!.startPreview();

      // 채널에 입장한다.
      await engine!.joinChannel(
        token: tempToken,
        channelId: channelName,
        options: ChannelMediaOptions(),
        uid: 0,
      );
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("LIVE")),
      body: FutureBuilder(
        future: init(),
        builder: (context, snapshot) {
          // 오류가 있을 때 오류 메시지를 출력한다.
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          // Future가 완료되지 않았을 때 로딩 스피너를 출력한다.
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // 영상 통화 화면을 출력한다.
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    renderMainView(),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Container(
                        color: Colors.grey,
                        height: 160,
                        width: 120,
                        child: renderSubView(),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (engine != null) {
                      await engine!.leaveChannel();
                    }

                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text("채널 나가기"),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// 내 휴대폰의 카메라
  Widget renderSubView() {
    if (uid != null) {
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: engine!,
          canvas: const VideoCanvas(uid: 0),
        ),
      );
    } else {
      return CircularProgressIndicator();
    }
  }

  /// 상대 휴대폰의 카메라
  Widget renderMainView() {
    if (otherUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: engine!,
          canvas: VideoCanvas(uid: otherUid),
          connection: const RtcConnection(channelId: channelName),
        ),
      );
    } else {
      return Center(
        child: Text("다른 사용자가 입장할 때까지 대기해주세요.", textAlign: TextAlign.center),
      );
    }
  }
}
