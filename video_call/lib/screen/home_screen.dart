import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100]!,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(child: _Logo()), // 로고
              Expanded(child: _Image()), // 중앙 이미지
              Expanded(child: _EntryButton()), // 화상 통화 시작 버튼
            ],
          ),
        ),
      ),
    );
  }
}

// 로고 이미지
class _Logo extends StatelessWidget {
  const _Logo({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(16.0) // 모서리 둥글게 만들기
            ,
            // 그림자 추가
            boxShadow: [
              BoxShadow(
                color: Colors.blue[300]!,
                blurRadius: 12.0, // 그림자 효과에서 흐림의 정도를 설정(0 일 수록 그림자 선이 선명)
                spreadRadius: 2.0, // 그림자 효과의 반경, 설정 값이 높을 수록 넓어짐
              ),
            ]),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min, // Row 주축 최소 크기,
            children: [
              Icon(
                Icons.videocam,
                color: Colors.white,
                size: 40.0,
              ),
              SizedBox(width: 12.0),
              // 앱 이름
              Text(
                'LIVE',
                style: TextStyle(
                  color: Colors.white, fontSize: 30.0,
                  letterSpacing: 4.0, // 글자 간 간격
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// 홈 이미지
class _Image extends StatelessWidget {
  const _Image({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        'asset/img/home_img.png',
      ),
    );
  }
}

// 화상 통화 채널에 접속 할 수 있는 버튼
class _EntryButton extends StatelessWidget {
  const _EntryButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton(
          onPressed: () {},
          child: Text('입장하기'),
        ),
      ],
    );
  }
}
