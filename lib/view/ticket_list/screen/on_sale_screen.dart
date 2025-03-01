import 'dart:async';

import 'package:flutter/material.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/constant/fonts.dart';
import 'package:newket/model/ticket/on_sale_response.dart';
import 'package:newket/repository/ticket_repository.dart';
import 'package:newket/view/ticket_list/widget/ticket_skeleton_widget.dart';
import 'package:newket/view/ticket_list/widget/drop_down_widget.dart';
import 'package:newket/view/ticket_list/widget/on_sale_widget.dart';
import 'package:newket/view/ticket_detail/screen/ticket_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnSaleScreen extends StatefulWidget {
  final Future repository;
  final Function onOptionChanged;

  const OnSaleScreen({super.key, required this.repository, required this.onOptionChanged});

  @override
  State<StatefulWidget> createState() => _OnSaleScreen();
}

class _OnSaleScreen extends State<OnSaleScreen> {
  TicketRepository ticketRepository = TicketRepository();
  late String selectedOption;
  final List<String> options = ['공연 날짜 임박 순', '최신 등록 순'];

  @override
  void initState() {
    super.initState();
    _loadSelectedOption();
  }

  _loadSelectedOption() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedOption = prefs.getString('onSaleSelectedOption') ?? '공연 날짜 임박 순';
    });
  }

  void updateItemList(String option) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedOption = option;
    });
    prefs.setString('onSaleSelectedOption', selectedOption);
    widget.onOptionChanged();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false, //키보드가 올라 오지 않도록
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: FutureBuilder(
                future: widget.repository,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const TicketSkeletonWidget(); // Skeleton UI 표시
                  }
                  OnSaleResponse onSaleResponse = snapshot.data!;
                  return Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(children: [
                        Container(height: 13),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('총 ${onSaleResponse.totalNum}개', style: b9_14Reg(f_80)),
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
                            onSaleResponse.tickets.length,
                            (index) {
                              return Column(children: [
                                GestureDetector(
                                  onTap: () {
                                    AmplitudeConfig.amplitude.logEvent(
                                        'OpeningNoticeDetail(id:${onSaleResponse.tickets[index].ticketId})');
                                    // 상세 페이지로 이동
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TicketDetailScreen(
                                          ticketId: onSaleResponse.tickets[index].ticketId, // 상세 페이지에 데이터 전달
                                        ),
                                      ),
                                    );
                                  },
                                  child: OnSaleWidget(onSaleResponse: onSaleResponse, index: index),
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
