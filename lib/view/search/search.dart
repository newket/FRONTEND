import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newket/component/on_sale_card.dart';
import 'package:newket/component/opening_notice_card.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/model/artist_model.dart';
import 'package:newket/model/ticket_model.dart';
import 'package:newket/repository/artist_repository.dart';
import 'package:newket/repository/ticket_repository.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/view/artist/artist_request.dart';
import 'package:newket/view/ticket_detail/ticket_detail.dart';

class SearchV2 extends StatefulWidget {
  const SearchV2({super.key, required this.keyword});

  final String keyword;

  @override
  State<StatefulWidget> createState() => _SearchV2();
}

class _SearchV2 extends State<SearchV2> {
  late TicketRepository ticketRepository;
  late TextEditingController _searchController;
  String keyword = '';
  bool isLoading = true;
  List<Artist> artists = []; // 검색 결과를 담을 리스트
  List<Concert> openingNoticeResponse = [];
  List<ConcertOnSale> onSaleResponse = [];
  late ArtistRepository artistRepository;
  late SearchResponse ticketResponse;
  List<bool> isFavoriteArtist = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.keyword);
    artistRepository = ArtistRepository();
    ticketRepository = TicketRepository();
    keyword = widget.keyword;
    _initializeSearchAndFavorites(keyword);
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
  Widget build(BuildContext context) {
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    Timer? debounce;
    if (isLoading) {
      return Container();
    }
    return Scaffold(
        //배경
        backgroundColor: Colors.white,
        //앱바
        appBar: AppBar(
          leadingWidth: 24, // 사이 간격 줄이기
          leading: IconButton(
              onPressed: () {
                AmplitudeConfig.amplitude.logEvent('Back');
                Navigator.pop(context); //뒤로가기
              },
              color: f_90,
              icon: const Icon(Icons.keyboard_arrow_left, size: 24)),
          backgroundColor: Colors.white,
          title: Container(
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
                      setState(() {
                        artists = [];
                        openingNoticeResponse = [];
                        onSaleResponse = [];
                        _searchController.clear(); // 텍스트 필드 값을 빈 문자열로 리셋
                        keyword = value;
                      });
                      _initializeSearchAndFavorites(value);
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
          ),
        ),
        //내용
        body: Stack(
          children: [
            GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(), // 키보드 외부를 탭하면 키보드 숨기기
                child: SingleChildScrollView(
                    //스크롤 가능
                    child: Column(
                  children: [
                    ticketResponse.artists.isNotEmpty
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            padding: const EdgeInsets.only(left: 20, right: 20, top: 24, bottom: 8),
                            decoration: const BoxDecoration(color: Colors.white),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("관심 아티스트 추가하기",
                                    style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: 18,
                                        color: f_100,
                                        fontWeight: FontWeight.w600)),
                                const SizedBox(height: 12),
                                Container(
                                    width: MediaQuery.of(context).size.width - 43,
                                    padding: const EdgeInsets.symmetric(vertical: 6),
                                    child: Column(
                                        children: List.generate(ticketResponse.artists.length, (index) {
                                      return Column(
                                        children: [
                                          SizedBox(
                                              height: 48,
                                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      ticketResponse.artists[index].name,
                                                      style: const TextStyle(
                                                        fontFamily: 'Pretendard',
                                                        fontSize: 16,
                                                        color: f_100,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                    if (ticketResponse.artists[index].nicknames != null)
                                                      Text(
                                                        ticketResponse.artists[index].nicknames!,
                                                        style: const TextStyle(
                                                          fontFamily: 'Pretendard',
                                                          fontSize: 14,
                                                          color: f_50,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      )
                                                  ],
                                                ),
                                                if (isFavoriteArtist[index]) //관심 아티스트 아님
                                                  GestureDetector(
                                                      child: const Text(
                                                        "관심 아티스트에서 제거",
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          fontFamily: 'Pretendard',
                                                          fontSize: 12,
                                                          color: f_60,
                                                          fontWeight: FontWeight.w500,
                                                        ),
                                                      ),
                                                      onTap: () async {
                                                        await artistRepository.deleteFavoriteArtist(
                                                            ticketResponse.artists[index].artistId, context);
                                                        setState(() {
                                                          isFavoriteArtist[index] = false;
                                                        });
                                                      })
                                                else //관심 아티스트
                                                  GestureDetector(
                                                      child: Container(
                                                          width: 111,
                                                          height: 36,
                                                          padding: const EdgeInsets.only(left: 12, top: 8, bottom: 8),
                                                          clipBehavior: Clip.antiAlias,
                                                          decoration: ShapeDecoration(
                                                            color: pt_10,
                                                            shape: RoundedRectangleBorder(
                                                              side: const BorderSide(width: 1, color: pt_20),
                                                              borderRadius: BorderRadius.circular(8),
                                                            ),
                                                          ),
                                                          child: Row(children: [
                                                            const Text(
                                                              "관심 아티스트",
                                                              style: TextStyle(
                                                                fontFamily: 'Pretendard',
                                                                fontSize: 12,
                                                                color: pn_100,
                                                                fontWeight: FontWeight.w600,
                                                              ),
                                                            ),
                                                            const SizedBox(width: 4),
                                                            SvgPicture.asset('images/v2/opening_notice/add.svg',
                                                                width: 20, height: 20)
                                                          ])),
                                                      onTap: () async {
                                                        final isSuccess = await artistRepository.addFavoriteArtist(
                                                            ticketResponse.artists[index].artistId, context);
                                                        if (isSuccess) {
                                                          setState(() {
                                                            isFavoriteArtist[index] = true;
                                                          });
                                                        }
                                                      })
                                              ])),
                                          const SizedBox(height: 12),
                                        ],
                                      );
                                    })))
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
                                  const Text(
                                    '찾으시는 아티스트가 없나요?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: f_100,
                                      fontSize: 16,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Text(
                                    '원하는 아티스트를 요청해주세요.\n새로운 아티스트로 등록되면 알림을 보내드릴게요!',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: f_50,
                                      fontSize: 12,
                                      fontFamily: 'Pretendard',
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                      width: 207,
                                      height: 46,
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      clipBehavior: Clip.antiAlias,
                                      decoration: ShapeDecoration(
                                        color: pt_10,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          AmplitudeConfig.amplitude.logEvent('ArtistRequestV2');
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => const ArtistRequestV2(),
                                            ),
                                          );
                                        },
                                        child: const Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '아티스트 등록 요청하러가기',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: pt_100,
                                                  fontSize: 14,
                                                  fontFamily: 'Pretendard',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(width: 4),
                                              Icon(Icons.navigate_next, color: pt_100, size: 20)
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
                                        child:
                                            Image.asset('images/v2/search/ticket_null.png', width: 350, height: 336)))
                                : const SizedBox(),
                            ticketResponse.openingNotice.totalNum > 0
                                ? Column(
                                    children: [
                                      Row(
                                        children: [
                                          const Text("오픈 예정 티켓",
                                              style: TextStyle(
                                                  fontFamily: 'Pretendard',
                                                  fontSize: 18,
                                                  color: f_100,
                                                  fontWeight: FontWeight.w600)),
                                          const SizedBox(width: 8),
                                          Text("${ticketResponse.openingNotice.totalNum}개",
                                              style: const TextStyle(
                                                  fontFamily: 'Pretendard',
                                                  fontSize: 16,
                                                  color: pn_100,
                                                  fontWeight: FontWeight.w600))
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
                                                      builder: (context) => TicketDetailV2(
                                                        concertId: ticketResponse
                                                            .openingNotice.concerts[index].concertId, // 상세 페이지에 데이터 전달
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: OpeningNoticeCard(
                                                    openingResponse: ticketResponse.openingNotice, index: index),
                                              ),
                                              const SizedBox(height: 12)
                                            ]);
                                          },
                                        ),
                                      )
                                    ],
                                  )
                                : const SizedBox(),
                            ticketResponse.onSale.totalNum > 0
                                ? Column(children: [
                                    const SizedBox(height: 28),
                                    Row(
                                      children: [
                                        const Text("예매 중인 티켓",
                                            style: TextStyle(
                                                fontFamily: 'Pretendard',
                                                fontSize: 18,
                                                color: f_100,
                                                fontWeight: FontWeight.w600)),
                                        const SizedBox(width: 8),
                                        Text("${ticketResponse.onSale.totalNum}개",
                                            style: const TextStyle(
                                                fontFamily: 'Pretendard',
                                                fontSize: 16,
                                                color: pn_100,
                                                fontWeight: FontWeight.w600))
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
                                                    builder: (context) => TicketDetailV2(
                                                      concertId: ticketResponse
                                                          .onSale.concerts[index].concertId, // 상세 페이지에 데이터 전달
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: OnSaleCard(onSaleResponse: ticketResponse.onSale, index: index),
                                            ),
                                            const SizedBox(height: 12)
                                          ]);
                                        },
                                      ),
                                    )
                                  ])
                                : const SizedBox()
                          ],
                        )),
                    const SizedBox(height: 20)
                  ],
                ))),
            if (_searchController.text.isNotEmpty &&
                (artists.isNotEmpty || openingNoticeResponse.isNotEmpty || onSaleResponse.isNotEmpty))
              Positioned(
                top: 0, // 검색 창 바로 아래에 위치
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 20,
                  ),
                  color: Colors.white,
                  child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 300, // 최대 높이를 300으로 제한
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
                                      keyword = artist.name;
                                    });
                                    _initializeSearchAndFavorites(keyword);
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    // 아래쪽 간격 설정
                                    color: Colors.transparent,
                                    width: MediaQuery.of(context).size.width - 43,
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
                                      AmplitudeConfig.amplitude.logEvent('SearchDetail(concertName: ${concert.title})');
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
                                      AmplitudeConfig.amplitude.logEvent('SearchDetail(concertName: ${concert.title})');
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
                                    width: MediaQuery.of(context).size.width - 43,
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
        ));
  }
}
