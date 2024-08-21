import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newket/repository/ticket_repository.dart';
import 'package:newket/theme/Colors.dart';
import 'package:url_launcher/url_launcher.dart';

class OnSaleDetail extends StatefulWidget {
  const OnSaleDetail({super.key, required this.concertId});

  final int concertId;

  @override
  State<StatefulWidget> createState() => _OnSaleDetail();
}

class _OnSaleDetail extends State<OnSaleDetail> {
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
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context); //뒤로가기
              },
              color: Colors.white,
              icon: const Icon(Icons.keyboard_arrow_left)),
          backgroundColor: b_950,
          centerTitle: true,
          title: const Text(
            "티켓 상세 정보",
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
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
                return SingleChildScrollView(
                    //스크롤 가능
                    child: Container(
                        width: double.infinity,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(color: p_700),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Stack(children: [
                                //점선 위 전체
                                Container(
                                  width: double.infinity,
                                  height: screenWidth * 4 / 3 + 90,
                                  decoration: const ShapeDecoration(
                                    color: b_950,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(24),
                                        bottomRight: Radius.circular(24),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start, //왼쪽 정렬
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12.0),
                                            child: Image.network(
                                              ticketResponse.imageUrl,
                                              width: screenWidth,
                                              height: screenWidth * 4 / 3,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          const SizedBox(height: 16),
                                          SizedBox(
                                              height: 50,
                                              child: RichText(
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  text: TextSpan(
                                                    text: ticketResponse.title,
                                                    style: const TextStyle(
                                                      fontFamily: 'Pretendard',
                                                      fontSize: 20,
                                                      color: Color(0xffffffff),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ))),
                                          const SizedBox(
                                            height: 24,
                                          )
                                        ]))
                              ]),
                              // 점선
                              Stack(children: [
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
                                  height: 270+(50*ticketResponse.date.length.toDouble()),
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
                                Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20, right: 20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const SizedBox(height: 25),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                SvgPicture.asset(
                                                    "images/ticket_detail/location.svg",
                                                    height: 20,
                                                    width: 20),
                                                const SizedBox(width: 8),
                                                const Text("공연 장소",
                                                    style: TextStyle(
                                                      fontFamily: 'Pretendard',
                                                      fontSize: 14,
                                                      color: b_400,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    )),
                                              ],
                                            ),
                                            //클릭하면 url로 이동
                                            InkWell(
                                                onTap: () {
                                                  launchURL(
                                                      ticketResponse.placeUrl);
                                                },
                                                child: Row(
                                                  children: [
                                                    Text(ticketResponse.place,
                                                        style: const TextStyle(
                                                          fontFamily:
                                                              'Pretendard',
                                                          fontSize: 14,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        )),
                                                    const SizedBox(width: 12),
                                                    const Icon(
                                                        Icons
                                                            .keyboard_arrow_right_rounded,
                                                        color: Colors.white)
                                                  ],
                                                ))
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(
                                                "images/ticket_detail/calendar.svg",
                                                height: 20,
                                                width: 20),
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
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 8),
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
                                        // 실선
                                        Container(
                                            height: 2,
                                            width: screenWidth - 40,
                                            color: b_800),
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
                                        Wrap(
                                          spacing: 12, // 각 아이템 간의 가로 간격
                                          runSpacing: 12, // 각 아이템 간의 세로 간격
                                          children: List.generate(
                                            ticketResponse.ticketProvider.length,
                                                (index) {
                                              String ticketProvider = ticketResponse.ticketProvider[index].ticketProvider;
                                              String? imageUrl;
                                              String? providerUrl = ticketResponse.ticketProvider[index].url; // 클릭 시 이동할 URL

                                              switch (ticketProvider) {
                                                case 'INTERPARK':
                                                  imageUrl = "images/ticket_detail/interpark.png";
                                                  break;
                                                case 'MELON':
                                                  imageUrl = "images/ticket_detail/melon.png";
                                                  break;
                                                case 'YES24':
                                                  imageUrl = "images/ticket_detail/yes24.png";
                                                  break;
                                                case 'TICKETLINK':
                                                  imageUrl = "images/ticket_detail/ticketlink.png";
                                                  break;
                                                default:
                                                  imageUrl = null;
                                              }

                                              if (imageUrl != null) {
                                                return InkWell(
                                                  onTap: () {
                                                    launchURL(providerUrl); // 클릭 시 URL로 이동
                                                  },
                                                  child: Image.asset(
                                                    imageUrl,
                                                    height: 56,
                                                    width: 56,
                                                  ),
                                                );
                                              } else {
                                                return const SizedBox(height: 56, width: 56);
                                              }
                                            },
                                          ),
                                        )
                                      ],
                                    ))
                              ])
                            ])));
              }
            }));
  }
}
