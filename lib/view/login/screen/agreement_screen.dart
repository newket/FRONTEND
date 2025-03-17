import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/model/auth_model.dart';
import 'package:newket/repository/auth_repository.dart';
import 'package:newket/repository/user_repository.dart';
import 'package:newket/view/agreement/screen/privacy_policy_screen.dart';
import 'package:newket/view/agreement/screen/terms_of_service_screen.dart';
import 'package:newket/view/login/screen/login_screen.dart';
import 'package:newket/view/tapbar/screen/tab_bar_screen.dart';

class AgreementScreen extends StatefulWidget {
  const AgreementScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AgreementScreen();
}

class _AgreementScreen extends State<AgreementScreen> {
  bool isAllSelected = false; // 전체 동의 체크 상태
  bool is1Selected = false; // 첫 번째 개별 동의 체크 상태
  bool is2Selected = false; // 두 번째 개별 동의 체크 상태
  String svgAll = 'images/login/checkbox_off.svg';
  String svg1 = 'images/login/checkbox_off.svg';
  String svg2 = 'images/login/checkbox_off.svg';
  Color agreementColor = pn_05;
  Color agreementStrokeColor = pn_10;

  void _toggleAll() {
    setState(() {
      isAllSelected = !isAllSelected;
      is1Selected = isAllSelected; // 전체 동의 시 첫 번째 개별 동의도 같이 변경
      is2Selected = isAllSelected; // 전체 동의 시 두 번째 개별 동의도 같이 변경
      svgAll = isAllSelected ? 'images/login/checkbox_on.svg' : 'images/login/checkbox_off.svg';
      svg1 = is1Selected ? 'images/login/checkbox_on.svg' : 'images/login/checkbox_off.svg';
      svg2 = is2Selected ? 'images/login/checkbox_on.svg' : 'images/login/checkbox_off.svg';
      agreementColor = isAllSelected ? pt_10 : pn_05;
      agreementStrokeColor = isAllSelected ? pn_20 : pn_10;
    });
  }

  void _toggle1() {
    setState(() {
      is1Selected = !is1Selected;
      // 전체 동의 체크박스 상태 업데이트
      isAllSelected = is1Selected && is2Selected;
      svgAll = isAllSelected ? 'images/login/checkbox_on.svg' : 'images/login/checkbox_off.svg';
      svg1 = is1Selected ? 'images/login/checkbox_on.svg' : 'images/login/checkbox_off.svg';
      svg2 = is2Selected ? 'images/login/checkbox_on.svg' : 'images/login/checkbox_off.svg';
      agreementColor = isAllSelected ? pt_10 : pn_05;
      agreementStrokeColor = isAllSelected ? pn_20 : pn_10;
    });
  }

