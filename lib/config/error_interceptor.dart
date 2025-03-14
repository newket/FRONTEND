import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/view/error/screen/global_error_screen.dart';
import 'package:newket/view/error/screen/network_error_screen.dart';

class ErrorInterceptor extends Interceptor {
  final Dio dio;

  ErrorInterceptor(this.dio);

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    String previousRoute = Get.currentRoute;
    final currentScreen = Get.key.currentState?.overlay?.context.widget;

    if (err.type == DioExceptionType.connectionError || err.error is SocketException) {
      print('network error : ${err.response}');
      //AmplitudeConfig.amplitude.logEvent('network error : ${err.message}');

      if (currentScreen != NetworkErrorScreen) {
        await Get.to(
            () => NetworkErrorScreen(onRetry: () async {
                  if (await _checkNetwork()) {
                    Get.back();
                  }
                }),
            arguments: previousRoute);
      }
    } else if (err.response?.data?["error"] == "Internal Server Error") {
      // 토큰 만료됨
      handler.next(err);
      return;
    } else if (err.response?.data?["errorCode"] == "USER-1") {
      // 온보딩시
      handler.next(err);
      return;
    } else {
      if (currentScreen != GlobalErrorScreen) {
        print('global error : ${err.response}');
        //AmplitudeConfig.amplitude.logEvent('global error : ${err.message}');

        await Get.to(
            () => GlobalErrorScreen(onRetry: () async {
                  if (await _checkErrorResolved(err.requestOptions)) {
                    Get.back();
                  }
                }),
            arguments: err.message);
      }
    }
    throw err;
  }

  /// 네트워크 상태 확인
  Future<bool> _checkNetwork() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  /// API 재시도하여 에러 해결 여부 확인
  Future<bool> _checkErrorResolved(RequestOptions requestOptions) async {
    print("dio:$dio");
    try {
      final response = await dio.fetch(requestOptions);
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
