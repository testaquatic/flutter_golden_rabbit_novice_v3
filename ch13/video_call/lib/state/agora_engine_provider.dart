import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:video_call/secret/agora.dart';

typedef AgoraEngine = ({RtcEngine engine, int? uid, int? otherUid});

/// agora 엔진을 생성한다.
final agoraEngineProvider =
    AsyncNotifierProvider<AgoraEngineNotifier, AgoraEngine>(
      AgoraEngineNotifier.new,
    );

class AgoraEngineNotifier extends AsyncNotifier<AgoraEngine> {
  @override
  FutureOr<AgoraEngine> build() async {
    // 엔진을 초기화한다.
    final engine = createAgoraRtcEngine();

    int? uid;
    int? otherUid;

    // 사용할 설정을 제공한다.
    await engine.initialize(
      RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
    );

    engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          print("채널에 입장했습니다. uid : ${connection.localUid}");
          uid = connection.localUid;
          state = AsyncValue.data((
            engine: engine,
            uid: uid,
            otherUid: otherUid,
          ));
        },
        onLeaveChannel: (connection, stats) {
          print("채널 퇴장");
          otherUid = null;
          state = AsyncValue.data((
            engine: engine,
            uid: uid,
            otherUid: otherUid,
          ));
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          print("상대가 채널에 입장했습니다. uid : $remoteUid");
          otherUid = remoteUid;
          state = AsyncValue.data((
            engine: engine,
            uid: uid,
            otherUid: otherUid,
          ));
        },
        onUserOffline: (connection, remoteUid, reason) {
          print("상대가 채널에서 나갔습니다. uid : $uid");
          otherUid = null;
          state = AsyncValue.data((
            engine: engine,
            uid: uid,
            otherUid: otherUid,
          ));
        },
      ),
    );

    await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await engine.enableVideo();
    await engine.startPreview();

    await engine.joinChannel(
      token: tempToken,
      channelId: channelName,
      uid: 0,
      options: ChannelMediaOptions(),
    );

    return (engine: engine, uid: null, otherUid: null);
  }
}
