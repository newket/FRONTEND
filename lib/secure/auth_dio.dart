import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:newket/model/auth_model.dart';
import 'package:newket/view/onboarding/auth.dart';

Future authDio(BuildContext context) async {
  var dio = Dio();
  const storage = FlutterSecureStorage();

  dio.interceptors.clear();

  dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) async {
    // 기기에 저장된 AccessToken 로드
    final accessToken = await storage.read(key: 'ACCESS_TOKEN');

    // 매 요청마다 헤더에 AccessToken을 포함
    options.baseUrl = dotenv.get("BASE_URL");
    options.headers['Authorization'] = 'Bearer $accessToken';

    return handler.next(options);
  }, onError: (error, handler) async {
    // 인증 오류가 발생했을 경우: AccessToken의 만료
    if (error.response?.statusCode == 401 || error.response?.statusCode == 500) {
      // 기기에 저장된 AccessToken과 RefreshToken 로드
      final refreshToken = await storage.read(key: 'REFRESH_TOKEN');

      // 토큰 갱신 요청을 담당할 dio 객체 구현 후 그에 따른 interceptor 정의
      var refreshDio = Dio();

      refreshDio.interceptors.clear();

      // 토큰 갱신 API 요청
      try {
        refreshDio.options.baseUrl = dotenv.get("BASE_URL");
        final requestBody = ReissueRequest(refreshToken!).toJson();
        final response = await refreshDio.post(
            "/api/v1/auth/reissue",
            data: requestBody
        );

        final responseBody = ReissueResponse.fromJson(response.data);

        // 기기에 저장된 AccessToken과 RefreshToken 갱신
        await storage.write(key: 'ACCESS_TOKEN', value: responseBody.accessToken);
        await storage.write(key: 'REFRESH_TOKEN', value: responseBody.refreshToken);

        // AccessToken의 만료로 수행하지 못했던 API 요청에 담겼던 AccessToken 갱신
        error.requestOptions.headers['Authorization'] = 'Bearer ${responseBody.accessToken}';

        // 수행하지 못했던 API 요청 복사본 생성
        final clonedRequest = await dio.request(
          error.requestOptions.path,
          options: Options(
            method: error.requestOptions.method,
            headers: error.requestOptions.headers,
          ),
          data: error.requestOptions.data,
          queryParameters: error.requestOptions.queryParameters,
        );

        // API 복사본으로 재요청
        return handler.resolve(clonedRequest);
      } catch (e) {
        // 토큰 갱신 실패 시: 기기의 자동 로그인 정보 삭제
        await storage.deleteAll();

        // 로그인 만료 dialog 발생 후 로그인 페이지로 이동
        if (context.mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
                (route) => false,
          );
        }
      }
    }

    return handler.next(error);
  }));

  return dio;
}
