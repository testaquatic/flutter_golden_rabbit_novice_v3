import 'package:calendar_scheduler/model/schedule_model.dart';
import 'package:calendar_scheduler/repository/auth_repository.dart';
import 'package:calendar_scheduler/repository/schedule_repository.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class ScheduleProvider extends ChangeNotifier {
  /// API 요청 로직
  final ScheduleRepository scheduleRepository;

  /// 토큰 관리
  final AuthRepository authRepository;

  String? accessToken;
  String? refreshToken;

  /// 선택한 날짜
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );

  /// 일정 정보 저장
  Map<DateTime, List<ScheduleModel>> cache = {};

  ScheduleProvider({
    required this.scheduleRepository,
    required this.authRepository,
  }) : super();

  /// 날짜별 일정을 불러온다.
  ///
  /// 일단 캐시 업데이트를 하고
  ///
  /// API 서버에 요청을 전송한다.
  ///
  /// 요청이 성공하면 캐시를 다시 업데이트 하고
  ///
  /// 실패하면 캐시를 롤백한다.
  void getSchedules({required DateTime date}) async {
    final resp = await scheduleRepository.getSchedules(
      date: date,
      accessToken: accessToken!,
    );
    cache.update(date, (value) => resp, ifAbsent: () => resp);

    // 리슨하는 위젯을 업데이트하기
    notifyListeners();
  }

  /// 일정을 생성한다.
  void createSchedule({required ScheduleModel schedule}) async {
    final targetDate = schedule.date;

    final tempId = Uuid().v4();
    final newSchedule = schedule.copyWith(id: tempId);

    // 일단 캐시 업데이트를 한다.
    cache.update(
      targetDate,
      (value) =>
          [...value, newSchedule]
            ..sort((a, b) => a.startTime.compareTo(b.startTime)),
      ifAbsent: () => [newSchedule],
    );

    // 캐시 업데이트 반영
    notifyListeners();

    try {
      // API 요청
      final savedSchedule = await scheduleRepository.createSchedule(
        schedule: schedule,
        accessToken: accessToken!,
      );

      cache.update(
        targetDate,
        (value) => value
            .map((e) => e.id == tempId ? e.copyWith(id: savedSchedule) : e)
            .toList(),
      );
    } catch (e) {
      cache.update(
        targetDate,
        (value) => value.where((e) => e.id != tempId).toList(),
      );
    }

    notifyListeners();
  }

  /// 일정을 삭제한다.
  ///
  /// 캐시를 업데이트하고
  ///
  /// 서버에 요청을 보낸다
  ///
  /// 오류가 발생하면 캐시를 롤백한다.
  void deleteSchedule({required DateTime date, required String id}) async {
    final targetSchedule = cache[date]!.firstWhere((e) => e.id == id);

    cache.update(
      date,
      (value) => value.where((e) => e.id != id).toList(),
      ifAbsent: () => [],
    );

    notifyListeners();

    try {
      await scheduleRepository.deleteSchedule(
        id: id,
        accessToken: accessToken!,
      );
    } catch (e) {
      cache.update(
        date,
        (value) =>
            [...value, targetSchedule]
              ..sort((a, b) => a.startTime.compareTo(b.startTime)),
      );
    }

    notifyListeners();
  }

  /// 선택한 날짜를 업데이트한다.
  void changeSelectdDate({required DateTime date}) {
    selectedDate = date;

    notifyListeners();
  }

  /// 토큰을 업데이트 한다.
  void updateTokens({String? refreshToken, String? accessToken}) {
    if (refreshToken != null) {
      this.refreshToken = refreshToken;
    }

    if (accessToken != null) {
      this.accessToken = accessToken;
    }

    notifyListeners();
  }

  /// 회원가입을 처리한다.
  Future<void> register({
    required String email,
    required String password,
  }) async {
    final resp = await authRepository.register(
      email: email,
      password: password,
    );

    updateTokens(
      refreshToken: resp.refreshToken,
      accessToken: resp.accessToken,
    );
  }

  /// 로그인을 처리한다.
  Future<void> login({required String email, required String password}) async {
    final resp = await authRepository.login(email: email, password: password);

    updateTokens(
      refreshToken: resp.refreshToken,
      accessToken: resp.accessToken,
    );
  }

  /// 로그아웃을 처리한다.
  void logout() {
    accessToken = null;
    refreshToken = null;

    cache = {};

    notifyListeners();
  }

  /// 토큰을 회전한다.
  void rotateTotken({
    required String refreshToken,
    required bool isRefreshToken,
  }) async {
    if (isRefreshToken) {
      final token = await authRepository.rotateRefreshToken(
        refreshToken: refreshToken,
      );
      this.refreshToken = token;
    } else {
      final token = await authRepository.rotateAccessToken(
        refreshToken: refreshToken,
      );
      accessToken = token;
    }

    notifyListeners();
  }
}
