import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newket/theme/colors.dart';
import 'package:newket/view/agreement/privacy_policy.dart';
import 'package:newket/view/agreement/terms_of_service.dart';
import 'package:newket/view/favorite_artist/favorite_artist.dart';

class Agreement extends StatefulWidget {
  const Agreement({super.key});

  @override
  State<StatefulWidget> createState() => _Agreement();
}

class _Agreement extends State<Agreement> {
  bool isAllSelected = false; // 전체 동의 체크 상태
  bool is1Selected = false; // 첫 번째 개별 동의 체크 상태
  bool is2Selected = false; // 두 번째 개별 동의 체크 상태
  String svgAll = 'images/onboarding/checkbox_off.svg';
  String svg1 = 'images/onboarding/checkbox_off.svg';
  String svg2 = 'images/onboarding/checkbox_off.svg';
  Color agreementColor = pt_10;
  Color nextColor = pt_30;

  void _toggleAll() {
    setState(() {
      isAllSelected = !isAllSelected;
      is1Selected = isAllSelected; // 전체 동의 시 첫 번째 개별 동의도 같이 변경
      is2Selected = isAllSelected; // 전체 동의 시 두 번째 개별 동의도 같이 변경
      svgAll = isAllSelected ? 'images/onboarding/checkbox_on.svg' : 'images/onboarding/checkbox_off.svg';
      svg1 = is1Selected ? 'images/onboarding/checkbox_on.svg' : 'images/onboarding/checkbox_off.svg';
      svg2 = is2Selected ? 'images/onboarding/checkbox_on.svg' : 'images/onboarding/checkbox_off.svg';
      agreementColor = isAllSelected ? pt_20 : pt_10;
      nextColor = isAllSelected ? p_700 : pt_30;
    });
  }

  void _toggle1() {
    setState(() {
      is1Selected = !is1Selected;
      // 전체 동의 체크박스 상태 업데이트
      isAllSelected = is1Selected && is2Selected;
      svgAll = isAllSelected ? 'images/onboarding/checkbox_on.svg' : 'images/onboarding/checkbox_off.svg';
      svg1 = is1Selected ? 'images/onboarding/checkbox_on.svg' : 'images/onboarding/checkbox_off.svg';
      svg2 = is2Selected ? 'images/onboarding/checkbox_on.svg' : 'images/onboarding/checkbox_off.svg';
      agreementColor = isAllSelected ? pt_20 : pt_10;
      nextColor = isAllSelected ? p_700 : pt_30;
    });
  }

  void _toggle2() {
    setState(() {
      is2Selected = !is2Selected;
      // 전체 동의 체크박스 상태 업데이트
      isAllSelected = is1Selected && is2Selected;
      svgAll = isAllSelected ? 'images/onboarding/checkbox_on.svg' : 'images/onboarding/checkbox_off.svg';
      svg1 = is1Selected ? 'images/onboarding/checkbox_on.svg' : 'images/onboarding/checkbox_off.svg';
      svg2 = is2Selected ? 'images/onboarding/checkbox_on.svg' : 'images/onboarding/checkbox_off.svg';
      agreementColor = isAllSelected ? pt_20 : pt_10;
      nextColor = isAllSelected ? p_700 : pt_30;
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
                Navigator.pop(context); //뒤로가기
              },
              color: b_100,
              icon: const Icon(Icons.keyboard_arrow_left)),
          backgroundColor: b_950,
          centerTitle: true,
          title: const Text(
            "약관 동의",
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 16,
              color: b_100,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment(0.00, -1.00),
                end: Alignment(0, 1),
                colors: [b_950, Color(0xFF090C2B), Color(0xFF201D65)],
              ),
            ),
            child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 24),
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
                              color: b_100,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            "뉴켓에서 티켓 오픈 소식을\n 전해드리고자 약관 동의를 받고 있어요!",
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 14,
                              color: b_400,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 34),
                          SvgPicture.asset("images/onboarding/ticket_check.svg", height: 100, width: 100),
                          const SizedBox(height: 96),
                          Container(
                            height: 60,
                            padding: const EdgeInsets.all(16),
                            decoration: ShapeDecoration(
                              color: agreementColor,
                              shape: RoundedRectangleBorder(
                                side: const BorderSide(width: 1, color: pt_30),
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
                                    color: Colors.white,
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
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontFamily: 'Pretendard',
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            const Text('필수',
                                                style: TextStyle(
                                                  color: p_500,
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const PrivacyPolicy()),
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
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontFamily: 'Pretendard',
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            const Text('필수',
                                                style: TextStyle(
                                                  color: p_500,
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
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const FavoriteArtist()),
                                  );
                                },
                                child: Container(
                                    padding: const EdgeInsets.all(12),
                                    height: 48,
                                    decoration: ShapeDecoration(
                                      color: p_700,
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
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        )
                                      ],
                                    )))
                          else
                            Container(
                                padding: const EdgeInsets.all(12),
                                height: 48,
                                decoration: ShapeDecoration(
                                  color: pt_30,
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
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w700,
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
