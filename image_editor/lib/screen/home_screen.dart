import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_editor/component/footer.dart';
import 'package:image_editor/component/main_app_bar.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? image; // 선택한 이미지를 저장할 변수

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          renderBody(),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: MainAppBar(
              onPickImage: onPickImage,
              onSaveImage: onSaveImage,
              onDeleteItem: onDeleteItem,
            ),
          ),
          // image가 선택되면 Footer 위치하기
          if (image != null)
            Positioned(
              // 맨 아래에 Footer 위젯 위치하기
              bottom: 0,
              // left, right가 0이면 좌우를 최대 크기로 차지함
              left: 0,
              right: 0,
              child: Footer(
                onEmoticonTap: onEmoticonTap,
              ),
            )
        ],
      ),
    );
  }

  void onEmoticonTap(int index) {}

  Widget renderBody() {
    // 이미지가 null이 아닐 때
    if (image != null) {
      // Stack 크기의 최대 크기만큼 차지하기
      return Positioned.fill(
        // 위젯 확대 및 좌우 이동을 가능하게 하는 위젯
        child: InteractiveViewer(
          child: Image.file(
            File(image!.path),
            // 이미지가 부모 위젯 크기 최대를 차지하도록 하기
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      // 이미지 선택이 안 된 경우 이미지 선택 버튼 표시
      return Center(
        child: TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.grey,
          ),
          onPressed: onPickImage,
          child: const Text('이미지 선택하기'),
        ),
      );
    }
  }

  // 미리 생성해둔 onPickImage() 함수 변경하기
  void onPickImage() async {
    // 갤러리에서 이미지를 선택하기
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    // 선택한 이미지 저장하기
    setState(() {
      this.image = image;
    });
  }

  void onSaveImage() {}

  void onDeleteItem() {}
}
