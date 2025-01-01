import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/view/home/screen/home_screen.dart';
import 'package:newket/view/login/screen/before_login_screen.dart';
import 'package:newket/view/my_ticket/screen/my_ticket_screen.dart';
import 'package:newket/view/mypage/screen/mypage_screen.dart';

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({super.key});

  @override
  State<StatefulWidget> createState() => _TabBarScreen();
}

late TabController tabController;

class _TabBarScreen extends State<TabBarScreen> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  int lastIndex = -1;
  bool isKeyboardVisible = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    tabController.addListener(() async {
      // 인덱스가 변경되었을 때만 실행
      if (tabController.index != lastIndex) {
        const storage = FlutterSecureStorage();
        String? accessToken = await storage.read(key: "ACCESS_TOKEN");
        if (accessToken == null) {
          tabController.index = 0; // 이전 인덱스으로 다시 설정
          AmplitudeConfig.amplitude.logEvent('BeforeLogin');
          Get.to(() => const BeforeLoginScreen());
          lastIndex = 0;
        } else {
          lastIndex = tabController.index; // 현재 인덱스를 마지막 인덱스로 저장
          switch (tabController.index) {
            case 0:
              AmplitudeConfig.amplitude.logEvent('Home');
              break;
            case 1:
              AmplitudeConfig.amplitude.logEvent('MyTicket');
              break;
          }
        }
        setState(() {});
      }
    });
    setState(() {
      isLoading = false;
    }); // 탭 변경 시 상태 업데이트
  }

  @override
  Widget build(BuildContext context) {
    isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

    if (isLoading) {
      return const Center(); // 로딩 인디케이터 표시
    }
    return Scaffold(
        resizeToAvoidBottomInset: false, //키보드가 올라 오지 않도록
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: const Text(
                    'NEWKET',
                    style: TextStyle(
                      color: pn_100,
                      fontSize: 24,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    FocusManager.instance.primaryFocus?.unfocus();
                    tabController.index = 0;
                  },
                ),
                GestureDetector(
                  child: SvgPicture.asset(
                    'images/home/mypage.svg',
                    width: 28,
                    height: 28,
                  ),
                  onTap: () async {
                    FocusScope.of(context).unfocus();
                    FocusManager.instance.primaryFocus?.unfocus();
                    const storage = FlutterSecureStorage();
                    String? accessToken = await storage.read(key: 'ACCESS_TOKEN');
                    if (accessToken == null) {
                      AmplitudeConfig.amplitude.logEvent('BeforeLogin');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BeforeLoginScreen(),
                        ),
                      );
                    } else {
                      AmplitudeConfig.amplitude.logEvent('MyPage');
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MyPageScreen()),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height, // 화면 전체 높이 사용
              child: TabBarView(
                controller: tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: const <Widget>[HomeScreen(), MyTicketScreen()],
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width / 2 - 122, // 중앙 정렬을 위한 계산 (244 / 2)
              bottom: 50,
              child: Container(
                color: Colors.transparent,
                width: 244,
                height: 60,
                // 탭바
                child: Container(
                  width: 244,
                  height: 60,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    shadows: const [
                      BoxShadow(
                        color: Color(0x231A1A25),
                        blurRadius: 52,
                        offset: Offset(0, 6),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Stack(
                    children: [
                      // 탭바 내용
                      TabBar(
                          tabs: <Tab>[
                            Tab(
                              icon: SizedBox(
                                  width: 120,
                                  height: 52,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        tabController.index == 0
                                            ? 'images/tab_bar/home_on.svg'
                                            : 'images/tab_bar/home_off.svg',
                                        width: 20,
                                        height: 20,
                                      ),
                                      Container(width: 4),
                                      Text("홈",
                                          style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontSize: 11,
                                              color: tabController.index == 0 ? pn_100 : f_40,
                                              fontWeight: FontWeight.w500)),
                                    ],
                                  )),
                            ),
                            Tab(
                              icon: SizedBox(
                                  width: 150,
                                  height: 52,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SvgPicture.asset(
                                        tabController.index == 1
                                            ? 'images/tab_bar/my_ticket_on.svg'
                                            : 'images/tab_bar/my_ticket_off.svg',
                                        width: 20,
                                        height: 20,
                                      ),
                                      Container(width: 4),
                                      Text("내 티켓",
                                          style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontSize: 11,
                                              color: tabController.index == 1 ? pn_100 : f_40,
                                              fontWeight: FontWeight.w500)),
                                    ],
                                  )),
                            ),
                          ],
                          controller: tabController,
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                          //divider 내리기
                          dividerColor: Colors.transparent,
                          // 흰 줄 제거
                          indicatorPadding: EdgeInsets.zero,
                          // indicator 위치 내리기
                          labelPadding: EdgeInsets.zero,
                          //탭 크기가 안 작아지게
                          indicator: BoxDecoration(
                            color: pt_10,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.circular(50),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
