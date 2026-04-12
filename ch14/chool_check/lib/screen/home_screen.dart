import 'package:chool_check/secret/company.dart';
import 'package:chool_check/state/location_permission.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// 가장 먼저 나타나는 홈화면이다.
/// 이 위젯은 상단에 앱바, 중간에 구글 지도, 하단에 출석체크를 진행하는 버튼이 위치한다.
class HomeScreen extends ConsumerWidget {
  // 회사 위치 설정
  static final LatLng companyLatLng = latLng;
  static final Marker marker = Marker(
    markerId: const MarkerId("choolCheckMarker"),
    position: companyLatLng,
  );
  static final Circle circle = Circle(
    circleId: CircleId("choolCheckCircle"),
    center: companyLatLng,
    radius: 100,
    strokeColor: Colors.blue,
    strokeWidth: 1,
  );

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationPermission = ref.watch(locationPermissionProvider);

    return Scaffold(
      appBar: renderAppBar(),
      body: locationPermission.when(
        // 로딩상태
        loading: () => const Center(child: CircularProgressIndicator()),
        // 오류가 발생했을 때
        error: (err, stack) => Center(child: Text(err.toString())),
        // 권한이 설정된 경우
        data: (isGranted) {
          // 권한이 허가됐을 때
          if (isGranted == "위치 권한이 허가되었습니다.") {
            return Column(
              children: [
                // 구글맵
                // 앱바를 제외한 화면의 2/3를 차지한다.
                Expanded(
                  flex: 2,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: companyLatLng,
                      zoom: 16.0,
                    ),
                    markers: {marker},
                    circles: {circle},
                  ),
                ),
                // 출석체크 버튼
                // 앱바를 제외한 화면의 1/3를 차지한다.
                // 출석 체크 버튼을 누르면 다이얼로그가 나타난다.
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.timelapse_outlined,
                        color: Colors.blue,
                        size: 50.0,
                      ),
                      const SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () async {
                          final curPosition =
                              await Geolocator.getCurrentPosition();
                          final distance = Geolocator.distanceBetween(
                            curPosition.latitude,
                            curPosition.longitude,
                            companyLatLng.latitude,
                            companyLatLng.longitude,
                          );

                          bool canCheck = distance <= 100;

                          if (context.mounted) {
                            showDialog(
                              context: context,
                              builder: (_) {
                                return AlertDialog(
                                  content: Text(
                                    canCheck
                                        ? "출근을 하시겠습니까?"
                                        : "출근할 수 없는 위치입니다.",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: const Text("취소"),
                                    ),
                                    if (canCheck)
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(true);
                                        },
                                        child: const Text("출근하기"),
                                      ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        child: const Text("출근하기!"),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
          // 권한이 허가되지 않았을 때
          return Center(child: Text(isGranted));
        },
      ),
    );
  }
}

/// 앱바를 출력한다.
AppBar renderAppBar() {
  return AppBar(
    centerTitle: true,
    title: const Text(
      "오늘도 출첵",
      style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w700),
    ),
    backgroundColor: Colors.white,
  );
}
