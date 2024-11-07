import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// 동영상 위젯 생성
class CustomVideoPlayer extends StatefulWidget {
  // 선택한 동영상을 저장할 변수
  // XFile은 ImagePicker로 영상 또는 이미지를 선택했을 때 반환하는 타입
  final XFile video;

  const CustomVideoPlayer({
    super.key,
    required this.video, // 상위에서 서택한 동영상 주입해주기
  });

  @override
  State<CustomVideoPlayer> createState() => _CustomVideoPlayerState();
}

class _CustomVideoPlayerState extends State<CustomVideoPlayer> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'CustomVideoPlayer', // 샘플 텍스트
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }
}
