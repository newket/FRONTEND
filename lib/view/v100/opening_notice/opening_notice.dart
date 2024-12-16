import 'package:flutter/material.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/repository/ticket_repository.dart';
import 'package:newket/repository/user_repository.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/view/v100/opening_notice/opening_notice_detail.dart';

class OpeningNoticeV1 extends StatefulWidget {
  const OpeningNoticeV1({super.key});

  @override
  State<StatefulWidget> createState() => _OpeningNoticeV1();
}

class _OpeningNoticeV1 extends State<OpeningNoticeV1> {
  late UserRepository userRepository;
  late TicketRepository ticketRepository;
  String selectedOption = '예매 오픈 임박 순';
  late Future repository; // Future 타입으로 초기화

  @override
  void initState() {
    super.initState();
    userRepository = UserRepository();
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
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: b_950,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              AmplitudeConfig.amplitude.logEvent('Back');
              Navigator.pop(context); //뒤로가기
            },
            color: b_100,
            icon: const Icon(Icons.keyboard_arrow_left)),
        backgroundColor: b_950,
        centerTitle: true,
        title: const Text(
          "오픈 예정 티켓",
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: FutureBuilder(
        future: repository,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // 데이터 로딩 실패
            return const Center();
          } else if (!snapshot.hasData) {
            // 데이터 없음
            return const Center();
          } else {
            final openingResponse = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                children: [
                  Container(height: 20),
                  Row(
                    children: [
                      Text(
                        '총 ${openingResponse.totalNum}개',
                        style: const TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18,
                          color: p_500,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Text(
                        "의 오픈 예정 티켓이 있어요!",
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18,
                          color: b_100,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  Container(height: 8),
                  Container(
                    height: 40,
                    padding: const EdgeInsets.only(left: 8, right: 8),
                    decoration: ShapeDecoration(
                      color: b_900,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 1, color: v1pt_50),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: PopupMenuButton<String>(
                      onSelected: (String newValue) {
                        setState(() {
                          selectedOption = newValue;
                          updateItemList(newValue); // 리스트 업데이트
                        });
                      },
                      padding: EdgeInsets.zero,
                      itemBuilder: (BuildContext context) {
                        return options.map((String option) {
                          return PopupMenuItem<String>(
                            value: option,
                            padding: const EdgeInsets.only(right: 12),
                            child: Container(
                              width: screenWidth - 40,
                              alignment: Alignment.centerRight,
                              child: Text(
                                option,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          );
                        }).toList();
                      },
                      constraints: BoxConstraints(
                        minWidth: screenWidth - 40,
                        maxWidth: screenWidth - 40,
                      ),
                      offset: const Offset(-8, 40),
                      color: b_900,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(width: 1, color: v1pt_90),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '정렬',
                            style: TextStyle(
                              color: b_400,
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
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const Icon(Icons.keyboard_arrow_down_outlined, color: Colors.white),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // 드롭다운과 리스트 사이의 간격
                  // Container로 GridView 감싸기
                  Expanded(
                    child: GridView.builder(
                      scrollDirection: Axis.vertical,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 가로에 두 개씩 배치
                        crossAxisSpacing: 20,
                        mainAxisExtent: ((screenWidth - 60) * 3 / 4) + 116,
                      ),
                      itemCount: openingResponse.concerts.length,
                      // concert 리스트의 길이 사용
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            onTap: () {
                              AmplitudeConfig.amplitude
                                  .logEvent('OpeningNoticeDetail(id:${openingResponse.concerts[index].concertId})');
                              // 상세 페이지로 이동
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => OpeningNoticeDetail(
                                    concertId: openingResponse.concerts[index].concertId, // 상세 페이지에 데이터 전달
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              height: 300,
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      openingResponse.concerts[index].imageUrl,
                                      width: (screenWidth - 60) / 2,
                                      height: (screenWidth - 60) * 3 / 4,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Container(height: 8),
                                  SizedBox(
                                      height: 34,
                                      child: RichText(
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          text: TextSpan(
                                            text: openingResponse.concerts[index].title,
                                            style: const TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontSize: 14,
                                              color: Color(0xffffffff),
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ))),
                                  Container(height: 8),
                                  Column(
                                      children: List.generate(
                                          //최대 2개
                                          openingResponse.concerts[index].ticketingSchedules.length > 2
                                              ? 2
                                              : openingResponse.concerts[index].ticketingSchedules.length, (index1) {
                                    return Column(
                                      children: [
                                        Container(
                                          height: 25,
                                          decoration: BoxDecoration(
                                            color: b_900,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          padding: const EdgeInsets.only(left: 8, right: 8),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  "${openingResponse.concerts[index].ticketingSchedules[index1].type} 오픈",
                                                  style: const TextStyle(
                                                    fontFamily: 'Pretendard',
                                                    fontSize: 12,
                                                    color: b_400,
                                                    fontWeight: FontWeight.w400,
                                                  )),
                                              if (openingResponse
                                                          .concerts[index].ticketingSchedules[index1].dday ==
                                                      'D-3' ||
                                                  openingResponse
                                                          .concerts[index].ticketingSchedules[index1].dday ==
                                                      'D-2' ||
                                                  openingResponse.concerts[index].ticketingSchedules[index1].dday ==
                                                      'D-1' ||
                                                  openingResponse.concerts[index].ticketingSchedules[index1].dday ==
                                                      'D-Day')
                                                Text(
                                                    "${openingResponse.concerts[index].ticketingSchedules[index1].dday}",
                                                    style: const TextStyle(
                                                      fontFamily: 'Pretendard',
                                                      fontSize: 12,
                                                      color: Color(0xffFF5F5F),
                                                      fontWeight: FontWeight.w700,
                                                    ))
                                              else
                                                Text(
                                                    "${openingResponse.concerts[index].ticketingSchedules[index1].dday}",
                                                    style: const TextStyle(
                                                      fontFamily: 'Pretendard',
                                                      fontSize: 12,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.w700,
                                                    ))
                                            ],
                                          ),
                                        ),
                                        Container(height: 8)
                                      ],
                                    );
                                  }))
                                ],
                              ),
                            ));
                      },
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
