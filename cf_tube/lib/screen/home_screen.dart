import 'package:cf_tube/component/custom_youtube_player.dart';
import 'package:cf_tube/model/video_model.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomYoutubePlayer(
        videoModel: VideoModel(
          id: '3Ck42C2ZCb8', // 샘플 동영상 ID
          title: '다트 언어 기본기 1시간만에 끝내기', // 샘플 제목
        ),
      ),
    );
  }
}
