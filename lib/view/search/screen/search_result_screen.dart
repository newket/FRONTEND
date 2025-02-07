import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/constant/fonts.dart';
import 'package:newket/model/ticket/on_sale_model.dart';
import 'package:newket/model/ticket/opening_notice_model.dart';
import 'package:newket/model/ticket/search_result_model.dart';
import 'package:newket/repository/artist_repository.dart';
import 'package:newket/repository/ticket_repository.dart';
import 'package:newket/view/artist/screen/artist_profile_screen.dart';
import 'package:newket/view/artist/screen/artist_request_screen.dart';
import 'package:newket/view/concert_list/widget/on_sale_widget.dart';
import 'package:newket/view/concert_list/widget/opening_notice_widget.dart';
import 'package:newket/view/search/widget/artist_list_widget.dart';
import 'package:newket/view/search/widget/searching_bar_widget.dart';
import 'package:newket/view/ticket_detail/screen/ticket_detail_screen.dart';

class SearchResultScreen extends StatefulWidget {
  const SearchResultScreen({super.key, required this.keyword});

  final String keyword;

  @override
  State<StatefulWidget> createState() => _SearchResultScreen();
}

class _SearchResultScreen extends State<SearchResultScreen> {
  late TicketRepository ticketRepository;
  bool isLoading = true;
  List<OpeningNoticeResponse> openingNoticeResponse = [];
  List<OnSaleResponse> onSaleResponse = [];
  late ArtistRepository artistRepository;
  late SearchResultResponse ticketResponse;
  List<bool> isFavoriteArtist = [];

  @override
  void initState() {
    super.initState();
    artistRepository = ArtistRepository();
    ticketRepository = TicketRepository();
    _initializeSearchAndFavorites(widget.keyword);
  }

  Future<void> _initializeSearchAndFavorites(String keyword) async {
    final response = await ticketRepository.searchArtistsAndTickets(keyword);
    final favoriteStatuses = await Future.wait(
      response.artists.map((i) => artistRepository.getIsFavoriteArtist(i.artistId, context)),
    );

    if (mounted) {
      setState(() {
        ticketResponse = response;
        isFavoriteArtist = favoriteStatuses;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(color: Colors.white);
    }
    return Scaffold(
        //배경
        backgroundColor: Colors.white,
        //내용
        body: SafeArea(
            child: Column(
          children: [
            SearchingBarWidget(keyword: widget.keyword),
            Expanded(
                child: SingleChildScrollView(
                    //스크롤 가능
                    child: Column(
              children: [
                ticketResponse.artists.isNotEmpty
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(left: 20, right: 20, top: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("아티스트", style: t2_18Semi(f_100)),
                            const SizedBox(height: 12),
                            Column(
                                children: List.generate(ticketResponse.artists.length, (index) {
                              return GestureDetector(
                                  onTap: () {
                                    Get.to(ArtistProfileScreen(artistId: ticketResponse.artists[index].artistId));
                                  },
                                  child: ArtistListWidget(
                                      artist: ticketResponse.artists[index],
                                      isFavoriteArtist: isFavoriteArtist[index]));
                            })),
                            const SizedBox(height: 4)
                          ],
                        ))
                    : Container(
                        height: 190,
                        width: double.infinity,
                        decoration: const BoxDecoration(color: Colors.white),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(height: 32),
                              Text(
                                '찾으시는 아티스트가 없나요?',
                                textAlign: TextAlign.center,
                                style: s1_16Semi(f_100),
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
                                    AmplitudeConfig.amplitude.logEvent('ArtistRequest');
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const ArtistRequestScreen(),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    width: 207,
                                    height: 46,
                                    padding: const EdgeInsets.symmetric(vertical: 12),
                                    clipBehavior: Clip.antiAlias,
                                    decoration: ShapeDecoration(
                                      color: pt_10,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                                          const Icon(Icons.navigate_next, color: pt_100, size: 20)
                                        ]),
                                  ))
                            ])),
                Container(height: 5, color: f_10, width: double.infinity), //아티스트 디바이더
                const SizedBox(height: 20),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        (ticketResponse.onSale.totalNum == 0 && ticketResponse.openingNotice.totalNum == 0)
                            ? Center(
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: Image.asset('images/search/ticket_null.png', width: 350, height: 336)))
                            : const SizedBox(),
                        ticketResponse.openingNotice.totalNum > 0
                            ? Column(
                                children: [
                                  Row(
                                    children: [
                                      Text("오픈 예정 티켓", style: t2_18Semi(f_100)),
                                      const SizedBox(width: 8),
                                      Text("${ticketResponse.openingNotice.totalNum}개", style: s1_16Semi(pn_100))
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Column(
                                    children: List.generate(
                                      ticketResponse.openingNotice.concerts.length,
                                      (index) {
                                        return Column(children: [
                                          GestureDetector(
                                            onTap: () {
                                              AmplitudeConfig.amplitude.logEvent(
                                                  'OpeningNoticeDetail(id:${ticketResponse.openingNotice.concerts[index].concertId})');
                                              // 상세 페이지로 이동
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => TicketDetailScreen(
                                                    concertId: ticketResponse
                                                        .openingNotice.concerts[index].concertId, // 상세 페이지에 데이터 전달
                                                  ),
                                                ),
                                              );
                                            },
                                            child: OpeningNoticeWidget(
                                                openingResponse: ticketResponse.openingNotice, index: index),
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
                        ticketResponse.onSale.totalNum > 0
                            ? Column(children: [
                                Row(
                                  children: [
                                    Text("예매 중인 티켓", style: t2_18Semi(f_100)),
                                    const SizedBox(width: 8),
                                    Text("${ticketResponse.onSale.totalNum}개", style: s1_16Semi(pn_100))
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Column(
                                  children: List.generate(
                                    ticketResponse.onSale.concerts.length,
                                    (index) {
                                      return Column(children: [
                                        GestureDetector(
                                          onTap: () {
                                            AmplitudeConfig.amplitude.logEvent(
                                                'OpeningNoticeDetail(id:${ticketResponse.onSale.concerts[index].concertId})');
                                            // 상세 페이지로 이동
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => TicketDetailScreen(
                                                  concertId:
                                                      ticketResponse.onSale.concerts[index].concertId, // 상세 페이지에 데이터 전달
                                                ),
                                              ),
                                            );
                                          },
                                          child: OnSaleWidget(onSaleResponse: ticketResponse.onSale, index: index),
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
        )));
  }
}
