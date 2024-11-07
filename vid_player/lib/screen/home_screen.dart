import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vid_player/component/custom_video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? video;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: video == null ? renderEmpty() : renderVideo(),
    );
  }

  Widget renderEmpty() {
    // 동영상 선택 전 보여줄 위젯
    return Container(
      width: MediaQuery.of(context).size.width, // 너비 값 최대로
      decoration: getBoxDecoration(),
      child: Column(
        // 위젯들 가운데 정렬
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _Logo(onTap: onNewVideoPressed), // 로고 이미지
          SizedBox(height: 30.0),
          _AppName(), // 앱 이름
        ],
      ),
    );
  }

  void onNewVideoPressed() async {
    final video = await ImagePicker().pickVideo(source: ImageSource.gallery);

    if (video != null) {
      setState(() {
        this.video = video;
      });
    }
  }

  BoxDecoration getBoxDecoration() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF2A3A7C),
          Color(0xFF000118),
        ],
      ),
    );
  }

  Widget renderVideo() {
    // 동영상 선택 후 보여줄 위젯
    return Center(
      child: CustomVideoPlayer(
        video: video!, // 선택된 동영상 입력해주기
      ),
    );
  }
}

// 로고를 보여줄 위젯
class _Logo extends StatelessWidget {
  final GestureTapCallback onTap; // 탭했을 때 실행할 함수

  const _Logo({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, // 상위 위젯으로부터 탭 콜백받기
      child: Image.asset(
        'asset/img/logo.png', // 로고 이미지
      ),
    );
  }
}

// 앱 이름을 보여줄 위젯
class _AppName extends StatelessWidget {
  const _AppName({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 30.0,
      fontWeight: FontWeight.w300,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
      children: [
        Text(
          'VIDEO',
          style: textStyle,
        ),
        Text(
          'PLAYER',
          style: textStyle.copyWith(
            // textStyle에서 두께만 700으로 변경
            fontWeight: FontWeight.w700,
          ),
        )
      ],
    );
  }
}
