import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:newket/firebase_options.dart';
import 'package:newket/view/onboarding/auth.dart';
import 'package:permission_handler/permission_handler.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('back title : ${message.notification?.title}, body: ${message.notification?.body}');
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
          priority: Priority.high,
         // icon: 'logo'
        ),
      ),
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
  final androidInitializationSettings = AndroidInitializationSettings('logo');
  final initializationSettings = InitializationSettings(android: androidInitializationSettings);
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // FCM 토큰 가져오기
  final fcmToken = await FirebaseMessaging.instance.getToken();
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  await FirebaseMessaging.instance.setDeliveryMetricsExportToBigQuery(true);


  print("토큰: $fcmToken");

  // FCM 포어그라운드 메시지 리스너
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    showFlutterNotification(message);
    print('title : ${message.notification?.title}, body: ${message.notification?.body}');
  });

  // FCM 백그라운드 메시지 리스너
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

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
