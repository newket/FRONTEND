import 'package:flutter/material.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/repository/ticket_repository.dart';
import 'package:newket/view/ticket_list/screen/before_sale_screen.dart';
import 'package:newket/view/ticket_list/screen/on_sale_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController controller;
  int lastIndex = -1;

  // beforeSale
  late String beforeSaleSelectedOption;
  late Future beforeSaleRepository;
  final List<String> beforeSaleOptions = ['예매 오픈 임박 순', '최신 등록 순'];

  loadBeforeSaleSelectedOption() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      beforeSaleSelectedOption = prefs.getString('openingNoticeSelectedOption') ?? beforeSaleOptions[0];
      if (beforeSaleSelectedOption == beforeSaleOptions[0]) {
        beforeSaleRepository = TicketRepository().getBeforeSaleTickets();
      } else if (beforeSaleSelectedOption == beforeSaleOptions[1]) {
        beforeSaleRepository = TicketRepository().getBeforeSaleTicketsOrderById();
      }
    });
  }

  void beforeSaleOptionChanged() {
    loadBeforeSaleSelectedOption();
  }

  // onSale
  late String onSaleSelectedOption;
  late Future onSaleRepository;
  final List<String> onSaleOptions = ['공연 날짜 임박 순', '최신 등록 순'];

  loadOnSaleSelectedOption() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      onSaleSelectedOption = prefs.getString('onSaleSelectedOption') ?? onSaleOptions[0];
      if (onSaleSelectedOption == onSaleOptions[0]) {
        onSaleRepository = TicketRepository().getOnSaleTickets();
      } else if (onSaleSelectedOption == onSaleOptions[1]) {
        onSaleRepository = TicketRepository().getOnSaleTicketsById();
      }
    });
  }

  void onSaleOptionChanged() {
    loadOnSaleSelectedOption();
  }

  @override
  void initState() {
    super.initState();
    beforeSaleRepository = TicketRepository().getBeforeSaleTickets();
    onSaleRepository = TicketRepository().getOnSaleTickets();
    loadBeforeSaleSelectedOption();
    loadOnSaleSelectedOption();

    controller = TabController(length: 2, vsync: this);
    controller.addListener(() {
      // 탭이 변경될 때마다 Amplitude 로그 기록
      if (controller.index != lastIndex) {
        // 인덱스가 변경되었을 때만 실행
        lastIndex = controller.index; // 현재 인덱스를 마지막 인덱스로 저장
        switch (controller.index) {
          case 0:
            AmplitudeConfig.amplitude.logEvent('OpeningNotice');
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
          titleSpacing: 20,
          centerTitle: true,
          title: const Text(
            'NEWKET',
            style: TextStyle(
              color: pn_100,
              fontSize: 24,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w800,
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
                  indicatorColor: pn_100,
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
                children: <Widget>[
                  BeforeSaleScreen(repository: beforeSaleRepository, onOptionChanged: beforeSaleOptionChanged),
                  OnSaleScreen(repository: onSaleRepository, onOptionChanged: onSaleOptionChanged)
                ],
              ))
            ])));
  }
}
