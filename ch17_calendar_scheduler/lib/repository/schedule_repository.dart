import 'package:ch17_calendar_scheduler/model/schedule_model.dart';
import 'package:dio/dio.dart';

const _testServer = 'http://192.168.1.107:3000';

class ScheduleRepository {
  final _dio = Dio();

  final _targetUrl = '$_testServer/schedule';

  Future<List<ScheduleModel>> getSchedules({required DateTime date}) async {
    final resp = await _dio.get(
      _targetUrl,
      queryParameters: {
        'date':
            '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}',
      },
    );

    return resp.data
        .map<ScheduleModel>((e) => ScheduleModel.fromJson(json: e))
        .toList();
  }

  Future<String> createSchedule({required ScheduleModel schedule}) async {
    final resp = await _dio.post(_targetUrl, data: schedule.toJson());

    return resp.data?["id"];
  }

  Future<String> deleteSchedule({required String id}) async {
    final resp = await _dio.delete(_targetUrl, data: {"id": id});

    return resp.data?["id"];
  }
}
