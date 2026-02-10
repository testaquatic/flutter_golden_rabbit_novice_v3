import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatelessWidget {
  /// 회사의 좌표
  static final LatLng companyLatLng = LatLng(37.5233273, 126.921252);

  /// 구글맵용 회사 마커
  static final marker = Marker(
    markerId: MarkerId("company"),
    position: companyLatLng,
  );

  static final circle = Circle(
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
        builder: (context, asyncSnapshot) {
          // Future가 이행되지 않았을 때
          if (!asyncSnapshot.hasData &&
              asyncSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // 권한을 받았을 때
          if (asyncSnapshot.data == "위치 권한이 허가되었습니다.") {
            return Column(
              children: [
                // 구글 지도 표시
                Expanded(
                  flex: 2,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: companyLatLng,
                      zoom: 16,
                    ),
                    myLocationEnabled: true,
                    markers: {marker},
                    circles: {circle},
                  ),
                ),
                // 출근 버튼 표시
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 시계 아이콘
                      Icon(
                        Icons.timelapse_outlined,
                        color: Colors.blue,
                        size: 50,
                      ),
                      // 출근하기 버튼
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

                          final canCheck = distance < 100;

                          if (context.mounted) {
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text("출근하기"),
                                content: Text(
                                  canCheck ? "출근을 하시겠습니까?" : "출근할 수 없는 위치입니다.",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    child: Text("취소"),
                                  ),
                                  if (canCheck)
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                      child: Text("출근하기"),
                                    ),
                                ],
                              ),
                            );
                          }
                        },
                        child: Text("출근하기!"),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          // 권한을 받지 못했을 때
          return Center(child: Text(asyncSnapshot.data.toString()));
        },
      ),
    );
  }

  /// 앱바
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

  /// 위치 권한을 확인한다.
  /// 모든 권한이 허가되면 "위치 권한이 허가되었습니다."를 반환한다.
  /// 오류가 있다면 관련한 문자열을 반환한다.
  Future<String> checkPermission() async {
    // 위치 서비스를 확인한다.
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    if (!isLocationEnabled) {
      return "위치 서비스를 활성화해주세요.";
    }

    // 위치 권한을 확인한다.
    var checkedPermission = await Geolocator.checkPermission();
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
  }
}
