import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/repository/auth_repository.dart';
import 'package:newket/repository/user_repository.dart';
import 'package:newket/theme/Colors.dart';
import 'package:newket/view/agreement/privacy_policy.dart';
import 'package:newket/view/agreement/terms_of_service.dart';
import 'package:newket/view/favorite_artist/my_favorite_aritst.dart';
import 'package:newket/view/mypage/help.dart';
import 'package:newket/view/mypage/notification_setting.dart';
import 'package:newket/view/mypage/notification_ticket.dart';
import 'package:newket/view/onboarding/login.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyPage(),
    );
  }
}

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<StatefulWidget> createState() => _MyPage();
}

class _MyPage extends State<MyPage> {
  late UserRepository userRepository;
  late AuthRepository authRepository;
  bool artistNotification = true;
  bool ticketNotification = true;
  Color artistBackground = b_900;
  Color ticketBackground = b_900;
  String email = '';

  @override
  void initState() {
    super.initState();
    userRepository = UserRepository();
    authRepository = AuthRepository();
    _getUserInfoApi(context); // 이메일 정보 불러오기
    _loadNotificationSettings(); // 알림 설정 불러오기
  }

  Future<void> _loadNotificationSettings() async {
    try {
      final response = await userRepository.getNotificationAllow();
      // 알림 설정 값 상태에 반영
      setState(() {
        artistNotification = response.artistNotification;
        artistBackground = artistNotification ? pt_20 : b_900;
        ticketNotification = response.ticketNotification;
        ticketBackground = ticketNotification ? pt_20 : b_900;
      });
    } catch (e) {
      // 에러 처리 (로그인 페이지로 리다이렉트 또는 에러 핸들링)
      Get.offAll(const Login());
    }
  }

