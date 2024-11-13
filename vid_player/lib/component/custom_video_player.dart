import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vid_player/component/custom_icon_button.dart';
import 'package:video_player/video_player.dart';

// 동영상 위젯 생성
class CustomVideoPlayer extends StatefulWidget {
  // 선택한 동영상을 저장할 변수
  // XFile은 ImagePicker로 영상 또는 이미지를 선택했을 때 반환하는 타입
  final XFile video;

  // 새로운 동영상을 선택하면 실행되는 함수
  final GestureTapCallback onNewVideoPressed;

  const CustomVideoPlayer({
    super.key,
    required this.video, // 상위에서 선택한 동영상 주입해주기
    required this.onNewVideoPressed,
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

    // listener 추가 - 컨트롤러의 속성이 변경될 때마다 실행할 함수 등록
    videoController.addListener(videoControllerListener);

    setState(() {
      this.videoController = videoController;
    });
  }

  // 동영상의 재생 상태가 변경될 때마다
  // setState()를 실행하여 build()를 재실행합니다.
  void videoControllerListener() {
    setState(() {});
  }

  // covariant 키워드 - CustomVideoPlayer 클래스의 상속된 값도 허가해줌
  @override
  void didUpdateWidget(covariant CustomVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);

    // 경로를 통해 새로 선택한 동영상이 같은 동영상인지 확인
    if (oldWidget.video.path != widget.video.path) {
      initializeController();
    }
  }

  // State가 폐기될 때 같이 폐기할 함수들을 실행합니다.
  @override
  void dispose() {
    // listener 삭제
    videoController?.removeListener(videoControllerListener);
    super.dispose();
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
          ),
          Align(
            alignment: Alignment.topRight,
            child: CustomIconButton(
              // 카메라 아이콘을 선택하면 새로운 동영상 선택 함수 실행
              onPressed: widget.onNewVideoPressed,
              iconData: Icons.photo_camera_back,
            ),
          ),
          // 동영상 재생 관련 아이콘 - 중앙 위치
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // 되감기 버튼
                CustomIconButton(
                  onPressed: onReversePressed,
                  iconData: Icons.rotate_left,
                ),
                // 재생/일시정지 버튼
                CustomIconButton(
                  onPressed: onPlayPressed,
                  iconData: videoController!.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                ),
                // 앞으로 감기 버튼
                CustomIconButton(
                  onPressed: onFowardPressed,
                  iconData: Icons.rotate_right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 되감기 실행 함수
  void onReversePressed() {
    final currentPosition = videoController!.value.position; // 현재 실행 중인 위치

    Duration position = Duration(); // 0초로 실행 위치 초기화

    if (currentPosition.inSeconds > 3) {
      // 현재 실행 위치가 3초보다 길 때만 3초 빼기
      position = currentPosition - Duration(seconds: 3);
    }

    videoController!.seekTo(position);
  }

  // 앞으로 감기 실행 함수
  void onFowardPressed() {
    final maxPosition = videoController!.value.duration; // 동영상 총 길이
    final currentPosition = videoController!.value.position; // 동영상 현 위치

    Duration position = maxPosition; // 동영상 길이 실행 위치 초기화

    // 동영상 길이에서 3초를 뺀 값보다 현재 위치가 짧을 때만 3초 더하기
    if ((maxPosition - const Duration(seconds: 3)).inSeconds >
        currentPosition.inSeconds) {
      position = currentPosition + const Duration(seconds: 3);
    }

    videoController!.seekTo(position);
  }

  // 재생 버튼을 눌렀을 때 실행 함수
  void onPlayPressed() {
    if (videoController!.value.isPlaying) {
      videoController!.pause();
    } else {
      videoController!.play();
    }
  }
}
