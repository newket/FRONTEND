import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:kakao_flutter_sdk_common/kakao_flutter_sdk_common.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/firebase_options.dart';
import 'package:newket/repository/notification_repository.dart';
import 'package:newket/view/v200/login/login.dart';
import 'package:newket/view/v200/tapbar/tab_bar.dart';
import 'package:newket/view/v200/ticket_detail/ticket_detail.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {}

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
              playSound: true, // 기본 사운드 재생 설정
              fullScreenIntent: true, // 화면을 깨우도록 설정
            ),
            iOS: const DarwinNotificationDetails(presentAlert: true, presentBadge: true, presentSound: true)),
        payload: json.encode({
          'notificationId': message.data['notificationId'],
          'concertId': message.data['concertId'],
        }));
  }
}

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: ".env");

    // Firebase 초기화
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    const storage = FlutterSecureStorage();

    // 설치 여부 확인 및 데이터 삭제
    bool isFirstRun = prefs.getBool('isFirstRun') ?? true;
    String? storedDeviceToken = await storage.read(key: 'DEVICE_TOKEN');

    if (isFirstRun || storedDeviceToken == null) {
      // Amplitude 시작
      AmplitudeConfig().init();
      AmplitudeConfig.amplitude.logEvent('install');
      await prefs.clear();
      await storage.deleteAll();
      await prefs.setBool('isFirstRun', false);
    }

    // Kakao SDK 초기화
    KakaoSdk.init(
      nativeAppKey: dotenv.get("NATIVE_APP_KEY"),
    );

    await [Permission.notification].request();

    //ios 메세지 수신 권한 요청
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // AndroidNotificationChannel 설정
    // FlutterLocalNotificationsPlugin 설정
    const androidInitializationSettings = AndroidInitializationSettings('logo');
    const iosInitializationSettings = DarwinInitializationSettings(
        requestAlertPermission: true, requestBadgePermission: true, requestSoundPermission: true);
    const initializationSettings =
        InitializationSettings(android: androidInitializationSettings, iOS: iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    String? deviceToken;
    // FCM 기기 토큰 가져오기
    try {
      deviceToken = await FirebaseMessaging.instance.getToken();
    } catch (e) {}

    debugPrint("deviceToken: $deviceToken");
    AmplitudeConfig.amplitude.setUserId('$deviceToken');
    storage.write(key: 'DEVICE_TOKEN', value: deviceToken);

    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    await FirebaseMessaging.instance.setDeliveryMetricsExportToBigQuery(true);

    // FCM 포어그라운드 메시지 리스너
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      showFlutterNotification(message);
    });

    // FCM 백그라운드 메시지 리스너
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      Get.to(() => TicketDetailV2(concertId: int.tryParse(message.data['concertId'])!));
      NotificationRepository().updateNotificationIsOpened(message.data['notificationId']);
    });

    // FCM terminated 메세지 리스너
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.to(() => TicketDetailV2(concertId: int.tryParse(initialMessage.data['concertId'])!));
      });
      NotificationRepository().updateNotificationIsOpened(initialMessage.data['notificationId']);
    }

    // FCM 포어그라운드 메시지 선택
    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse details) async {
        debugPrint(details.payload!);
        // payload에서 JSON 형식으로 데이터를 추출
        final Map<String, dynamic> payloadData = json.decode(details.payload!);

        // payloadData에서 concertId를 가져오기
        final String? concertId = payloadData['concertId']?.toString();
        final String? notificationId = payloadData['notificationId']?.toString();

        if (concertId != null) {
          debugPrint('concertId:${int.tryParse(concertId.toString())!}');
          Get.to(() => TicketDetailV2(concertId: int.tryParse(concertId.toString())!));
        }

        await NotificationRepository().updateNotificationIsOpened(notificationId!);
      },
    );

    String? accessToken = ""; //user의 정보를 저장하기 위한 변수
    asyncMethod() async {
      accessToken = await storage.read(key: "ACCESS_TOKEN");
      if (accessToken == null) {
        AmplitudeConfig.amplitude.logEvent('LoginV2');
        runApp(const MyApp());
      } else {
        AmplitudeConfig.amplitude.logEvent('HomeV2');
        runApp(const MyApp2());
      }
    }

    asyncMethod();
  } catch (e) {
    debugPrint('main error: $e');
    AmplitudeConfig.amplitude.logEvent('main error: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      home: Scaffold(
        body: Center(child: LoginV2()),
      ),
    );
  }
}

class MyApp2 extends StatelessWidget {
  const MyApp2({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      home: Scaffold(
        body: Center(child: TabBarV2()),
      ),
    );
  }
}
