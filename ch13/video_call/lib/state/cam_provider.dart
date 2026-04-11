import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

final permissionProvider = FutureProvider<bool>((ref) async {
  final resp = await [Permission.camera, Permission.microphone].request();

  final cameraPermission = resp[Permission.camera];
  final microphonePermission = resp[Permission.microphone];

  if (cameraPermission != PermissionStatus.granted ||
      microphonePermission != PermissionStatus.granted) {
    throw "카메라 또는 마이크 권한이 없습니다.";
  }

  return true;
});
