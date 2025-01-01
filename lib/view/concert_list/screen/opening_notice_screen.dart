import 'dart:async';

import 'package:flutter/material.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/repository/ticket_repository.dart';
import 'package:newket/view/concert_list/widget/concert_skeleton_ui_widget.dart';
import 'package:newket/view/concert_list/widget/drop_down_widget.dart';
import 'package:newket/view/concert_list/widget/opening_notice_widget.dart';
import 'package:newket/view/ticket_detail/screen/ticket_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OpeningNoticeScreen extends StatefulWidget {
  const OpeningNoticeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _OpeningNoticeScreen();
}

class _OpeningNoticeScreen extends State<OpeningNoticeScreen> {
  TicketRepository ticketRepository = TicketRepository();
  late String selectedOption;
  late Future repository;
  late Timer skeletonTimer;
  bool showSkeleton = false;
  final List<String> options = ['예매 오픈 임박 순', '최신 등록 순'];

  @override
  void initState() {
    super.initState();
    repository = ticketRepository.openingNoticeApi();
    _loadSelectedOption();

    // 200ms 후 Skeleton UI 표시
    skeletonTimer = Timer(const Duration(milliseconds: 200), () {
      if (!mounted) return;
      setState(() {
        showSkeleton = true;
      });
    });
  }

  @override
  void dispose() {
    skeletonTimer.cancel();
    super.dispose();
  }

  _loadSelectedOption() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedOption = prefs.getString('openingNoticeSelectedOption') ?? options[0];
      if (selectedOption == options[0]) {
        repository = ticketRepository.openingNoticeApi();
      } else if (selectedOption == options[1]) {
        repository = ticketRepository.openingNoticeApiOrderById();
      }
    });
  }

  void updateItemList(String option) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('openingNoticeSelectedOption', option);
    setState(() {
      selectedOption = option;
      if (selectedOption == options[0]) {
        repository = ticketRepository.openingNoticeApi();
        AmplitudeConfig.amplitude.logEvent('openingNoticeSelectedOption : $selectedOption');
      } else if (selectedOption == options[1]) {
        repository = ticketRepository.openingNoticeApiOrderById();
        AmplitudeConfig.amplitude.logEvent('openingNoticeSelectedOption : $selectedOption');
      }
      showSkeleton = false;
      skeletonTimer = Timer(const Duration(milliseconds: 200), () {
        if (!mounted) return;
        setState(() {
          showSkeleton = true;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false, //키보드가 올라 오지 않도록
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: FutureBuilder(
                future: repository,
                builder: (context, snapshot) {
                  if ((snapshot.connectionState == ConnectionState.waiting || snapshot.hasError || !snapshot.hasData) &&
                      showSkeleton) {
                    return const ConcertSkeletonUIWidget(); // Skeleton UI 표시
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(); // 로딩 중 데이터 없음
                  }
                  final openingResponse = snapshot.data!;
                  return Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(children: [
                        Container(height: 13),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '총 ${openingResponse.totalNum}개',
                              style: const TextStyle(
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: f_80,
                                letterSpacing: -0.48,
                              ),
                            ),
                            DropDownWidget(
                              selectedOption: selectedOption,
                              updateItemList: updateItemList,
                              options: options,
                            )
                          ],
                        ),
                        Container(height: 8),
                        Column(
                          children: List.generate(
                            openingResponse.concerts.length,
                            (index) {
                              return Column(children: [
                                GestureDetector(
                                  onTap: () {
                                    AmplitudeConfig.amplitude.logEvent(
                                        'OpeningNoticeDetail(id:${openingResponse.concerts[index].concertId})');
                                    // 상세 페이지로 이동
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TicketDetailScreen(
                                          concertId: openingResponse.concerts[index].concertId, // 상세 페이지에 데이터 전달
                                        ),
                                      ),
                                    );
                                  },
                                  child: OpeningNoticeWidget(openingResponse: openingResponse, index: index),
                                ),
                                const SizedBox(height: 12)
                              ]);
                            },
                          ),
                        ),
                        const SizedBox(height: 122)
                      ]));
                })));
  }
}
