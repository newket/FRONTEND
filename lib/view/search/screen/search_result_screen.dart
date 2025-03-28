import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/constant/fonts.dart';
import 'package:newket/model/ticket/search_result_response.dart';
import 'package:newket/repository/notification_request_repository.dart';
import 'package:newket/repository/ticket_repository.dart';
import 'package:newket/view/artist/screen/artist_profile_screen.dart';
import 'package:newket/view/artist/screen/artist_request_screen.dart';
import 'package:newket/view/artist/widget/artist_list_widget.dart';
import 'package:newket/view/search/widget/search_result_skeleton_widget.dart';
import 'package:newket/view/search/widget/searching_bar_widget.dart';
import 'package:newket/view/ticket_detail/screen/ticket_detail_screen.dart';
import 'package:newket/view/ticket_list/widget/before_sale_widget.dart';
import 'package:newket/view/ticket_list/widget/on_sale_widget.dart';

class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({super.key, required this.keyword});

  final String keyword;

  @override
  State<StatefulWidget> createState() => _SearchResultScreen();
}

class _SearchResultScreen extends State<SearchResultScreen> with WidgetsBindingObserver, RouteAware {
  late TicketRepository ticketRepository;
  bool isLoading = true;
  late NotificationRequestRepository notificationRequestRepository;
  late SearchResultResponse ticketResponse;
  List<bool> isFavoriteArtist = [];
  final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();

  @override
  void initState() {
    super.initState();
    notificationRequestRepository = NotificationRequestRepository();
    ticketRepository = TicketRepository();
    WidgetsBinding.instance.addObserver(this);
  }

