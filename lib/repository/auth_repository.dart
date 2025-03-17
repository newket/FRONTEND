import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/route_manager.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:newket/config/dio_auth.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/config/dio_client.dart';
import 'package:newket/model/auth_model.dart';
import 'package:newket/repository/user_repository.dart';
import 'package:newket/view/login/screen/agreement_screen.dart';
import 'package:newket/view/login/screen/login_screen.dart';
import 'package:newket/view/tapbar/screen/tab_bar_screen.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthRepository {
  var dio = DioClient.dio;
  var storage = const FlutterSecureStorage();

  Future<void> kakaoLoginApi(BuildContext context) async {
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
          OAuthToken token = await UserApi.instance.loginWithKakaoTalk();
          String accessToken = token.accessToken;
          storage.write(key: 'KAKAO_TOKEN', value: accessToken);

          try {
            await socialLoginKakaoApi(SocialLoginRequest(accessToken));

            await UserRepository().putDeviceTokenApi(context);

            //AmplitudeConfig.amplitude.logEvent('카카오톡으로 로그인 성공');

            Get.offAll(() => const TabBarScreen());
          } catch (error) {
            //response 가 400이면 약관 동의 페이지
          }
        } catch (error) {
          // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
          // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
          if (error is PlatformException && error.code == 'CANCELED') {
            return;
          }
          try {
            OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
            String accessToken = token.accessToken;
            storage.write(key: 'KAKAO_TOKEN', value: accessToken);

            try {
              await socialLoginKakaoApi(SocialLoginRequest(accessToken));

              await UserRepository().putDeviceTokenApi(context);

              //AmplitudeConfig.amplitude.logEvent('카카오톡으로 로그인 성공');

              Get.offAll(() => const TabBarScreen());
            } catch (error) {
              //response 가 400이면 약관 동의 페이지
            }
          } catch (error) {
            //AmplitudeConfig.amplitude.logEvent('카카오계정으로 로그인 실패 $error');
          }
        }
      } else {
        try {
          OAuthToken token = await UserApi.instance.loginWithKakaoAccount();
          String accessToken = token.accessToken;
          storage.write(key: 'KAKAO_TOKEN', value: accessToken);

          try {
            await socialLoginKakaoApi(SocialLoginRequest(accessToken));

            await UserRepository().putDeviceTokenApi(context);

            //AmplitudeConfig.amplitude.logEvent('카카오계정으로 로그인 성공');

            Get.offAll(() => const TabBarScreen());
          } catch (error) {
            //response 가 400이면 약관 동의 페이지
          }
        } catch (error) {
          //AmplitudeConfig.amplitude.logEvent('카카오계정으로 로그인 실패 $error');
        }
      }
    } catch (error) {
      //AmplitudeConfig.amplitude.logEvent('카카오로그인 실패 $error');
    } finally {
      if (Get.isDialogOpen!) {
        Get.back(); // 로딩 화면을 닫음
      }
    }
  }

  Future<void> appleLoginApi(BuildContext context) async {
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

      if (credential.familyName != null || savedUserIdentifier != newUserIdentifier) {
        final name = "${credential.familyName.toString()}${credential.givenName.toString()}";
        storage.write(key: 'APPLE_NAME', value: name);
        storage.write(key: 'APPLE_EMAIL', value: credential.email.toString());
        storage.write(key: 'APPLE_SOCIAL_ID', value: credential.userIdentifier.toString());
      }
      final authorizationCode = credential.authorizationCode.toString();
      print(authorizationCode);

      try {
        await socialLoginAppleApi(SocialLoginAppleRequest(credential.userIdentifier.toString()));

        final serverToken = await storage.read(key: 'ACCESS_TOKEN');
        await UserRepository().putDeviceTokenApi(context);

        //AmplitudeConfig.amplitude.logEvent('애플 계정으로 로그인 성공');

        Get.offAll(() => const TabBarScreen());
      } catch (error) {
        //response 가 400이면 약관 동의 페이지
      }
    } catch (error) {
      //AmplitudeConfig.amplitude.logEvent('애플로 로그인 실패 $error');
    } finally {
      if (Get.isDialogOpen!) {
        Get.back(); // 로딩 화면을 닫음
      }
    }
  }

  Future<void> naverLoginApi(BuildContext context) async {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(),
      ),
      barrierDismissible: false, // 화면을 터치해도 닫히지 않도록 설정
    );
    try {
      NaverLoginResult result = await FlutterNaverLogin.logIn();
      // 사용자 취소
      if (result.status == NaverLoginStatus.cancelledByUser || result.status == NaverLoginStatus.error) {
        return;
      } else{
        storage.write(key: 'NAVER_NAME', value: result.account.name);
        storage.write(key: 'NAVER_EMAIL', value: result.account.email);
        storage.write(key: 'NAVER_SOCIAL_ID', value: result.account.id);

        try {
          await socialLoginNaverApi(SocialLoginAppleRequest(result.account.id));

          await UserRepository().putDeviceTokenApi(context);

          Get.offAll(() => const TabBarScreen());
        } catch (error) {
          //response 가 400이면 약관 동의 페이지
        }
      }
    } catch (error) {
      //AmplitudeConfig.amplitude.logEvent('애플로 로그인 실패 $error');
    } finally {
      if (Get.isDialogOpen!) {
        Get.back(); // 로딩 화면을 닫음
      }
    }
  }

  Future<SocialLoginResponse> signUpKakaoApi(SignUpRequest signUpRequest) async {
    try {
      final requestBody = signUpRequest.toJson();

      final response = await dio.post(
        "/api/v1/auth/signup/KAKAO",
        data: requestBody,
        options: Options(
          headers: {
            "Content-Type": "application/json;charset=UTF-8",
          },
        ),
      );

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
          //AmplitudeConfig.amplitude.logEvent('SignUp error->Login $e');
          Get.offAll(() => const LoginScreen());
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

      final response = await dio.post(
        "/api/v1/auth/signup/APPLE",
        data: requestBody,
        options: Options(
          headers: {
            "Content-Type": "application/json;charset=UTF-8",
          },
        ),
      );

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
          //AmplitudeConfig.amplitude.logEvent('Login');
          var storage = const FlutterSecureStorage();
          await storage.deleteAll();
        }
      }
      rethrow;
    }
  }

  Future<SocialLoginResponse> signUpNaverApi(SignUpAppleRequest signUpAppleRequest) async {
    try {
      final requestBody = signUpAppleRequest.toJson();

      final response = await dio.post(
        "/api/v1/auth/signup/NAVER",
        data: requestBody,
        options: Options(
          headers: {
            "Content-Type": "application/json;charset=UTF-8",
          },
        ),
      );

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
          //AmplitudeConfig.amplitude.logEvent('Login');
          var storage = const FlutterSecureStorage();
          await storage.deleteAll();
        }
      }
      rethrow;
    }
  }

  Future<void> socialLoginKakaoApi(SocialLoginRequest socialLoginRequest) async {
    try {
      final requestBody = socialLoginRequest.toJson();
      print('requestBody: $requestBody'); // 디버깅을 위한 로그 추가

      final response = await dio.post(
        "/api/v1/auth/login/KAKAO",
        data: requestBody,
        options: Options(
          headers: {
            "Content-Type": "application/json;charset=UTF-8",
          },
        ),
      );

      final responseBody = SocialLoginResponse.fromJson(response.data);

      await Future.wait([
        storage.write(key: 'ACCESS_TOKEN', value: responseBody.accessToken),
        storage.write(key: 'REFRESH_TOKEN', value: responseBody.refreshToken)
      ]);
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 400) {
          // 온보딩 페이지로 이동
          storage.write(key: 'SOCIAL_PROVIDER', value: 'KAKAO');
          //AmplitudeConfig.amplitude.logEvent('Agreement');
          Get.offAll(() => const AgreementScreen());
          return; // 여기서 예외를 다시 throw하지 않음
        }
      }
      rethrow; // 다른 예외는 그대로 던지기
    }
  }

  Future<void> socialLoginAppleApi(SocialLoginAppleRequest socialLoginAppleRequest) async {
    try {
      final requestBody = socialLoginAppleRequest.toJson();

      final response = await dio.post(
        "/api/v1/auth/login/APPLE",
        data: requestBody,
        options: Options(
          headers: {
            "Content-Type": "application/json;charset=UTF-8",
          },
        ),
      );

      final responseBody = SocialLoginResponse.fromJson(response.data);

      await Future.wait([
        storage.write(key: 'ACCESS_TOKEN', value: responseBody.accessToken),
        storage.write(key: 'REFRESH_TOKEN', value: responseBody.refreshToken)
      ]);
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 400) {
          // 온보딩 페이지로 이동
          storage.write(key: 'SOCIAL_PROVIDER', value: 'APPLE');
          //AmplitudeConfig.amplitude.logEvent('Agreement');
          Get.offAll(() => const AgreementScreen());
          return; // 여기서 예외를 다시 throw하지 않음
        }
      }
      rethrow; // 다른 예외는 그대로 던지기
    }
  }

  Future<void> socialLoginNaverApi(SocialLoginAppleRequest socialLoginAppleRequest) async {
    try {
      final requestBody = socialLoginAppleRequest.toJson();

      final response = await dio.post(
        "/api/v1/auth/login/NAVER",
        data: requestBody,
        options: Options(
          headers: {
            "Content-Type": "application/json;charset=UTF-8",
          },
        ),
      );

      final responseBody = SocialLoginResponse.fromJson(response.data);

      await Future.wait([
        storage.write(key: 'ACCESS_TOKEN', value: responseBody.accessToken),
        storage.write(key: 'REFRESH_TOKEN', value: responseBody.refreshToken)
      ]);
    } catch (e) {
      if (e is DioException) {
        if (e.response?.statusCode == 400) {
          // 온보딩 페이지로 이동
          storage.write(key: 'SOCIAL_PROVIDER', value: 'NAVER');
          //AmplitudeConfig.amplitude.logEvent('Agreement');
          Get.offAll(() => const AgreementScreen());
          return; // 여기서 예외를 다시 throw하지 않음
        }
      }
      rethrow; // 다른 예외는 그대로 던지기
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

    await dio.delete(
      "/api/v1/auth/APPLE",
      data: requestBody,
      options: Options(
        headers: {
          "Content-Type": "application/json;charset=UTF-8",
        },
      ),
    );
  }
}
