import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/model/ticket/before_sale_ticket_response.dart';
import 'package:newket/view/ticket_detail/screen/ticket_detail_screen.dart';
import 'package:newket/view/ticket_list/widget/before_sale_widget.dart';

class MyTicketBeforeSaleWidget extends StatelessWidget {
  final BeforeSaleTicketsResponse beforeSaleResponse;

  const MyTicketBeforeSaleWidget({super.key, required this.beforeSaleResponse});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: beforeSaleResponse.tickets.isEmpty
            ? Image.asset('images/my_ticket/artist_before_sale_null.png', width: 350)
            : Column(
                children: [
                  Column(
                    children: List.generate(
                      beforeSaleResponse.tickets.length,
                      (index) {
                        return Column(children: [
                          GestureDetector(
                            onTap: () {
                              //AmplitudeConfig.amplitude.logEvent('OpeningNoticeDetail(id:${beforeSaleResponse.tickets[index].ticketId})');
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
                  const SizedBox(height: 50)
                ],
              ));
  }
}
