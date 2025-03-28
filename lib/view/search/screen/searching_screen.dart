import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/constant/fonts.dart';
import 'package:newket/model/ticket/autocomplete_response.dart';
import 'package:newket/repository/ticket_repository.dart';
import 'package:newket/view/artist/screen/artist_profile_screen.dart';
import 'package:newket/view/search/screen/search_result_screen.dart';
import 'package:newket/view/ticket_detail/screen/ticket_detail_screen.dart';

class SearchingScreen extends StatefulWidget {
  final String keyword;

  const SearchingScreen({super.key, required this.keyword});

  @override
  State<StatefulWidget> createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchingScreen> {
  late TicketRepository ticketRepository;
  late TextEditingController _searchController;
  late FocusNode _searchFocusNode;
  List<Artist> artists = [];
  List<Ticket> tickets = [];
  late AutocompleteResponse autocompleteResponse;

  @override
  void initState() {
    super.initState();
    // 키보드 자동 띄우기
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
    ticketRepository = TicketRepository();
    if (widget.keyword.isNotEmpty) {
      _search(widget.keyword);
    }
    _searchController = TextEditingController(text: widget.keyword);
    _searchFocusNode = FocusNode();
    _searchController.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Future<void> _search(String keyword) async {
    if (keyword.trim().isNotEmpty) {
      AutocompleteResponse result = await ticketRepository.autocomplete(keyword);
      if (mounted) {
        setState(() {
          artists = result.artists;
          tickets = result.tickets;
        });
      }
    }
  }

  // 검색 키워드 강조하는 함수
  TextSpan _highlightKeyword(String text, String keyword) {
    final keywordStyle = b8_14Bold(pn_100); // 강조할 색상
    final normalStyle = b8_14Med(f_80); // 기본 텍스트 색상

    if (keyword.isEmpty) {
      return TextSpan(text: text, style: normalStyle);
    }

    final regex = RegExp('($keyword)', caseSensitive: false);
    final matches = regex.allMatches(text);

    if (matches.isEmpty) {
      return TextSpan(text: text, style: normalStyle);
    }

    final textSpans = <TextSpan>[];

    int start = 0;

    // 모든 매치를 찾아서 그에 맞는 텍스트 span을 만들기
    for (final match in matches) {
      if (match.start > start) {
        textSpans.add(TextSpan(
          text: text.substring(start, match.start),
          style: normalStyle,
        ));
      }

      textSpans.add(TextSpan(
        text: match.group(0),
        style: keywordStyle,
      ));

      start = match.end;
    }

    if (start < text.length) {
      textSpans.add(TextSpan(
        text: text.substring(start),
        style: normalStyle,
      ));
    }

    return TextSpan(children: textSpans);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Timer? debounce;
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: systemUiOverlayStyle,
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 44,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 24, color: f_90),
                            padding: EdgeInsets.zero,
                          ),
                        ),
                        Expanded(
                            child: Container(
                          height: 44,
                          decoration: ShapeDecoration(
                            color: pn_05,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 1, color: pt_40),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset('images/search/search.svg', height: 20, width: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                  child: TextField(
                                focusNode: _searchFocusNode,
                                controller: _searchController,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  // 입력 필드의 기본 테두리 제거
                                  isCollapsed: true,
                                  // 내부 패딩 제거
                                  contentPadding: EdgeInsets.zero,
                                  // 추가 패딩 제거
                                  hintText: '아티스트 또는 공연 이름을 검색해보세요',
                                  hintStyle: b9_14Reg(f_50),
                                ),
                                style: c1_14Med(f_80),
                                maxLines: 1,
                                onSubmitted: (value) {
                                  if (value.isNotEmpty && value != ' ') {
                                    Get.off(() => SearchResultScreen(keyword: value));
                                  }
                                },
                                onChanged: (value) {
                                  // 이전 타이머가 존재하면 취소
                                  if (debounce?.isActive ?? false) debounce!.cancel();
                                  // 새로운 타이머 설정 (0.5초 후에 실행)
                                  debounce = Timer(const Duration(microseconds: 500), () {
                                    _search(_searchController.text); // 마지막 입력값으로 검색 실행
                                  });
                                },
                              )),
                              _searchController.text.trim().isEmpty
                                  ? Container()
                                  : GestureDetector(
                                      onTap: () => {
                                            setState(() {
                                              _searchController.clear();
                                            })
                                          },
                                      child: SvgPicture.asset('images/search/close-circle.svg', height: 24, width: 24)),
                            ],
                          ),
                        )),
                        const SizedBox(width: 20)
                      ],
                    )),
                if (_searchController.text.isNotEmpty && (artists.isNotEmpty || tickets.isNotEmpty))
                  Expanded(
                      child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    child: Column(
                      children: [
                        // 아티스트 항목
                        ...artists.map((artist) => GestureDetector(
                              onTap: () {
                                Get.off(() => ArtistProfileScreen(artistId: artist.artistId));
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 6),
                                // 아래쪽 간격 설정
                                color: Colors.transparent,
                                width: MediaQuery.of(context).size.width - 40,
                                height: 48,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset('images/search/search_artist.svg', width: 20, height: 20),
                                    const SizedBox(width: 12),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        RichText(
                                          maxLines: 1,
                                          textHeightBehavior: const TextHeightBehavior(
                                            // 텍스트 높이 맞춤
                                            applyHeightToFirstAscent: false,
                                            applyHeightToLastDescent: false,
                                          ),
                                          overflow: TextOverflow.ellipsis, // 1줄 이상은 ...
                                          text: _highlightKeyword(artist.name, _searchController.text),
                                        ),
                                        if (artist.subName != null)
                                          Text(
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis, // 1줄 이상은 ...
                                            artist.subName ?? '',
                                            style: c4_12Reg(f_40),
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )),
                        ...tickets.map((ticket) => GestureDetector(
                              onTap: () {
                                Get.off(() => TicketDetailScreen(ticketId: ticket.ticketId));
                              },
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 6),
                                // 아래쪽 간격 설정
                                color: Colors.transparent,
                                width: MediaQuery.of(context).size.width - 40,
                                height: 48,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SvgPicture.asset('images/search/search_ticket.svg', width: 20, height: 20),
                                    const SizedBox(width: 12),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width - 72,
                                      child: RichText(
                                        maxLines: 1,
                                        textHeightBehavior: const TextHeightBehavior(
                                          // 텍스트 높이 맞춤
                                          applyHeightToFirstAscent: false,
                                          applyHeightToLastDescent: false,
                                        ),
                                        overflow: TextOverflow.ellipsis, // 1줄 이상은 ...
                                        text: _highlightKeyword(ticket.title, _searchController.text),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ],
                    ),
                  ))
              ],
            ),
          ),
        ));
  }
}
