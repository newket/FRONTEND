import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/model/ticket_model.dart';
import 'package:newket/repository/notification_repository.dart';
import 'package:newket/repository/ticket_repository.dart';
import 'package:newket/theme/colors.dart';
import 'package:newket/view/v100/onboarding/login.dart';
import 'package:url_launcher/url_launcher.dart';

class OpeningNoticeDetailV2 extends StatefulWidget {
  const OpeningNoticeDetailV2({super.key, required this.concertId});

  final int concertId;

  @override
  State<StatefulWidget> createState() => _OpeningNoticeDetailV2();
}

class _OpeningNoticeDetailV2 extends State<OpeningNoticeDetailV2> {
  late TicketRepository ticketRepository;
  late NotificationRepository notificationRepository;
  bool isNotification = false;
  bool isLoading = true; // 로딩 상태 추가
  late TicketDetail ticketResponse;

  void showToast(BuildContext context) {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 88.0, // Toast 위치 조정
        left: 20, // 화면의 가운데 정렬
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width - 40,
            height: 64,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: ShapeDecoration(
              color: b_800,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(),
                  child: const Icon(
                    Icons.check,
                    color: p_500,
                  ),
                ),
                const SizedBox(width: 12),
                const Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '알림 받기 신청이 완료되었어요!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '티켓 오픈 하루 전, 1시간 전에 알려드릴게요',
                      style: TextStyle(
                        color: b_400,
                        fontSize: 12,
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );

    Overlay.of(context).insert(overlayEntry);

    // 5초 후에 Toast를 자동으로 제거
    Future.delayed(const Duration(seconds: 5), () {
      overlayEntry.remove();
    });
  }

