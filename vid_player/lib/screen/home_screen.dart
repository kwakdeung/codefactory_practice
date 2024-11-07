import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

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
      child: Column(
        // 위젯들 가운데 정렬
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _Logo(), // 로고 이미지
          SizedBox(height: 30.0),
          _AppName(), // 앱 이름
        ],
      ),
    );
  }

  Widget renderVideo() {
    // 동영상 선택 후 보여줄 위젯
    return Container();
  }
}

// 로고를 보여줄 위젯
class _Logo extends StatelessWidget {
  const _Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'asset/img/logo.png', // 로고 이미지
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
