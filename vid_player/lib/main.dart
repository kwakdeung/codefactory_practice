import 'package:flutter/material.dart';
import 'package:vid_player/screen/home_screen.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    ),
  );
}

// Duration duration = Duration(seconds: 192);
// print(duration); // 기간을 출력 - 0:03:12.000000
// print(duration.toString().split('.')[0]); // 0:03:12 출력
// print(duration.toString().split('.')[0].split(':').sublist(1, 3).join(':')); // 03:12 출력
// print('${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}'); // 03:12 출력
// print('23'.padLeft(3, '0')); // 023 출력
// print('233'.padLeft(3, '0')); // 223 출력