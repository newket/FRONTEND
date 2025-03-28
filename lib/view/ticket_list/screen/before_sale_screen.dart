import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_smartlook/flutter_smartlook.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/constant/fonts.dart';
import 'package:newket/model/ticket/before_sale_ticket_response.dart';
import 'package:newket/view/ticket_detail/screen/ticket_detail_screen.dart';
import 'package:newket/view/ticket_list/widget/before_sale_widget.dart';
import 'package:newket/view/ticket_list/widget/drop_down_widget.dart';
import 'package:newket/view/ticket_list/widget/ticket_skeleton_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BeforeSaleScreen extends StatefulWidget {
  final Future repository;
  final Function onOptionChanged;

  const BeforeSaleScreen({super.key, required this.repository, required this.onOptionChanged});

  @override
  State<StatefulWidget> createState() => _BeforeSaleScreen();
}

class _BeforeSaleScreen extends State<BeforeSaleScreen> {
  late String selectedOption;
  final List<String> options = ['예매 오픈 임박 순', '최신 등록 순'];

  @override
  void initState() {
    super.initState();
    _loadSelectedOption();
  }

  _loadSelectedOption() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedOption = prefs.getString('openingNoticeSelectedOption') ?? '예매 오픈 임박 순';
    });
    final Properties properties = Properties();
    properties.putString('option', value: selectedOption);
    properties.putString('tab',value: '오픈 예정 티켓');
    Smartlook.instance.trackEvent('HomeScreen', properties: properties);
  }

  void updateItemList(String option) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedOption = option;
    });
    prefs.setString('openingNoticeSelectedOption', selectedOption);
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
                    return const TicketSkeletonWidget();
                  }
                  BeforeSaleTicketsResponse beforeSaleResponse = snapshot.data!;
                  return Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: Column(children: [
                        Container(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('총 ${beforeSaleResponse.totalNum}개', style: b9_14Reg(f_80)),
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
                            beforeSaleResponse.tickets.length,
                            (index) {
                              return Column(children: [
                                GestureDetector(
                                  onTap: () {
                                    // 상세 페이지로 이동
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TicketDetailScreen(
                                          ticketId: beforeSaleResponse.tickets[index].ticketId, // 상세 페이지에 데이터 전달
                                        ),
                                      ),
                                    );
                                  },
                                  child: BeforeSaleWidget(beforeSaleTicketsResponse: beforeSaleResponse, index: index),
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
