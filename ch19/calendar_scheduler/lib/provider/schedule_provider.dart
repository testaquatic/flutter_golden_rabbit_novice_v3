import 'package:calendar_scheduler/model/schedule_model.dart';
import 'package:calendar_scheduler/repository/schedule_repository.dart';

import 'package:riverpod/riverpod.dart';
import 'package:uuid/v4.dart';

final scheduleNotifierProvider =
    AsyncNotifierProvider<ScheduleNotifier, List<ScheduleModel>>(
      ScheduleNotifier.new,
    );

class ScheduleNotifier extends AsyncNotifier<List<ScheduleModel>> {
  ScheduleRepository repository = ScheduleRepository();
  Map<String, List<ScheduleModel>> cache = {};
  String selectedDate = dateToString(DateTime.now());

  @override
  Future<List<ScheduleModel>> build() async {
    final resp = await repository.getSchedules(date: selectedDate);
    cache.update(selectedDate, (value) => resp, ifAbsent: () => resp);
    return resp;
  }

  Future<int> getSchedules(String date) async {
    if (selectedDate == date) {
      return state.value!.length;
    }
    selectedDate = date;

    if (cache.containsKey(date)) {
      state = AsyncData(cache[date]!);
      return state.value!.length;
    }

    final resp = await repository.getSchedules(date: date);
    cache.update(date, (value) => resp, ifAbsent: () => resp);
    state = AsyncData(cache[date] ?? []);

    return state.value!.length;
  }

  Future<int> addSchedule(ScheduleModel schedule) async {
    state = AsyncValue.loading();
    final targetDate = schedule.date;
    selectedDate = targetDate;
    final tempId = UuidV4().toString();
    final newSchedule = schedule.copyWith(id: tempId);

    // 응답을 받기 전에 캐시를 업데이트 한다.
    cache.update(
      targetDate,
      (value) =>
          [...value, newSchedule]
            ..sort((a, b) => a.startTime.compareTo(b.startTime)),
      ifAbsent: () => [newSchedule],
    );
    // 이전 단계에서 null체크를 했다.
    state = AsyncData(cache[targetDate]!);

    try {
      final savedScheduleId = await repository.createSchedule(
        schedule: schedule,
      );

      cache.update(
        targetDate,
        (value) => value
            .map((e) => e.id == tempId ? e.copyWith(id: savedScheduleId) : e)
            .toList(),
      );

      state = AsyncData(cache[targetDate]!);

      return state.value!.length;
    } catch (e) {
      cache.update(
        targetDate,
        (value) => value.where((e) => e.id != tempId).toList(),
      );

      state = AsyncData(cache[targetDate]!);
    }

    return state.value!.length;
  }

  Future<void> deleteSchedule({
    required String date,
    required String id,
  }) async {
    selectedDate = date;
    state = AsyncLoading();
    // 삭제할 일정
    final targetSchedule = cache[date]!.firstWhere((e) => e.id == id);

    // 일단 캐시에서 삭제하고 상태 변경
    cache.update(
      date,
      (value) => value.where((e) => e.id != id).toList(),
      ifAbsent: () => [],
    );
    state = AsyncData(cache[date] ?? []);

    try {
      await repository.deleteSchedule(id: id);
    } catch (e) {
      cache.update(
        date,
        (value) =>
            [...value, targetSchedule]
              ..sort((a, b) => a.startTime.compareTo(b.startTime)),
      );
      state = AsyncData(cache[date] ?? []);
    }

    cache.update(
      date,
      (value) => value.where((e) => e.id != id).toList(),
      ifAbsent: () => [],
    );

    state = AsyncData(cache[date]!);
  }

  Future<void> changeSelectedDate(String date) async {
    getSchedules(date);
  }
}

String dateToString(DateTime date) {
  return "${date.year}${date.month.toString().padLeft(2, "0")}${date.day.toString().padLeft(2, "0")}";
}
