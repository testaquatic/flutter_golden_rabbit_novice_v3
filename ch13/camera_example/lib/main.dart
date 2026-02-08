import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

late List<CameraDescription> _cameras;

Future<void> main() async {
  // 플러터 앱이 실행 준비 되었는지 확인
  WidgetsFlutterBinding.ensureInitialized();

  // 카메라 리스트 불러오기
  _cameras = await availableCameras();

  runApp(const CameraApp());
}

/// 카메라를 사용하는 위젯
class CameraApp extends StatefulWidget {
  const CameraApp({super.key});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  // 카메라를 조정하는 컨트롤러
  late CameraController cameraController;

  @override
  void initState() {
    super.initState();

    initializeCamera();
  }

  // 카메라를 초기화한다.
  void initializeCamera() async {
    try {
      // 첫번째 카메라로 설정
      cameraController = CameraController(_cameras[0], ResolutionPreset.max);

      // 카메라 조기화
      await cameraController.initialize();

      setState(() {});
    } catch (e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print("User denied camera access.");
            break;
          default:
            print("Handle other errors.");
            break;
        }
      }
    }
  }

  @override
  void dispose() {
    // 컨트롤러 해제
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 컨트롤러가 초기화되지 않았을 때의 처리
    if (!cameraController.value.isInitialized) {
      return Container();
    }
    return MaterialApp(home: CameraPreview(cameraController));
  }
}
