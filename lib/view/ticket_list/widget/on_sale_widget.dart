import 'package:flutter/material.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/constant/fonts.dart';
import 'package:newket/model/ticket/on_sale_response.dart';
import 'package:newket/view/common/image_loading_widget.dart';

class OnSaleWidget extends StatelessWidget {
  final OnSaleResponse onSaleResponse;
  final int index;

  const OnSaleWidget({
    super.key,
    required this.onSaleResponse,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
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
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), bottomLeft: Radius.circular(6)),
                child: ImageLoadingWidget(
                    width: 85, height: 107, radius: 0, imageUrl: onSaleResponse.tickets[index].imageUrl)),
            Stack(
              children: [
                //티켓 정보
                Container(
                  width: MediaQuery.of(context).size.width - 85 - 43,
                  // 원하는 여백을 빼고 가로 크기 설정
                  height: 107,
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
                          child: SizedBox(
                              height: 44,
                              child: RichText(
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  text: TextSpan(text: onSaleResponse.tickets[index].title, style: b8_14Med(f_100))))),
                      //실선
                      Container(color: f_15, height: 1),
                      // 티켓 오픈 정보
                      Row(
                        children: [
                          Container(
                              width: (MediaQuery.of(context).size.width - 85 - 43),
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              height: 40,
                              child: Row(
                                children: [
                                  Text("공연일시", style: c4_12Reg(f_60)),
                                  const SizedBox(width: 10),
                                  Text(onSaleResponse.tickets[index].date, style: c3_12Med(f_90)),
                                ],
                              )),
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
