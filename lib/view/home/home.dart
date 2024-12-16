import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/model/artist_model.dart';
import 'package:newket/model/ticket_model.dart';
import 'package:newket/repository/ticket_repository.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/view/on_sale/on_sale.dart';
import 'package:newket/view/opening_notice/opening_notice.dart';
import 'package:newket/view/search/search.dart';
import 'package:newket/view/ticket_detail/ticket_detail.dart';

class HomeV2 extends StatefulWidget {
  const HomeV2({super.key});

  @override
  State<StatefulWidget> createState() => _HomeV2();
}

class _HomeV2 extends State<HomeV2> with SingleTickerProviderStateMixin {
  late TicketRepository ticketRepository;
  final TextEditingController _searchController = TextEditingController();
  late TabController controller;
  int lastIndex = -1;
  List<Artist> artists = []; // 검색 결과를 담을 리스트
  List<Concert> openingNoticeResponse = [];
  List<ConcertOnSale> onSaleResponse = [];

  Future<void> _search(String keyword) async {
    if (keyword.isNotEmpty) {
      SearchResponse result = await ticketRepository.searchArtistsAndTickets(keyword);
      setState(() {
        artists = result.artists;
        openingNoticeResponse = result.openingNotice.concerts;
        onSaleResponse = result.onSale.concerts;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    ticketRepository = TicketRepository();
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
            AmplitudeConfig.amplitude.logEvent('OnSaleV2');
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
    Timer? debounce;

    return Scaffold(
        resizeToAvoidBottomInset: false, //키보드가 올라 오지 않도록
        backgroundColor: Colors.white,
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              FocusManager.instance.primaryFocus?.unfocus();
            }, // 키보드 외부를 탭하면 키보드 숨기기
            child: Stack(
              children: [
                Positioned.fill(
                    child: Column(children: [
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Container(
                        height: 44,
                        decoration: ShapeDecoration(
                          color: isKeyboardVisible ? pn_10 : Colors.white, // 내부 배경색
                          shape: RoundedRectangleBorder(
                            side: BorderSide(width: 1, color: isKeyboardVisible ? pt_40 : pt_60), // 테두리 색상 및 두께
                            borderRadius: BorderRadius.circular(42),
                          ),
                        ),
                        padding: const EdgeInsets.only(top: 4, bottom: 4, left: 12, right: 12),
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
                                contentPadding: EdgeInsets.symmetric(vertical: 9), // 텍스트 높이 조정
                              ),
                              style: const TextStyle(
                                color: f_80,
                                fontSize: 14,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 1,
                              // 한 줄로 제한
                              scrollPhysics: const BouncingScrollPhysics(),
                              inputFormatters: [LengthLimitingTextInputFormatter(50)],
                              // 최대 글자 수를 50자로 제한
                              onSubmitted: (value) {
                                //빈 값이 아닐 때 검색어 제출 시 페이지 이동
                                if (value != '') {
                                  AmplitudeConfig.amplitude.logEvent('SearchDetail(keyword: $value)');
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => SearchV2(keyword: value),
                                    ),
                                  );
                                }
                              },
                              onChanged: (value) {
                                // 이전 타이머가 존재하면 취소
                                if (debounce?.isActive ?? false) debounce!.cancel();
                                // 새로운 타이머 설정 (3초 후에 실행)
                                debounce = Timer(const Duration(microseconds: 300), () {
                                  _search(value); // 마지막 입력값으로 검색 실행
                                });
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
                      indicatorColor: const Color(0xFF796FFF),
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
                    children: const <Widget>[OpeningNoticeV2(), OnSaleV2()],
                  ))
                ])),
                if (_searchController.text != '')
                  Positioned(
                    top: 68, // 검색 창 바로 아래에 위치
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
                      color: Colors.white,
                      child: ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxHeight: 288, // 최대 높이를 28*6으로 제한
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                // 아티스트 항목
                                ...artists.map((artist) => GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          artists = [];
                                          openingNoticeResponse = [];
                                          onSaleResponse = [];
                                          _searchController.clear(); // 텍스트 필드 값을 빈 문자열로 리셋
                                          AmplitudeConfig.amplitude.logEvent('SearchDetail(artist: ${artist.name})');
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => SearchV2(keyword: artist.name),
                                            ),
                                          );
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(bottom: 8),
                                        // 아래쪽 간격 설정
                                        color: Colors.transparent,
                                        width: MediaQuery.of(context).size.width - 40,
                                        height: 48,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset('images/v2/home/mypage.svg', width: 20, height: 20),
                                            const SizedBox(width: 8),
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  artist.name,
                                                  style: const TextStyle(
                                                    color: f_100,
                                                    fontSize: 16,
                                                    fontFamily: 'Pretendard',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                                if (artist.nicknames != null)
                                                  Text(
                                                    artist.nicknames ?? '',
                                                    style: const TextStyle(
                                                      color: f_50,
                                                      fontSize: 14,
                                                      fontFamily: 'Pretendard',
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                                ...openingNoticeResponse.map((concert) => GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          artists = [];
                                          openingNoticeResponse = [];
                                          onSaleResponse = [];
                                          _searchController.clear(); // 텍스트 필드 값을 빈 문자열로 리셋
                                          AmplitudeConfig.amplitude
                                              .logEvent('SearchDetail(concertName: ${concert.title})');
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => TicketDetailV2(concertId: concert.concertId),
                                            ),
                                          );
                                        });
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        margin: const EdgeInsets.only(bottom: 8), // 아래쪽 간격 설정
                                        height: 48,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset('images/v2/home/search_ticket.svg', width: 20, height: 20),
                                            const SizedBox(width: 8),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width - 72,
                                              child: RichText(
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis, // 1줄 이상은 ...
                                                text: TextSpan(
                                                  text: concert.title,
                                                  style: const TextStyle(
                                                    color: f_100,
                                                    fontSize: 16,
                                                    fontFamily: 'Pretendard',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                                ...onSaleResponse.map((concert) => GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          artists = [];
                                          openingNoticeResponse = [];
                                          onSaleResponse = [];
                                          _searchController.clear(); // 텍스트 필드 값을 빈 문자열로 리셋
                                          AmplitudeConfig.amplitude
                                              .logEvent('SearchDetail(concertName: ${concert.title})');
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => TicketDetailV2(concertId: concert.concertId),
                                            ),
                                          );
                                        });
                                      },
                                      child: Container(
                                        color: Colors.transparent,
                                        width: MediaQuery.of(context).size.width - 40,
                                        margin: const EdgeInsets.only(bottom: 8),
                                        // 아래쪽 간격 설정
                                        height: 48,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset('images/v2/home/search_ticket.svg', width: 20, height: 20),
                                            const SizedBox(width: 8),
                                            SizedBox(
                                              width: MediaQuery.of(context).size.width - 72,
                                              child: RichText(
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis, // 1줄 이상은 ...
                                                text: TextSpan(
                                                  text: concert.title,
                                                  style: const TextStyle(
                                                    color: f_100,
                                                    fontSize: 16,
                                                    fontFamily: 'Pretendard',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          )),
                    ),
                  )
              ],
            )));
  }
}