  Future<void> _getUserInfoApi(BuildContext context) async {
    try {
      final response = await userRepository.getUserInfoApi(context);
      // 이메일 정보를 상태에 한 번만 저장
      setState(() {
        email = response.email;
      });
    } catch (e) {
      // 에러 처리 (로그인 페이지로 리다이렉트 또는 에러 핸들링)
      Get.offAll(const Login());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: b_950,
          title: const Text(
            "마이페이지",
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 20,
              color: b_100,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        backgroundColor: p_700,
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(children: [
                //점선 위 전체
                Container(
                  width: double.infinity,
                  height: 90,
                  decoration: const ShapeDecoration(
                    color: b_950,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "사용자 계정",
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.0),
                              child: Image.asset("images/mypage/kakao.png", width: 20),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              email,
                              style: const TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 12,
                                color: b_400,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ])
                        ])),
              ]),
              // 점선
              Stack(children: [
                DottedBorder(
                  color: p_700,
                  strokeWidth: 6,
                  dashPattern: const [6, 6],
                  child: const SizedBox(
                    width: double.infinity,
                    height: 0,
                  ),
                ),
                Container(
                    height: MediaQuery.of(context).size.height - 188,
                    decoration: const ShapeDecoration(
                      color: b_950,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20, top: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                                onTap: () {
                                  AmplitudeConfig.amplitude.logEvent('MyFavoriteArtist');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const MyFavoriteArtist(),
                                    ),
                                  );
                                },
                                child: Container(
                                  color: Colors.transparent,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SvgPicture.asset("images/mypage/star.svg", height: 20, width: 20),
                                          const SizedBox(width: 8),
                                          const Text(
                                            '나의 관심 아티스트',
                                            style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontSize: 16,
                                              color: b_100,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          )
                                        ],
                                      ),
                                      const Icon(Icons.keyboard_arrow_right_rounded, color: Colors.white)
                                    ],
                                  ),
                                )),
                            const SizedBox(height: 24),
                            GestureDetector(
                                onTap: () {
                                  AmplitudeConfig.amplitude.logEvent('NotificationTicket');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const NotificationTicket(),
                                    ),
                                  );
                                },
                                child: Container(
                                    color: Colors.transparent,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            SvgPicture.asset("images/mypage/notification.svg", height: 20, width: 20),
                                            const SizedBox(width: 8),
                                            const Text(
                                              '알림 받기 신청한 티켓',
                                              style: TextStyle(
                                                fontFamily: 'Pretendard',
                                                fontSize: 16,
                                                color: b_100,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            )
                                          ],
                                        ),
                                        const Icon(Icons.keyboard_arrow_right_rounded, color: Colors.white)
                                      ],
                                    ))),
                            const SizedBox(height: 24),
                            GestureDetector(
                                onTap: () {
                                  AmplitudeConfig.amplitude.logEvent('NotificationSetting');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const NotificationSetting(),
                                    ),
                                  );
                                },
                                child: Container(
                                    color: Colors.transparent,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            SvgPicture.asset("images/mypage/ticket.svg", height: 20, width: 20),
                                            const SizedBox(width: 8),
                                            const Text(
                                              '알림 설정',
                                              style: TextStyle(
                                                fontFamily: 'Pretendard',
                                                fontSize: 16,
                                                color: b_100,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            )
                                          ],
                                        ),
                                        const Icon(Icons.keyboard_arrow_right_rounded, color: Colors.white)
                                      ],
                                    ))),
                            const SizedBox(height: 24),
                            //구분선
                            Container(color: b_800, height: 2),
                            const SizedBox(height: 24),
                            GestureDetector(
                                onTap: () {
                                  AmplitudeConfig.amplitude.logEvent('PrivacyPolicy');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const PrivacyPolicy(),
                                    ),
                                  );
                                },
                                child: Container(
                                    color: Colors.transparent,
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '개인정보처리 방침',
                                          style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Icon(Icons.keyboard_arrow_right_rounded, color: Colors.white)
                                      ],
                                    ))),
                            const SizedBox(height: 24),
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
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '서비스 이용약관',
                                          style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Icon(Icons.keyboard_arrow_right_rounded, color: Colors.white)
                                      ],
                                    ))),
                            const SizedBox(height: 24),
                            GestureDetector(
                              onTap: () {
                                AmplitudeConfig.amplitude.logEvent('Help');
                                // 문의하기 페이지로 이동
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const Help()),
                                );
                              },
                              child: Container(
                                  color: Colors.transparent,
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '문의하기',
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontSize: 14,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      Icon(Icons.keyboard_arrow_right_rounded, color: Colors.white)
                                    ],
                                  )),
                            ),
                            const SizedBox(height: 24),
                            GestureDetector(
                                onTap: () async {
                                  var storage = const FlutterSecureStorage();
                                  await storage.deleteAll();
                                  // 로그인 페이지로 이동
                                  AmplitudeConfig.amplitude.logEvent('Logout');
                                  Get.offAll(const Login());
                                },
                                child: const Text(
                                  '로그아웃',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )),
                            const SizedBox(height: 24),
                            //탈퇴하기
                            GestureDetector(
                              onTap: () async {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return Dialog(
                                      child: Container(
                                        width: 320,
                                        height: 264,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: ShapeDecoration(
                                          color: b_800,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            SvgPicture.asset("images/mypage/warning.svg", height: 32, width: 32),
                                            const SizedBox(height: 12),
                                            const Text(
                                              '잠시만요!\n정말로 탈퇴하시겠어요?',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: b_100,
                                                fontSize: 18,
                                                fontFamily: 'Pretendard',
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(height: 8),
                                            const Text(
                                              '탈퇴하시면 그동안 저장하신 관심 아티스트,\n티켓 오픈 알림 정보가 사라져요.',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: b_400,
                                                fontSize: 14,
                                                fontFamily: 'Pretendard',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                            const SizedBox(height: 24),
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                IconButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    icon: Container(
                                                        height: 48,
                                                        padding:
                                                            const EdgeInsets.symmetric(horizontal: 28, vertical: 13),
                                                        child: const Text(
                                                          '아니오',
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontFamily: 'Pretendard',
                                                            fontWeight: FontWeight.w400,
                                                          ),
                                                        ))),
                                                const SizedBox(width: 12),
                                                IconButton(
                                                    onPressed: () async {
                                                      await authRepository.withdraw(context);
                                                      var storage = const FlutterSecureStorage();
                                                      storage.deleteAll();
                                                      AmplitudeConfig.amplitude.logEvent('Withdraw');
                                                      Get.offAll(const Login());
                                                    },
                                                    icon: Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 13),
                                                      height: 48,
                                                      clipBehavior: Clip.antiAlias,
                                                      decoration: ShapeDecoration(
                                                        color: p_700,
                                                        shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(12),
                                                        ),
                                                      ),
                                                      child: const Text(
                                                        '네, 탈퇴할게요',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                          fontFamily: 'Pretendard',
                                                          fontWeight: FontWeight.w700,
                                                        ),
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                              child: const Text('회원 탈퇴',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 14,
                                    color: b_500,
                                    fontWeight: FontWeight.w400,
                                  )),
                            )
                          ],
                        )))
              ])
            ]));
  }
}
