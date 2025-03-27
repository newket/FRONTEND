import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
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
  DateTime? backPressedTime; // 뒤로 가기 시간 저장 변수

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    const storage = FlutterSecureStorage();
    tabController.addListener(() async {
      if (tabController.index != lastIndex) {
        String? accessToken = await storage.read(key: "ACCESS_TOKEN");
        if ((tabController.index == 1 || tabController.index == 3) && accessToken == null) {
          tabController.index = lastIndex; // 이전 인덱스로 복구
          Get.to(() => const BeforeLoginScreen());
        } else {
          lastIndex = tabController.index;
        }
        setState(() {});
      }
    });
  }

  void showSnackbar(BuildContext context, String message) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 60, // 화면 아래에서 100px 위
        left: MediaQuery.of(context).size.width * 0.1, // 좌우 여백 조정
        width: MediaQuery.of(context).size.width * 0.8, // 가로 너비 조정
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Center(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    // 2초 후 자동 삭제
    Future.delayed(const Duration(seconds: 2), () {
      overlayEntry.remove();
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        DateTime nowTime = DateTime.now(); // 현재 시간 저장

        if (backPressedTime == null || nowTime.difference(backPressedTime!) > const Duration(seconds: 2)) {
          backPressedTime = nowTime;
          showSnackbar(context, '한 번 더 누르시면 종료됩니다.');
        } else {
          SystemNavigator.pop(); // 앱 종료
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height,
              child: TabBarView(
                controller: tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: const <Widget>[HomeScreen(), MyTicketScreen(), SearchScreen(), MyPageScreen()],
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 48 + MediaQuery.of(context).viewPadding.bottom,
                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom),
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
                            width: 48,
                            height: 48,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: SvgPicture.asset(
                              tabController.index == 0 ? 'images/tab_bar/home_on.svg' : 'images/tab_bar/home_off.svg',
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                        Tab(
                          icon: Container(
                            width: 48,
                            height: 48,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: SvgPicture.asset(
                              tabController.index == 1
                                  ? 'images/tab_bar/my_ticket_on.svg'
                                  : 'images/tab_bar/my_ticket_off.svg',
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                        Tab(
                          icon: Container(
                            width: 48,
                            height: 48,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: SvgPicture.asset(
                              tabController.index == 2
                                  ? 'images/tab_bar/search_on.svg'
                                  : 'images/tab_bar/search_off.svg',
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                        Tab(
                          icon: Container(
                            width: 48,
                            height: 48,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            child: SvgPicture.asset(
                              tabController.index == 3 ? 'images/tab_bar/my_on.svg' : 'images/tab_bar/my_off.svg',
                              width: 24,
                              height: 24,
                            ),
                          ),
                        ),
                      ],
                      controller: tabController,
                      dividerColor: Colors.transparent,
                      // 흰 줄 제거
                      indicatorPadding: EdgeInsets.zero,
                      // indicator 위치 내리기
                      labelPadding: EdgeInsets.zero,
                      //탭 크기 유지
                      indicator: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      onTap: (int index) {
                        if (index == 0 && lastIndex == 0) {
                          Get.offAll(
                            () => const TabBarScreen(),
                            transition: Transition.noTransition,
                          );
                        }
                        HapticFeedback.lightImpact();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