  Future<void> _initializeSearchAndFavorites(String keyword) async {
    final response = await ticketRepository.searchResult(keyword);
    final favoriteStatuses = await Future.wait(
      response.artists.map((i) async {
        if (!mounted) return false; // 위젯이 dispose되었으면 기본값 반환
        return notificationRequestRepository.isArtistNotification(i.artistId, context);
      }),
    );

    if (!mounted) return; // dispose된 후 setState 방지

    setState(() {
      ticketResponse = response;
      isFavoriteArtist = favoriteStatuses;
      isLoading = false;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final route = ModalRoute.of(context);
    if (route != null) {
      _initializeSearchAndFavorites(widget.keyword);
      routeObserver.unsubscribe(this);
      routeObserver.subscribe(this, route as PageRoute);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: systemUiOverlayStyle,
        child: Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            body: SafeArea(
                child: Column(
              children: [
                SearchingBarWidget(keyword: widget.keyword),
                Expanded(
                    child: SingleChildScrollView(
                        child: isLoading
                            ? const SearchResultSkeletonWidget()
                            : Column(
                                children: [
                                  ticketResponse.artists.isNotEmpty
                                      ? Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("아티스트", style: s1_16Semi(f_100)),
                                              const SizedBox(height: 10),
                                              Column(
                                                  children: List.generate(ticketResponse.artists.length, (index) {
                                                return GestureDetector(
                                                    onTap: () {
                                                      Get.to(() => ArtistProfileScreen(
                                                          artistId: ticketResponse.artists[index].artistId));
                                                    },
                                                    child: ArtistListWidget(
                                                        artist: ticketResponse.artists[index],
                                                        isFavoriteArtist: isFavoriteArtist[index],
                                                        toastBottom: 40));
                                              })),
                                              const SizedBox(height: 4)
                                            ],
                                          ))
                                      : Container(
                                          height: 186,
                                          width: double.infinity,
                                          decoration: const BoxDecoration(color: Colors.white),
                                          child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                const SizedBox(height: 36),
                                                Text(
                                                  '찾으시는 아티스트가 없나요?',
                                                  textAlign: TextAlign.center,
                                                  style: button2_14Semi(f_100),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '원하는 아티스트를 요청해주세요.\n새로운 아티스트로 등록되면 알림을 보내드릴게요!',
                                                  textAlign: TextAlign.center,
                                                  style: c4_12Reg(f_50),
                                                ),
                                                const SizedBox(height: 12),
                                                GestureDetector(
                                                    onTap: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => const ArtistRequestScreen(),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      width: 210,
                                                      height: 40,
                                                      padding: const EdgeInsets.symmetric(vertical: 9),
                                                      clipBehavior: Clip.antiAlias,
                                                      decoration: ShapeDecoration(
                                                        color: pt_10,
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(8)),
                                                      ),
                                                      child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          crossAxisAlignment: CrossAxisAlignment.center,
                                                          children: [
                                                            Text(
                                                              '아티스트 등록 요청하러가기',
                                                              textAlign: TextAlign.center,
                                                              style: button2_14Semi(pt_100),
                                                            ),
                                                            const SizedBox(width: 4),
                                                            const Icon(Icons.arrow_forward_ios_rounded,
                                                                color: pt_100, size: 20)
                                                          ]),
                                                    ))
                                              ])),
                                  Container(height: 4, color: f_10, width: double.infinity), //아티스트 디바이더
                                  const SizedBox(height: 20),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20),
                                      child: Column(
                                        children: [
                                          (ticketResponse.onSaleTickets.totalNum == 0 &&
                                                  ticketResponse.beforeSaleTickets.totalNum == 0)
                                              ? Center(
                                                  child: ClipRRect(
                                                      borderRadius: BorderRadius.circular(12.0),
                                                      child: Image.asset('images/search/ticket_null.png',
                                                          width: 350, height: 336)))
                                              : const SizedBox(),
                                          ticketResponse.beforeSaleTickets.totalNum > 0
                                              ? Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text("오픈 예정 티켓", style: s1_16Semi(f_100)),
                                                        const SizedBox(width: 8),
                                                        Text("${ticketResponse.beforeSaleTickets.totalNum}개",
                                                            style: b7_16Reg(f_50))
                                                      ],
                                                    ),
                                                    const SizedBox(height: 12),
                                                    Column(
                                                      children: List.generate(
                                                        ticketResponse.beforeSaleTickets.tickets.length,
                                                        (index) {
                                                          return Column(children: [
                                                            GestureDetector(
                                                              onTap: () {
                                                                Navigator.push(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                    builder: (context) => TicketDetailScreen(
                                                                      ticketId: ticketResponse
                                                                          .beforeSaleTickets.tickets[index].ticketId,
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                              child: BeforeSaleWidget(
                                                                  beforeSaleTicketsResponse:
                                                                      ticketResponse.beforeSaleTickets,
                                                                  index: index),
                                                            ),
                                                            const SizedBox(height: 12)
                                                          ]);
                                                        },
                                                      ),
                                                    ),
                                                    const SizedBox(height: 28)
                                                  ],
                                                )
                                              : const SizedBox(),
                                          ticketResponse.onSaleTickets.totalNum > 0
                                              ? Column(children: [
                                                  Row(
                                                    children: [
                                                      Text("예매 중인 티켓", style: s1_16Semi(f_100)),
                                                      const SizedBox(width: 8),
                                                      Text("${ticketResponse.onSaleTickets.totalNum}개",
                                                          style: b7_16Reg(f_50))
                                                    ],
                                                  ),
                                                  const SizedBox(height: 12),
                                                  Column(
                                                    children: List.generate(
                                                      ticketResponse.onSaleTickets.totalNum,
                                                      (index) {
                                                        return Column(children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              // 상세 페이지로 이동
                                                              Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => TicketDetailScreen(
                                                                    ticketId: ticketResponse.onSaleTickets
                                                                        .tickets[index].ticketId, // 상세 페이지에 데이터 전달
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                            child: OnSaleWidget(
                                                                onSaleResponse: ticketResponse.onSaleTickets,
                                                                index: index),
                                                          ),
                                                          const SizedBox(height: 12)
                                                        ]);
                                                      },
                                                    ),
                                                  ),
                                                  const SizedBox(height: 28)
                                                ])
                                              : const SizedBox()
                                        ],
                                      )),
                                  const SizedBox(height: 20)
                                ],
                              ))),
              ],
            ))));
  }
}
