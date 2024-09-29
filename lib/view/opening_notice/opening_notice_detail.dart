import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newket/repository/ticket_repository.dart';
import 'package:newket/repository/user_repository.dart';
import 'package:newket/theme/Colors.dart';
import 'package:url_launcher/url_launcher.dart';

class OpeningNoticeDetail extends StatefulWidget {
  const OpeningNoticeDetail({super.key, required this.concertId});

  final int concertId;

  @override
  State<StatefulWidget> createState() => _OpeningNoticeDetail();
}

class _OpeningNoticeDetail extends State<OpeningNoticeDetail> {
  late TicketRepository ticketRepository;

  @override
  void initState() {
    super.initState();
    ticketRepository = TicketRepository();
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    void launchURL(String url) async {
      Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $url';
      }
    }

    return Scaffold(
        backgroundColor: b_950,
        body: FutureBuilder(
            future: ticketRepository.ticketDetail(context, widget.concertId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                // 데이터 로딩 실패
                return const Center(child: CircularProgressIndicator());
              } else if (!snapshot.hasData) {
                // 데이터 없음
                return const Center(child: CircularProgressIndicator());
              } else {
                final ticketResponse = snapshot.data!;
                return Container(
                    width: double.infinity,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(color: p_700),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(children: [
                            //점선 위 전체
                            SizedBox(
                              width: double.infinity,
                              height: 335,
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(24),
                                  bottomRight: Radius.circular(24),
                                ),
                                child: Image.network(
                                  ticketResponse.imageUrl,
                                  width: 116,
                                  height: 154,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            ),
                            //검은 그림자
                            Container(
                              width: double.infinity,
                              height: 335,
                              decoration: const ShapeDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment(0.00, -1.00),
                                  end: Alignment(0, 1),
                                  colors: [Color(0x66020617), Color(0xFF020617)],
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(24),
                                    bottomRight: Radius.circular(24),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 72, left: 20, right: 20),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 32),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12.0),
                                        child: Image.network(
                                          ticketResponse.imageUrl,
                                          width: 116,
                                          height: 154,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      RichText(
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis, //2줄 이상은 ...
                                          text: TextSpan(
                                            text: ticketResponse.title,
                                            style: const TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontSize: 20,
                                              color: Color(0xffffffff),
                                              fontWeight: FontWeight.w700,
                                            ),
                                          )),
                                      const SizedBox(width: 12),
                                    ])),
                            //앱바
                            AppBar(
                              leading: IconButton(
                                  onPressed: () {
                                    Navigator.pop(context); //뒤로가기
                                  },
                                  color: b_100,
                                  icon: const Icon(Icons.keyboard_arrow_left)),
                              backgroundColor: Colors.transparent,
                              centerTitle: true,
                              title: const Text(
                                "티켓 상세 정보",
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ]),
                          // 점선
                          Expanded(
                              child: Stack(children: [
                            DottedBorder(
                              color: p_700,
                              strokeWidth: 6,
                              dashPattern: const [6, 6],
                              child: const SizedBox(
                                width: double.infinity,
                                height: 0,
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              decoration: const ShapeDecoration(
                                color: b_950,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(24),
                                    topRight: Radius.circular(24),
                                  ),
                                ),
                              ),
                            ),
                           //스크롤 가능
                           SingleChildScrollView(
                             padding: const EdgeInsets.only(left: 20, right: 20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 25),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SvgPicture.asset("images/ticket_detail/location.svg", height: 20, width: 20),
                                        const SizedBox(width: 8),
                                        const Text("공연 장소",
                                            style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontSize: 14,
                                              color: b_400,
                                              fontWeight: FontWeight.w400,
                                            )),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    //클릭하면 url로 이동
                                    InkWell(
                                        onTap: () {
                                          launchURL(ticketResponse.placeUrl);
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(ticketResponse.place,
                                                style: const TextStyle(
                                                  fontFamily: 'Pretendard',
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w500,
                                                )),
                                            const SizedBox(width: 12),
                                            const Icon(Icons.keyboard_arrow_right_rounded, color: Colors.white)
                                          ],
                                        )),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SvgPicture.asset("images/ticket_detail/calendar.svg", height: 20, width: 20),
                                        const SizedBox(width: 8),
                                        const Text("공연 일시",
                                            style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontSize: 14,
                                              color: b_400,
                                              fontWeight: FontWeight.w400,
                                            )),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    //공연 일시 박스
                                    Wrap(
                                      spacing: 12, // 각 아이템 간의 가로 간격
                                      runSpacing: 12, // 각 아이템 간의 세로 간격
                                      children: List.generate(
                                        ticketResponse.date.length,
                                        (index) {
                                          return Container(
                                            width: (screenWidth - 52) / 2,
                                            // 아이템의 너비를 반으로 나눔 (양쪽 여백 포함)
                                            height: 37,
                                            decoration: BoxDecoration(
                                              color: b_900,
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                            child: Text(
                                              ticketResponse.date[index],
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                fontFamily: 'Pretendard',
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    //실선
                                    Container(height: 2, width: screenWidth - 40, color: b_800),
                                    const SizedBox(height: 20),
                                    //예매처 바로 가기
                                    const Text("예매처 바로가기",
                                        style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                        )),
                                    const SizedBox(height: 12),
                                    Container(height: 8),
                                    //예매처 카드
                                    Wrap(
                                        runSpacing: 8, // 각 아이템 간의 세로 간격
                                        children: List.generate(ticketResponse.ticketProviders.length, (index) {
                                          return InkWell(
                                              onTap: () {
                                                launchURL(ticketResponse.ticketProviders[index].url); // 클릭 시 URL로 이동
                                              },
                                              child: Container(
                                                width: screenWidth - 40,
                                                height: 106,
                                                decoration: BoxDecoration(
                                                  color: b_900,
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                                child: Column(children: [
                                                  //예매처 사진
                                                  Row(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Image.asset(
                                                            switch (
                                                                ticketResponse.ticketProviders[index].ticketProvider) {
                                                              'INTERPARK' => "images/ticket_detail/interpark.png",
                                                              'MELON' => "images/ticket_detail/melon.png",
                                                              'YES24' => "images/ticket_detail/yes24.png",
                                                              'TICKETLINK' => "images/ticket_detail/ticketlink.png",
                                                              _ => "",
                                                            },
                                                            height: 32,
                                                            width: 32,
                                                          ),
                                                          const SizedBox(width: 12),
                                                          Text(
                                                              switch (ticketResponse
                                                                  .ticketProviders[index].ticketProvider) {
                                                                'INTERPARK' => "인터파크 티켓",
                                                                'MELON' => "멜론 티켓",
                                                                'YES24' => "YES24 티켓",
                                                                'TICKETLINK' => "티켓링크",
                                                                _ => "",
                                                              },
                                                              style: const TextStyle(
                                                                fontFamily: 'Pretendard',
                                                                fontSize: 14,
                                                                color: b_200,
                                                                fontWeight: FontWeight.w500,
                                                              ))
                                                        ],
                                                      ),
                                                      const Icon(Icons.keyboard_arrow_right_rounded,
                                                          color: Colors.white)
                                                    ],
                                                  ),
                                                  const SizedBox(height: 10),
                                                  //오픈일
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: [
                                                      // 첫 번째 일정 텍스트
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            "${ticketResponse.ticketProviders[index].ticketingSchedules[0].type} 오픈일",
                                                            textAlign: TextAlign.center,
                                                            style: const TextStyle(
                                                              fontFamily: 'Pretendard',
                                                              fontSize: 12,
                                                              color: b_500,
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          ),
                                                          Text(
                                                            "${ticketResponse.ticketProviders[index].ticketingSchedules[0].date} ${ticketResponse.ticketProviders[index].ticketingSchedules[0].time}",
                                                            textAlign: TextAlign.center,
                                                            style: const TextStyle(
                                                              fontFamily: 'Pretendard',
                                                              fontSize: 14,
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      // 만약 일정이 두 개라면 사이에 VerticalDivider 추가
                                                      if (ticketResponse
                                                              .ticketProviders[index].ticketingSchedules.length ==
                                                          2) ...[
                                                        Container(
                                                          color: b_800,
                                                          // 세로 실선 색상
                                                          width: 1,
                                                          // 실선 두께
                                                          height: 24,
                                                        ),
                                                        // 두 번째 일정 텍스트
                                                        Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              "${ticketResponse.ticketProviders[index].ticketingSchedules[1].type} 오픈일",
                                                              textAlign: TextAlign.center,
                                                              style: const TextStyle(
                                                                fontFamily: 'Pretendard',
                                                                fontSize: 12,
                                                                color: b_500,
                                                                fontWeight: FontWeight.w400,
                                                              ),
                                                            ),
                                                            Text(
                                                              "${ticketResponse.ticketProviders[index].ticketingSchedules[1].date} ${ticketResponse.ticketProviders[index].ticketingSchedules[1].time}",
                                                              textAlign: TextAlign.center,
                                                              style: const TextStyle(
                                                                fontFamily: 'Pretendard',
                                                                fontSize: 14,
                                                                color: Colors.white,
                                                                fontWeight: FontWeight.w500,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ]
                                                    ],
                                                  )
                                                ]),
                                              ));
                                        }))
                                  ],
                                ))
                          ]))
                        ]));
              }
            }));
  }
}
