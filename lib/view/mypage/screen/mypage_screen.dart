import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';
import 'package:get/route_manager.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/constant/fonts.dart';
import 'package:newket/repository/auth_repository.dart';
import 'package:newket/repository/user_repository.dart';
import 'package:newket/view/agreement/screen/privacy_policy_screen.dart';
import 'package:newket/view/agreement/screen/terms_of_service_screen.dart';
import 'package:newket/view/login/screen/login_screen.dart';
import 'package:newket/view/mypage/screen/help_screen.dart';
import 'package:newket/view/mypage/screen/mypage_skeleton_screen.dart';
import 'package:newket/view/mypage/widget/withdraw_popup_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<StatefulWidget> createState() => _MyPageScreen();
}

class _MyPageScreen extends State<MyPageScreen> {
  late UserRepository userRepository;
  late AuthRepository authRepository;
  bool artistNotification = true;
  bool ticketNotification = true;
  Color artistBackground = b_900;
  Color ticketBackground = b_900;
  String userName = '';
  String email = '';
  String provider = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    userRepository = UserRepository();
    authRepository = AuthRepository();
    _getUserInfoApi(context);
    Smartlook.instance.trackEvent('MyPageScreen');
  }

  Future<void> _getUserInfoApi(BuildContext context) async {
    await UserRepository().putDeviceTokenApi(context);
    final response = await userRepository.getUserInfoApi(context);
    final response2 = await userRepository.getNotificationAllow();

    if (!mounted) return;

    setState(() {
      userName = response.name;
      email = response.email;
      provider = response.provider;
      artistNotification = response2.artistNotification;
      artistBackground = artistNotification ? v1pt_20 : b_900;
      ticketNotification = response2.ticketNotification;
      ticketBackground = ticketNotification ? v1pt_20 : b_900;
      isLoading = false;
      notificationAllow = isEnabled;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      bool isEnabled = await NotificationPermissionManager.isNotificationEnabled();

      if (mounted && notificationAllow!=isEnabled) {
        setState(() {
          notificationAllow = isEnabled;
        });
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 로딩 중일 때 로딩 화면을 표시
    if (isLoading) {
      return const MyPageSkeletonScreen();
    }
    return Scaffold(
        appBar: AppBar(
          title: Text('마이페이지', style: t2_18Semi(f_100)),
          backgroundColor: Colors.white,
          centerTitle: true,
          scrolledUnderElevation: 0,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
              Padding(
                  padding: const EdgeInsets.only(top: 12, left: 20, right: 20, bottom: 20),
                  child: Column(children: [
                    Container(
                      decoration: ShapeDecoration(
                        color: f_5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  userName,
                                  style: t2_18Semi(f_100),
                                ),
                                const SizedBox(height: 2),
                                Row(children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.asset(
                                      (() {
                                        switch (provider) {
                                          case 'KAKAO':
                                            return 'images/mypage/kakao.png';
                                          case 'APPLE':
                                            return 'images/mypage/apple.png';
                                          case 'NAVER':
                                            return 'images/mypage/naver.png';
                                          case 'GOOGLE':
                                            return 'images/mypage/google.png';
                                          default:
                                            return 'images/mypage/sns_null.png';
                                        }
                                      })(),
                                      width: 20,
                                      height: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    email,
                                    style: c4_12Reg(f_40),
                                  )
                                ])
                              ])),
                    )
                  ])),
              Container(color: f_10, height: 2),
              Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('알림 설정', style: s1_16Semi(f_100)),
                    const SizedBox(height: 20),
                    notificationAllow
                        ? Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('아티스트 알림', style: b8_14Med(f_90)),
                                      Text('알림 받는 아티스트의 티켓이 등록되면 알림을 보내드려요.', style: c4_12Reg(f_40))
                                    ],
                                  ),
                                  CupertinoSwitch(
                                    value: artistNotification,
                                    activeTrackColor: pn_100,
                                    onChanged: (bool value) async {
                                      // UI 상태 업데이트
                                      setState(() {
                                        artistNotification = value;
                                      });
                                      String isAllow = value ? 'on' : 'off';
                                      await userRepository.postNotificationAllow(isAllow, "artist");
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('티켓 오픈 임박 알림', style: b8_14Med(f_90)),
                                      Text('티켓 오픈 하루 전, 1시간 전에 알려드려요.', style: c4_12Reg(f_40))
                                    ],
                                  ),
                                  CupertinoSwitch(
                                    value: ticketNotification,
                                    activeTrackColor: pn_100,
                                    onChanged: (bool value) async {
                                      // UI 상태 업데이트
                                      setState(() {
                                        ticketNotification = value;
                                      });
                                      String isAllow = value ? 'on' : 'off';
                                      await userRepository.postNotificationAllow(isAllow, "ticket");
                                    },
                                  ),
                                ],
                              ),
                            ],
                          )
                        : Column(children: [
                            GestureDetector(
                                child: Container(
                                    height: 66,
                                    decoration: BoxDecoration(
                                      color: pn_05,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                    child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                      Row(
                                        children: [
                                          SvgPicture.asset("images/artist/alarm.svg", height: 24, width: 24),
                                          const SizedBox(width: 10),
                                          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                            Text("휴대폰 알림이 꺼져있어요", style: b8_14Med(f_100)),
                                            Text(
                                              "기기에서 알림을 켜야 티켓 소식을 놓치지 않아요",
                                              style: c4_12Reg(f_40),
                                            )
                                          ])
                                        ],
                                      ),
                                      Text("알림 켜기", style: button2_14Semi(pn_100))
                                    ])),
                                onTap: () async {
                                  // 알림 설정 화면 열기
                                  await openAppSettings();
                                }),
                            const SizedBox(height: 20),
                            Opacity(
                                opacity: 0.3,
                                child: Column(children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('아티스트 알림', style: b8_14Med(f_90)),
                                          Text('알림 받는 아티스트의 티켓이 등록되면 알림을 보내드려요.', style: c4_12Reg(f_40))
                                        ],
                                      ),
                                      CupertinoSwitch(
                                        value: false,
                                        activeTrackColor: pn_100,
                                        onChanged: (bool value) async {
                                          // UI 상태 업데이트
                                          setState(() {
                                            artistNotification = value;
                                          });
                                          String isAllow = value ? 'on' : 'off';
                                          await userRepository.postNotificationAllow(isAllow, "artist");
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('티켓 오픈 임박 알림', style: b8_14Med(f_90)),
                                          Text('티켓 오픈 하루 전, 1시간 전에 알려드려요.', style: c4_12Reg(f_40))
                                        ],
                                      ),
                                      CupertinoSwitch(
                                        value: false,
                                        activeTrackColor: pn_100,
                                        onChanged: (bool value) async {
                                          // UI 상태 업데이트
                                          setState(() {
                                            ticketNotification = value;
                                          });
                                          String isAllow = value ? 'on' : 'off';
                                          await userRepository.postNotificationAllow(isAllow, "ticket");
                                        },
                                      ),
                                    ],
                                  )
                                ]))
                          ])
                  ])),
              Container(color: f_10, height: 2),
              Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PrivacyPolicyScreen(),
                            ),
                          );
                        },
                        child: Container(
                            color: Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '개인정보처리 방침',
                                  style: b8_14Med(f_90),
                                ),
                                const Icon(Icons.arrow_forward_ios_rounded, color: f_90, size: 20)
                              ],
                            ))),
                    const SizedBox(height: 20),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const TermsOfService(),
                            ),
                          );
                        },
                        child: Container(
                            color: Colors.transparent,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '서비스 이용약관',
                                  style: b8_14Med(f_90),
                                ),
                                const Icon(Icons.arrow_forward_ios_rounded, color: f_90, size: 20)
                              ],
                            ))),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        // 문의하기 페이지로 이동
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const HelpScreen()),
                        );
                      },
                      child: Container(
                          color: Colors.transparent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '문의하기',
                                style: b8_14Med(f_90),
                              ),
                              const Icon(Icons.arrow_forward_ios_rounded, color: f_90, size: 20)
                            ],
                          )),
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                        onTap: () async {
                          if (provider == 'NAVER') {
                            await FlutterNaverLogin.logOut();
                          }
                          await userRepository.deleteDeviceToken();
                          var storage = const FlutterSecureStorage();
                          await storage.deleteAll();
                          // 로그인 페이지로 이동
                          Get.offAll(() => const LoginScreen());
                        },
                        child: Text('로그아웃', style: b8_14Med(f_90))),
                    const SizedBox(height: 24),
                    //탈퇴하기
                    GestureDetector(
                        onTap: () async {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                insetPadding: EdgeInsets.zero,
                                child: WithdrawPopupWidget(onConfirm: () async {
                                  await userRepository.deleteDeviceToken();
                                  if (provider == 'NAVER') {
                                    await FlutterNaverLogin.logOut();
                                  }
                                  if (provider == 'APPLE') {
                                    final credential = await SignInWithApple.getAppleIDCredential(
                                      scopes: [
                                        AppleIDAuthorizationScopes.email,
                                        AppleIDAuthorizationScopes.fullName,
                                      ],
                                    );
                                    final authorizationCode = credential.authorizationCode.toString();
                                    await authRepository.withdrawApple(context, authorizationCode);
                                  } else {
                                    await authRepository.withdraw(context);
                                  }
                                  var storage = const FlutterSecureStorage();
                                  final prefs = await SharedPreferences.getInstance();
                                  await storage.deleteAll();
                                  await prefs.clear();
                                  Get.offAll(() => const LoginScreen());
                                }),
                              );
                            },
                          );
                        },
                        child: Text('회원 탈퇴', style: b9_14Reg(f_50))),
                    const SizedBox(height: 100)
                  ]))
            ])));
  }
}
