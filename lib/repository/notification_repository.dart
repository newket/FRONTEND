import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:newket/model/notification_model.dart';
import 'package:newket/model/ticket_model.dart';
import 'package:newket/secure/auth_dio.dart';

class NotificationRepository{
  Future<void> addTicketNotification(BuildContext context, int concertId) async {
    var dio = await authDio(context);
    await dio.post("/api/v1/notifications/ticket-open?concertId=$concertId");
  }

  Future<bool> getIsTicketNotification(BuildContext context, int concertId) async {
    var dio = await authDio(context);
    final response = await dio.get("/api/v1/notifications/ticket-open?concertId=$concertId");

    return response.data as bool;
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
}