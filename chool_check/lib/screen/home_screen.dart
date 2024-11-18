import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatelessWidget {
  // 지도 초기화 위치
  static const LatLng companyLatLng = LatLng(
    37.5233273, // 위도
    126.921252, // 경도
  );
  // 회사 위치 마커 선언
  static const Marker marker = Marker(
    markerId: MarkerId('company'),
    position: companyLatLng,
  );
  // 현재 위치 반경 표시
  static final Circle circle = Circle(
    circleId: const CircleId('choolCheckCircle'),
    center: companyLatLng, // 원의 중심이 되는 위치. LatLng 값을 제공함.
    fillColor: Colors.blue.withOpacity(0.5), // 원의 색상
    radius: 100, // 원의 반지름(미터 단위)
    strokeColor: Colors.blue, // 원의 테두리 색
    strokeWidth: 1, // 원의 테두리 두께
  );

  // renderAppBar() 함수 아래에 입력하기
  Future<String> checkPermission() async {
    final isLocationEnabled = await Geolocator.isLocationServiceEnabled();
    // 위치 서비스 활성화 여부 확인
    if (!isLocationEnabled) {
      // 위치 서비스 활성화 안 됐을 때
      return '위치 서비스를 활성화해주세요.';
    }

    LocationPermission checkedPermission =
        await Geolocator.checkPermission(); // 위치 권한 확인

    // 위치 권한 거절됨
    if (checkedPermission == LocationPermission.denied) {
      // 위치 권한 요청하기
      checkedPermission = await Geolocator.requestPermission();

      if (checkedPermission == LocationPermission.denied) {
        return '위치 권한을 허가해주세요.';
      }
    }

    // 위치 권한 거절됨 (앱에서 재요청 불가)
    if (checkedPermission == LocationPermission.deniedForever) {
      return '앱의 위치 권한을 설정에서 허가해주세요.';
    }

    // 위 모든 조건이 통과되면 위치 권한 허가 완료
    return '위치 권한이 허가 되었습니다.';
  }

  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppBar(),
      body: FutureBuilder<String>(
        future: checkPermission(),
        builder: (context, snapshot) {
          // 로딩 상태
          if (!snapshot.hasData &&
              snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // 권한 허가된 상태
          if (snapshot.data == '위치 권한이 허가 되었습니다.') {
            return Column(
              children: [
                // 2/3 만큼 공간 차지
                Expanded(
                  flex: 2,
                  child: GoogleMap(
                    // 지도 위치 지정
                    initialCameraPosition: const CameraPosition(
                      target: companyLatLng,
                      zoom: 16, // 확대 정도 (값이 높을수록 크게 보임)
                    ),
                    myLocationEnabled: true, // 내 위치 지도에 보여주기
                    markers: Set.from([marker]), // Set으로 Marker 제공
                    circles: Set.from([circle]), // Set으로 Circle 제공
                  ),
                ),
                // 1/3 만큼 공간 차지
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // 시계 아이콘
                      const Icon(
                        Icons.timelapse_outlined,
                        color: Colors.blue,
                        size: 50.0,
                      ),
                      const SizedBox(height: 20.0),
                      // 출근하기 버튼
                      ElevatedButton(
                        onPressed: () async {
                          final curPosition =
                              await Geolocator.getCurrentPosition(); // 현재 위치
                          final distance = Geolocator.distanceBetween(
                            curPosition.latitude, // 현재 위치 위도
                            curPosition.longitude, // 현재 위치 경도
                            companyLatLng.latitude, // 회사 위치 위도
                            companyLatLng.longitude, // 회사 위치 경도
                          );

                          bool canCheck = distance < 100; // 100미터 이내에 있으면 출근 가능

                          showDialog(
                            // ignore: use_build_context_synchronously
                            context: context,
                            builder: (_) {
                              return AlertDialog(
                                title: const Text('출근하기'),

                                // 출근 가능 여부에 따라 다른 메시지 제공
                                content: Text(
                                  canCheck ? '출근을 하시겠습니까?' : '출근할 수 없는 위치입니다.',
                                ),
                                actions: [
                                  // 취소 버튼
                                  TextButton(
                                    // 취소 버튼 누를 시 false로 반환
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    child: const Text('취소'),
                                  ),
                                  // 출근 가능한 상태일 때만 [출근하기] 버튼 제공
                                  if (canCheck)
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                      child: const Text('출근하기'),
                                    ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text('출근하기!'),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }

          // 권한 없는 상태
          return Center(
            child: Text(
              snapshot.data.toString(),
            ),
          );
        },
      ),
    );
  }
}

AppBar renderAppBar() {
  return AppBar(
    centerTitle: true,
    title: const Text(
      '오늘도 출첵',
      style: TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.w700,
      ),
    ),
    backgroundColor: Colors.white,
  );
}
