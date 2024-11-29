import 'package:calendar_scheduler/component/custom_text_field.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ScheduleBottomSheet extends StatefulWidget {
  final DateTime selectedDate; // 선택된 날짜 상위 위젯에서 입력받기

  const ScheduleBottomSheet({
    super.key,
    required this.selectedDate,
  });

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey(); // 폼 key 생성

  int? startTime; // 시작 시간 저장 변수
  int? endTime; // 종료 시간 저장 변수
  String? content; // 일정 내용 저장 변수

  @override
  Widget build(BuildContext context) {
    // 키보드 높이 가져오기
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Form(
      // 텍스트 필드를 한 번에 관리할 수 있는 폼 위젯
      key: formKey, // Form을 조작할 키값
      child: SafeArea(
        child: Container(
          // 화면 반 높이에 키보드 높이 추가하기
          height: MediaQuery.of(context).size.height / 2 + bottomInset,
          color: Colors.white,
          child: Padding(
            // 패딩에 키보드 높이 추가해서 위젯 전반적으로 위로 올려주기
            padding:
                EdgeInsets.only(left: 8, right: 8, top: 8, bottom: bottomInset),
            child: Column(
              // 시간 관련 텍스트 필드와 내용 관련 텍스트 필드 세로로 배치
              children: [
                Row(
                  children: [
                    // 시작 시간 가로로 배치
                    Expanded(
                      child: CustomTextField(
                        label: '시작 시간',
                        isTime: true,
                        onSaved: (String? val) {
                          // 저장이 실행되면 startTime 변수에 텍스트 필드값 저장
                          startTime = int.parse(val!);
                        },
                        validator: timeValidator,
                      ),
                    ),
                    const SizedBox(width: 16.0),
                    Expanded(
                      // 종료 시간 입력 필드
                      child: CustomTextField(
                        label: '종료 시간',
                        isTime: true,
                        onSaved: (String? val) {
                          // 저장이 실행되면 endTime 변수에 텍스트 필드값 저장
                          endTime = int.parse(val!);
                        },
                        validator: timeValidator,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8.0),
                Expanded(
                  // 내용 필드 입력
                  child: CustomTextField(
                    label: '내용',
                    isTime: false,
                    onSaved: (String? val) {
                      // 저장이 실행되면 content 변수에 텍스트 필드값 지정
                      content = val;
                    },
                    validator: contentValidator,
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  // 저장 버튼
                  child: ElevatedButton(
                    onPressed: onSavePressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PRIMARY_COLOR,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('저장'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 저장 함수
  void onSavePressed() async {
    if (formKey.currentState!.validate()) {
      // 폼 검증하기
      formKey.currentState!.save(); // 폼 저장하기

      print(startTime); // 시작 시간 출력
      print(endTime); // 종료 시간 출력
      print(content); // 내용 출력

      // 일정 생성하기
      await GetIt.I<LocalDatabase>().createSchedule(
        SchedulesCompanion(
          startTime: Value(startTime!),
          endTime: Value(endTime!),
          content: Value(content!),
          date: Value(widget.selectedDate),
        ),
      );

      Navigator.of(context).pop(); // 일정 생성 후 화면 뒤로 가기
    }
  }

  // timeValidator(), contentValidator() - 출력/반환 매개변수 사용

  // 시간값 검증 함수
  String? timeValidator(String? val) {
    if (val == null) {
      return '값을 입력해주세요';
    }

    int? number;

    try {
      number = int.parse(val);
    } catch (e) {
      return '숫자를 입력해주세요';
    }

    if (number < 0 || number > 24) {
      return '0시부터 24시 사이를 입력해주세요';
    }
  }

  // 내용값 검증 함수
  String? contentValidator(String? val) {
    if (val == null || val.length == 0) {
      return '값을 입력해주세요';
    }

    return null;
  }
}
