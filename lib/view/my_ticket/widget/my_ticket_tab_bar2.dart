import 'package:flutter/material.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/constant/fonts.dart';
import 'package:newket/model/ticket/before_sale_ticket_response.dart';
import 'package:newket/view/common/image_loading_widget.dart';
import 'package:newket/view/ticket_detail/screen/ticket_detail_screen.dart';

class MyTicketTabBar2 extends StatelessWidget {
  final BeforeSaleTicketsResponse notificationTickets;

  const MyTicketTabBar2({super.key, required this.notificationTickets});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: Column(children: [
      Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(), // SingleChildScrollView 내부라 스크롤 비활성화
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 한 줄에 두 개씩 배치
            crossAxisSpacing: 8, // 가로 간격
            mainAxisSpacing: 8, // 세로 간격
            mainAxisExtent: 270, // 아이템 세로 크기 고정
          ),
          itemCount: notificationTickets.tickets.length,
          itemBuilder: (context, index) {
            final ticket = notificationTickets.tickets[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TicketDetailScreen(ticketId: ticket.ticketId),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.bottomLeft,
                      children: [
                        ImageLoadingWidget(width: double.infinity, height: 200, radius: 8, imageUrl: ticket.imageUrl),
                        Container(
                          width: double.infinity,
                          height: 148,
                          decoration: const ShapeDecoration(
                            gradient: LinearGradient(
                              begin: Alignment(0.00, -1.00),
                              end: Alignment(0, 1),
                              colors: [Color(0x001A1A25), Color(0x351A1A25), Color(0xA61A1A25), Color(0xFF1A1A25)],
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
                          height: 56,
                          child: RichText(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            text: TextSpan(text: ticket.title, style: b8_14Med(Colors.white)),
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: 70,
                      width: double.infinity,
                      decoration: ShapeDecoration(
                        color: f_100,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Column(
                        children: [
                          Container(color: f_80, width: 89, height: 1),
                          Padding(
                            padding: const EdgeInsets.all(9),
                            child: Column(
                              children: List.generate(
                                ticket.ticketSaleSchedules.length > 2 ? 2 : ticket.ticketSaleSchedules.length,
                                    (index1) {
                                  return Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            ticket.ticketSaleSchedules[index1].type,
                                            style: c4_12Reg(f_30),
                                          ),
                                          Text(ticket.ticketSaleSchedules[index1].dday,
                                              style: b8_14Med(ticket.ticketSaleSchedules[index1].dday == "D-Day" ||
                                                  ticket.ticketSaleSchedules[index1].dday == "D-1" ||
                                                  ticket.ticketSaleSchedules[index1].dday == "D-2" ||
                                                  ticket.ticketSaleSchedules[index1].dday == "D-3"
                                                  ? pn_100
                                                  : Colors.white)),
                                        ],
                                      ),
                                      const SizedBox(height: 3),
                                    ],
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 100)
    ]));
  }
}
