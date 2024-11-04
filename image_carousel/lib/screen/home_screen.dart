import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// StatefulWidget 정의
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

// _HomeScreenState 정의
class _HomeScreenState extends State<HomeScreen> {
  final PageController pageController = PageController();

  @override
  void initState() {
    super.initState(); // 부모 initState() 실행

    Timer.periodic(
      // Timer.periodic() 등록
      const Duration(seconds: 3),
      (timer) {
        // 현재 페이지 가져오기
        int? nextPage = pageController.page?.toInt();
        // 페이지 값이 없을 때 return으로 예외처리
        if (nextPage == null) {
          return;
        }

        if (nextPage == 4) {
          nextPage = 0;
        } else {
          nextPage++;
        }
        pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 상태바 색상 변경
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    return Scaffold(
      // 페이지뷰 구현(List, Map 이용)
      body: PageView(
        controller: pageController,
        children: [1, 2, 3, 4, 5]
            .map(
              (number) => Image.asset(
                'asset/img/image_$number.jpeg',
                // BoxFit 속성 설정
                fit: BoxFit.cover,
              ),
            )
            .toList(),
      ),
    );
  }
}
