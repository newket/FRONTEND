import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/route_manager.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:newket/model/auth_model.dart';
import 'package:newket/model/user_model.dart';
import 'package:newket/view/onboarding/agreement.dart';
import 'package:newket/view/onboarding/login.dart';
import 'package:newket/view/tapbar/tap_bar.dart';

enum LoginPlatform {
  KAKAO,
  none, // logout
}

class AuthRepository {
  final Dio dio = Dio();
  var storage = const FlutterSecureStorage();

  AuthRepository() {
    dio.options.baseUrl = dotenv.get("BASE_URL");
  }

  Future<void> kakaoLoginApi() async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false, // 화면을 터치해도 닫히지 않도록 설정
    );
    // 카카오톡 실행 가능 여부 확인
    // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
    try {
      if (await isKakaoTalkInstalled()) {
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          String accessToken = token.accessToken;
          storage.write(key: 'KAKAO_TOKEN', value: accessToken);
          await socialLoginApi(SocialLoginRequest(accessToken));

          final serverToken = await storage.read(key: 'ACCESS_TOKEN');
          await putDeviceTokenApi(serverToken!);

          print('카카오톡으로 로그인 성공');
          print("kakao 토큰: $accessToken");
          Get.offAll(const TapBar());
        } catch (error) {
          print('카카오톡으로 로그인 실패 $error');

          // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
          // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
          if (error is PlatformException && error.code == 'CANCELED') {
            return;
          }
          try {
            OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
            String accessToken = token.accessToken;
            storage.write(key: 'KAKAO_TOKEN', value: accessToken);
            await socialLoginApi(SocialLoginRequest(accessToken));

            final serverToken = await storage.read(key: 'ACCESS_TOKEN');
            await putDeviceTokenApi(serverToken!);

            print('카카오계정으로 로그인 성공');
            print("kakao 토큰: $accessToken");

            Get.offAll(const TapBar());
          } catch (error) {
            print('카카오계정으로 로그인 실패 $error');
          }
        }
      } else {
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          String accessToken = token.accessToken;
          storage.write(key: 'KAKAO_TOKEN', value: accessToken);
          await socialLoginApi(SocialLoginRequest(accessToken));

          final serverToken = await storage.read(key: 'ACCESS_TOKEN');
          await putDeviceTokenApi(serverToken!);

          print('카카오계정으로 로그인 성공');
          print("kakao 토큰: $accessToken");

          Get.offAll(const TapBar());
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } catch (error){
      print('카카오계정으로 로그인 실패 $error');
    } finally {
      if (Get.isDialogOpen!) {
        Get.back(); // 로딩 화면을 닫음
      }
    }
  }

  Future<SocialLoginResponse> signUpApi(SignUpRequest signUpRequest) async {
    try {
      final requestBody = signUpRequest.toJson();

      final response = await dio.post("/api/v1/auth/signup/KAKAO", data: requestBody);

      final responseBody = SocialLoginResponse.fromJson(response.data);

      await Future.wait([
        storage.write(key: 'ACCESS_TOKEN', value: responseBody.accessToken),
        storage.write(key: 'REFRESH_TOKEN', value: responseBody.refreshToken)
      ]);
      return responseBody;
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 400 || e.response?.statusCode == 500) {
          // 로그인 페이지로 이동
          Get.offAll(const Login());
        }
      }
      throw e;
    }
  }

  Future<SocialLoginResponse> socialLoginApi(SocialLoginRequest socialLoginRequest) async {
    try {
      final requestBody = socialLoginRequest.toJson();

      final response = await dio.post("/api/v1/auth/login/KAKAO", data: requestBody);

      final responseBody = SocialLoginResponse.fromJson(response.data);

      await Future.wait([
        storage.write(key: 'ACCESS_TOKEN', value: responseBody.accessToken),
        storage.write(key: 'REFRESH_TOKEN', value: responseBody.refreshToken)
      ]);
      return responseBody;
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 400) {
          // 온보딩 페이지로 이동
          Get.offAll(const Agreement());
        }
      }
      throw e;
    }
  }

  Future<void> putDeviceTokenApi(String accessToken) async {
    dio.options.headers['Authorization'] = 'Bearer $accessToken';
    final deviceToken = await FirebaseMessaging.instance.getToken();

    final requestBody = UserDeviceToken(deviceToken!).toJson();

    await dio.put("/api/v1/users/device-token", data: requestBody);
  }
}