  void _toggle2() {
    setState(() {
      is2Selected = !is2Selected;
      // 전체 동의 체크박스 상태 업데이트
      isAllSelected = is1Selected && is2Selected;
      svgAll = isAllSelected ? 'images/login/checkbox_on.svg' : 'images/login/checkbox_off.svg';
      svg1 = is1Selected ? 'images/login/checkbox_on.svg' : 'images/login/checkbox_off.svg';
      svg2 = is2Selected ? 'images/login/checkbox_on.svg' : 'images/login/checkbox_off.svg';
      agreementColor = isAllSelected ? pt_10 : pn_05;
      agreementStrokeColor = isAllSelected ? pn_20 : pn_10;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                //AmplitudeConfig.amplitude.logEvent('Agreement->Login');
                Get.offAll(() => const LoginScreen());
              },
              color: f_90,
              icon: const Icon(Icons.arrow_back_ios_new_rounded)),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            "약관동의",
            style: TextStyle(
              color: f_100,
              fontSize: 16,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w600,
              height: 0.09,
              letterSpacing: -0.48,
            ),
          )),
      body: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(left: 20, right: 20, top: 16),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(children: [
                      Text(
                        "약관에 동의해주세요",
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 24,
                          color: f_100,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "뉴켓에서 티켓 오픈 소식을\n 전해드리고자 약관 동의를 받고 있어요!",
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 14,
                          color: f_60,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ]),
                    Image.asset("images/login/ticket_check.png", width: 220),
                    Column(
                      children: [
                        Container(
                          height: 60,
                          padding: const EdgeInsets.all(16),
                          decoration: ShapeDecoration(
                            color: agreementColor,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 1, color: pt_10),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GestureDetector(
                                  onTap: _toggleAll,
                                  child: SvgPicture.asset(
                                    svgAll,
                                    width: 24,
                                    height: 24,
                                  )),
                              const SizedBox(width: 16),
                              const Text(
                                '약관 전체 동의',
                                style: TextStyle(
                                  color: f_100,
                                  fontSize: 18,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        GestureDetector(
                            onTap: () {
                              //AmplitudeConfig.amplitude.logEvent('TermsOfService');
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const TermsOfService()),
                              );
                            },
                            child: Container(
                                height: 24,
                                padding: const EdgeInsets.only(left: 16),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                              onTap: _toggle1,
                                              child: SvgPicture.asset(
                                                svg1,
                                                width: 24,
                                                height: 24,
                                              )),
                                          const SizedBox(width: 16),
                                          const Text(
                                            '서비스 이용약관 동의',
                                            style: TextStyle(
                                              color: f_90,
                                              fontSize: 14,
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Text('필수',
                                              style: TextStyle(
                                                color: pn_100,
                                                fontSize: 12,
                                                fontFamily: 'Pretendard',
                                                fontWeight: FontWeight.w400,
                                                height: 0.11,
                                              ))
                                        ],
                                      ),
                                      const Icon(Icons.keyboard_arrow_right_rounded, color: f_60),
                                    ]))),
                        const SizedBox(height: 24),
                        GestureDetector(
                            onTap: () {
                              //AmplitudeConfig.amplitude.logEvent('PrivacyPolicy');
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const PrivacyPolicyScreen()),
                              );
                            },
                            child: Container(
                                height: 24,
                                padding: const EdgeInsets.only(left: 16),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                              onTap: _toggle2,
                                              child: SvgPicture.asset(
                                                svg2,
                                                width: 24,
                                                height: 24,
                                              )),
                                          const SizedBox(width: 16),
                                          const Text(
                                            '개인정보 수집 및 이용 동의',
                                            style: TextStyle(
                                              color: f_90,
                                              fontSize: 14,
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          const Text('필수',
                                              style: TextStyle(
                                                color: pn_100,
                                                fontSize: 12,
                                                fontFamily: 'Pretendard',
                                                fontWeight: FontWeight.w400,
                                                height: 0.11,
                                              ))
                                        ],
                                      ),
                                      const Icon(Icons.keyboard_arrow_right_rounded, color: f_60),
                                    ]))),
                        const SizedBox(height: 68),
                      ],
                    )
                  ],
                )),
              ])),
      bottomNavigationBar: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width - 40,
          height: 88 + MediaQuery.of(context).viewPadding.bottom,
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom + 20, top: 12, left: 20, right: 20),
          child: isAllSelected
              ? ElevatedButton(
                  onPressed: () async {
                    Get.dialog(
                      const Center(
                        child: CircularProgressIndicator(),
                      ),
                      barrierDismissible: false, // 화면 터치해도 닫히지 않음
                    );
                    try {
                      // 여기에 실제 회원가입 API 호출
                      var storage = const FlutterSecureStorage();

                      String? provider = await storage.read(key: 'SOCIAL_PROVIDER');
                      //signup
                      if (provider == 'APPLE') {
                        String? name = await storage.read(key: 'APPLE_NAME');
                        String? email = await storage.read(key: 'APPLE_EMAIL');
                        String? socialId = await storage.read(key: 'APPLE_SOCIAL_ID');

                        await AuthRepository()
                            .signUpAppleApi(SignUpAppleRequest(name: name!, email: email!, socialId: socialId!));

                        await storage.delete(key: 'APPLE_NAME');
                        await storage.delete(key: 'APPLE_EMAIL');
                        await storage.delete(key: 'APPLE_SOCIAL_ID');
                        await storage.delete(key: 'SOCIAL_PROVIDER');
                      } else if (provider == 'NAVER') {
                        String? name = await storage.read(key: 'NAVER_NAME');
                        String? email = await storage.read(key: 'NAVER_EMAIL');
                        String? socialId = await storage.read(key: 'NAVER_SOCIAL_ID');

                        await AuthRepository()
                            .signUpNaverApi(SignUpAppleRequest(name: name!, email: email!, socialId: socialId!));

                        await storage.delete(key: 'NAVER_NAME');
                        await storage.delete(key: 'NAVER_EMAIL');
                        await storage.delete(key: 'NAVER_SOCIAL_ID');
                        await storage.delete(key: 'SOCIAL_PROVIDER');
                      } else if (provider == 'KAKAO') {
                        String? kakaoToken = await storage.read(key: 'KAKAO_TOKEN');

                        await AuthRepository().signUpKakaoApi(SignUpRequest(kakaoToken!));

                        await storage.delete(key: 'KAKAO_TOKEN');
                        await storage.delete(key: 'SOCIAL_PROVIDER');
                      }

                      await UserRepository().putDeviceTokenApi(context);
                      //AmplitudeConfig.amplitude.logEvent('Home');
                      // 성공적으로 끝났을 때 다이얼로그 닫기
                      Get.back();
                      // 성공 후 다음 화면으로 이동
                      Get.offAll(() => const TabBarScreen());
                    } catch (e) {
                      // 오류 발생 시 다이얼로그 닫기
                      Get.back();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: pn_100,
                    // 버튼 색상
                    padding: const EdgeInsets.all(12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(0, 48),
                    // 버튼 높이 조정
                    shadowColor: Colors.transparent,
                  ).copyWith(
                    splashFactory: NoSplash.splashFactory,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '다음',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                )
              : ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    // 그림자 없앰
                    backgroundColor: f_10,
                    padding: const EdgeInsets.all(12),
                    minimumSize: const Size(0, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    shadowColor: Colors.transparent,
                  ).copyWith(
                    splashFactory: NoSplash.splashFactory,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '다음',
                        style: TextStyle(
                          color: f_30,
                          fontSize: 16,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ))),
    );
  }
}
