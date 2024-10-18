import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/repository/ticket_repository.dart';
import 'package:newket/theme/colors.dart';
import 'package:newket/view/v100/on_sale/on_sale_detail.dart';
import 'package:newket/view/v100/opening_notice/opening_notice_detail.dart';

class SearchDetail extends StatefulWidget {
  const SearchDetail({super.key, required this.keyword});

  final String keyword;

  @override
  State<StatefulWidget> createState() => _SearchDetail();
}

class _SearchDetail extends State<SearchDetail> {
  late TicketRepository ticketRepository;
  final TextEditingController _searchController = TextEditingController();
  String keyword = '';

  @override
  void initState() {
    super.initState();
    ticketRepository = TicketRepository();
    keyword = widget.keyword;
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
        //배경
        backgroundColor: b_950,

        //앱바
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                AmplitudeConfig.amplitude.logEvent('Back');
                Navigator.pop(context); //뒤로가기
              },
              color: Colors.white,
              icon: const Icon(Icons.keyboard_arrow_left)),
          backgroundColor: b_950,
          title: Container(
            height: 40,
            decoration: ShapeDecoration(
              color: isKeyboardVisible ? v1pt_20 : b_900, // 내부 배경색
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: v1pt_50), // 테두리 색상 및 두께
                borderRadius: BorderRadius.circular(42),
              ),
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 검색 아이콘
                Image.asset('images/v1/navigator/search_on.png', height: 20, width: 20),
                const SizedBox(width: 12),
                // 텍스트 필드 (예시 텍스트)
                Expanded(
                    child: TextField(
                  decoration: const InputDecoration(
                    border: InputBorder.none, // 입력 필드의 기본 테두리 제거
                    hintText: "",
                    hintStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                  ),
                  onSubmitted: (value) {
                    if (value != '') {
                      // 검색어 제출 시 페이지 이동
                      setState(() {
                        keyword = value;
                      });
                    }
                  },
                  controller: _searchController,
                )),
                GestureDetector(
                    onTap: () => {
                          setState(() {
                            _searchController.clear();
                          })
                        },
                    child: SvgPicture.asset('images/v1/favorite_artist/close-circle.svg', height: 16, width: 16)),
              ],
            ),
          ),
        ),

        //내용
        body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(), // 키보드 외부를 탭하면 키보드 숨기기
            child: SingleChildScrollView(
                //스크롤 가능
                child: FutureBuilder(
                    future: ticketRepository.searchTicket(keyword),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: Column(children: [SizedBox(height: 20), CircularProgressIndicator()]));
                      } else if (snapshot.hasError || !snapshot.hasData) {
                        // 데이터 로딩 실패
                        return Center(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 204),
                              SvgPicture.asset("images/v1/search/ticket_null.svg", height: 92, width: 92),
                              const SizedBox(height: 20),
                              const Text(
                                '앗, 검색결과가 없어요.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const SizedBox(
                                width: double.infinity,
                                child: Text('아직 공연 예매 일정이 나오지 않았어요.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: b_400,
                                      fontSize: 14,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w400,
                                    )),
                              ),
                            ],
                          ),
                        );
                      } else {
                        final ticketResponse = snapshot.data!;
                        if (ticketResponse.onSale.totalNum == 0 && ticketResponse.openingNotice.totalNum == 0) {
                          return Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 204),
                                SvgPicture.asset("images/v1/search/ticket_null.svg", height: 92, width: 92),
                                const SizedBox(height: 20),
                                const Text(
                                  '앗, 검색결과가 없어요.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const SizedBox(
                                  width: double.infinity,
                                  child: Text('아직 공연 예매 일정이 나오지 않았어요.',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: b_400,
                                        fontSize: 14,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w400,
                                      )),
                                ),
                              ],
                            ),
                          );
                        }
                        return Container(
                            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                            child: Column(
                              children: [
                                ticketResponse.openingNotice.totalNum > 0
                                    ? Column(
                                        children: [
                                          Row(
                                            children: [
                                              const Text("오픈 예정 티켓",
                                                  style: TextStyle(
                                                      fontFamily: 'Pretendard',
                                                      fontSize: 16,
                                                      color: b_100,
                                                      fontWeight: FontWeight.w500)),
                                              const SizedBox(width: 12),
                                              Container(
                                                height: 29,
                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                                clipBehavior: Clip.antiAlias,
                                                decoration: ShapeDecoration(
                                                  color: v1pt_20,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                ),
                                                child: Text("${ticketResponse.openingNotice.totalNum}개",
                                                    style: const TextStyle(
                                                        fontFamily: 'Pretendard',
                                                        fontSize: 14,
                                                        color: p_500,
                                                        fontWeight: FontWeight.w700)),
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          Column(
                                            children: List.generate(ticketResponse.openingNotice.totalNum, (index1) {
                                              return Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      AmplitudeConfig.amplitude.logEvent(
                                                          'OpeningNoticeDetail(id:${ticketResponse.openingNotice.concerts[index1].concertId})');
                                                      // 상세 페이지로 이동
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => OpeningNoticeDetail(
                                                            concertId: ticketResponse.openingNotice.concerts[index1]
                                                                .concertId, // 상세 페이지에 데이터 전달
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Row(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius: BorderRadius.circular(8.0),
                                                          child: Image.network(
                                                            ticketResponse.openingNotice.concerts[index1].imageUrl,
                                                            height: 110,
                                                            width: 83,
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                        Stack(
                                                          children: [
                                                            //티켓 정보
                                                            Container(
                                                              width: MediaQuery.of(context).size.width - 123,
                                                              // 원하는 여백을 빼고 가로 크기 설정
                                                              height: 110,
                                                              clipBehavior: Clip.antiAlias,
                                                              decoration: ShapeDecoration(
                                                                color: b_900,
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(12),
                                                                ),
                                                              ),
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(12.0),
                                                                // 여백 12씩 추가
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  //왼쪽정렬
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    //공연 제목
                                                                    SizedBox(
                                                                        height: 34,
                                                                        child: RichText(
                                                                          maxLines: 2,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          text: TextSpan(
                                                                            text: ticketResponse
                                                                                .openingNotice.concerts[index1].title,
                                                                            style: const TextStyle(
                                                                              fontFamily: 'Pretendard',
                                                                              fontSize: 14,
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.w500,
                                                                            ),
                                                                          ),
                                                                        )),
                                                                    // 티켓 오픈 정보
                                                                    //일반예매 만
                                                                    if (ticketResponse.openingNotice.concerts[index1]
                                                                            .ticketingSchedules.length ==
                                                                        1)
                                                                      Row(
                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                          children: [
                                                                            Column(
                                                                              crossAxisAlignment:
                                                                                  CrossAxisAlignment.start,
                                                                              mainAxisAlignment:
                                                                                  MainAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  "${ticketResponse.openingNotice.concerts[index1].ticketingSchedules[0].type} 오픈",
                                                                                  style: const TextStyle(
                                                                                    fontFamily: 'Pretendard',
                                                                                    fontSize: 12,
                                                                                    color: b_400,
                                                                                    fontWeight: FontWeight.w400,
                                                                                  ),
                                                                                ),
                                                                                if (ticketResponse
                                                                                            .openingNotice
                                                                                            .concerts[index1]
                                                                                            .ticketingSchedules[0]
                                                                                            .dday ==
                                                                                        'D-3' ||
                                                                                    ticketResponse
                                                                                            .openingNotice
                                                                                            .concerts[index1]
                                                                                            .ticketingSchedules[0]
                                                                                            .dday ==
                                                                                        'D-2' ||
                                                                                    ticketResponse
                                                                                            .openingNotice
                                                                                            .concerts[index1]
                                                                                            .ticketingSchedules[0]
                                                                                            .dday ==
                                                                                        'D-1' ||
                                                                                    ticketResponse
                                                                                            .openingNotice
                                                                                            .concerts[index1]
                                                                                            .ticketingSchedules[0]
                                                                                            .dday ==
                                                                                        'D-Day')
                                                                                  Text(
                                                                                    ticketResponse
                                                                                        .openingNotice
                                                                                        .concerts[index1]
                                                                                        .ticketingSchedules[0]
                                                                                        .dday,
                                                                                    style: const TextStyle(
                                                                                      fontFamily: 'Pretendard',
                                                                                      fontSize: 12,
                                                                                      color: Color(0xffFF5F5F),
                                                                                      fontWeight: FontWeight.w700,
                                                                                    ),
                                                                                  )
                                                                                else
                                                                                  Text(
                                                                                    ticketResponse
                                                                                        .openingNotice
                                                                                        .concerts[index1]
                                                                                        .ticketingSchedules[0]
                                                                                        .dday,
                                                                                    style: const TextStyle(
                                                                                      fontFamily: 'Pretendard',
                                                                                      fontSize: 12,
                                                                                      color: Colors.white,
                                                                                      fontWeight: FontWeight.w700,
                                                                                    ),
                                                                                  ),
                                                                              ],
                                                                            )
                                                                          ])
                                                                    //선예매 , 일반예매
                                                                    else
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                        children: [
                                                                          Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                "${ticketResponse.openingNotice.concerts[index1].ticketingSchedules[0].type} 오픈",
                                                                                style: const TextStyle(
                                                                                  fontFamily: 'Pretendard',
                                                                                  fontSize: 12,
                                                                                  color: b_400,
                                                                                  fontWeight: FontWeight.w400,
                                                                                ),
                                                                              ),
                                                                              if (ticketResponse
                                                                                          .openingNotice
                                                                                          .concerts[index1]
                                                                                          .ticketingSchedules[0]
                                                                                          .dday ==
                                                                                      'D-3' ||
                                                                                  ticketResponse
                                                                                          .openingNotice
                                                                                          .concerts[index1]
                                                                                          .ticketingSchedules[0]
                                                                                          .dday ==
                                                                                      'D-2' ||
                                                                                  ticketResponse
                                                                                          .openingNotice
                                                                                          .concerts[index1]
                                                                                          .ticketingSchedules[0]
                                                                                          .dday ==
                                                                                      'D-1' ||
                                                                                  ticketResponse
                                                                                          .openingNotice
                                                                                          .concerts[index1]
                                                                                          .ticketingSchedules[0]
                                                                                          .dday ==
                                                                                      'D-Day')
                                                                                Text(
                                                                                  ticketResponse
                                                                                      .openingNotice
                                                                                      .concerts[index1]
                                                                                      .ticketingSchedules[0]
                                                                                      .dday,
                                                                                  style: const TextStyle(
                                                                                    fontFamily: 'Pretendard',
                                                                                    fontSize: 12,
                                                                                    color: Color(0xffFF5F5F),
                                                                                    fontWeight: FontWeight.w700,
                                                                                  ),
                                                                                )
                                                                              else
                                                                                Text(
                                                                                  ticketResponse
                                                                                      .openingNotice
                                                                                      .concerts[index1]
                                                                                      .ticketingSchedules[0]
                                                                                      .dday,
                                                                                  style: const TextStyle(
                                                                                    fontFamily: 'Pretendard',
                                                                                    fontSize: 12,
                                                                                    color: Colors.white,
                                                                                    fontWeight: FontWeight.w700,
                                                                                  ),
                                                                                ),
                                                                            ],
                                                                          ),
                                                                          Container(
                                                                            width: 1,
                                                                            // 실선의 두께
                                                                            height: 40,
                                                                            // 실선의 높이
                                                                            color: b_800,
                                                                            // 실선 색상
                                                                            margin: const EdgeInsets.symmetric(
                                                                                horizontal: 12), // 여백
                                                                          ),
                                                                          Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            mainAxisAlignment: MainAxisAlignment.start,
                                                                            children: [
                                                                              Text(
                                                                                "${ticketResponse.openingNotice.concerts[index1].ticketingSchedules[1].type} 오픈",
                                                                                style: const TextStyle(
                                                                                  fontFamily: 'Pretendard',
                                                                                  fontSize: 12,
                                                                                  color: b_400,
                                                                                  fontWeight: FontWeight.w400,
                                                                                ),
                                                                              ),
                                                                              if (ticketResponse
                                                                                          .openingNotice
                                                                                          .concerts[index1]
                                                                                          .ticketingSchedules[1]
                                                                                          .dday ==
                                                                                      'D-3' ||
                                                                                  ticketResponse
                                                                                          .openingNotice
                                                                                          .concerts[index1]
                                                                                          .ticketingSchedules[1]
                                                                                          .dday ==
                                                                                      'D-2' ||
                                                                                  ticketResponse
                                                                                          .openingNotice
                                                                                          .concerts[index1]
                                                                                          .ticketingSchedules[1]
                                                                                          .dday ==
                                                                                      'D-1' ||
                                                                                  ticketResponse
                                                                                          .openingNotice
                                                                                          .concerts[index1]
                                                                                          .ticketingSchedules[1]
                                                                                          .dday ==
                                                                                      'D-Day')
                                                                                Text(
                                                                                  ticketResponse
                                                                                      .openingNotice
                                                                                      .concerts[index1]
                                                                                      .ticketingSchedules[1]
                                                                                      .dday,
                                                                                  style: const TextStyle(
                                                                                    fontFamily: 'Pretendard',
                                                                                    fontSize: 12,
                                                                                    color: Color(0xffFF5F5F),
                                                                                    fontWeight: FontWeight.w700,
                                                                                  ),
                                                                                )
                                                                              else
                                                                                Text(
                                                                                  ticketResponse
                                                                                      .openingNotice
                                                                                      .concerts[index1]
                                                                                      .ticketingSchedules[1]
                                                                                      .dday,
                                                                                  style: const TextStyle(
                                                                                    fontFamily: 'Pretendard',
                                                                                    fontSize: 12,
                                                                                    color: Colors.white,
                                                                                    fontWeight: FontWeight.w700,
                                                                                  ),
                                                                                ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(height: 12),
                                                ],
                                              );
                                            }),
                                          )
                                        ],
                                      )
                                    : const SizedBox(),
                                ticketResponse.onSale.totalNum > 0
                                    ? Column(
                                        children: [
                                          Row(
                                            children: [
                                              const Text("예매 중인 티켓",
                                                  style: TextStyle(
                                                      fontFamily: 'Pretendard',
                                                      fontSize: 16,
                                                      color: b_100,
                                                      fontWeight: FontWeight.w500)),
                                              const SizedBox(width: 12),
                                              Container(
                                                height: 29,
                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                                clipBehavior: Clip.antiAlias,
                                                decoration: ShapeDecoration(
                                                  color: v1pt_20,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                ),
                                                child: Text("${ticketResponse.onSale.totalNum}개",
                                                    style: const TextStyle(
                                                        fontFamily: 'Pretendard',
                                                        fontSize: 14,
                                                        color: p_500,
                                                        fontWeight: FontWeight.w700)),
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 12),
                                          Column(
                                            children: List.generate(ticketResponse.onSale.totalNum, (index1) {
                                              return Column(
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      // 상세 페이지로 이동
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => OnSaleDetailV1(
                                                            concertId: ticketResponse
                                                                .onSale.concerts[index1].concertId, // 상세 페이지에 데이터 전달
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Row(
                                                      children: [
                                                        ClipRRect(
                                                          borderRadius: BorderRadius.circular(12.0),
                                                          child: Image.network(
                                                            ticketResponse.onSale.concerts[index1].imageUrl,
                                                            height: 110,
                                                            width: 83,
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                        Stack(
                                                          children: [
                                                            //티켓 정보
                                                            Container(
                                                              width: MediaQuery.of(context).size.width - 123,
                                                              // 원하는 여백을 빼고 가로 크기 설정
                                                              height: 110,
                                                              clipBehavior: Clip.antiAlias,
                                                              decoration: ShapeDecoration(
                                                                color: b_900,
                                                                shape: RoundedRectangleBorder(
                                                                  borderRadius: BorderRadius.circular(8),
                                                                ),
                                                              ),
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(12.0),
                                                                // 여백 12씩 추가
                                                                child: Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  //왼쪽정렬
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                  children: [
                                                                    //공연 제목
                                                                    SizedBox(
                                                                        height: 34,
                                                                        child: RichText(
                                                                          maxLines: 2,
                                                                          overflow: TextOverflow.ellipsis,
                                                                          text: TextSpan(
                                                                            text: ticketResponse
                                                                                .onSale.concerts[index1].title,
                                                                            style: const TextStyle(
                                                                              fontFamily: 'Pretendard',
                                                                              fontSize: 14,
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.w500,
                                                                            ),
                                                                          ),
                                                                        )),
                                                                    // 티켓 공연 정보
                                                                    Column(
                                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                                      children: [
                                                                        const Text("공연 일시",
                                                                            style: TextStyle(
                                                                              fontFamily: 'Pretendard',
                                                                              fontSize: 12,
                                                                              color: b_400,
                                                                              fontWeight: FontWeight.w400,
                                                                            )),
                                                                        Text(
                                                                          ticketResponse.onSale.concerts[index1].date,
                                                                          style: const TextStyle(
                                                                            fontFamily: 'Pretendard',
                                                                            fontSize: 12,
                                                                            color: b_400,
                                                                            fontWeight: FontWeight.w400,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Container(height: 12),
                                                ],
                                              );
                                            }),
                                          )
                                        ],
                                      )
                                    : const SizedBox()
                              ],
                            ));
                      }
                    }))));
  }
}
