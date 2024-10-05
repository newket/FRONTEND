import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/model/notification_model.dart';
import 'package:newket/model/ticket_model.dart';
import 'package:newket/repository/notification_repository.dart';
import 'package:newket/theme/Colors.dart';
import 'package:newket/view/onboarding/login.dart';
import 'package:newket/view/opening_notice/opening_notice_detail.dart';

class NotificationTicket extends StatefulWidget {
  const NotificationTicket({super.key});

  @override
  State<StatefulWidget> createState() => _NotificationTicket();
}

class _NotificationTicket extends State<NotificationTicket> {
  late NotificationRepository notificationRepository;
  bool isDeleteMode = false;
  late List<bool> isSelectedList;
  late OpeningNoticeResponse openingResponse;
  bool isLoading = true;

  Future<void> getAllTicketNotifications(BuildContext context) async {
    try {
      final response = await notificationRepository.getAllTicketNotifications(context);
      // 이메일 정보를 상태에 한 번만 저장
      setState(() {
        openingResponse = response;
        isSelectedList = List<bool>.filled(openingResponse.totalNum, false);
        isLoading = false; // 로딩 완료 시 로딩 상태 해제
      });
    } catch (e) {
      // 에러 처리 (로그인 페이지로 리다이렉트 또는 에러 핸들링)
      Get.offAll(const Login());
    }
  }

  @override
  void initState() {
    super.initState();
    notificationRepository = NotificationRepository();
    getAllTicketNotifications(context);
  }

