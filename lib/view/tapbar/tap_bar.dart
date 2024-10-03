import 'package:flutter/material.dart';
import 'package:newket/theme/colors.dart';
import 'package:newket/view/home/home.dart';
import 'package:newket/view/mypage/my_page.dart';
import 'package:newket/view/search/search.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TapBar(),
    );
  }
}

class TapBar extends StatefulWidget {
  const TapBar({super.key});

  @override
  State<StatefulWidget> createState() => _TapBar();
}

class _TapBar extends State<TapBar> with SingleTickerProviderStateMixin {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 3, vsync: this);
    controller.addListener(() {
      setState(() {}); // 탭 변경 시 상태 업데이트
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, //키보드가 올라 오지 않도록
      body: Stack(
        children: [
          TabBarView(
            controller: controller,
            children: const <Widget>[Home(), Search(), MyPage()],
          ),
          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 99,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: const Alignment(-0.00, 1.00),
                  end: const Alignment(0, -1),
                  colors: [
                    Colors.black,
                    Colors.black.withOpacity(0.2),
                    Colors.black.withOpacity(0)
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            bottom: 20,
            child: Container(
              color: Colors.transparent,
              height: 64,
              // 둥글게
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                // 탭바
                child: Container(
                  color: b_800,
                  height: 64,
                  child: Stack(
                    children: [
                      // 탭바 내용
                      TabBar(
                        tabs: <Tab>[
                          Tab(
                            icon: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(height: 2),
                                Container(
                                  width: 28,
                                  height: 28,
                                  decoration: controller.index == 0
                                      ? const BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: p_700,
                                              blurRadius: 28,
                                              offset: Offset(0, 5),
                                              spreadRadius: 0,
                                            )
                                          ],
                                        )
                                      : null,
                                  child: Image.asset(
                                    controller.index == 0
                                        ? 'images/navigator/home_on.png'
                                        : 'images/navigator/home_off.png',
                                  ),
                                ),
                                const Text("홈",
                                    style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: 11,
                                        color: Color(0xffffffff),
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                          Tab(
                            icon: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(height: 2),
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: controller.index == 1
                                      ? const BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: p_700,
                                              blurRadius: 28,
                                              offset: Offset(0, 5),
                                              spreadRadius: 0,
                                            )
                                          ],
                                        )
                                      : null,
                                  child: Image.asset(
                                    controller.index == 1
                                        ? 'images/navigator/search_on.png'
                                        : 'images/navigator/search_off.png',
                                  ),
                                ),
                                Container(height: 4),
                                const Text("검색",
                                    style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: 11,
                                        color: Color(0xffffffff),
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                          Tab(
                            icon: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(height: 2),
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: controller.index == 2
                                      ? const BoxDecoration(
                                          boxShadow: [
                                            BoxShadow(
                                              color: p_700,
                                              blurRadius: 28,
                                              offset: Offset(0, 5),
                                              spreadRadius: 0,
                                            )
                                          ],
                                        )
                                      : null,
                                  child: Image.asset(
                                    controller.index == 2
                                        ? 'images/navigator/mypage_on.png'
                                        : 'images/navigator/mypage_off.png',
                                  ),
                                ),
                                Container(height: 4),
                                const Text("마이페이지",
                                    style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: 11,
                                        color: Color(0xffffffff),
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ],
                        indicatorColor: p_700,
                        // indicator
                        controller: controller,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 5,
                        ),
                        //divider 내리기
                        dividerColor: Colors.transparent,
                        // 흰 줄 제거
                        indicatorPadding:
                            const EdgeInsets.all(-10), // indicator 위치 내리기
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
