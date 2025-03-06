import 'package:flutter/material.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/constant/fonts.dart';
import 'package:newket/model/ticket/before_sale_ticket_response.dart';
import 'package:newket/view/common/image_loading_widget.dart';

class BeforeSaleWidget extends StatelessWidget {
  final BeforeSaleTicketsResponse beforeSaleTicketsResponse;
  final int index;

  const BeforeSaleWidget({
    super.key,
    required this.beforeSaleTicketsResponse,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final first = beforeSaleTicketsResponse.tickets[index].ticketSaleSchedules[0];
    TicketSaleScheduleDto second = TicketSaleScheduleDto(type: '', dday: '');
    if (beforeSaleTicketsResponse.tickets[index].ticketSaleSchedules.length > 1) {
      second = beforeSaleTicketsResponse.tickets[index].ticketSaleSchedules[1];
    }

    return Container(
        clipBehavior: Clip.antiAlias,
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 1.50, color: f_10),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
              child: ImageLoadingWidget(
                  width: 85, height: 110, radius: 0, imageUrl: beforeSaleTicketsResponse.tickets[index].imageUrl),
            ),
            Stack(
              children: [
                //티켓 정보
                Container(
                  width: MediaQuery.of(context).size.width - 85 - 43,
                  // 원하는 여백을 빼고 가로 크기 설정
                  height: 110,
                  clipBehavior: Clip.antiAlias,
                  decoration: const ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
                    ),
                  ),
                  child: Column(
                    //왼쪽 정렬
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //공연 제목
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
                          // 여백 12씩 추가
                          child: SizedBox(
                              height: 44,
                              child: RichText(
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  text: beforeSaleTicketsResponse.tickets[index].title,
                                  style: b8_14Med(f_100),
                                ),
                              ))),
                      //실선
                      Container(color: f_15, height: 1),
                      // 티켓 오픈 정보
                      Row(
                        children: [
                          SizedBox(
                              width: (MediaQuery.of(context).size.width - 85 - 43) / 2,
                              height: 42,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 12),
                                  Text(
                                    first.type,
                                    style: c4_12Reg(f_60),
                                  ),
                                  const SizedBox(width: 8),
                                  if (first.dday == 'D-3' ||
                                      first.dday == 'D-2' ||
                                      first.dday == 'D-1' ||
                                      first.dday == 'D-Day')
                                    Text(
                                      first.dday,
                                      style: c3_12Med(p_normal),
                                    )
                                  else
                                    Text(
                                      first.dday,
                                      style: c3_12Med(f_80),
                                    )
                                ],
                              )),
                          if (beforeSaleTicketsResponse.tickets[index].ticketSaleSchedules.length > 1)
                            SizedBox(
                                width: (MediaQuery.of(context).size.width - 85 - 43) / 2,
                                height: 42,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(color: f_15, width: 1, height: 16),
                                    const SizedBox(width: 12),
                                    Text(
                                      second.type,
                                      style: c4_12Reg(f_60),
                                    ),
                                    const SizedBox(width: 8),
                                    if (second.dday == 'D-3' ||
                                        second.dday == 'D-2' ||
                                        second.dday == 'D-1' ||
                                        second.dday == 'D-Day')
                                      Text(
                                        second.dday,
                                        style: c3_12Med(p_normal),
                                      )
                                    else
                                      Text(
                                        second.dday,
                                        style: c3_12Med(f_80),
                                      )
                                  ],
                                ))
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
