import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:newket/config/error_interceptor.dart';

class DioClient {
  static Dio? _dio;

  static Dio get dio {
    _dio ??= Dio(BaseOptions(
      baseUrl: dotenv.get("BASE_URL"),
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
    ));
    _dio!.interceptors.clear();
    _dio!.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        options.headers['Authorization'] = null;
        return handler.next(options);
      },
    ));
    _dio!.interceptors.add(ErrorInterceptor(_dio!));
    return _dio!;
  }
}