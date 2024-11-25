import 'package:cf_tube/component/custom_youtube_player.dart';
import 'package:cf_tube/model/video_model.dart';
import 'package:cf_tube/repository/youtube_repository.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true, // 제목 가운데 정렬
        title: const Text('코팩튜브'),
        backgroundColor: Colors.black,
      ),
      body:
          // CustomYoutubePlayer(
          //   videoModel: VideoModel(
          //     id: '3Ck42C2ZCb8', // 샘플 동영상 ID
          //     title: '다트 언어 기본기 1시간만에 끝내기', // 샘플 제목
          //   ),
          // ),
          FutureBuilder<List<VideoModel>>(
        future: YoutubeRepository.getVideos(),
        builder: ((context, snapshot) {
          // 에러가 있을 경우 에러 화면 표시하기
          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }
          // 로딩 중일 때 로딩 위젯 보여주기
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            physics: const BouncingScrollPhysics(),
            children: snapshot.data!
                .map((e) => CustomYoutubePlayer(videoModel: e))
                .toList(),
          );
        }),
      ),
    );
  }
}
