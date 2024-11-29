import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class MainCalendar extends StatelessWidget {
  final OnDaySelected onDaySelected; // 날짜 선택 시 실행할 함수
  final DateTime selectedDate; // 선택된 날짜

  const MainCalendar({
    super.key,
    required this.onDaySelected,
    required this.selectedDate,
  });

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      locale: 'ko_kr', // 한국어로 언어 변경
      onDaySelected: onDaySelected, // 날짜 선택 함수
      // 날짜 선택 시 실행할 함수
      selectedDayPredicate: (date) =>
          date.year == selectedDate.year &&
          date.month == selectedDate.month &&
          date.day == selectedDate.day,
      firstDay: DateTime(1800, 1, 1), // 첫째 날
      lastDay: DateTime(3000, 1, 1), // 마지막 날
      focusedDay: DateTime.now(), // 화면에 보여지는 날
      headerStyle: const HeaderStyle(
        // 달력 최상단 스타일 설정
        titleCentered: true, // 제목 중앙에 위치시키기
        formatButtonVisible: false, // 달력 크기 선택 옵션 없애기
        titleTextStyle: TextStyle(
          // 제목 글꼴
          fontWeight: FontWeight.w700,
          fontSize: 16.0,
        ),
      ),
      calendarStyle: CalendarStyle(
        // 달력 스타일 설정
        isTodayHighlighted: false, // 오늘 날짜 하이라이트 설정
        // 기본 날짜 스타일 설정
        defaultDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: LIGHT_GREY_COLOR,
        ),
        // 주말 날짜 스타일 설정
        weekendDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          color: LIGHT_GREY_COLOR,
        ),
        // 선택된 날짜 스타일 설정
        selectedDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6.0),
          border: Border.all(
            color: PRIMARY_COLOR,
            width: 1.0,
          ),
        ),
        // 기본 글꼴 설정
        defaultTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: DARK_GREY_COLOR,
        ),
        // 주말 글꼴 설정
        weekendTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: DARK_GREY_COLOR,
        ),
        // 선택된 날짜 글꼴 설정
        selectedTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: DARK_GREY_COLOR,
        ),
      ),
    );
  }
}
