import 'package:ch17_calendar_scheduler/model/schedule_model.dart';
import 'package:ch17_calendar_scheduler/repository/schedule_repository.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ScheduleProvider extends ChangeNotifier {
  final ScheduleRepository repository;

  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  Map<DateTime, List<ScheduleModel>> cache = {};

  ScheduleProvider({required this.repository}) : super() {
    getSchedules(date: selectedDate);
  }

  void getSchedules({required DateTime date}) async {
    final resp = await repository.getSchedules(date: date);

    cache.update(date, (value) => resp, ifAbsent: () => resp);

    notifyListeners();
  }

  void createSchedule({required ScheduleModel schedule}) async {
    final targetDate = schedule.date;
    final tempId = Uuid().v4();
    final newSchedule = schedule.copyWith(id: tempId);

    // 긍정적 응답 구간
    cache.update(
      targetDate,
      (value) =>
          [...value, newSchedule]
            ..sort((a, b) => a.startTime.compareTo(b.startTime)),
      ifAbsent: () => [newSchedule],
    );

    // 캐시 업데이트를 반영한다.
    notifyListeners();

    // 서버에 요청을 한다.
    try {
      final savedSchedule = await repository.createSchedule(schedule: schedule);
      // 서버의 응답으로 캐시를 업데이트 한다.
      cache.update(
        targetDate,
        (value) => value
            .map((e) => e.id == tempId ? e.copyWith(id: savedSchedule) : e)
            .toList(),
      );
    } catch (e) {
      // 생성 실패시 롤백
      cache.update(
        targetDate,
        (value) => value.where((e) => e.id != tempId).toList(),
      );
    }

    notifyListeners();
  }

  void deleteSchedule({required DateTime date, required String id}) async {
    // 삭제할 일정 기억
    final targetSchedule = cache[date]!.firstWhere((e) => e.id == id);

    // 먼저 캐시에 반영
    cache.update(
      date,
      (value) => value.where((e) => e.id != id).toList(),
      ifAbsent: () => [],
    );

    // UI에 반영
    notifyListeners();

    try {
      // 서버에 삭제 요청
      await repository.deleteSchedule(id: id);
    } catch (e) {
      // 실패 시 롤백
      cache.update(
        date,
        (value) =>
            [...value, targetSchedule]
              ..sort((a, b) => a.startTime.compareTo(b.startTime)),
      );
    }

    // UI에 반영
    notifyListeners();
  }

  void changeSelectedDate({required DateTime date}) {
    selectedDate = date;
    notifyListeners();
  }
}
