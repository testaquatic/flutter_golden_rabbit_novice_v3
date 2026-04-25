import 'package:calendar_scheduler/model/schedule_model.dart';
import 'package:dio/dio.dart';

class ScheduleRepository {
  final _dio = Dio();
  final _targetUrl = "http://192.168.1.173:8000/schedule";

  Future<List<ScheduleModel>> getSchedules({required String date}) async {
    final resp = await _dio.get(_targetUrl, queryParameters: {"date": date});

    return resp.data
        .map<ScheduleModel>((e) => ScheduleModel.fromJson(json: e))
        .toList();
  }

  Future<String> createSchedule({required ScheduleModel schedule}) async {
    final json = schedule.toJson();
    final resp = await _dio.post(_targetUrl, data: json);

    return resp.data?["id"];
  }

  Future<String> deleteSchedule({required String id}) async {
    final resp = await _dio.delete(_targetUrl, data: {"id": id});

    return resp.data?["id"];
  }
}
