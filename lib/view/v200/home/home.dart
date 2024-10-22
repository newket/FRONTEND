import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/theme/colors.dart';
import 'package:newket/view/v200/login/before_login.dart';
import 'package:newket/view/v200/mypage/mypage.dart';
import 'package:newket/view/v200/on_sale/on_sale.dart';
import 'package:newket/view/v200/opening_notice/opening_notice.dart';

class HomeV2 extends StatefulWidget {
  const HomeV2({super.key});

  @override
  State<StatefulWidget> createState() => _HomeV2();
}

class _HomeV2 extends State<HomeV2> with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late TabController controller;
  int lastIndex = -1;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      // 탭이 변경될 때마다 Amplitude 로그 기록
      if (controller.index != lastIndex) {
        // 인덱스가 변경되었을 때만 실행
        lastIndex = controller.index; // 현재 인덱스를 마지막 인덱스로 저장
        switch (controller.index) {
          case 0:
            AmplitudeConfig.amplitude.logEvent('HomeV2');
            break;
          case 1:
            AmplitudeConfig.amplitude.logEvent('MyTicketV2');
            break;
          default:
            break;
        }
      }
      setState(() {}); // 탭 변경 시 상태 업데이트
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
        resizeToAvoidBottomInset: false, //키보드가 올라 오지 않도록
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'NEWKET',
                  style: TextStyle(
                    color: np_100,
                    fontSize: 24,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w800,
                  ),
                ),
                GestureDetector(
                  child: SvgPicture.asset(
                    'images/v2/home/mypage.svg',
                    width: 28,
                    height: 28,
                  ),
                  onTap: () async {
                    const storage = FlutterSecureStorage();
                    final accessToken = await storage.read(key: 'ACCESS_TOKEN');
                    if (accessToken==null || accessToken.isEmpty) {
                      AmplitudeConfig.amplitude.logEvent('BeforeLogin');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BeforeLogin(),
                        ),
                      );
                    } else{
                      AmplitudeConfig.amplitude.logEvent('MyPage');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MyPageV2()),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
        body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(), // 키보드 외부를 탭하면 키보드 숨기기
            child: Column(children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: Container(
                    height: 44,
                    decoration: ShapeDecoration(
                      color: isKeyboardVisible ? np_10 : Colors.white, // 내부 배경색
                      shape: RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: isKeyboardVisible ? pt_40 : pt_60), // 테두리 색상 및 두께
                        borderRadius: BorderRadius.circular(42),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // 검색 아이콘
                        SvgPicture.asset('images/v2/home/search.svg', height: 20, width: 20),
                        const SizedBox(width: 12),
                        // 텍스트 필드 (예시 텍스트)
                        Expanded(
                            child: TextField(
                          decoration: const InputDecoration(
                            border: InputBorder.none, // 입력 필드의 기본 테두리 제거
                            hintText: '아티스트 또는 공연 이름을 검색해보세요!',
                            hintStyle: TextStyle(
                              color: f_50, // 텍스트 색상
                              fontSize: 14,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          style: const TextStyle(
                            color: f_80,
                            fontSize: 14,
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w400,
                          ),
                          onSubmitted: (value) {
                            //빈 값이 아닐 때 검색어 제출 시 페이지 이동
                            if (value != '') {
                              AmplitudeConfig.amplitude.logEvent('SearchDetail(keyword: $value)');
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (context) => SearchDetail(keyword: value),
                              //   ),
                              // );
                            }
                          },
                          controller: _searchController,
                        )),
                        GestureDetector(
                            onTap: () => {
                                  setState(() {
                                    _searchController.clear();
                                  })
                                },
                            child: SvgPicture.asset('images/v2/home/close-circle.svg', height: 24, width: 24)),
                      ],
                    ),
                  )),
              // 네비게이션 바
              Container(
                color: Colors.white,
                height: 44,
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: TabBar(
                  tabs: <Tab>[
                    Tab(
                      icon: SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 44,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("오픈 예정 티켓",
                                    style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: 16,
                                        color: controller.index == 0 ? np_100 : f_40,
                                        fontWeight: FontWeight.w600))
                              ])),
                    ),
                    Tab(
                      icon: SizedBox(
                          width: MediaQuery.of(context).size.width / 2,
                          height: 44,
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("예매 중인 티켓",
                                    style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: 16,
                                        color: controller.index == 1 ? np_100 : f_40,
                                        fontWeight: FontWeight.w600))
                              ])),
                    ),
                  ],
                  controller: controller,
                  dividerColor: Colors.transparent,
                  // 흰 줄 제거
                  indicatorColor: const Color(0xFF796FFF),
                  indicatorWeight: 2,
                  indicatorPadding: const EdgeInsets.all(-11),
                  // indicator 위치 내리기
                  labelPadding: EdgeInsets.zero, //탭 크기가 안 작아지게
                ),
              ),
              Expanded(
                  child: TabBarView(
                controller: controller,
                physics: const NeverScrollableScrollPhysics(),
                children: const <Widget>[OpeningNoticeV2(), OnSaleV2()],
              ))
            ])));
  }
}
