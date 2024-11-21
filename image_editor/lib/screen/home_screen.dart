import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:image_editor/component/emoticon_sticker.dart';
import 'package:image_editor/component/footer.dart';
import 'package:image_editor/component/main_app_bar.dart';
import 'package:image_editor/model/sticker_model.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? image; // 선택한 이미지를 저장할 변수
  Set<StickerModel> stickers = {}; // 화면에 추가된 스티커를 저장할 변수
  String? selectedId; // 현재 선택된 스티커의 ID
  GlobalKey imgKey = GlobalKey(); // 이미지로 전환할 위젯에 입력해줄 키값

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

  // renderBody() 함수 아래에 추가
  void onEmoticonTap(int index) async {
    setState(() {
      stickers = {
        ...stickers,
        StickerModel(
          id: Uuid().v4(), // 스티커의 고유 ID
          imgPath: 'asset/img/emoticon_$index.png',
        ),
      };
    });
  }

  Widget renderBody() {
    // 이미지가 null이 아닐 때
    if (image != null) {
      // 하위 트리에 위치한 위젯이 변경될 때 Flutter 엔진이 전체 화면을 다시 그리는 대신, 지정된 부분만 새로 그리도록 최적화하는 역할
      // 렌더링 성능을 최적화, 불필요한 재렌더링을 방지
      return RepaintBoundary(
        // 위젯을 이미지로 저장하는 데 사용
        key: imgKey,
        // Stack 크기의 최대 크기만큼 차지하기
        child: Positioned.fill(
          // 위젯 확대 및 좌우 이동을 가능하게 하는 위젯
          child: InteractiveViewer(
            child: Stack(
              fit: StackFit.expand, // 크기 최대로 늘려주기
              children: [
                Image.file(
                  File(image!.path),
                  // 이미지가 부모 위젯 크기 최대를 차지하도록 하기
                  fit: BoxFit.cover,
                ),
                ...stickers.map(
                  (sticker) => Center(
                    // 최초 스티커 선택 시 중앙에 배치
                    child: EmoticonSticker(
                      key: ObjectKey(sticker.id),
                      onTransform: () {
                        onTransform(sticker.id);
                      },
                      imgPath: sticker.imgPath,
                      isSelected: selectedId == sticker.id,
                    ),
                  ),
                ),
              ],
            ),
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

  // 이미지 저장 기능을 구현할 함수
  void onSaveImage() async {
    RenderRepaintBoundary boundary = imgKey.currentContext!.findRenderObject()
        as RenderRepaintBoundary; // 바운더리: 경계
    ui.Image image = await boundary.toImage(); // 바운더리를 이미지로 변경
    // byte data 형태로 변경
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    // Unit8List 형태로 변경
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    // 함수 끝에 추가
    // 이미지 저장하기
    await ImageGallerySaver.saveImage(pngBytes, quality: 100);

    // 저장 후 Snackbar 보여주기
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('저장되었습니다!'),
      ),
    );
  }

  void onDeleteItem() async {
    setState(() {
      // .where - 조건을 필터링할 때 사용하는 함수
      stickers = stickers.where((sticker) => sticker.id != selectedId).toSet();
      // 현재 선택 되어 있는 스티커 삭제 후 Set로 변환
    });
  }

  void onTransform(String id) {
    // 스티커가 변형될 때마다 변형 중인
    // 스티커를 현재 선택한 스티커로 지정
    setState(() {
      selectedId = id;
    });
  }
}
