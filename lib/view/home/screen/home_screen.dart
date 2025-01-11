import 'package:flutter/material.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/view/concert_list/screen/on_sale_screen.dart';
import 'package:newket/view/concert_list/screen/opening_notice_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> with SingleTickerProviderStateMixin {
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
            AmplitudeConfig.amplitude.logEvent('OpeningNoticeV2');
            break;
          case 1:
            AmplitudeConfig.amplitude.logEvent('OnSale');
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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          titleSpacing: 0,
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
                  },
                ),
              ],
            ),
          ),
        ),
        resizeToAvoidBottomInset: false, //키보드가 올라 오지 않도록
        backgroundColor: Colors.white,
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              FocusManager.instance.primaryFocus?.unfocus();
            }, // 키보드 외부를 탭하면 키보드 숨기기
            child: Stack(children: [
              Positioned.fill(
                  child: Column(children: [
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
                                          color: controller.index == 0 ? pn_100 : f_40,
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
                                          color: controller.index == 1 ? pn_100 : f_40,
                                          fontWeight: FontWeight.w600))
                                ])),
                      ),
                    ],
                    controller: controller,
                    dividerColor: Colors.transparent,
                    // 흰 줄 제거
                    indicatorColor: Colors.transparent,
                    indicatorWeight: 2,
                    indicatorPadding: const EdgeInsets.all(-11),
                    // indicator 위치 내리기
                    labelPadding: EdgeInsets.zero, //탭 크기가 안 작아지게
                  ),
                ),
                Container(height: 5, color: f_10, width: double.infinity),
                Expanded(
                    child: TabBarView(
                  controller: controller,
                  children: const <Widget>[OpeningNoticeScreen(), OnSaleScreen()],
                ))
              ]))
            ])));
  }
}
