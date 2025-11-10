import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/constant/enum.dart';
import 'package:newket/constant/fonts.dart';
import 'package:newket/repository/ticket_repository.dart';
import 'package:newket/view/ticket_list/screen/before_sale_screen.dart';
import 'package:newket/view/ticket_list/screen/on_sale_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TicketListScreen extends StatefulWidget {
  const TicketListScreen({super.key, required this.genre});

  final Genre genre;

  @override
  State<StatefulWidget> createState() => _TicketListScreen();
}

class _TicketListScreen extends State<TicketListScreen> with SingleTickerProviderStateMixin {
  late TabController controller;
  int lastIndex = -1;
  late Genre _selectedGenre;

  //drop down
  bool _dropdownVisible = false;

  void _toggleDropdown() {
    setState(() {
      _dropdownVisible = !_dropdownVisible;
    });
  }

  void _selectGenre(Genre genre) {
    setState(() {
      _selectedGenre = genre;
      _dropdownVisible = false;
    });
    loadBeforeSaleSelectedOption();
    loadOnSaleSelectedOption();
  }

  // beforeSale
  late String beforeSaleSelectedOption;
  late Future beforeSaleRepository;
  final List<String> beforeSaleOptions = ['예매 오픈 임박 순', '최신 등록 순'];

  loadBeforeSaleSelectedOption() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      beforeSaleSelectedOption = prefs.getString('openingNoticeSelectedOption') ?? beforeSaleOptions[0];
      if (beforeSaleSelectedOption == beforeSaleOptions[0]) {
        beforeSaleRepository = TicketRepository().getBeforeSaleTickets(_selectedGenre);
      } else if (beforeSaleSelectedOption == beforeSaleOptions[1]) {
        beforeSaleRepository = TicketRepository().getBeforeSaleTicketsOrderById(_selectedGenre);
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
        onSaleRepository = TicketRepository().getOnSaleTickets(_selectedGenre);
      } else if (onSaleSelectedOption == onSaleOptions[1]) {
        onSaleRepository = TicketRepository().getOnSaleTicketsById(_selectedGenre);
      }
    });
  }

  void onSaleOptionChanged() {
    loadOnSaleSelectedOption();
  }

  @override
  void initState() {
    super.initState();
    _selectedGenre = widget.genre;
    beforeSaleRepository = TicketRepository().getBeforeSaleTickets(_selectedGenre);
    onSaleRepository = TicketRepository().getOnSaleTickets(_selectedGenre);
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
            break;
          case 1:
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
          title: GestureDetector(
            onTap: _toggleDropdown,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(_selectedGenre.displayName, style: t2_18Semi(f_100)),
                const SizedBox(width: 6),
                Icon(
                  _dropdownVisible ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                  color: f_100,
                  size: 30,
                ),
              ],
            ),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context); //뒤로가기
              },
              color: f_90,
              icon: const Icon(Icons.arrow_back_ios_new_rounded)),
        ),
        backgroundColor: Colors.white,
        body: Stack(children: [
          GestureDetector(
              onTap: () {
                if (_dropdownVisible) {
                  setState(() {
                    _dropdownVisible = false;
                  });
                }
              },
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
                                  Text("오픈 예정 티켓", style: button2_14Semi(controller.index == 0 ? pn_100 : f_40))
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
                                  Text("예매 중인 티켓", style: button2_14Semi(controller.index == 1 ? pn_100 : f_40))
                                ])),
                      ),
                    ],
                    controller: controller,
                    dividerColor: Colors.transparent,
                    // 흰 줄 제거
                    indicatorColor: pn_100,
                    indicatorWeight: 2,
                    indicatorPadding: EdgeInsets.zero,
                    indicator: const UnderlineTabIndicator(
                      borderSide: BorderSide(width: 2, color: pn_100),
                      insets: EdgeInsets.fromLTRB(0, 0, 0, -10), // 위치 조정
                    ),
                    // indicator 위치 내리기
                    labelPadding: EdgeInsets.zero, //탭 크기가 안 작아지게
                  ),
                ),
                Container(height: 1, color: f_10, width: double.infinity),
                Expanded(
                    child: TabBarView(
                  controller: controller,
                  children: <Widget>[
                    BeforeSaleScreen(
                        key: ValueKey('before_${_selectedGenre.name}'),
                        repository: beforeSaleRepository,
                        onOptionChanged: beforeSaleOptionChanged),
                    OnSaleScreen(
                        key: ValueKey('before_${_selectedGenre.name}'),
                        repository: onSaleRepository,
                        onOptionChanged: onSaleOptionChanged)
                  ],
                ))
              ])),
          // 외부 터치시 드롭다운 닫힘
          if (_dropdownVisible)
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _dropdownVisible = false;
                  });
                },
                child: Container(color: Colors.transparent),
              ),
            ),
          // 드롭다운
          if (_dropdownVisible)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 124,
                padding: const EdgeInsets.only(top: 20, bottom: 24, left: 20, right: 20),
                decoration: const ShapeDecoration(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                  shadows: [
                    BoxShadow(
                      color: Color(0x33060943),
                      blurRadius: 31,
                      offset: Offset(0, 7),
                      spreadRadius: 0,
                    )
                  ],
                ),
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: (MediaQuery.of(context).size.width - 48) / 2 / 36,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  children: Genre.values.map((genre) {
                    final isSelected = genre == _selectedGenre;
                    return InkWell(
                      onTap: () => _selectGenre(genre),
                      child: Row(children: [
                        SvgPicture.asset("images/ticket/ic_${genre.name}.svg",
                            height: 28, width: 28, color: isSelected ? pn_100 : f_60),
                        const SizedBox(width: 8),
                        Text(genre.displayName, style: c1_14Med(isSelected ? pn_100 : f_60))
                      ]),
                    );
                  }).toList(),
                ),
              ),
            )
        ]));
  }
}
