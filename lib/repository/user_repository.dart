import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:newket/model/user_model.dart';
import 'package:newket/auth/auth_dio.dart';

class UserRepository {
  final storage = const FlutterSecureStorage();

  Future<UserInfoResponse> getUserInfoApi(BuildContext context) async {
    var dio = await authDio(context);

    final response = await dio.get("/api/v1/users");
    return UserInfoResponse.fromJson(response.data);
  }

  Future<NotificationAllow> getNotificationAllow() async {
    var dio = Dio();
    dio.options.baseUrl = dotenv.get("BASE_URL");
    final deviceToken = await storage.read(key: "DEVICE_TOKEN");
    final requestBody = UserDeviceToken(deviceToken!).toJson();

    final response = await dio.get("/api/v1/users/notification", data: requestBody);

    return NotificationAllow.fromJson(response.data);
  }

  Future<void> putNotificationAllow(String isAllow, String target) async {
    var dio = Dio();
    dio.options.baseUrl = dotenv.get("BASE_URL");
    final deviceToken = await storage.read(key: "DEVICE_TOKEN");
    final requestBody = UserDeviceToken(deviceToken!).toJson();

    await dio.put("/api/v1/users/notification?isAllow=$isAllow&target=$target", data: requestBody);
  }

  Future<void> createHelp(BuildContext context, HelpRequest request) async {
    var dio = await authDio(context);
    final requestBody = request.toJson();

    await dio.post("/api/v2/users/help", data: requestBody);
  }


  Future<void> putDeviceTokenApi(String accessToken) async {
    var dio = Dio();
    dio.options.baseUrl = dotenv.get("BASE_URL");
    dio.options.headers['Authorization'] = 'Bearer $accessToken';
    final deviceToken = await FirebaseMessaging.instance.getToken();
    storage.write(key: 'DEVICE_TOKEN', value: deviceToken);
    final requestBody = UserDeviceToken(deviceToken!).toJson();

    await dio.put("/api/v1/users/device-token", data: requestBody);
  }


  Future<void> deleteDeviceToken() async {
    var dio = Dio();
    dio.options.baseUrl = dotenv.get("BASE_URL");
    final deviceToken = await storage.read(key: "DEVICE_TOKEN");
    final requestBody = UserDeviceToken(deviceToken!).toJson();

    await dio.delete("/api/v1/users/device-token", data: requestBody);
  }
}
