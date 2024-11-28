import 'dart:io';

import 'package:calendar_scheduler/model/schedule.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

// private값까지 불러올 수 있음
part 'drift_database.g.dart'; // part 파일 지정

@DriftDatabase(
  // 사용할 테이블 등록
  tables: [
    Schedules,
  ],
)
// _&란?
// _(언더스코어)는 Dart에서 "내부적으로 사용"되는 클래스나 멤버를 나타내기 위해 사용됩니다.
// $는 Drift에서 자동 생성된 코드를 구분하기 위해 붙이는 관례입니다.
// Code Generation으로 생성할 클래스 상속
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  // 데이터를 조회하고 변화 감지, watchSchedules() -> 스케쥴 조회, 변화 감지
  Stream<List<Schedule>> watchSchedules(DateTime date) =>
      (select(schedules)..where((tbl) => tbl.date.equals(date))).watch();
  // createSchedule() -> 스케쥴 생성
  Future<int> createSchedule(SchedulesCompanion data) =>
      into(schedules).insert(data);
  // removeSchedule() -> 스케쥴 제거
  Future<int> removeSchedule(int id) =>
      (delete(schedules)..where((tbl) => tbl.id.equals(id))).go();

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    // 데이터베이스 파일 저장할 폴더
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}
