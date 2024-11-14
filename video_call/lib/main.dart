import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:video_call/screen/home_screen.dart';

late List<CameraDescription> _cameras;

// Future, async, await: camera 패키지 사용으로 핸드폰에 있는 카메라들 가져오기 위해 비동기 사용
// Future<void> main() async {
//   WidgetsFlutterBinding.ensureInitialized();

//   // 핸드폰에 있는 카메라들 가져오기
//   _cameras = await availableCameras();
//   runApp(const CameraApp());
// }

void main() {
  runApp(
    const MaterialApp(
      home: HomeScreen(),
    ),
  );
}

class CameraApp extends StatefulWidget {
  const CameraApp({super.key});

  @override
  State<CameraApp> createState() => _CameraAppState();
}

class _CameraAppState extends State<CameraApp> {
  // 카메라를 제어할 수 있는 컨트롤러 선언
  late CameraController controller;

  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  initializeCamera() async {
    try {
      // 가장 첫 번째 카메라로 카메라 실행하기, 카메라 제어(가장 첫 번째 카메라, 비디오 녹화와 이미지 캡쳐의 품질 효과-max)
      controller = CameraController(_cameras[0], ResolutionPreset.max);

      // 카메라 초기화
      await controller.initialize();

      setState(() {});
    } catch (e) {
      // 에러났을 때 출력
      if (e is CameraException) {
        // switch 조건문 - 에러 코드에 따른 조건
        switch (e.code) {
          // 카메라 접근 거부 시
          case 'CameraAccessDenied':
            print('User denied camera access');
            break;
          // 나머지 에러
          default:
            print('Handle other errors.');
            break;
        }
      }
    }
  }

  @override
  void dispose() {
    // 컨트롤러 삭제
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 카메라 초기화가 완료된 상태인지 확인
    if (!controller.value.isInitialized) {
      return Container();
    }
    return MaterialApp(
      // CameraPreview 위젯으로 카메라를 화면에 보여주기
      home: CameraPreview(controller),
    );
  }
}
