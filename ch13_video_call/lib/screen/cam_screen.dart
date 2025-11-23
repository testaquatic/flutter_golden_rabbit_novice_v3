import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:ch13_video_call/secret/secret.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CamScreen extends StatefulWidget {
  const CamScreen({super.key});

  @override
  State<CamScreen> createState() => _CamScreenState();
}

class _CamScreenState extends State<CamScreen> {
  // 아고라 엔진
  RtcEngine? engine;
  // 내 id
  int? uid;
  // 상대방 id
  int? otherUid;

  Future<bool> init() async {
    final resp = await [Permission.camera, Permission.microphone].request();

    final cameraPermission = resp[Permission.camera];
    final micPermission = resp[Permission.microphone];

    if (cameraPermission != PermissionStatus.granted ||
        micPermission != PermissionStatus.granted) {
      throw "카메라 또는 마이크 권한이 없습니다.";
    }

    // 엔진이 정의되어 있지 않을 때
    if (engine == null) {
      // 새로 정의한다.
      engine = createAgoraRtcEngine();

      // 아고라 엔진을 초기화한다.
      await engine!.initialize(
        RtcEngineContext(
          appId: APP_ID,
          // 라이브 동영상 송출
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        ),
      );

      engine!.registerEventHandler(
        RtcEngineEventHandler(
          // 채널 접속에 성공했을 때
          onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
            print("채널에 입장했습니다. uid: ${connection.localUid}");
            setState(() {
              uid = connection.localUid;
            });
          },
          // 채널을 퇴장했을 때
          onLeaveChannel: (RtcConnection connection, RtcStats stats) {
            print("채널 퇴장");
            setState(() {
              uid = null;
            });
          },
          // 다른 사용자가 접속했을 때
          onUserJoined: (connection, remoteUid, elapsed) {
            print("상대가 채널에 입장했습니다. uid: $remoteUid");
            setState(() {
              otherUid = remoteUid;
            });
          },
          // 다른 사용자가 채널을 나갔을 때
          onUserOffline: (connection, remoteUid, reason) {
            setState(() {
              otherUid = null;
            });
          },
        ),
      );
    }

    // 엔진으로 영상을 송출한다.
    await engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    // 동영상 기능을 활성하한다.
    await engine!.enableVideo();
    // 카메라를 이용해 동영상을 표시한다.
    await engine!.joinChannel(
      token: TEMP_TOKEN,
      channelId: CHANNEL_NAME,
      uid: 0,
      options: ChannelMediaOptions(),
    );

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("LIVE")),
      body: FutureBuilder(
        future: init(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // Future 실행 후 에러가 있을 때
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          // Future 실행 후 아직 데이터가 없을 때 (로딩 표시)
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    // 상대방
                    renderMainView(),
                    // 나
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

  // 내 핸드폰이 찍는 화면 표시
  Widget renderSubView() {
    if (uid != null) {
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: engine!,
          // 내 영상을 보여준다.
          canvas: const VideoCanvas(uid: 0),
        ),
      );
    } else {
      // 아직 내가 채널에 접속하지 않았다면 로딩 화면을 보여준다.
      return CircularProgressIndicator();
    }
  }

  // 상대 휴대폰이 보내는 화면 표시
  Widget renderMainView() {
    if (otherUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: engine!,
          canvas: VideoCanvas(uid: otherUid),
          connection: const RtcConnection(channelId: CHANNEL_NAME),
        ),
      );
    } else {
      // 생대가 아직 채널에 들어오지 않았다면 대기 메시지를 표시한다.
      return Center(
        child: const Text(
          "다른 사용자가 입장할 때까지 대기해주세요.",
          textAlign: TextAlign.center,
        ),
      );
    }
  }
}
