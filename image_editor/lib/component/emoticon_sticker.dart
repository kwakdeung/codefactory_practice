import 'package:flutter/material.dart';

// 스티커를 그리는 위젯
class EmoticonSticker extends StatefulWidget {
  final VoidCallback onTransform;
  final String imgPath; // 이미지 경로
  final bool isSelected;

  const EmoticonSticker({
    super.key,
    required this.onTransform,
    required this.imgPath,
    required this.isSelected,
  });

  @override
  State<EmoticonSticker> createState() => _EmoticonStickerState();
}

class _EmoticonStickerState extends State<EmoticonSticker> {
  double scale = 1; // 확대/축소 배율
  double hTransform = 0; // 가로의 움직임
  double vTransform = 0; // 세로의 움직임
  double actualScale = 1; // 위젯의 초기 크기 기준 확대/축소 비율

  @override
  Widget build(BuildContext context) {
    // child 위젯을 변형할 수 있는 위젯
    return Transform(
      transform: Matrix4.identity()
        ..translate(hTransform, vTransform) // 상/하 움직임 정의
        ..scale(scale, scale), // 확대/축소 정의
      child: Container(
        decoration: widget.isSelected // 선택 상태일 때만 테두리 색상 구현
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(4.0), // 모서리 둥글게
                border: Border.all(
                  // 테두리 파란색
                  color: Colors.blue, width: 1.0,
                ),
              )
            : BoxDecoration(
                // 테두리는 투명이나 너비는 1로 설정해서 스티커가 선택, 취소될 때 깜빡이는 현상 제거
                border: Border.all(
                  width: 1.0,
                  color: Colors.transparent,
                ),
              ),
        child: GestureDetector(
          // 스티커를 눌렀을 때 실행할 함수
          onTap: () {
            // 스티커의 상태가 변경될 때마다 실행
            widget.onTransform();
          },
          onScaleUpdate: (ScaleUpdateDetails detaills) {
            // 스티커의 확대 비율이 변경했을 때 실행
            widget.onTransform();
          },
          onScaleEnd: (ScaleEndDetails details) {},
          // 스티커의 확대 비율 변경이 완료됐을 때 실행
          child: Image.asset(
            widget.imgPath,
          ),
        ),
      ),
    );
  }
}
