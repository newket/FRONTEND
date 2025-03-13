import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/route_manager.dart';
import 'package:newket/config/amplitude_config.dart';
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
  }

  Future<void> _getUserInfoApi(BuildContext context) async {
    var storage = const FlutterSecureStorage();
    final serverToken = await storage.read(key: 'ACCESS_TOKEN');
    await UserRepository().putDeviceTokenApi(serverToken!);
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
    });
  }

  @override
  Widget build(BuildContext context) {
    // 로딩 중일 때 로딩 화면을 표시
    if (isLoading) {
      return const MyPageSkeletonScreen();
    }
    return Scaffold(
        appBar: AppBar(title: Text('마이페이지', style: t2_18Semi(f_100)), backgroundColor: Colors.white, centerTitle: true),
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
                          activeColor: pn_100,
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
                          activeColor: pn_100,
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
                  ])),
              Container(color: f_10, height: 2),
              Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    GestureDetector(
                        onTap: () {
                          AmplitudeConfig.amplitude.logEvent('PrivacyPolicy');
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
                          AmplitudeConfig.amplitude.logEvent('TermsOfService');
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
                        AmplitudeConfig.amplitude.logEvent('Help');
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
                          await userRepository.deleteDeviceToken();
                          var storage = const FlutterSecureStorage();
                          await storage.deleteAll();
                          // 로그인 페이지로 이동
                          AmplitudeConfig.amplitude.logEvent('Logout');
                          Get.offAll(() => const LoginScreen());
                        },
                        child: Text(
                          '로그아웃',
                          style: b8_14Med(f_90),
                        )),
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
                                  AmplitudeConfig.amplitude.logEvent('Withdraw');
                                  Get.offAll(() => const LoginScreen());
                                }),
                              );
                            },
                          );
                        },
                        child: Text('회원 탈퇴', style: b9_14Reg(f_50)))
                  ]))
            ])));
  }
}
