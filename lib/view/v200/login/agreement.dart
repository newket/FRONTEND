import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/model/auth_model.dart';
import 'package:newket/repository/auth_repository.dart';
import 'package:newket/theme/colors.dart';
import 'package:newket/view/v200/agreement/privacy_policy.dart';
import 'package:newket/view/v200/agreement/terms_of_service.dart';
import 'package:newket/view/v200/home/home.dart';
import 'package:newket/view/v200/tapbar/tab_bar.dart';


class AgreementV2 extends StatefulWidget {
  const AgreementV2({super.key});

  @override
  State<StatefulWidget> createState() => _AgreementV2();
}

class _AgreementV2 extends State<AgreementV2> {
  bool isAllSelected = false; // 전체 동의 체크 상태
  bool is1Selected = false; // 첫 번째 개별 동의 체크 상태
  bool is2Selected = false; // 두 번째 개별 동의 체크 상태
  String svgAll = 'images/v2/login/checkbox_off.svg';
  String svg1 = 'images/v2/login/checkbox_off.svg';
  String svg2 = 'images/v2/login/checkbox_off.svg';
  Color agreementColor = np_05;
  Color agreementStrokeColor = np_10;

  void _toggleAll() {
    setState(() {
      isAllSelected = !isAllSelected;
      is1Selected = isAllSelected; // 전체 동의 시 첫 번째 개별 동의도 같이 변경
      is2Selected = isAllSelected; // 전체 동의 시 두 번째 개별 동의도 같이 변경
      svgAll = isAllSelected ? 'images/v2/login/checkbox_on.svg' : 'images/v2/login/checkbox_off.svg';
      svg1 = is1Selected ? 'images/v2/login/checkbox_on.svg' : 'images/v2/login/checkbox_off.svg';
      svg2 = is2Selected ? 'images/v2/login/checkbox_on.svg' : 'images/v2/login/checkbox_off.svg';
      agreementColor = isAllSelected ? pt_10 : np_05;
      agreementStrokeColor = isAllSelected ? np_20 : np_10;
    });
  }

  void _toggle1() {
    setState(() {
      is1Selected = !is1Selected;
      // 전체 동의 체크박스 상태 업데이트
      isAllSelected = is1Selected && is2Selected;
      svgAll = isAllSelected ? 'images/v2/login/checkbox_on.svg' : 'images/v2/login/checkbox_off.svg';
      svg1 = is1Selected ? 'images/v2/login/checkbox_on.svg' : 'images/v2/login/checkbox_off.svg';
      svg2 = is2Selected ? 'images/v2/login/checkbox_on.svg' : 'images/v2/login/checkbox_off.svg';
      agreementColor = isAllSelected ? pt_10 : np_05;
      agreementStrokeColor = isAllSelected ? np_20 : np_10;
    });
  }

  void _toggle2() {
    setState(() {
      is2Selected = !is2Selected;
      // 전체 동의 체크박스 상태 업데이트
      isAllSelected = is1Selected && is2Selected;
      svgAll = isAllSelected ? 'images/v2/login/checkbox_on.svg' : 'images/v2/login/checkbox_off.svg';
      svg1 = is1Selected ? 'images/v2/login/checkbox_on.svg' : 'images/v2/login/checkbox_off.svg';
      svg2 = is2Selected ? 'images/v2/login/checkbox_on.svg' : 'images/v2/login/checkbox_off.svg';
      agreementColor = isAllSelected ? pt_10 : np_05;
      agreementStrokeColor = isAllSelected ? np_20 : np_10;
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
                AmplitudeConfig.amplitude.logEvent('Back');
                Navigator.pop(context); //뒤로가기
              },
              color: b_100,
              icon: const Icon(Icons.keyboard_arrow_left)),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            "약관 동의",
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 16,
              color: f_100,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        body: Container(
            color: Colors.white,
            child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const Text(
                            "약관에 동의해주세요",
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 24,
                              color: f_100,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "뉴켓에서 티켓 오픈 소식을\n 전해드리고자 약관 동의를 받고 있어요!",
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 14,
                              color: f_60,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 34),
                          Image.asset("images/v2/login/ticket_check.png", height: 220, width: 220),
                          const SizedBox(height: 70),
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
                                AmplitudeConfig.amplitude.logEvent('TermsOfServiceV2');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const TermsOfServiceV2()),
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
                                                  color: np_100,
                                                  fontSize: 12,
                                                  fontFamily: 'Pretendard',
                                                  fontWeight: FontWeight.w400,
                                                  height: 0.11,
                                                ))
                                          ],
                                        ),
                                        const Icon(Icons.keyboard_arrow_right_rounded, color: Colors.white),
                                      ]))),
                          const SizedBox(height: 24),
                          GestureDetector(
                              onTap: () {
                                AmplitudeConfig.amplitude.logEvent('PrivacyPolicyV2');
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const PrivacyPolicyV2()),
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
                                                  color: np_100,
                                                  fontSize: 12,
                                                  fontFamily: 'Pretendard',
                                                  fontWeight: FontWeight.w400,
                                                  height: 0.11,
                                                ))
                                          ],
                                        ),
                                        const Icon(Icons.keyboard_arrow_right_rounded, color: Colors.white),
                                      ]))),
                        ],
                      ),
                      Column(
                        children: [
                          if (isAllSelected)
                            ElevatedButton(
                              onPressed: () async {
                                var storage = const FlutterSecureStorage();
                                final name = await storage.read(key: 'APPLE_NAME');
                                final email = await storage.read(key: 'APPLE_EMAIL');
                                final socialId = await storage.read(key: 'APPLE_SOCIAL_ID');
                                //signup
                                await AuthRepository().signUpAppleApi(
                                    SignUpAppleRequest(name: name!, email: email!, socialId: socialId!));
                                //기기 토큰 저장
                                final serverToken = await storage.read(key: 'ACCESS_TOKEN');
                                await AuthRepository().putDeviceTokenApi(serverToken!);
                                AmplitudeConfig.amplitude.logEvent('HomeV2');
                                Get.offAll(() => const TabBarV2());
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: np_100, // 버튼 색상
                                padding: const EdgeInsets.all(12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                minimumSize: const Size(0, 48), // 버튼 높이 조정
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
                          else
                            ElevatedButton(
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
                                )),
                          const SizedBox(height: 44),
                        ],
                      )
                    ]))));
  }
}