  Future<void> _getIsNotification() async {
    try {
      final response = await notificationRepository.getIsTicketNotification(context, widget.concertId);
      final response2 = await ticketRepository.ticketDetail(widget.concertId);
      setState(() {
        isNotification = response;
        ticketResponse = response2;
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
    ticketRepository = TicketRepository();
    notificationRepository = NotificationRepository();
    _getIsNotification();
  }

  @override
  Widget build(BuildContext context) {
    // 로딩 중일 때 로딩 화면을 표시
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(), // 로딩 인디케이터
      );
    }

    final double screenWidth = MediaQuery.of(context).size.width;

    void launchURL(String url) async {
      Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        throw 'Could not launch $url';
      }
    }

    return Scaffold(
        backgroundColor: b_950,
        body: Stack(children: [
          Container(
              width: double.infinity,
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(color: p_700),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(children: [
                      //점선 위 전체
                      SizedBox(
                        width: double.infinity,
                        height: 335,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(24),
                            bottomRight: Radius.circular(24),
                          ),
                          child: Image.network(
                            ticketResponse.imageUrl,
                            width: 116,
                            height: 154,
                            fit: BoxFit.fitWidth,
                          ),
                        ),
                      ),
                      //검은 그림자
                      Container(
                        width: double.infinity,
                        height: 335,
                        decoration: const ShapeDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.00, -1.00),
                            end: Alignment(0, 1),
                            colors: [Color(0x66020617), Color(0xFF020617)],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(24),
                              bottomRight: Radius.circular(24),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 72, left: 20, right: 20),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(height: 32),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12.0),
                                  child: Image.network(
                                    ticketResponse.imageUrl,
                                    width: 116,
                                    height: 154,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                RichText(
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis, //2줄 이상은 ...
                                    text: TextSpan(
                                      text: ticketResponse.title,
                                      style: const TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: 20,
                                        color: Color(0xffffffff),
                                        fontWeight: FontWeight.w700,
                                      ),
                                    )),
                                const SizedBox(width: 12),
                              ])),
                      //앱바
                      AppBar(
                        leading: IconButton(
                            onPressed: () {
                              AmplitudeConfig.amplitude.logEvent('Back');
                              Navigator.pop(context); //뒤로가기
                            },
                            color: b_100,
                            icon: const Icon(Icons.keyboard_arrow_left)),
                        backgroundColor: Colors.transparent,
                        centerTitle: true,
                        title: const Text(
                          "티켓 상세 정보",
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ]),
                    // 점선
                    Expanded(
                        child: Stack(children: [
                          DottedBorder(
                            color: p_700,
                            strokeWidth: 6,
                            dashPattern: const [6, 6],
                            child: const SizedBox(
                              width: double.infinity,
                              height: 0,
                            ),
                          ),
                          Container(
                            width: double.infinity,
                            decoration: const ShapeDecoration(
                              color: b_950,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(24),
                                  topRight: Radius.circular(24),
                                ),
                              ),
                            ),
                          ),
                          //스크롤 가능
                          SingleChildScrollView(
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 25),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset("images/v1/ticket_detail/location.svg", height: 20, width: 20),
                                      const SizedBox(width: 8),
                                      const Text("공연 장소",
                                          style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontSize: 14,
                                            color: b_400,
                                            fontWeight: FontWeight.w400,
                                          )),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  //클릭하면 url로 이동
                                  InkWell(
                                      onTap: () {
                                        launchURL(ticketResponse.placeUrl);
                                      },
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(ticketResponse.place,
                                              style: const TextStyle(
                                                fontFamily: 'Pretendard',
                                                fontSize: 14,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              )),
                                          const SizedBox(width: 12),
                                          const Icon(Icons.keyboard_arrow_right_rounded, color: Colors.white)
                                        ],
                                      )),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset("images/v1/ticket_detail/calendar.svg", height: 20, width: 20),
                                      const SizedBox(width: 8),
                                      const Text("공연 일시",
                                          style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontSize: 14,
                                            color: b_400,
                                            fontWeight: FontWeight.w400,
                                          )),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  //공연 일시 박스
                                  Wrap(
                                    spacing: 12, // 각 아이템 간의 가로 간격
                                    runSpacing: 12, // 각 아이템 간의 세로 간격
                                    children: List.generate(
                                      ticketResponse.date.length,
                                          (index) {
                                        return Container(
                                          width: (screenWidth - 52) / 2,
                                          // 아이템의 너비를 반으로 나눔 (양쪽 여백 포함)
                                          height: 37,
                                          decoration: BoxDecoration(
                                            color: b_900,
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                          child: Text(
                                            ticketResponse.date[index],
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontSize: 14,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  //실선
                                  Container(height: 2, width: screenWidth - 40, color: b_800),
                                  const SizedBox(height: 20),
                                  //예매처 바로 가기
                                  const Text("예매처 바로가기",
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: 18,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      )),
                                  const SizedBox(height: 12),
                                  Container(height: 8),
                                  //예매처 카드
                                  Wrap(
                                      runSpacing: 8, // 각 아이템 간의 세로 간격
                                      children: List.generate(ticketResponse.ticketProviders.length, (index) {
                                        return InkWell(
                                            onTap: () {
                                              launchURL(ticketResponse.ticketProviders[index].url); // 클릭 시 URL로 이동
                                            },
                                            child: Container(
                                              width: screenWidth - 40,
                                              height: 106,
                                              decoration: BoxDecoration(
                                                color: b_900,
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                              child: Column(children: [
                                                //예매처 사진
                                                Row(
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Image.asset(
                                                          switch (ticketResponse.ticketProviders[index].ticketProvider) {
                                                            'INTERPARK' => "images/v1/ticket_detail/interpark.png",
                                                            'MELON' => "images/v1/ticket_detail/melon.png",
                                                            'YES24' => "images/v1/ticket_detail/yes24.png",
                                                            'TICKETLINK' => "images/v1/ticket_detail/ticketlink.png",
                                                            _ => "",
                                                          },
                                                          height: 32,
                                                          width: 32,
                                                        ),
                                                        const SizedBox(width: 12),
                                                        Text(
                                                            switch (ticketResponse.ticketProviders[index].ticketProvider) {
                                                              'INTERPARK' => "인터파크 티켓",
                                                              'MELON' => "멜론 티켓",
                                                              'YES24' => "YES24 티켓",
                                                              'TICKETLINK' => "티켓링크",
                                                              _ => "",
                                                            },
                                                            style: const TextStyle(
                                                              fontFamily: 'Pretendard',
                                                              fontSize: 14,
                                                              color: b_200,
                                                              fontWeight: FontWeight.w500,
                                                            ))
                                                      ],
                                                    ),
                                                    const Icon(Icons.keyboard_arrow_right_rounded, color: Colors.white)
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                //오픈일
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    // 첫 번째 일정 텍스트
                                                    Column(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text(
                                                          "${ticketResponse.ticketProviders[index].ticketingSchedules[0].type} 오픈일",
                                                          textAlign: TextAlign.center,
                                                          style: const TextStyle(
                                                            fontFamily: 'Pretendard',
                                                            fontSize: 12,
                                                            color: b_400,
                                                            fontWeight: FontWeight.w400,
                                                          ),
                                                        ),
                                                        Text(
                                                          "${ticketResponse.ticketProviders[index].ticketingSchedules[0].date} ${ticketResponse.ticketProviders[index].ticketingSchedules[0].time}",
                                                          textAlign: TextAlign.center,
                                                          style: const TextStyle(
                                                            fontFamily: 'Pretendard',
                                                            fontSize: 14,
                                                            color: Colors.white,
                                                            fontWeight: FontWeight.w500,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    // 만약 일정이 두 개라면 사이에 VerticalDivider 추가
                                                    if (ticketResponse.ticketProviders[index].ticketingSchedules.length ==
                                                        2) ...[
                                                      Container(
                                                        color: b_800,
                                                        // 세로 실선 색상
                                                        width: 1,
                                                        // 실선 두께
                                                        height: 24,
                                                      ),
                                                      // 두 번째 일정 텍스트
                                                      Column(
                                                        mainAxisAlignment: MainAxisAlignment.center,
                                                        crossAxisAlignment: CrossAxisAlignment.center,
                                                        children: [
                                                          Text(
                                                            "${ticketResponse.ticketProviders[index].ticketingSchedules[1].type} 오픈일",
                                                            textAlign: TextAlign.center,
                                                            style: const TextStyle(
                                                              fontFamily: 'Pretendard',
                                                              fontSize: 12,
                                                              color: b_400,
                                                              fontWeight: FontWeight.w400,
                                                            ),
                                                          ),
                                                          Text(
                                                            "${ticketResponse.ticketProviders[index].ticketingSchedules[1].date} ${ticketResponse.ticketProviders[index].ticketingSchedules[1].time}",
                                                            textAlign: TextAlign.center,
                                                            style: const TextStyle(
                                                              fontFamily: 'Pretendard',
                                                              fontSize: 14,
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          )
                                                        ],
                                                      ),
                                                    ]
                                                  ],
                                                )
                                              ]),
                                            ));
                                      })),
                                  const SizedBox(height: 88)
                                ],
                              ))
                        ]))
                  ])),
          Positioned(
              bottom: 0, // 검색 창 바로 아래에 위치
              left: 20,
              right: 20,
              child: Container(
                  color: b_950,
                  width: MediaQuery.of(context).size.width - 40,
                  height: 88,
                  padding: const EdgeInsets.only(bottom: 24, top: 16),
                  child: ElevatedButton(
                    onPressed: () async {
                      // 요청 전송
                      if (!isNotification) {
                        // 알림 안받은 상태에서
                        await NotificationRepository().addTicketNotification(context, widget.concertId);
                        showToast(context);
                      } else {
                        // 알림 받은 상태에서
                        await NotificationRepository().deleteTicketNotification(context, widget.concertId);
                      }
                      setState(() {
                        isNotification = !isNotification;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isNotification ? v1pt_30 : p_700, // 버튼 배경색
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1,
                          color: isNotification ? Colors.transparent : p_400,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 13), // 상하 패딩
                      fixedSize: Size(MediaQuery.of(context).size.width - 40, 48), // 고정 크기
                    ),
                    child: Text(
                      isNotification ? '알림 신청 해제하기' : '알림 신청하기',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: 'Pretendard',
                          fontWeight: FontWeight.w700,
                          color: isNotification ? p_600 : Colors.white),
                    ),
                  )))
        ]));
  }
}
