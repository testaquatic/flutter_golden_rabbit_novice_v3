import 'dart:async';

import 'package:calendar_scheduler/model/schedule_model.dart';
import 'package:dio/dio.dart';

class ScheduleRepository {
  final _dio = Dio();
  // 서버의 주소를 변경했다.
  final _targetUrl = 'http://192.168.1.107:3000/schedule';

  Future<List<ScheduleModel>> getSchedules({
    required String accessToken,
    required DateTime date,
  }) async {
    final resp = await _dio.get(_targetUrl,
        queryParameters: {
          // ➊ Query Parameter
          'date':
              '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}',
        },
        options: Options(
          headers: {
            // 엑세스 토큰
            'authorization': 'Bearer $accessToken',
          },
        ));

    return resp.data // ➋ 모델 인스턴스로 데이터 매핑하기
        .map<ScheduleModel>(
          (x) => ScheduleModel.fromJson(
            json: x,
          ),
        )
        .toList();
  }

  Future<String> createSchedule({
    required String accessToken,
    required ScheduleModel schedule,
  }) async {
    final json = schedule.toJson();

    final resp = await _dio.post(_targetUrl,
        data: json,
        options: Options(headers: {
          // 엑세스 토큰
          "authorization": "Bearer $accessToken"
        }));

    return resp.data?['id'];
  }

  Future<String> deleteSchedule({
    required String accessToken,
    required String id,
  }) async {
    final resp = await _dio.delete(_targetUrl,
        data: {
          'id': id, // 삭제할 ID값
        },
        options: Options(headers: {
          // 엑세스 토큰
          "authorization": "Bearer $accessToken"
        }));

    return resp.data?['id']; // 삭제된 ID값 반환
  }
}
