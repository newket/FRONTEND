import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/view/home/screen/home_screen.dart';
import 'package:newket/view/login/screen/before_login_screen.dart';
import 'package:newket/view/my_ticket/screen/my_ticket_screen.dart';
import 'package:newket/view/mypage/screen/mypage_screen.dart';
import 'package:newket/view/search/screen/search_screen.dart';

class TabBarScreen extends StatefulWidget {
  const TabBarScreen({super.key});

  @override
  State<StatefulWidget> createState() => _TabBarScreen();
}

late TabController tabController;

class _TabBarScreen extends State<TabBarScreen> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  int lastIndex = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    const storage = FlutterSecureStorage();
    tabController.addListener(() async {
      // 인덱스가 변경되었을 때만 실행
      if (tabController.index != lastIndex) {
        String? accessToken = await storage.read(key: "ACCESS_TOKEN");
        if ((tabController.index == 1 || tabController.index == 3) && accessToken == null) {
          tabController.index = lastIndex; // 이전 인덱스으로 다시 설정
          AmplitudeConfig.amplitude.logEvent('BeforeLogin');
          Get.to(() => const BeforeLoginScreen());
        } else {
          lastIndex = tabController.index; // 현재 인덱스를 마지막 인덱스로 저장
          switch (tabController.index) {
            case 0:
              AmplitudeConfig.amplitude.logEvent('Home');
              break;
            case 1:
              AmplitudeConfig.amplitude.logEvent('MyTicket');
              break;
            case 2:
              AmplitudeConfig.amplitude.logEvent('Search');
              break;
            case 3:
              AmplitudeConfig.amplitude.logEvent('MyPage');
              break;
          }
        }
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height, // 화면 전체 높이 사용
              child: TabBarView(
                controller: tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: const <Widget>[HomeScreen(), MyTicketScreen(), SearchScreen(), MyPageScreen()],
              ),
            ),
            Positioned(
              bottom: 34,
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 56,
                  padding: const EdgeInsets.only(top: 4, bottom: 2),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x1E1A1A25),
                        blurRadius: 52,
                        offset: Offset(0, 6),
                        spreadRadius: 0,
                      )
                    ],
                  ),
                  child: Stack(
                    children: [
                      TabBar(
                        tabs: <Tab>[
                          Tab(
                            icon: Container(
                                width: 50,
                                height: 50,
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      tabController.index == 0
                                          ? 'images/tab_bar/home_on.svg'
                                          : 'images/tab_bar/home_off.svg',
                                      width: 24,
                                      height: 24,
                                    ),
                                    Text("홈",
                                        style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontSize: 10,
                                            letterSpacing: -0.30,
                                            color: tabController.index == 0 ? pn_100 : f_40,
                                            fontWeight: FontWeight.w400)),
                                  ],
                                )),
                          ),
                          Tab(
                            icon: Container(
                                width: 50,
                                height: 50,
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Column(
                                  children: [
                                    SvgPicture.asset(
                                      tabController.index == 1
                                          ? 'images/tab_bar/my_ticket_on.svg'
                                          : 'images/tab_bar/my_ticket_off.svg',
                                      width: 24,
                                      height: 24,
                                    ),
                                    Text("내 티켓",
                                        style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontSize: 10,
                                            letterSpacing: -0.30,
                                            color: tabController.index == 1 ? pn_100 : f_40,
                                            fontWeight: FontWeight.w400)),
                                  ],
                                )),
                          ),
                          Tab(
                            icon: Container(
                                width: 50,
                                height: 50,
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      tabController.index == 2
                                          ? 'images/tab_bar/search_on.svg'
                                          : 'images/tab_bar/search_off.svg',
                                      width: 24,
                                      height: 24,
                                    ),
                                    Text("검색",
                                        style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontSize: 10,
                                            letterSpacing: -0.30,
                                            color: tabController.index == 2 ? pn_100 : f_40,
                                            fontWeight: FontWeight.w400)),
                                  ],
                                )),
                          ),
                          Tab(
                            icon: Container(
                                width: 50,
                                height: 50,
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      tabController.index == 3
                                          ? 'images/tab_bar/my_on.svg'
                                          : 'images/tab_bar/my_off.svg',
                                      width: 24,
                                      height: 24,
                                    ),
                                    Text("MY",
                                        style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontSize: 10,
                                            letterSpacing: -0.30,
                                            color: tabController.index == 3 ? pn_100 : f_40,
                                            fontWeight: FontWeight.w400)),
                                  ],
                                )),
                          ),
                        ],
                        controller: tabController,
                        //divider 내리기
                        dividerColor: Colors.transparent,
                        // 흰 줄 제거
                        indicatorPadding: EdgeInsets.zero,
                        // indicator 위치 내리기
                        labelPadding: EdgeInsets.zero,
                        //탭 크기가 안 작아지게
                        indicator: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        onTap: (int index) {
                          HapticFeedback.lightImpact();
                        },
                      ),
                    ],
                  )),
            ),
            Positioned(
                bottom: 0,
                child: Container(
                  color: Colors.white,
                  height: 34,
                  width: MediaQuery.of(context).size.height,
                ))
          ],
        ));
  }
}