  @override
  Widget build(BuildContext context) {
    // 로딩 중일 때 로딩 화면을 표시
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(), // 로딩 인디케이터
      );
    }

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                AmplitudeConfig.amplitude.logEvent('Back');
                Navigator.pop(context); //뒤로가기
              },
              color: b_100,
              icon: const Icon(Icons.keyboard_arrow_left)),
          backgroundColor: b_950,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              const Text(
                "알림 받기 신청한 티켓",
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 16,
                  color: b_100,
                  fontWeight: FontWeight.w700,
                ),
              ),
              GestureDetector(
                onTap: () async {
                  setState(() {
                    isDeleteMode = !isDeleteMode; // 상태를 변경하여 텍스트 업데이트
                  });
                  if (!isDeleteMode) {
                    List<int> concertIds = [];
                    for (int i = 0; i < openingResponse.totalNum; i++) {
                      if (isSelectedList[i]) {
                        concertIds.add(openingResponse.concerts[i].concertId);
                      }
                    }
                    if (concertIds.isNotEmpty) {
                      // 선택된 항목이 있을 경우에만 삭제 요청
                      await NotificationRepository().deleteAllTicketNotifications(context, ConcertIds(concertIds));
                      final response = await notificationRepository.getAllTicketNotifications(context);
                      // 이메일 정보를 상태에 한 번만 저장
                      setState(() {
                        openingResponse = response;
                      });
                    }
                  }
                },
                child: Text(
                  isDeleteMode ? "삭제 완료" : "삭제 모드", // 상태에 따라 텍스트 변경
                  style: TextStyle(
                    color: isDeleteMode ? p_700 : b_400,
                    fontSize: 12,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
        backgroundColor: b_950,
        body: SingleChildScrollView(
            child: Stack(
          children: [
            Column(
                children: List.generate(
              openingResponse.totalNum,
              (index1) {
                return Stack(
                  children: [
                    Positioned(
                        top: 28,
                        right: 20,
                        child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                isSelectedList[index1] = !isSelectedList[index1]; // 선택 상태 토글
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(55, 94), // 버튼 높이 조정
                                backgroundColor: pt_10, // 버튼 색상
                                padding: const EdgeInsets.symmetric(vertical: 38),
                                shape: RoundedRectangleBorder(
                                  side:
                                      BorderSide(width: 1, color: isSelectedList[index1] ? pt_50 : Colors.transparent),
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
                                )),
                            child: Text(
                              isSelectedList[index1] ? '선택 완료' : '선택', // 상태에 따라 텍스트 변경
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: p_500,
                                fontSize: 12,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w700,
                              ),
                            ))),
                    Container(height: 122),
                  ],
                );
              },
            )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //빈공간 12
                Container(height: 20),
                //티켓
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(openingResponse.totalNum, (index1) {
                    return Stack(
                      children: [
                        AnimatedPositioned(
                            duration: const Duration(milliseconds: 300),
                            left: isDeleteMode ? -54 : 0, // 삭제 모드 시 왼쪽으로 이동
                            child: GestureDetector(
                              onTap: () {
                                AmplitudeConfig.amplitude.logEvent('OpeningNoticeDetail(id:${openingResponse.concerts[index1].concertId})');
                                // 상세 페이지로 이동
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => OpeningNoticeDetail(
                                      concertId: openingResponse.concerts[index1].concertId, // 상세 페이지에 데이터 전달
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                children: [
                                  const SizedBox(width: 20),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      openingResponse.concerts[index1].imageUrl,
                                      height: 110,
                                      width: 83,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Stack(
                                    children: [
                                      //티켓 정보
                                      Container(
                                        width: MediaQuery.of(context).size.width - 123,
                                        // 원하는 여백을 빼고 가로 크기 설정
                                        height: 110,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: ShapeDecoration(
                                          color: b_900,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          // 여백 12씩 추가
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            //왼쪽정렬
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              //공연 제목
                                              SizedBox(
                                                  height: 38,
                                                  child: RichText(
                                                    maxLines: 2,
                                                    overflow: TextOverflow.ellipsis,
                                                    text: TextSpan(
                                                      text: openingResponse.concerts[index1].title,
                                                      style: const TextStyle(
                                                        fontFamily: 'Pretendard',
                                                        fontSize: 14,
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  )),
                                              // 티켓 오픈 정보
                                              //일반예매 만
                                              if (openingResponse.concerts[index1].ticketingSchedules.length == 1)
                                                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        "${openingResponse.concerts[index1].ticketingSchedules[0].type} 오픈",
                                                        style: const TextStyle(
                                                          fontFamily: 'Pretendard',
                                                          fontSize: 12,
                                                          color: b_400,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                      if (openingResponse
                                                                  .concerts[index1].ticketingSchedules[0].dday ==
                                                              'D-3' ||
                                                          openingResponse
                                                                  .concerts[index1].ticketingSchedules[0].dday ==
                                                              'D-2' ||
                                                          openingResponse.concerts[index1].ticketingSchedules[0].dday ==
                                                              'D-1' ||
                                                          openingResponse.concerts[index1].ticketingSchedules[0].dday ==
                                                              'D-Day')
                                                        Text(
                                                          openingResponse.concerts[index1].ticketingSchedules[0].dday,
                                                          style: const TextStyle(
                                                            fontFamily: 'Pretendard',
                                                            fontSize: 12,
                                                            color: Color(0xffFF5F5F),
                                                            fontWeight: FontWeight.w700,
                                                          ),
                                                        )
                                                      else
                                                        Text(
                                                          openingResponse.concerts[index1].ticketingSchedules[0].dday,
                                                          style: const TextStyle(
                                                            fontFamily: 'Pretendard',
                                                            fontSize: 12,
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w700,
                                                          ),
                                                        ),
                                                    ],
                                                  )
                                                ])
                                              //선예매 , 일반예매
                                              else
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "${openingResponse.concerts[index1].ticketingSchedules[0].type} 오픈",
                                                          style: const TextStyle(
                                                            fontFamily: 'Pretendard',
                                                            fontSize: 12,
                                                            color: b_400,
                                                            fontWeight: FontWeight.w400,
                                                          ),
                                                        ),
                                                        if (openingResponse
                                                                    .concerts[index1].ticketingSchedules[0].dday ==
                                                                'D-3' ||
                                                            openingResponse
                                                                    .concerts[index1].ticketingSchedules[0].dday ==
                                                                'D-2' ||
                                                            openingResponse
                                                                    .concerts[index1].ticketingSchedules[0].dday ==
                                                                'D-1' ||
                                                            openingResponse
                                                                    .concerts[index1].ticketingSchedules[0].dday ==
                                                                'D-Day')
                                                          Text(
                                                            openingResponse.concerts[index1].ticketingSchedules[0].dday,
                                                            style: const TextStyle(
                                                              fontFamily: 'Pretendard',
                                                              fontSize: 12,
                                                              color: Color(0xffFF5F5F),
                                                              fontWeight: FontWeight.w700,
                                                            ),
                                                          )
                                                        else
                                                          Text(
                                                            openingResponse.concerts[index1].ticketingSchedules[0].dday,
                                                            style: const TextStyle(
                                                              fontFamily: 'Pretendard',
                                                              fontSize: 12,
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.w700,
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                    Container(
                                                      width: 1,
                                                      // 실선의 두께
                                                      height: 40,
                                                      // 실선의 높이
                                                      color: b_800,
                                                      // 실선 색상
                                                      margin: const EdgeInsets.symmetric(horizontal: 12), // 여백
                                                    ),
                                                    Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          "${openingResponse.concerts[index1].ticketingSchedules[1].type} 오픈",
                                                          style: const TextStyle(
                                                            fontFamily: 'Pretendard',
                                                            fontSize: 12,
                                                            color: b_400,
                                                            fontWeight: FontWeight.w400,
                                                          ),
                                                        ),
                                                        if (openingResponse
                                                                    .concerts[index1].ticketingSchedules[1].dday ==
                                                                'D-3' ||
                                                            openingResponse
                                                                    .concerts[index1].ticketingSchedules[1].dday ==
                                                                'D-2' ||
                                                            openingResponse
                                                                    .concerts[index1].ticketingSchedules[1].dday ==
                                                                'D-1' ||
                                                            openingResponse
                                                                    .concerts[index1].ticketingSchedules[1].dday ==
                                                                'D-Day')
                                                          Text(
                                                            openingResponse.concerts[index1].ticketingSchedules[1].dday,
                                                            style: const TextStyle(
                                                              fontFamily: 'Pretendard',
                                                              fontSize: 12,
                                                              color: Color(0xffFF5F5F),
                                                              fontWeight: FontWeight.w700,
                                                            ),
                                                          )
                                                        else
                                                          Text(
                                                            openingResponse.concerts[index1].ticketingSchedules[1].dday,
                                                            style: const TextStyle(
                                                              fontFamily: 'Pretendard',
                                                              fontSize: 12,
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.w700,
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )),
                        Container(height: 122),
                      ],
                    );
                  }),
                ),
              ],
            )
          ],
        )));
  }
}
