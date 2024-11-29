import 'package:calendar_scheduler/component/main_calendar.dart';
import 'package:calendar_scheduler/component/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler/component/schedule_card.dart';
import 'package:calendar_scheduler/component/today_banner.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/database/drift_database.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // 미리 작업해둔 달력 위젯 보여주기
            MainCalendar(
              selectedDate: selectedDate, // 선택된 날짜 선택하기
              onDaySelected: onDaySelected, // 날짜가 선택 됐을 때 실행할 함수
            ),
            const SizedBox(height: 8.0),
            // 일정을 Stream으로 받아오기
            StreamBuilder<List<Schedule>>(
              stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
              builder: (context, snapshot) {
                // 배너 추가하기
                return TodayBanner(
                  selectedDate: selectedDate,
                  count: snapshot.data?.length ?? 0,
                );
              },
            ),
            const SizedBox(height: 8.0),
            // 남는 공간 모두 차지하기
            Expanded(
              // 일정 정보가 Stream으로 제공되기 때문에 StreamBuilder 사용
              // StreamBuilder -> 일정 관련 데이터가 변경될 때마다 위젯들을 새로 렌더링해줌
              child: StreamBuilder<List<Schedule>>(
                  // watchSchedules() - Stream을 반환
                  stream: GetIt.I<LocalDatabase>().watchSchedules(selectedDate),
                  builder: (context, snapshot) {
                    // 데이터가 없을 때
                    if (!snapshot.hasData) {
                      return Container();
                    }
                    // 화면에 보이는 값들만 렌더링하는 리스트
                    return ListView.builder(
                      // 리스트에 입력할 값들의 총 개수
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        // 현재 index에 해당되는 일정
                        final schedule = snapshot.data![index];
                        return Dismissible(
                          key: ObjectKey(schedule.id), // 유일한 키값
                          // 밀기 방향(왼쪽 -> 오른쪽)
                          direction: DismissDirection.startToEnd,
                          // 밀기 했을 때 실행할 함수
                          onDismissed: (DismissDirection direction) {
                            // 스케쥴 제거 함수
                            GetIt.I<LocalDatabase>()
                                .removeSchedule(schedule.id);
                          },
                          // 패딩 추가로 UI 개선
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 8.0, left: 8.0, right: 8.0),
                            child: ScheduleCard(
                              startTime: schedule.startTime,
                              endTime: schedule.endTime,
                              content: schedule.content,
                            ),
                          ),
                        );
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
      // 새 일정 버튼
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isDismissible: true, // 배경 탭했을 때 BottomSheet 닫기
            builder: (_) => ScheduleBottomSheet(
              selectedDate: selectedDate, // 선택된 날짜 (selectedDate) 넘겨주기
            ),
            // BottomSheet의 높이를 화면의 최대 높이로
            // 정의하고 스크롤 가능하게 변경
            isScrollControlled: true,
          );
        },
        backgroundColor: PRIMARY_COLOR,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    // 날짜 선택될 때마다 실행할 함수
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}
