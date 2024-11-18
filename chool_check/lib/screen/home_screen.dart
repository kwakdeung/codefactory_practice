import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatelessWidget {
  // 지도 초기화 위치
  static const LatLng companyLatLng = LatLng(
    37.5233273, // 위도
    126.921252, // 경도
  );
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: renderAppBar(),
      body: const GoogleMap(
        // 지도 위치 지정
        initialCameraPosition: CameraPosition(
          target: companyLatLng,
          zoom: 16, // 확대 정도 (값이 높을수록 크게 보임)
        ),
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
