import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:newket/repository/ticket_repository.dart';
import 'package:newket/repository/user_repository.dart';
import 'package:newket/theme/colors.dart';
import 'package:newket/view/on_sale/on_sale.dart';
import 'package:newket/view/on_sale/on_sale_detail.dart';
import 'package:newket/view/opening_notice/opening_notice.dart';
import 'package:newket/view/opening_notice/opening_notice_detail.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _Home();
}

class _Home extends State<Home> {
  late UserRepository userRepository;
  late TicketRepository ticketRepository;

  @override
  void initState() {
    super.initState();
    userRepository = UserRepository();
    ticketRepository = TicketRepository();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //배경
      backgroundColor: b_950,

      //앱바
      appBar: AppBar(
        backgroundColor: b_950,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Image.asset("images/appbar/appbar_ticket.png", height: 28),
            Image.asset("images/appbar/appbar_alarm.png", height: 28),
          ],
        ),
      ),

      //내용
      body: RefreshIndicator(
        //새로 고침
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
          //스크롤 가능
          child: Container(
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(color: p_700),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //오픈이 임박한 티켓
                Stack(children: [
                  Container(
                    width: double.infinity,
                    height: 575,
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
                  //안내 멘트
                  Positioned(
                    left: 20,
                    top: 20,
                    right: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //왼쪽 정렬
                      children: [
                        // OO0님,
                        FutureBuilder(
                            future: userRepository.getUserInfoApi(context),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                //데이터 로딩 실패
                                return const Text("",
                                    style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700));
                              } else if (!snapshot.hasData) {
                                //데이터 없음
                                return const Text("",
                                    style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700));
                              } else {
                                final userInfo = snapshot.data!;
                                return Text("${userInfo.name}님,",
                                    style: const TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: 20,
                                        color: b_100,
                                        fontWeight: FontWeight.w700));
                              }
                            }),
                        //000의 티켓, 확인해 볼까요?
                        FutureBuilder(
                            future: ticketRepository.openingNoticeApi(context),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                //데이터 로딩 실패
                                return Center(
                                    child: Row(children: [
                                  Image.asset(
                                      "images/opening_notice/opening_notice_logo.png",
                                      height: 24),
                                  Container(width: 8),
                                  const Text("오픈이 임박한 티켓",
                                      style: TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontSize: 18,
                                          color: b_100,
                                          fontWeight: FontWeight.w700)),
                                  const CircularProgressIndicator()
                                ]));
                              } else if (!snapshot.hasData) {
                                //데이터 없음
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else {
                                final openingResponse = snapshot.data!;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(children: [
                                      Text(openingResponse.artistName,
                                          style: const TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontSize: 20,
                                              color: p_400,
                                              fontWeight: FontWeight.w700)),
                                      const Text("의 티켓, 확인해 볼까요?",
                                          style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontSize: 20,
                                              color: b_100,
                                              fontWeight: FontWeight.w700))
                                    ]),
                                    //빈공간 33
                                    Container(height: 33),
                                    //로고 + 오픈이 임박한 티켓
                                    Row(children: [
                                      Image.asset(
                                          "images/opening_notice/opening_notice_logo.png",
                                          height: 24),
                                      Container(width: 8),
                                      const Text("오픈이 임박한 티켓",
                                          style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontSize: 18,
                                              color: b_100,
                                              fontWeight: FontWeight.w700))
                                    ]),
                                    //빈공간 12
                                    Container(height: 12),
                                    //티켓
                                    Column(
                                      children: List.generate(3, (index1) {
                                        return Column(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                // 상세 페이지로 이동
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        OpeningNoticeDetail(
                                                      concertId: openingResponse
                                                          .concerts[index1]
                                                          .concertId, // 상세 페이지에 데이터 전달
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: Image.network(
                                                      openingResponse
                                                          .concerts[index1]
                                                          .imageUrl,
                                                      height: 110,
                                                      width: 83,
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                  Stack(
                                                    children: [
                                                      Column(
                                                        children: [
                                                          //점선 위 공간
                                                          Container(height: 10),
                                                          //티켓 점선
                                                          DottedBorder(
                                                            color: const Color(
                                                                0xffffffff),
                                                            strokeWidth: 1,
                                                            dashPattern: const [
                                                              4,
                                                              4
                                                            ],
                                                            child:
                                                                const SizedBox(
                                                              width: 0,
                                                              height: 86,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                      //티켓 정보
                                                      Container(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width -
                                                            123,
                                                        // 원하는 여백을 빼고 가로 크기 설정
                                                        height: 110,
                                                        clipBehavior:
                                                            Clip.antiAlias,
                                                        decoration:
                                                            ShapeDecoration(
                                                          color: b_900,
                                                          shape:
                                                              RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        12),
                                                          ),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          // 여백 8씩 추가
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            //왼쪽정렬
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              //공연 제목
                                                              SizedBox(
                                                                  height: 34,
                                                                  child:
                                                                      RichText(
                                                                    maxLines: 2,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    text:
                                                                        TextSpan(
                                                                      text: openingResponse
                                                                          .concerts[
                                                                              index1]
                                                                          .title,
                                                                      style:
                                                                          const TextStyle(
                                                                        fontFamily:
                                                                            'Pretendard',
                                                                        fontSize:
                                                                            16,
                                                                        color: Color(
                                                                            0xffffffff),
                                                                        fontWeight:
                                                                            FontWeight.w700,
                                                                      ),
                                                                    ),
                                                                  )),
                                                              // 티켓 오픈 정보
                                                              //일반예매 만
                                                              if (openingResponse
                                                                      .concerts[
                                                                          index1]
                                                                      .ticketingSchedule
                                                                      .length ==
                                                                  1)
                                                                Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceEvenly,
                                                                    children: [
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Text(
                                                                            "${openingResponse.concerts[index1].ticketingSchedule[0].type} 오픈",
                                                                            style:
                                                                                const TextStyle(
                                                                              fontFamily: 'Pretendard',
                                                                              fontSize: 12,
                                                                              color: b_400,
                                                                              fontWeight: FontWeight.w400,
                                                                            ),
                                                                          ),
                                                                          if (openingResponse.concerts[index1].ticketingSchedule[0].dday == 'D-3' ||
                                                                              openingResponse.concerts[index1].ticketingSchedule[0].dday == 'D-2' ||
                                                                              openingResponse.concerts[index1].ticketingSchedule[0].dday == 'D-1' ||
                                                                              openingResponse.concerts[index1].ticketingSchedule[0].dday == 'D-Day')
                                                                            Text(
                                                                              openingResponse.concerts[index1].ticketingSchedule[0].dday,
                                                                              style: const TextStyle(
                                                                                fontFamily: 'Pretendard',
                                                                                fontSize: 12,
                                                                                color: Color(0xffFF5F5F),
                                                                                fontWeight: FontWeight.w700,
                                                                              ),
                                                                            )
                                                                          else
                                                                            Text(
                                                                              openingResponse.concerts[index1].ticketingSchedule[0].dday,
                                                                              style: const TextStyle(
                                                                                fontFamily: 'Pretendard',
                                                                                fontSize: 12,
                                                                                color: Color(0xffffffff),
                                                                                fontWeight: FontWeight.w700,
                                                                              ),
                                                                            ),
                                                                        ],
                                                                      )
                                                                    ])
                                                              //선예매 , 일반예매
                                                              else
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  children: [
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          "${openingResponse.concerts[index1].ticketingSchedule[0].type} 오픈",
                                                                          style:
                                                                              const TextStyle(
                                                                            fontFamily:
                                                                                'Pretendard',
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                b_400,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                          ),
                                                                        ),
                                                                        if (openingResponse.concerts[index1].ticketingSchedule[0].dday == 'D-3' ||
                                                                            openingResponse.concerts[index1].ticketingSchedule[0].dday ==
                                                                                'D-2' ||
                                                                            openingResponse.concerts[index1].ticketingSchedule[0].dday ==
                                                                                'D-1' ||
                                                                            openingResponse.concerts[index1].ticketingSchedule[0].dday ==
                                                                                'D-Day')
                                                                          Text(
                                                                            openingResponse.concerts[index1].ticketingSchedule[0].dday,
                                                                            style:
                                                                                const TextStyle(
                                                                              fontFamily: 'Pretendard',
                                                                              fontSize: 12,
                                                                              color: Color(0xffFF5F5F),
                                                                              fontWeight: FontWeight.w700,
                                                                            ),
                                                                          )
                                                                        else
                                                                          Text(
                                                                            openingResponse.concerts[index1].ticketingSchedule[0].dday,
                                                                            style:
                                                                                const TextStyle(
                                                                              fontFamily: 'Pretendard',
                                                                              fontSize: 12,
                                                                              color: Color(0xffffffff),
                                                                              fontWeight: FontWeight.w700,
                                                                            ),
                                                                          ),
                                                                      ],
                                                                    ),
                                                                    Container(
                                                                      width: 1,
                                                                      // 실선의 두께
                                                                      height:
                                                                          40,
                                                                      // 실선의 높이
                                                                      color:
                                                                          b_800,
                                                                      // 실선 색상
                                                                      margin: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              8), // 여백
                                                                    ),
                                                                    Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .center,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          "${openingResponse.concerts[index1].ticketingSchedule[1].type} 오픈",
                                                                          style:
                                                                              const TextStyle(
                                                                            fontFamily:
                                                                                'Pretendard',
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                b_400,
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                          ),
                                                                        ),
                                                                        if (openingResponse.concerts[index1].ticketingSchedule[1].dday == 'D-3' ||
                                                                            openingResponse.concerts[index1].ticketingSchedule[1].dday ==
                                                                                'D-2' ||
                                                                            openingResponse.concerts[index1].ticketingSchedule[1].dday ==
                                                                                'D-1' ||
                                                                            openingResponse.concerts[index1].ticketingSchedule[1].dday ==
                                                                                'D-Day')
                                                                          Text(
                                                                            openingResponse.concerts[index1].ticketingSchedule[1].dday,
                                                                            style:
                                                                                const TextStyle(
                                                                              fontFamily: 'Pretendard',
                                                                              fontSize: 12,
                                                                              color: Color(0xffFF5F5F),
                                                                              fontWeight: FontWeight.w700,
                                                                            ),
                                                                          )
                                                                        else
                                                                          Text(
                                                                            openingResponse.concerts[index1].ticketingSchedule[1].dday,
                                                                            style:
                                                                                const TextStyle(
                                                                              fontFamily: 'Pretendard',
                                                                              fontSize: 12,
                                                                              color: Color(0xffffffff),
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
                                            Container(height: 12),
                                          ],
                                        );
                                      }),
                                    ),
                                    //오픈 예정 티켓 00개 모두 보기
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const OpeningNotice()),
                                        );
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                40,
                                        height: 44,
                                        decoration: ShapeDecoration(
                                          color: Colors.white.withOpacity(0.1),
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(
                                                width: 1, color: b_600),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            const Text('오픈 예정 티겟 ',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontFamily: 'Pretendard',
                                                    fontWeight:
                                                        FontWeight.w500)),
                                            Text(
                                              '${openingResponse.totalNum}개',
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontFamily: 'Pretendard',
                                                  fontWeight: FontWeight.w700),
                                            ),
                                            const Text(' 모두 보기',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontFamily: 'Pretendard',
                                                  fontWeight: FontWeight.w500,
                                                ))
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }
                            }),
                      ],
                    ),
                  ),
                ]),
                //예매 중인 티켓
                Stack(
                  children: [
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
                      height: 591,
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
                    Positioned(
                        left: 20,
                        top: 24,
                        right: 20,
                        child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start, //왼쪽 정렬
                            children: [
                              //로고 + 예매 중인 티켓
                              Row(children: [
                                Image.asset("images/on_sale/on_sale_logo.png",
                                    height: 24),
                                Container(width: 8),
                                const Text("예매 중인 티켓",
                                    style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: 18,
                                        color: b_100,
                                        fontWeight: FontWeight.w700))
                              ]),
                              //빈공간 12
                              Container(height: 12),
                              FutureBuilder(
                                  future: ticketRepository.onSaleApi(context),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      //데이터 로딩 실패
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else if (!snapshot.hasData) {
                                      //데이터 없음
                                      return const Center(
                                          child: CircularProgressIndicator());
                                    } else {
                                      final onSaleResponse = snapshot.data!;
                                      return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                              children:
                                                  List.generate(3, (index1) {
                                                return Column(
                                                  children: [
                                                    GestureDetector(
                                                      onTap: () {
                                                        // 상세 페이지로 이동
                                                        Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                                OnSaleDetail(
                                                              concertId:
                                                                  onSaleResponse
                                                                      .concerts[
                                                                          index1]
                                                                      .concertId, // 상세 페이지에 데이터 전달
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      child: Row(
                                                        children: [
                                                          ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        8.0),
                                                            child:
                                                                Image.network(
                                                              onSaleResponse
                                                                  .concerts[
                                                                      index1]
                                                                  .imageUrl,
                                                              height: 110,
                                                              width: 83,
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                          Stack(
                                                            children: [
                                                              Column(
                                                                children: [
                                                                  //점선 위 공간
                                                                  Container(
                                                                      height:
                                                                          10),
                                                                  //티켓 점선
                                                                  DottedBorder(
                                                                    color: const Color(
                                                                        0xffffffff),
                                                                    strokeWidth:
                                                                        1,
                                                                    dashPattern: const [
                                                                      4,
                                                                      4
                                                                    ],
                                                                    child:
                                                                        const SizedBox(
                                                                      width: 0,
                                                                      height:
                                                                          86,
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                              //티켓 정보
                                                              Container(
                                                                width: MediaQuery.of(
                                                                            context)
                                                                        .size
                                                                        .width -
                                                                    123,
                                                                // 원하는 여백을 빼고 가로 크기 설정
                                                                height: 110,
                                                                clipBehavior: Clip
                                                                    .antiAlias,
                                                                decoration:
                                                                    ShapeDecoration(
                                                                  color: b_900,
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            12),
                                                                  ),
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          8.0),
                                                                  // 여백 8씩 추가
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    //왼쪽정렬
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    children: [
                                                                      //공연 제목
                                                                      SizedBox(
                                                                          height:
                                                                              34,
                                                                          child:
                                                                              RichText(
                                                                            maxLines:
                                                                                2,
                                                                            overflow:
                                                                                TextOverflow.ellipsis,
                                                                            text:
                                                                                TextSpan(
                                                                              text: onSaleResponse.concerts[index1].title,
                                                                              style: const TextStyle(
                                                                                fontFamily: 'Pretendard',
                                                                                fontSize: 16,
                                                                                color: Color(0xffffffff),
                                                                                fontWeight: FontWeight.w700,
                                                                              ),
                                                                            ),
                                                                          )),
                                                                      // 티켓 공연 정보
                                                                      Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.start,
                                                                        children: [
                                                                          const Text(
                                                                              "공연 일시",
                                                                              style: TextStyle(
                                                                                fontFamily: 'Pretendard',
                                                                                fontSize: 12,
                                                                                color: b_400,
                                                                                fontWeight: FontWeight.w400,
                                                                              )),
                                                                          Text(
                                                                            onSaleResponse.concerts[index1].date,
                                                                            style:
                                                                                const TextStyle(
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
                                            ),
                                            // 예매 중인 티켓 00개 모두 보기
                                            GestureDetector(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const OnSale()),
                                                  );
                                                },
                                                child: Container(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width -
                                                      40,
                                                  height: 44,
                                                  decoration: ShapeDecoration(
                                                    color: Colors.white
                                                        .withOpacity(0.1),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      side: const BorderSide(
                                                          width: 1,
                                                          color: b_600),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      const Text('예매 중인 티겟 ',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14,
                                                              fontFamily:
                                                                  'Pretendard',
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)),
                                                      Text(
                                                        '${onSaleResponse.totalNum}개',
                                                        style: const TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'Pretendard',
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700),
                                                      ),
                                                      const Text(' 모두 보기',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontFamily:
                                                                'Pretendard',
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ))
                                                    ],
                                                  ),
                                                ))
                                          ]);
                                    }
                                  })
                            ]))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
