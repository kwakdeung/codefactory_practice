import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

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
  // 동영상을 조작하는 컨트롤러
  VideoPlayerController? videoController;

  @override
  void initState() {
    super.initState();

    initializeController(); // 컨트롤러 초기화
  }

  // 선택한 동영상으로 컨트롤러 초기화
  initializeController() async {
    final videoController = VideoPlayerController.file(
      File(widget.video.path),
    );

    await videoController.initialize();

    setState(() {
      this.videoController = videoController;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 동영상 컨트롤러가 준비 중일 때 로딩 표시
    if (videoController == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    // AspectRatio - 동영상 비율에 따른 화면 렌더링, 자식 위젯을 특정한 비율로 만듦
    return AspectRatio(
      aspectRatio: videoController!.value.aspectRatio,
      child: Stack(
        // children 위젯을 위로 쌓을 수 있는 위젯 - List에 입력 되는 순서대로
        children: [
          VideoPlayer(
            // child 위젯의 위치를 정할 수 있는 위젯
            videoController!,
          ),
          Positioned(
            // 위치값
            bottom: 0,
            right: 0,
            left: 0,
            child: Slider(
              // 동영상 재생 상태를 보여주는 슬라이더
              onChanged: (double val) {
                // seekTo() - 동영상의 재생 위치를 변경 할 수 있게 함으로써 재생 위치를 특정 위치로 이동해줌
                videoController!.seekTo(
                  Duration(seconds: val.toInt()),
                );
              },
              // 동영상 재생 위치(position)를 초 단위(inSeconds.toDouble())로 표현
              // position.inSeconds getter를 사용하면 현재 동영상이 실행되고 있는 위치를 받을 수 있음
              value: videoController!.value.position.inSeconds.toDouble(),
              min: 0, // Slider 위젯의 min 값은 항상 0 -> 동영상의 시작은 항상 0초부터 시작하기 때문
              max: videoController!.value.duration.inSeconds
                  .toDouble(), // Duration으로 동영상 전체 길이를 받아와 inSeconds으로 전체 길이를 초(seconds)로 변환
            ),
          )
        ],
      ),
    );
  }
}
