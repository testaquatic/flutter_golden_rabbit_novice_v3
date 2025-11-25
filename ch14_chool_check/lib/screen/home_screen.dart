import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatelessWidget {
  // 지도 초기화 위치
  static final LatLng companyLatLng = LatLng(37.5233273, 126.921252);

  // 회사 위치 마커
  static final Marker marker = Marker(
    markerId: MarkerId("company"),
    position: companyLatLng,
  );
  static final Circle circle = Circle(
    circleId: CircleId("choolCheckCircle"),
    center: companyLatLng,
    fillColor: Colors.blue.withAlpha(127),
    radius: 100,
    strokeColor: Colors.blue,
    strokeWidth: 1,
  );

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppBar(),
      body: FutureBuilder(
        future: checkPermission(),
        builder: (context, snapshot) {
          // 로딩 상태
          if (!snapshot.hasData &&
              snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          // 권한이 허가된 상태
          if (snapshot.data == "위치 권한이 허가 되었습니다.") {
            return Column(
              children: [
                Expanded(
                  // 2/3만큼 공간 차지
                  flex: 2,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: companyLatLng,
                      // 확대 정도
                      zoom: 16,
                    ),
                    // 현재 위치를 지도에 표시한다.
                    myLocationEnabled: true,
                    markers: {marker},
                    circles: {circle},
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 시계 아이콘
                      Icon(
                        Icons.timelapse_outlined,
                        color: Colors.blue,
                        size: 50.0,
                      ),
                      // 여백
                      const SizedBox(height: 20.0),
                      // 출근하기 버튼
                      ElevatedButton(
                        onPressed: () async {
                          // 현재 위치
                          final curPosition =
                              await Geolocator.getCurrentPosition();
                          // 거리
                          final distance = Geolocator.distanceBetween(
                            curPosition.latitude,
                            curPosition.longitude,
                            companyLatLng.latitude,
                            companyLatLng.longitude,
                          );

                          // 100m 이내에 있으면 출근 가능
                          bool canCheck = distance <= 100;

                          if (!context.mounted) {
                            return;
                          }

                          showDialog(
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: Text("출근하기"),
                                content: Text(
                                  canCheck ? "출근을 하기겠습니까?" : "출근할 수 없는 위치입니다.",
                                ),
                                actions: [
                                  // 취소 버튼
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    child: Text("취소"),
                                  ),

                                  // 출근하기 버튼
                                  // 출근 가능한 상태일 때만 표시된다.
                                  if (canCheck)
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                      child: Text("출근하기"),
                                    ),
                                ],
                              );
                            },
                          );
                        },
                        child: Text("출근하기!"),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          // 권한이 없는 상태
          return Center(child: Text(snapshot.data.toString()));
        },
      ),
    );
  }

  // 앱바를 구성한다.
  AppBar renderAppBar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        "오늘도 출첵",
        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w700),
      ),
      backgroundColor: Colors.white,
    );
  }

  Future<String> checkPermission() async {
    // 위치 서비스가 활성화 되었는지 확인
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnabled) {
      return "위치 서비스를 활성화해주세요.";
    }

    // 위치 권한 확인
    LocationPermission checkPermission = await Geolocator.checkPermission();
    if (checkPermission == LocationPermission.denied) {
      checkPermission = await Geolocator.requestPermission();
      if (checkPermission == LocationPermission.denied) {
        return "위치 권한을 허가해주세요.";
      }
    }

    // 위치 권한 거절됨(앱에서 재요청 불가)
    if (checkPermission == LocationPermission.deniedForever) {
      return "앱의 위치 권한을 설정에서 허가해주세요.";
    }

    // 위치 권한 허가됨
    return "위치 권한이 허가 되었습니다.";
  }
}
