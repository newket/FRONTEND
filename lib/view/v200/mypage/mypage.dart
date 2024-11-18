import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';
import 'package:newket/component/common/app_bar_back.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/repository/auth_repository.dart';
import 'package:newket/repository/user_repository.dart';
import 'package:newket/theme/colors.dart';
import 'package:newket/view/v200/agreement/privacy_policy.dart';
import 'package:newket/view/v200/agreement/terms_of_service.dart';
import 'package:newket/view/v200/login/login.dart';
import 'package:newket/view/v200/mypage/help.dart';
import 'package:newket/view/v200/mypage/my_favorite_artist.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class MyPageV2 extends StatefulWidget {
  const MyPageV2({super.key});

  @override
  State<StatefulWidget> createState() => _MyPageV2();
}

class _MyPageV2 extends State<MyPageV2> {
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
    _getUserInfoApi(context); // 이메일 정보 불러오기
    _loadNotificationSettings(); // 알림 설정 불러오기
  }

  Future<void> _loadNotificationSettings() async {
    try {
      final response = await userRepository.getNotificationAllow();
      // 알림 설정 값 상태에 반영
      setState(() {
        artistNotification = response.artistNotification;
        artistBackground = artistNotification ? v1pt_20 : b_900;
        ticketNotification = response.ticketNotification;
        ticketBackground = ticketNotification ? v1pt_20 : b_900;
        isLoading = false;
      });
    } catch (e) {
      // 에러 처리 (로그인 페이지로 리다이렉트 또는 에러 핸들링)
      AmplitudeConfig.amplitude.logEvent('MyPage error->LoginV2 $e');
      Get.offAll(() => const LoginV2());
      var storage = const FlutterSecureStorage();
      await storage.deleteAll();
    }
  }

  Future<void> _getUserInfoApi(BuildContext context) async {
    try {
      final response = await userRepository.getUserInfoApi(context);
      // 이메일 정보를 상태에 한 번만 저장
      setState(() {
        userName = response.name;
        email = response.email;
        provider = response.provider;
      });
    } catch (e) {
      // 에러 처리 (로그인 페이지로 리다이렉트 또는 에러 핸들링)
      AmplitudeConfig.amplitude.logEvent('MyPage error->LoginV2 $e');
      Get.offAll(() => const LoginV2());
      var storage = const FlutterSecureStorage();
      await storage.deleteAll();
    }
  }

  @override
  Widget build(BuildContext context) {
    // 로딩 중일 때 로딩 화면을 표시
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
        appBar: appBarBack(context, "마이페이지"),
        backgroundColor: Colors.white,
        body: Padding(
            padding: const EdgeInsets.only(top: 12, left: 20, right: 20),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                                style: const TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: 20,
                                  color: f_100,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset(
                                    (() {
                                      switch (provider) {
                                        case 'KAKAO':
                                          return 'images/v2/mypage/kakao.png';
                                        case 'APPLE':
                                          return 'images/v2/mypage/apple.png';
                                        default:
                                          return 'images/v2/mypage/sns_null.png';
                                      }
                                    })(),
                                    width: 20,
                                    height: 20,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  email,
                                  style: const TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 14,
                                    color: f_50,
                                    fontWeight: FontWeight.w400,
                                  ),
                                )
                              ])
                            ])),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                      onTap: () {
                        AmplitudeConfig.amplitude.logEvent('MyFavoriteArtistV2');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyFavoriteArtistV2(),
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
                                SvgPicture.asset(
                                  "images/v1/mypage/star.svg",
                                  height: 20,
                                  width: 20,
                                  color: f_70,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  '나의 관심 아티스트',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 18,
                                    color: f_100,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                            const Icon(Icons.keyboard_arrow_right_rounded, color: f_70)
                          ],
                        ),
                      )),
                  const SizedBox(height: 20),
                  Container(color: f_15, height: 2),
                  const SizedBox(height: 20),
                  Container(
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          SvgPicture.asset("images/v1/mypage/notification.svg", height: 20, width: 20, color: f_70),
                          const SizedBox(width: 8),
                          const Text(
                            '알림 설정',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 18,
                              color: f_100,
                              fontWeight: FontWeight.w600,
                            ),
                          )
                        ],
                      )),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '관심 아티스트 알림',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 16,
                                color: f_90,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '관심 아티스트의 티켓이 등록되면 알려드려요.',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 12,
                                color: f_50,
                                fontWeight: FontWeight.w400,
                              ),
                            )
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
                            await userRepository.putNotificationAllow(isAllow, "artist");
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '티켓 오픈 임박 알림',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 16,
                                color: f_90,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '티켓 오픈 하루 전, 1시간 전에 알려드려요.',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 12,
                                color: f_50,
                                fontWeight: FontWeight.w400,
                              ),
                            )
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
                            await userRepository.putNotificationAllow(isAllow, "ticket");
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(color: f_15, height: 2),
                  const SizedBox(height: 20),
                  GestureDetector(
                      onTap: () {
                        AmplitudeConfig.amplitude.logEvent('PrivacyPolicyV2');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PrivacyPolicyV2(),
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
                                  fontSize: 16,
                                  color: f_90,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Icon(Icons.keyboard_arrow_right_rounded, color: f_90)
                            ],
                          ))),
                  const SizedBox(height: 24),
                  GestureDetector(
                      onTap: () {
                        AmplitudeConfig.amplitude.logEvent('TermsOfServiceV2');
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TermsOfServiceV2(),
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
                                  fontSize: 16,
                                  color: f_90,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Icon(Icons.keyboard_arrow_right_rounded, color: f_90)
                            ],
                          ))),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: () {
                      AmplitudeConfig.amplitude.logEvent('HelpV2');
                      // 문의하기 페이지로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const HelpV2()),
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
                                fontSize: 16,
                                color: f_90,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Icon(Icons.keyboard_arrow_right_rounded, color: f_90)
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
                        Get.offAll(() => const LoginV2());
                      },
                      child: const Text(
                        '로그아웃',
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 16,
                          color: f_90,
                          fontWeight: FontWeight.w500,
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
                                color: Colors.white,
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
                                  SvgPicture.asset("images/v2/mypage/warning.svg", height: 32, width: 32),
                                  const SizedBox(height: 12),
                                  const Text(
                                    '잠시만요!\n정말로 탈퇴하시겠어요?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: f_100,
                                      fontSize: 18,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  const Text(
                                    '탈퇴하시면 그동안 저장하신 관심 아티스트,\n티켓 오픈 알림 정보가 사라져요.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: f_60,
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
                                              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 13),
                                              child: const Text(
                                                '아니오',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: f_60,
                                                  fontSize: 14,
                                                  fontFamily: 'Pretendard',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ))),
                                      const SizedBox(width: 12),
                                      IconButton(
                                          onPressed: () async {
                                            await userRepository.deleteDeviceToken();
                                            if(provider=='APPLE'){
                                              final credential = await SignInWithApple.getAppleIDCredential(
                                                scopes: [
                                                  AppleIDAuthorizationScopes.email,
                                                  AppleIDAuthorizationScopes.fullName,
                                                ],
                                              );
                                              final authorizationCode = credential.authorizationCode.toString();
                                              await authRepository.withdrawApple(context, authorizationCode);
                                            }else{
                                              await authRepository.withdraw(context);
                                            }
                                            var storage = const FlutterSecureStorage();
                                            await storage.deleteAll();
                                            AmplitudeConfig.amplitude.logEvent('Withdraw');
                                            Get.offAll(() => const LoginV2());
                                          },
                                          icon: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 13),
                                            height: 48,
                                            clipBehavior: Clip.antiAlias,
                                            decoration: ShapeDecoration(
                                              color: pn_100,
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
                          fontSize: 16,
                          color: b_500,
                          fontWeight: FontWeight.w400,
                        )),
                  )
                ])));
  }
}
