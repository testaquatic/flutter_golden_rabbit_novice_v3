import 'package:geolocator/geolocator.dart';
import 'package:riverpod/riverpod.dart';

final locationPermissionProvider = FutureProvider<String>((ref) async {
  // 위치 서비스 활성화 여부 확인
  final isLocationEnabled = await Geolocator.isLocationServiceEnabled();

  if (!isLocationEnabled) {
    return "위치 서비스를 활성화해주세요.";
  }

  // 위치 권한 확인
  LocationPermission checkedPermission = await Geolocator.checkPermission();
  if (checkedPermission == LocationPermission.denied) {
    checkedPermission = await Geolocator.requestPermission();
    if (checkedPermission == LocationPermission.denied) {
      return "위치 권한을 허가해주세요.";
    }
  }
  if (checkedPermission == LocationPermission.deniedForever) {
    return "앱의 위치 권한을 설정에서 허가해주세요.";
  }

  return "위치 권한이 허가되었습니다.";
});
