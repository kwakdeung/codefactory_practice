import 'package:calendar_scheduler/const/colors.dart';
import 'package:flutter/material.dart';

// 스케쥴 카드 위젯
class ScheduleCard extends StatelessWidget {
  final int startTime;
  final int endTime;
  final String content;

  const ScheduleCard({
    super.key,
    required this.startTime,
    required this.endTime,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.0,
          color: PRIMARY_COLOR,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        // 높이를 내부 위젯들의 최대 높이로 설정
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 시작과 종료 시간을 보여줄 위젯
              _Time(
                startTime: startTime,
                endTime: endTime,
              ),
              const SizedBox(width: 16.0),
              _Content(content: content),
              const SizedBox(width: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}

// 시간을 표현하는 위젯
class _Time extends StatelessWidget {
  final int startTime; // 시작 시간
  final int endTime; // 끝 시간
  const _Time({
    required this.startTime,
    required this.endTime,
  });

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontWeight: FontWeight.w600,
      color: PRIMARY_COLOR,
      fontSize: 16.0,
    );

    return Column(
      children: [
        Text(
          // 숫자가 두 자릿수가 안 되면 0으로 채워주기
          '${startTime.toString().padLeft(2, '0')}:00',
          style: textStyle,
        ),
        Text(
          // 숫자가 두 자릿수가 안 되면 0으로 채워주기
          '${endTime.toString().padLeft(2, '0')}:00',
          style: textStyle.copyWith(
            fontSize: 10.0,
          ),
        ),
      ],
    );
  }
}

// 내용을 렌더링 하는 위젯
class _Content extends StatelessWidget {
  final String content; // 내용

  const _Content({
    super.key,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Text(content),
    );
  }
}
