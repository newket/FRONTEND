import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:newket/firebase_options.dart';
import 'package:newket/repository/notification_repository.dart';
import 'package:newket/view/onboarding/login.dart';
import 'package:permission_handler/permission_handler.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await NotificationRepository().updateNotificationIsOpened(message.data['notificationId']);
}

AndroidNotificationChannel channel = const AndroidNotificationChannel(
  'newket', // id
  'newket notification', // title
  importance: Importance.max,
);

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void showFlutterNotification(RemoteMessage message) {
  RemoteNotification? notification = message.notification;
  AndroidNotification? android = message.notification?.android;
  if (notification != null && android != null) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      message.notification?.title,
      message.notification?.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          importance: Importance.max,
          priority: Priority.max,
        ),
      ),
      payload: message.data['notificationId']
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await [Permission.notification].request();

  // Kakao SDK 초기화
  KakaoSdk.init(
    nativeAppKey: dotenv.get("NATIVE_APP_KEY"),
  );

  // Firebase 초기화
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);


  // AndroidNotificationChannel 설정
  // FlutterLocalNotificationsPlugin 설정
  const androidInitializationSettings = AndroidInitializationSettings('logo');
  const initializationSettings = InitializationSettings(android: androidInitializationSettings);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // FCM 기기 토큰 가져오기
  final deviceToken = await FirebaseMessaging.instance.getToken();
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  await FirebaseMessaging.instance.setDeliveryMetricsExportToBigQuery(true);


  print("디바이스 토큰: $deviceToken");

  // FCM 포어그라운드 메시지 리스너
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    showFlutterNotification(message);
  });

  // FCM 백그라운드 메시지 리스너
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  //종료시 메세지 리스너
  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    await NotificationRepository().updateNotificationIsOpened(initialMessage.data['notificationId']);
  }


  // 선택된 알림 처리
  flutterLocalNotificationsPlugin.initialize(initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse details) async {
    await NotificationRepository().updateNotificationIsOpened(details.payload!);
    },
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      home: Scaffold(
        body: Center(child: Login()),
      ),
    );
  }
}
