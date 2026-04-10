import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vid_player/appstate/provider.dart';
import 'package:vid_player/component/custom_video_player.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final video = ref.watch(videoProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      // 동영상을 선택 여부에 따라서 표시하는 위젯이 달라진다.
      body: video.value == null ? renderEmpty() : renderVideo(),
    );
  }

  /// 동영상을 선택하지 않았을 때 표시하는 위젯
  Widget renderEmpty() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: getBoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _Logo(onTap: onNewVideoPressed),
          const SizedBox(height: 30.0),
          _AppName(),
        ],
      ),
    );
  }

  /// 로고를 눌렀을 때 실행하는 콜백
  /// 동영상을 선택한다.
  void onNewVideoPressed() async {
    ref.read(videoProvider.notifier).pickVideo();
  }

  /// renderEmpty
  BoxDecoration getBoxDecoration() {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xff2a3a7c), Color(0xff000118)],
      ),
    );
  }

  /// 동영상을 선택했을 때 표시하는 위젯
  Widget renderVideo() {
    return CustomVideoPlayer();
  }
}

/// 로고 위젯
class _Logo extends StatelessWidget {
  final GestureTapCallback onTap;

  const _Logo({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset("asset/img/logo.png"),
    );
  }
}

/// 앱 이름 위젯
class _AppName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 30.0,
      fontWeight: FontWeight.w300,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("VIDEO", style: textStyle),
        Text("PLAYER", style: textStyle.copyWith(fontWeight: FontWeight.w700)),
      ],
    );
  }
}
