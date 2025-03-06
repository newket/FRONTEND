import 'package:newket/config/dio_client.dart';

class NotificationRepository {
  var dio = DioClient.dio;

  Future<void> updateNotificationIsOpened(String notificationId) async {
    await dio.post("/api/v1/notifications/opened?notificationId=$notificationId");
  }
}
