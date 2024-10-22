import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/model/notification_model.dart';
import 'package:newket/model/ticket_model.dart';
import 'package:newket/secure/auth_dio.dart';
import 'package:newket/view/v200/login/before_login.dart';

class NotificationRepository{
  Future<bool> addTicketNotification(BuildContext context, int concertId) async {
    var dio = Dio();
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'ACCESS_TOKEN');
    if (accessToken==null || accessToken.isEmpty) {
      AmplitudeConfig.amplitude.logEvent('BeforeLogin');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BeforeLogin(),
        ),
      );
      return false;
    } else {
      dio.options.baseUrl = dotenv.get("BASE_URL");
      dio.options.headers['Authorization'] = 'Bearer $accessToken';
      await dio.post("/api/v1/notifications/ticket-open?concertId=$concertId");
      return true;
    }
  }

  Future<bool> getIsTicketNotification(BuildContext context, int concertId) async {
    var dio = Dio();
    const storage = FlutterSecureStorage();
    final accessToken = await storage.read(key: 'ACCESS_TOKEN');
    if (accessToken==null || accessToken.isEmpty) {
      return false;
    } else {
      dio.options.baseUrl = dotenv.get("BASE_URL");
      dio.options.headers['Authorization'] = 'Bearer $accessToken';
      final response = await dio.get("/api/v1/notifications/ticket-open?concertId=$concertId");
      return response.data as bool;
    }
  }

  Future<void> deleteTicketNotification(BuildContext context, int concertId) async {
    var dio = await authDio(context);
    return await dio.delete("/api/v1/notifications/ticket-open?concertId=$concertId");
  }

  Future<OpeningNoticeResponse> getAllTicketNotifications(BuildContext context) async {
    var dio = await authDio(context);
    final response = await dio.get("/api/v1/notifications/ticket-open/all");

    return OpeningNoticeResponse.fromJson(response.data);
  }

  Future<void> deleteAllTicketNotifications(BuildContext context, ConcertIds concertIds) async {
    var dio = await authDio(context);
    return await dio.delete("/api/v1/notifications/ticket-open/all", data: concertIds.toJson());
  }

  Future<void> updateNotificationIsOpened(String notificationId) async {
    var dio = Dio();
    dio.options.baseUrl = dotenv.get("BASE_URL");
    await dio.post("/api/v1/notifications/opened?notificationId=$notificationId");
  }

  Future<Notifications> getAllNotifications(BuildContext context) async {
    var dio = await authDio(context);
    final response = await dio.get("/api/v1/notifications");

    return Notifications.fromJson(response.data);
  }
}