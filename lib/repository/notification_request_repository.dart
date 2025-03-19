import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newket/config/dio_auth.dart';
import 'package:newket/model/notification_request/artist_notification_response.dart';
import 'package:newket/model/ticket/before_sale_ticket_response.dart';
import 'package:newket/model/ticket/on_sale_response.dart';
import 'package:newket/view/login/screen/before_login_screen.dart';

class NotificationRequestRepository {
  // 아티스트 알림 추가
  Future<bool> postArtistNotification(int artistId, BuildContext context) async {
    try {
      var dio = await authDio(context);
      await dio.post("/api/v1/notification-requests/artists/$artistId");
      return true;
    } on DioException catch (e) {
      Get.to(() => const BeforeLoginScreen());
      return false;
    }
  }

  // 아티스트 알림 여부
  Future<bool> isArtistNotification(int artistId, BuildContext context) async {
    try {
      var dio = await authDio(context);
      final response = await dio.get("/api/v1/notification-requests/artists/$artistId");
      return response.data as bool;
    } on DioException catch (e) {
      return false;
    }
  }

  // 아티스트 알림 삭제
  Future<void> deleteArtistNotification(int artistId, BuildContext context) async {
    var dio = await authDio(context);
    await dio.delete("/api/v1/notification-requests/artists/$artistId");
  }

  // 티켓 알림 추가
  Future<bool> postTicketNotification(BuildContext context, int ticketId) async {
    try {
      var dio = await authDio(context);
      await dio.post("/api/v1/notification-requests/tickets/$ticketId");
      return true;
    } on DioException catch (e) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const BeforeLoginScreen(),
        ),
      );
      return false;
    }
  }

  // 티켓 알림 여부
  Future<bool> isTicketNotification(BuildContext context, int ticketId) async {
    try {
      var dio = await authDio(context);
      final response = await dio.get("/api/v1/notification-requests/tickets/$ticketId");
      return response.data as bool;
    } on DioException catch (e) {
      return false;
    }
  }

  // 티켓 삭제
  Future<void> deleteTicketNotification(BuildContext context, int ticketId) async {
    var dio = await authDio(context);
    return await dio.delete("/api/v1/notification-requests/tickets/$ticketId");
  }

  // 아티스트 알림 불러오기
  Future<ArtistNotificationResponse> getAllArtistNotification(BuildContext context) async {
    var dio = await authDio(context);
    final response = await dio.get("/api/v1/notification-requests/artists");

    return ArtistNotificationResponse.fromJson(response.data);
  }

  // 아티스트 알림받는 오픈 예정 티켓
  Future<BeforeSaleTicketsResponse> getAllBeforeSaleTicketNotification(BuildContext context) async {
    var dio = await authDio(context);
    final response = await dio.get("/api/v1/notification-requests/artists/before-sale");

    return BeforeSaleTicketsResponse.fromJson(response.data);
  }

  // 아티스트 알림받는 예매 중인 티켓
  Future<OnSaleResponse> getAllArtistOnSaleTicket(BuildContext context) async {
    var dio = await authDio(context);
    final response = await dio.get("/api/v1/notification-requests/artists/on-sale");

    return OnSaleResponse.fromJson(response.data);
  }

  // 티켓 알림 불러오기 - 오픈 예정 티켓
  Future<BeforeSaleTicketsResponse> getAllTicketNotification(BuildContext context) async {
    var dio = await authDio(context);
    final response = await dio.get("/api/v1/notification-requests/tickets");

    return BeforeSaleTicketsResponse.fromJson(response.data);
  }
}
