import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:newket/config/dio_auth.dart';
import 'package:newket/config/dio_client.dart';
import 'package:newket/model/user/notification_allow_request.dart';
import 'package:newket/model/user_model.dart';

class UserRepository {
  final storage = const FlutterSecureStorage();
  var dio = DioClient.dio;

  Future<UserInfoResponse> getUserInfoApi(BuildContext context) async {
    var dio = await authDio(context);
    final response = await dio.get("/api/v1/users");

    return UserInfoResponse.fromJson(response.data);
  }

  Future<void> postNotificationAllow(String isAllow, String target) async {
    final deviceToken = await storage.read(key: "DEVICE_TOKEN");
    final requestBody = NotificationAllowRequest(isAllow: isAllow, target: target, token: deviceToken!).toJson();

    await dio.post(
      "/api/v1/users/notification",
      data: requestBody,
      options: Options(
        headers: {
          "Content-Type": "application/json;charset=UTF-8",
        },
      ),
    );
  }

  Future<NotificationAllow> getNotificationAllow() async {
    final deviceToken = await storage.read(key: "DEVICE_TOKEN");
    final response = await dio.put("/api/v1/users/notification?token=$deviceToken");

    return NotificationAllow.fromJson(response.data);
  }

  Future<void> createHelp(BuildContext context, HelpRequest request) async {
    var dio = await authDio(context);
    final requestBody = request.toJson();

    await dio.post(
      "/api/v1/users/help",
      data: requestBody,
      options: Options(
        headers: {
          "Content-Type": "application/json;charset=UTF-8",
        },
      ),
    );
  }

  Future<void> putDeviceTokenApi(String accessToken) async {
    dio.options.headers['Authorization'] = 'Bearer $accessToken';
    final deviceToken = await FirebaseMessaging.instance.getToken();
    storage.write(key: 'DEVICE_TOKEN', value: deviceToken);
    final requestBody = UserDeviceToken(deviceToken!).toJson();

    await dio.put("/api/v1/users/device-token",
        data: requestBody,
        options: Options(
          headers: {
            "Content-Type": "application/json;charset=UTF-8",
          },
        ));
  }

  Future<void> deleteDeviceToken() async {
    final deviceToken = await storage.read(key: "DEVICE_TOKEN");
    final requestBody = UserDeviceToken(deviceToken!).toJson();

    await dio.delete(
      "/api/v1/users/device-token",
      data: requestBody,
      options: Options(
        headers: {
          "Content-Type": "application/json;charset=UTF-8",
        },
      ),
    );
  }
}
