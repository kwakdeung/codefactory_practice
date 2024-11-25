import 'package:cf_tube/model/video_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class YoutubeRepository {
  static String apiKey = dotenv.env["API_KEY"]!;
  static String youtubeApiBaseUrl = dotenv.env["YOUTUBE_API_BASE_URL"]!;
  static String cfChannelId = dotenv.env["CF_CHANNEL_ID"]!;

  static Future<List<VideoModel>> getVideos() async {
    final resp = await Dio().get(
      // GET 메서드 보내기
      youtubeApiBaseUrl, // 요청을 보낼 URL
      queryParameters: {
        'channelId': cfChannelId,
        'maxResults': 50,
        'key': apiKey,
        'part': 'snippet',
        'order': 'date',
      },
    );

    // 'items'를 List<dynamic>으로 변환
    final items = (resp.data['items'] as List<dynamic>?);
    if (items == null) {
      throw Exception('items가 null입니다.');
    }

    final listWithData = items.where(
      (item) =>
          item?['id']?['videoId'] != null && item?['snippet']?['title'] != null,
    ); // videoId와 title이 null이 아닌 값들만 필터링

    return listWithData
        .map<VideoModel>(
          (item) => VideoModel(
            id: item['id']['videoId'],
            title: item['snippet']['title'],
          ),
        )
        .toList(); // 필터링된 값들을 기반으로 videoModel 생성
  }
}
