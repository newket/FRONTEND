import 'package:flutter/material.dart';
import 'package:newket/model/ticket_model.dart';
import 'package:newket/theme/colors.dart';

class OpeningNoticeCard extends StatelessWidget {
  final OpeningNoticeResponse openingResponse;
  final int index;

  const OpeningNoticeCard({
    super.key,
    required this.openingResponse,
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
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8), bottomLeft: Radius.circular(8)),
              child: Image.network(
                openingResponse.concerts[index].imageUrl,
                height: 122,
                width: 91,
                fit: BoxFit.fill,
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child; // 로딩이 완료되었을 때의 이미지
                  }
                  return Container(
                    height: 122,
                    width: 91,
                    color: f_10, // 로딩 중일 때의 배경색
                  );
                },
                errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                  return Container(
                    height: 122,
                    width: 91,
                    color: f_10, // 로딩 실패 시의 배경색
                  );
                },
              ),
            ),
            Stack(
              children: [
                //티켓 정보
                Container(
                  width: MediaQuery.of(context).size.width - 91 - 43,
                  // 원하는 여백을 빼고 가로 크기 설정
                  height: 122,
                  clipBehavior: Clip.antiAlias,
                  decoration: const ShapeDecoration(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8), bottomRight: Radius.circular(8)),
                    ),
                  ),
                  child: Column(
                    //왼쪽 정렬
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //공연 제목
                      Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                          // 여백 12씩 추가
                          child: SizedBox(
                              height: 44,
                              child: RichText(
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                text: TextSpan(
                                  text: openingResponse.concerts[index].title,
                                  style: const TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 14,
                                    color: f_100,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ))),
                      //실선
                      Container(color: f_15, height: 1),
                      // 티켓 오픈 정보
                      Row(
                        children: [
                          SizedBox(
                              width: (MediaQuery.of(context).size.width - 91 - 43) / 2,
                              height: 45,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  const SizedBox(width: 12),
                                  Text(
                                    "${openingResponse.concerts[index].ticketingSchedules[0].type} 오픈 ",
                                    style: const TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: 12,
                                      color: f_60,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  if (openingResponse.concerts[index]
                                      .ticketingSchedules[0].dday ==
                                      'D-3' ||
                                      openingResponse.concerts[index]
                                          .ticketingSchedules[0].dday ==
                                          'D-2' ||
                                      openingResponse.concerts[index]
                                          .ticketingSchedules[0].dday ==
                                          'D-1' ||
                                      openingResponse.concerts[index]
                                          .ticketingSchedules[0].dday ==
                                          'D-Day')
                                    Text(
                                      openingResponse
                                          .concerts[index].ticketingSchedules[0].dday,
                                      style: const TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: 14,
                                        color: p_normal,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                  else
                                    Text(
                                      openingResponse
                                          .concerts[index].ticketingSchedules[0].dday,
                                      style: const TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: 14,
                                        color: f_80,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )
                                ],
                              )),
                          if (openingResponse.concerts[index].ticketingSchedules.length >
                              1)
                            SizedBox(
                                width: (MediaQuery.of(context).size.width - 91 - 43) / 2,
                                height: 45,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(color: f_15, width: 1, height: 16),
                                    const SizedBox(width: 12),
                                    Text(
                                      "${openingResponse.concerts[index].ticketingSchedules[1].type} 오픈 ",
                                      style: const TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: 12,
                                        color: f_60,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    if (openingResponse.concerts[index]
                                        .ticketingSchedules[1].dday ==
                                        'D-3' ||
                                        openingResponse.concerts[index]
                                            .ticketingSchedules[1].dday ==
                                            'D-2' ||
                                        openingResponse.concerts[index]
                                            .ticketingSchedules[1].dday ==
                                            'D-1' ||
                                        openingResponse.concerts[index]
                                            .ticketingSchedules[1].dday ==
                                            'D-Day')
                                      Text(
                                        openingResponse
                                            .concerts[index].ticketingSchedules[1].dday,
                                        style: const TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontSize: 14,
                                          color: p_normal,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                    else
                                      Text(
                                        openingResponse
                                            .concerts[index].ticketingSchedules[1].dday,
                                        style: const TextStyle(
                                          fontFamily: 'Pretendard',
                                          fontSize: 14,
                                          color: f_80,
                                          fontWeight: FontWeight.w500,
                                        ),
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
