import 'package:ch12_vid_player/component/custom_video_player.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  // 동영상을 저장할 변수
  XFile? video;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // 동영상 선택에 따라서 보여줄 위젯
      body: video == null ? renderEmpty() : renderVideo(),
    );
  }

  Widget renderEmpty() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: getBoxDecoration(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 로고 이미지
          _Logo(onTab: onNewVideoPressed),
          SizedBox(height: 30.0),
          // 앱 이름
          _AppName(),
        ],
      ),
    );
  }

  // 이미지를 선택한다.
  void onNewVideoPressed() async {
    final video = await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (video != null) {
      setState(() {
        this.video = video;
      });
    }
  }

  BoxDecoration getBoxDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xff_2a3a7c), Color(0xff_000118)],
      ),
    );
  }

  Widget renderVideo() {
    return Center(
      child: CustomVideoPlayer(
        video: video!,
        onNewVidioPressed: onNewVideoPressed,
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  final GestureTapCallback onTab;
  const _Logo({required this.onTab});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTab,
      child: Image.asset("asset/img/logo.png"),
    );
  }
}

class _AppName extends StatelessWidget {
  const _AppName();

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
        Text(
          "PLAYER",
          style: textStyle.copyWith(
            // 글자 굵기만 변경
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
