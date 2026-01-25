import 'dart:convert';

import 'package:dio/dio.dart';

class AuthRepository {
  // Dio 인스턴스 생성
  final _dio = Dio();
  // 서버 주소
  // 개인 환경에 맞춰서 수정했다.
  final _targetUrl = "http://192.168.1.107:3000/auth";

  Future<({String refreshTocken, String accessToken})> register({
    required String email,
    required String password,
  }) async {
    final result = await _dio.post("$_targetUrl/register/email", data: {
      "email": email,
      "password": password,
    });

    return (
      refreshTocken: result.data["refreshToken"] as String,
      accessToken: result.data["accessToken"] as String,
    );
  }

  Future<({String refreshTocken, String accessToken})> login({
    required String email,
    required String password,
  }) async {
    final emailAndPassword = "$email:$password";
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    final encoded = stringToBase64.encode(emailAndPassword);

    // 인코딩된 문자열을 헤더에 담아서 로그인 요청을 보낸다.
    final result = await _dio.post("$_targetUrl/login/email",
        options: Options(headers: {
          "authorization": "Basic $encoded",
        }));

    return (
      refreshTocken: result.data["refreshToken"] as String,
      accessToken: result.data["accessToken"] as String,
    );
  }

  Future<String> rotateRefreshToken({
    required String refreshToken,
  }) async {
    final result = await _dio.post("$_targetUrl/token/refresh",
        options: Options(headers: {
          "authorization": "Bearer $refreshToken",
        }));

    return result.data["refreshToken"] as String;
  }

  Future<String> rotateAccessToken({required String refreshToken}) async {
    final result = await _dio.post("$_targetUrl/token/access",
        options: Options(headers: {
          "authorization": "Bearer $refreshToken",
        }));

    return result.data["accessToken"] as String;
  }
}
