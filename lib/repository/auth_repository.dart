import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:flutter/services.dart';
import 'package:newket/model/auth_model.dart';
import 'package:newket/secure/token_storage.dart';
import 'package:get/route_manager.dart';
import 'package:newket/view/home.dart';

enum LoginPlatform {
  KAKAO,
  none, // logout
}

class AuthRepository {
  final Dio dio = Dio();
  final SecureStorage storage;

  AuthRepository(this.storage) {
    dio.options.baseUrl = dotenv.get("BASE_URL");
    dio.options.validateStatus = (status) {
      return status! < 500;
    };
  }

  Future<void> kakaoLoginApi() async {
    // 카카오톡 실행 가능 여부 확인
    // 카카오톡 실행이 가능하면 카카오톡으로 로그인, 아니면 카카오계정으로 로그인
    if (await isKakaoTalkInstalled()) {
      try {
        await UserApi.instance.loginWithKakaoTalk();
        OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
        String accessToken = token.accessToken;

        await socialLoginApi(SocialLoginRequest(accessToken));

        print('카카오톡으로 로그인 성공');
        print("토큰: $accessToken");
        Get.offAll(Home());
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');

        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }
        try {
          await UserApi.instance.loginWithKakaoAccount();
          OAuthToken Token = await UserApi.instance.loginWithKakaoAccount();
          String accessToken = Token.accessToken;

          await socialLoginApi(SocialLoginRequest(accessToken));

          print('카카오계정으로 로그인 성공');
          print("토큰: $accessToken");

          Get.offAll(const Home());
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        await UserApi.instance.loginWithKakaoAccount();
        OAuthToken Token = await UserApi.instance.loginWithKakaoAccount();
        String accessToken = Token.accessToken;

        await socialLoginApi(SocialLoginRequest(accessToken));

        print('카카오계정으로 로그인 성공');
        print("토큰: ${accessToken}");

        Get.offAll(Home());
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }
  }

  Future<void> socialLoginApi(SocialLoginRequest socialLoginRequest) async {
    try {
      final requestBody = socialLoginRequest.toJson();

      final response = await dio.post(
          "/api/v1/auth/login/KAKAO",
          data: requestBody
      );
      print(response.statusCode);

      if (response.statusCode == 200) {
        final responseBody = SocialLoginResponse.fromJson(response.data);

        await Future.wait([
          storage.saveAccessToken(responseBody.accessToken),
          storage.saveRefreshToken(responseBody.refreshToken)
        ]);
      }
    } catch (e) {
    print(e);
    }
  }
}