import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/repository/ticket_repository.dart';
import 'package:newket/theme/colors.dart';
import 'package:newket/view/v200/ticket_detail/ticket_detail.dart';

class OnSaleV2 extends StatefulWidget {
  const OnSaleV2({super.key});

  @override
  State<StatefulWidget> createState() => _OnSaleV2();
}

class _OnSaleV2 extends State<OnSaleV2> {
  late TicketRepository ticketRepository;
  String selectedOption = '공연 날짜 임박 순';
  late Future repository; // Future 타입으로 초기화

  @override
  void initState() {
    super.initState();
    ticketRepository = TicketRepository();
    repository = ticketRepository.onSaleApi();
  }

  void updateItemList(String option) {
    if (option == '공연 날짜 임박 순') {
      repository = ticketRepository.onSaleApi();
    } else if (option == '최신 등록 순') {
      repository = ticketRepository.onSaleApiOrderById();
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> options = ['공연 날짜 임박 순', '최신 등록 순'];
    return Scaffold(
        resizeToAvoidBottomInset: false, //키보드가 올라 오지 않도록
        backgroundColor: f_5,
        body: SingleChildScrollView(
            scrollDirection: Axis.vertical,
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
                    final onSaleResponse = snapshot.data!;
                    return Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(height: 24),
                              Row(
                                children: [
                                  Text(
                                    '총 ${onSaleResponse.totalNum}개',
                                    style: const TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: 18,
                                      color: np_100,
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
                                          SvgPicture.asset('images/v2/opening_notice/arrow-down.svg',
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
                                  onSaleResponse.concerts.length,
                                  (index) {
                                    return Column(children: [
                                      GestureDetector(
                                        onTap: () {
                                          AmplitudeConfig.amplitude.logEvent(
                                              'OpeningNoticeDetail(id:${onSaleResponse.concerts[index].concertId})');
                                          // 상세 페이지로 이동
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => TicketDetailV2(
                                                concertId: onSaleResponse.concerts[index].concertId, // 상세 페이지에 데이터 전달
                                              ),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            ClipRRect(
                                              borderRadius: const BorderRadius.only(
                                                  topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
                                              child: Image.network(
                                                onSaleResponse.concerts[index].imageUrl,
                                                height: 122,
                                                width: 91,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                            Stack(
                                              children: [
                                                //티켓 정보
                                                Container(
                                                  width: MediaQuery.of(context).size.width - 91 - 40,
                                                  // 원하는 여백을 빼고 가로 크기 설정
                                                  height: 122,
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration: const ShapeDecoration(
                                                    color: Colors.white,
                                                    shape: RoundedRectangleBorder(
                                                      borderRadius: BorderRadius.only(
                                                          topRight: Radius.circular(8),
                                                          bottomRight: Radius.circular(8)),
                                                    ),
                                                  ),
                                                  child: Column(
                                                    //왼쪽 정렬
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      //공연 제목
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                                                          // 여백 12씩 추가
                                                          child: SizedBox(
                                                              height: 44,
                                                              child: RichText(
                                                                maxLines: 2,
                                                                overflow: TextOverflow.ellipsis,
                                                                text: TextSpan(
                                                                  text: onSaleResponse.concerts[index].title,
                                                                  style: const TextStyle(
                                                                    fontFamily: 'Pretendard',
                                                                    fontSize: 14,
                                                                    color: f_100,
                                                                    fontWeight: FontWeight.w500,
                                                                  ),
                                                                ),
                                                              ))),
                                                      //실선
                                                      Container(color: f_15, height: 1),
                                                      // 티켓 오픈 정보
                                                      Row(
                                                        children: [
                                                          Container(
                                                              width: (MediaQuery.of(context).size.width - 91 - 40),
                                                              padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 13),
                                                              height: 45,
                                                              child: Row(
                                                                children: [
                                                                  const Text(
                                                                    "공연일시",
                                                                    style: TextStyle(
                                                                      fontFamily: 'Pretendard',
                                                                      fontSize: 12,
                                                                      color: f_60,
                                                                      fontWeight: FontWeight.w400,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(width: 10),
                                                                  Text(
                                                                    onSaleResponse.concerts[index].date,
                                                                    style: const TextStyle(
                                                                      fontFamily: 'Pretendard',
                                                                      fontSize: 14,
                                                                      color: f_80,
                                                                      fontWeight: FontWeight.w500,
                                                                    ),
                                                                  ),
                                                                ],
                                                              )),
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 12)
                                    ]);
                                  },
                                ),
                              ),
                              const SizedBox(height: 122)
                            ]));
                  }
                })));
  }
}
