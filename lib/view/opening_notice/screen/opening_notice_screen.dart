import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newket/view/opening_notice/widget/opening_notice_widget.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/repository/ticket_repository.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/view/ticket_detail/ticket_detail.dart';

class OpeningNoticeV2 extends StatefulWidget {
  const OpeningNoticeV2({super.key});

  @override
  State<StatefulWidget> createState() => _OpeningNoticeV2();
}

class _OpeningNoticeV2 extends State<OpeningNoticeV2> {
  late TicketRepository ticketRepository;
  String selectedOption = '예매 오픈 임박 순';
  late Future repository; // Future 타입으로 초기화

  @override
  void initState() {
    super.initState();
    ticketRepository = TicketRepository();
    repository = ticketRepository.openingNoticeApi();
  }

  void updateItemList(String option) {
    if (option == '예매 오픈 임박 순') {
      repository = ticketRepository.openingNoticeApi();
    } else if (option == '최신 등록 순') {
      repository = ticketRepository.openingNoticeApiOrderById();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> options = ['예매 오픈 임박 순', '최신 등록 순'];
    return Scaffold(
        resizeToAvoidBottomInset: false, //키보드가 올라 오지 않도록
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: FutureBuilder(
          future: repository,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: Column(children: [SizedBox(height: 12), CircularProgressIndicator()]));
            } else if (snapshot.hasError) {
              // 데이터 로딩 실패
              return const Center();
            } else if (!snapshot.hasData) {
              // 데이터 없음
              return const Center();
            } else {
              final openingResponse = snapshot.data!;
              return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(height: 20),
                            Row(
                              children: [
                                Text(
                                  '총 ${openingResponse.totalNum}개',
                                  style: const TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 18,
                                    color: pn_100,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Text(
                                  "의 오픈 예정 티켓이 있어요!",
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 18,
                                    color: f_100,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Container(height: 8),
                            Container(
                              height: 38,
                              width: 192,
                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                              decoration: ShapeDecoration(
                                color: Colors.white, // 배경색 변경
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(width: 1, color: f_15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: PopupMenuButton<String>(
                                onSelected: (String newValue) {
                                  setState(() {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                    selectedOption = newValue;
                                    updateItemList(newValue); // 리스트 업데이트
                                  });
                                },
                                onCanceled: () {
                                  setState(() {
                                    FocusManager.instance.primaryFocus?.unfocus();
                                  });
                                },
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                constraints: const BoxConstraints(
                                  minWidth: 192,
                                  maxWidth: 192,
                                ),
                                //팝업 가로 길이 고정
                                offset: const Offset(-17, 28),
                                // 팝업 위치 조정
                                elevation: 0,
                                // 그림자 제거
                                itemBuilder: (BuildContext context) {
                                  return options.map((String option) {
                                    return PopupMenuItem<String>(
                                      value: option,
                                      padding: const EdgeInsets.only(left: 12),
                                      child: Container(
                                        height: 38,
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          option,
                                          style: const TextStyle(
                                            color: f_70,
                                            fontSize: 14,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList();
                                },
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  side: const BorderSide(width: 1, color: f_15),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      '정렬',
                                      style: TextStyle(
                                        color: f_50,
                                        fontSize: 14,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          selectedOption,
                                          style: const TextStyle(
                                            color: f_70,
                                            fontSize: 14,
                                            fontFamily: 'Pretendard',
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        SvgPicture.asset('images/opening_notice/arrow-down.svg',
                                            height: 16, width: 16),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 20), // 드롭다운과 리스트 사이의 간격
                            Column(
                              children: List.generate(
                                openingResponse.concerts.length,
                                (index) {
                                  return Column(children: [
                                    GestureDetector(
                                      onTap: () {
                                        AmplitudeConfig.amplitude.logEvent(
                                            'OpeningNoticeDetail(id:${openingResponse.concerts[index].concertId})');
                                        // 상세 페이지로 이동
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => TicketDetailV2(
                                              concertId: openingResponse.concerts[index].concertId, // 상세 페이지에 데이터 전달
                                            ),
                                          ),
                                        );
                                      },
                                      child: OpeningNoticeWidget(openingResponse: openingResponse, index: index),
                                    ),
                                    const SizedBox(height: 12)
                                  ]);
                                },
                              ),
                            ),
                            const SizedBox(height: 122)
                          ],
                        ))
                  ]);
            }
          },
        )));
  }
}
