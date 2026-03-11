import 'package:calendar_scheduler/model/schedule_model.dart';
import 'package:dio/dio.dart';

class ScheduleRepository {
  final _dio = Dio();
  final _targetUrl = 'http://192.168.1.232:3000/schedule';

  /// 날짜별 일정을 불러온다.
  Future<List<ScheduleModel>> getSchedules({
    required String accessToken,
    required DateTime date,
  }) async {
    final resp = await _dio.get(
      _targetUrl,
      queryParameters: {
        "date":
            "${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}",
      },
      options: Options(headers: {"Authorization": "Bearer $accessToken"}),
    );

    if (resp.data is List) {
      return (resp.data as List)
          .map((x) => ScheduleModel.fromJson(json: x))
          .toList();
    }

    throw Exception("Invalid response data");
  }

  /// 일정을 서버에 저장하고 저장된 id를 반환한다.
  Future<String> createSchedule({
    required String accessToken,
    required ScheduleModel schedule,
  }) async {
    final json = schedule.toJson();

    final resp = await _dio.post(
      _targetUrl,
      data: json,
      options: Options(headers: {"Authorization": "Bearer $accessToken"}),
    );

    return resp.data?["id"];
  }

  /// 일정을 서버에서 삭제하고 삭제된 id를 반환한다.
  Future<String> deleteSchedule({
    required String accessToken,
    required String id,
  }) async {
    final resp = await _dio.delete(
      _targetUrl,
      data: {"id": id},
      options: Options(headers: {"Authorization": "Bearer $accessToken"}),
    );

    return resp.data?["id"];
  }
}
