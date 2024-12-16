import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/route_manager.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/model/auth_model.dart';
import 'package:newket/repository/user_repository.dart';
import 'package:newket/auth/auth_dio.dart';
import 'package:newket/view/login/screen/agreement_screen.dart';
import 'package:newket/view/login/screen/login_screen.dart';
import 'package:newket/view/tapbar/tab_bar.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

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
          await UserRepository().putDeviceTokenApi(serverToken!);

          AmplitudeConfig.amplitude.logEvent('카카오톡으로 로그인 성공');

          Get.offAll(const TabBarV2());
        } catch (error) {
          AmplitudeConfig.amplitude.logEvent('카카오톡으로 로그인 실패 $error');

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
            await UserRepository().putDeviceTokenApi(serverToken!);

            AmplitudeConfig.amplitude.logEvent('카카오계정으로 로그인 성공');

            Get.offAll(const TabBarV2());
          } catch (error) {
            AmplitudeConfig.amplitude.logEvent('카카오계정으로 로그인 실패 $error');
          }
        }
      } else {
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          String accessToken = token.accessToken;
          storage.write(key: 'KAKAO_TOKEN', value: accessToken);
          await socialLoginApi(SocialLoginRequest(accessToken));

          final serverToken = await storage.read(key: 'ACCESS_TOKEN');
          await UserRepository().putDeviceTokenApi(serverToken!);

          AmplitudeConfig.amplitude.logEvent('카카오계정으로 로그인 성공');

          Get.offAll(const TabBarV2());
        } catch (error) {
          AmplitudeConfig.amplitude.logEvent('카카오계정으로 로그인 실패 $error');
        }
      }
    } catch (error) {
      AmplitudeConfig.amplitude.logEvent('카카오계정으로 로그인 실패 $error');
    } finally {
      if (Get.isDialogOpen!) {
        Get.back(); // 로딩 화면을 닫음
      }
    }
  }

  Future<void> appleLoginApi() async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false, // 화면을 터치해도 닫히지 않도록 설정
    );
    // 애플 로그인
    try {
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );
      final newUserIdentifier = credential.userIdentifier.toString();
      final savedUserIdentifier = await storage.read(key: 'APPLE_SOCIAL_ID');

      if(credential.familyName!=null || savedUserIdentifier != newUserIdentifier){
        final name = "${credential.familyName.toString()}${credential.givenName.toString()}";
        storage.write(key: 'APPLE_NAME', value: name);
        storage.write(key: 'APPLE_EMAIL', value: credential.email.toString());
        storage.write(key: 'APPLE_SOCIAL_ID', value: credential.userIdentifier.toString());
      }

      await socialLoginAppleApi(SocialLoginAppleRequest(credential.userIdentifier.toString()));

      final serverToken = await storage.read(key: 'ACCESS_TOKEN');
      await UserRepository().putDeviceTokenApi(serverToken!);

      AmplitudeConfig.amplitude.logEvent('애플 계정으로 로그인 성공');

      Get.offAll(const TabBarV2());

      // Now send the credential (especially `credential.authorizationCode`) to your server to create a session
      // after they have been validated with Apple (see `Integration` section for more information on how to do this)
    } catch (error) {
      AmplitudeConfig.amplitude.logEvent('애플로 로그인 실패 $error');
    } finally {
      if (Get.isDialogOpen!) {
        Get.back(); // 로딩 화면을 닫음
      }
    }
  }

  Future<SocialLoginResponse> signUpApi(SignUpRequest signUpRequest) async {
    try {
      final requestBody = signUpRequest.toJson();

      final response = await dio.post("/api/v2/auth/signup/KAKAO", data: requestBody);

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
          AmplitudeConfig.amplitude.logEvent('SignUp error->LoginV2 $e');
          Get.offAll(() => const LoginV2());
          var storage = const FlutterSecureStorage();
          await storage.deleteAll();
        }
      }
      rethrow;
    }
  }

  Future<SocialLoginResponse> signUpAppleApi(SignUpAppleRequest signUpAppleRequest) async {
    try {
      final requestBody = signUpAppleRequest.toJson();

      final response = await dio.post("/api/v1/auth/signup/APPLE", data: requestBody);

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
          AmplitudeConfig.amplitude.logEvent('LoginV2');
          var storage = const FlutterSecureStorage();
                                  await storage.deleteAll();
        }
      }
      rethrow;
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
          AmplitudeConfig.amplitude.logEvent('AgreementV2');
          Get.offAll(() => const AgreementV2());
        }
      }
      rethrow;
    }
  }

  Future<SocialLoginResponse> socialLoginAppleApi(SocialLoginAppleRequest socialLoginAppleRequest) async {
    try {
      final requestBody = socialLoginAppleRequest.toJson();

      final response = await dio.post("/api/v1/auth/login/APPLE", data: requestBody);

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
          AmplitudeConfig.amplitude.logEvent('AgreementV2');
          Get.offAll(() => const AgreementV2());
        }
      }
      rethrow;
    }
  }

  Future<void> withdraw(BuildContext context) async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false, // 화면을 터치해도 닫히지 않도록 설정
    );
    var dio = await authDio(context);

    await dio.delete("/api/v1/auth");
  }

  Future<void> withdrawApple(BuildContext context, String authorizationCode) async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false, // 화면을 터치해도 닫히지 않도록 설정
    );
    var dio = await authDio(context);
    final requestBody = WithDrawApple(authorizationCode).toJson();

    await dio.delete("/api/v1/auth/APPLE", data: requestBody);
  }
}
