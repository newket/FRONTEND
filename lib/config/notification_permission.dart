import 'package:permission_handler/permission_handler.dart';

class NotificationPermissionManager {
  static Future<bool> isNotificationEnabled() async {
    PermissionStatus status = await Permission.notification.status;
    return status.isGranted;
  }
}
