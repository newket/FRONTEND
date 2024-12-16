import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';
import 'package:newket/component/common/app_bar_back.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/model/ticket_model.dart';
import 'package:newket/repository/artist_repository.dart';
import 'package:newket/repository/notification_repository.dart';
import 'package:newket/repository/ticket_repository.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/view/login/login.dart';
import 'package:url_launcher/url_launcher.dart';

class TicketDetailV2 extends StatefulWidget {
  const TicketDetailV2({super.key, required this.concertId});

  final int concertId;

  @override
  State<StatefulWidget> createState() => _TicketDetailV2();
}

class _TicketDetailV2 extends State<TicketDetailV2> {
  late TicketRepository ticketRepository;
  late NotificationRepository notificationRepository;
  late ArtistRepository artistRepository;
  bool isNotification = false;
  bool isLoading = true; // 로딩 상태 추가
  late TicketDetail ticketResponse;
  late List<bool> isFavoriteArtist;

  void showToast(BuildContext context) {
    OverlayEntry overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 130, // Toast 위치 조정
        left: 20, // 화면의 가운데 정렬
        child: Material(
          color: Colors.transparent,
          child: Container(
            width: MediaQuery.of(context).size.width - 40,
            height: 78,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: ShapeDecoration(
              color: f_80,
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
                  width: 24,
                  height: 24,
                  padding: const EdgeInsets.all(4.80),
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: const Color(0xFF8397FF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9.60),
                    ),
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 14.4,
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
      final response3 =
          await Future.wait(response2.artists.map((i) => artistRepository.getIsFavoriteArtist(i.artistId, context)));
      setState(() {
        isNotification = response;
        ticketResponse = response2;
        isFavoriteArtist = response3;
        isLoading = false; // 로딩 완료 시 로딩 상태 해제
      });
    } catch (e) {
      // 에러 처리 (로그인 페이지로 리다이렉트 또는 에러 핸들링)
      AmplitudeConfig.amplitude.logEvent('TicketDetail error->LoginV2 $e');
      Get.offAll(() => const LoginV2());
      var storage = const FlutterSecureStorage();
      await storage.deleteAll();
    }
  }

  @override
  void initState() {
    super.initState();
    ticketRepository = TicketRepository();
    notificationRepository = NotificationRepository();
    artistRepository = ArtistRepository();
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
        backgroundColor: Colors.white,
        //앱바
        appBar: appBarBack(context, "티켓 상세 정보"),
        body: SingleChildScrollView(
            child: Column(children: [
          Stack(children: [
            //점선 위 전체
            SizedBox(
              width: double.infinity,
              height: 228,
              child: Image.network(
                ticketResponse.imageUrl,
                width: 142,
                height: 188,
                fit: BoxFit.fitWidth,
              ),
            ),
            //검은 그림자
            Container(
              width: double.infinity,
              height: 228,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: const Alignment(-0.00, 1.00),
                  end: const Alignment(0, -1),
                  colors: [
                    Colors.white,
                    const Color(0x91AAAAAA),
                    const Color(0x95454545),
                    Colors.black.withOpacity(0.6000000238418579)
                  ],
                ),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 20, left: 20),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 32),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12.0),
                        child: Image.network(
                          ticketResponse.imageUrl,
                          width: 142,
                          height: 188,
                          fit: BoxFit.fill,
                        ),
                      )
                    ])),
          ]),
          const SizedBox(height: 12),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis, //2줄 이상은 ...
                      text: TextSpan(
                        text: ticketResponse.title,
                        style: const TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 20,
                          color: f_100,
                          fontWeight: FontWeight.w700,
                        ),
                      )),
                  const SizedBox(height: 32),
                  Row(children: [
                    SvgPicture.asset('images/v2/opening_notice/ticketing_info.svg'),
                    const SizedBox(width: 8),
                    const Text(
                      "예매 정보",
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontSize: 18,
                        color: f_100,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ]),
                  const SizedBox(height: 16),
                  Wrap(
                      runSpacing: 16, // 각 아이템 간의 세로 간격
                      children: List.generate(ticketResponse.ticketProviders.length, (index) {
                        return InkWell(
                            onTap: () {
                              launchURL(ticketResponse.ticketProviders[index].url); // 클릭 시 URL로 이동
                            },
                            child: Stack(
                              children: [
                                Container(
                                    height: 80 + ticketResponse.ticketProviders[index].ticketingSchedules.length * 32,
                                    decoration: ShapeDecoration(
                                      color: f_5,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    )),
                                Container(
                                  height: 56,
                                  decoration: ShapeDecoration(
                                    color: f_90,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                  child: Row(
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
                                                fontSize: 16,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600,
                                              ))
                                        ],
                                      ),
                                      SvgPicture.asset('images/v2/opening_notice/send.svg')
                                    ],
                                  ),
                                ),
                                Positioned(
                                    top: 18 + 56,
                                    left: 16,
                                    child: SizedBox(
                                        width: MediaQuery.of(context).size.width - 72,
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: List.generate(
                                                ticketResponse.ticketProviders[index].ticketingSchedules.length,
                                                (index1) {
                                              return Column(
                                                children: [
                                                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                                    Text(
                                                      "${ticketResponse.ticketProviders[index].ticketingSchedules[index1].type} 오픈일",
                                                      textAlign: TextAlign.center,
                                                      style: const TextStyle(
                                                        fontFamily: 'Pretendard',
                                                        fontSize: 12,
                                                        color: f_50,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                    Text(
                                                      "${ticketResponse.ticketProviders[index].ticketingSchedules[index1].date} ${ticketResponse.ticketProviders[index].ticketingSchedules[0].time}",
                                                      textAlign: TextAlign.center,
                                                      style: const TextStyle(
                                                        fontFamily: 'Pretendard',
                                                        fontSize: 14,
                                                        color: f_80,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    )
                                                  ]),
                                                  const SizedBox(height: 8),
                                                ],
                                              );
                                            }))))
                              ],
                            ));
                      })),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SvgPicture.asset('images/v2/opening_notice/circle_info.svg'),
                      const SizedBox(width: 8),
                      const Expanded(
                          child: Text(
                        "티켓 오픈 일정은 티켓판매처 또는 기획사의 사정에 사전 예고 없이 변경 또는 취소 될 수 있습니다.",
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 12,
                          color: f_60,
                          fontWeight: FontWeight.w400,
                        ),
                        softWrap: true, // 줄바꿈 허용
                        overflow: TextOverflow.visible,
                      ))
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 2,
                    color: f_15,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      SvgPicture.asset('images/v2/opening_notice/pin.svg'),
                      const SizedBox(width: 8),
                      const Text(
                        "기본 정보",
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18,
                          color: f_100,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                      height: 74,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: ShapeDecoration(
                        color: f_5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text(
                          "공연 장소",
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 14,
                            color: f_50,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
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
                                      color: f_90,
                                      fontWeight: FontWeight.w500,
                                    )),
                                Row(
                                  children: [
                                    const Text(
                                      "위치 보러 가기",
                                      style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: 14,
                                        color: f_50,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    SvgPicture.asset(
                                      'images/v2/opening_notice/send.svg',
                                      color: f_60,
                                    )
                                  ],
                                ),
                              ],
                            ))
                      ])),
                  const SizedBox(height: 12),
                  Container(
                      width: MediaQuery.of(context).size.width - 40,
                      height: 50 + ((ticketResponse.date.length - 1) ~/ 2 + 1) * 38,
                      padding: const EdgeInsets.all(16),
                      decoration: ShapeDecoration(
                        color: f_5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        const Text(
                          "공연 일시",
                          style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontSize: 14,
                            color: f_50,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Wrap(
                          spacing: 8, // 각 아이템 간의 가로 간격
                          runSpacing: 8, // 각 아이템 간의 세로 간격
                          children: List.generate(
                            ticketResponse.date.length,
                            (index) {
                              return Container(
                                width: (screenWidth - 80) / 2,
                                // 아이템의 너비를 반으로 나눔 (양쪽 여백 포함)
                                height: 30,
                                decoration: BoxDecoration(
                                  color: f_15,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                                child: Text(
                                  ticketResponse.date[index],
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 14,
                                    color: f_90,
                                    letterSpacing: -0.42,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                      ])),
                  const SizedBox(height: 20),
                  Container(
                    height: 2,
                    color: f_15,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      SvgPicture.asset('images/v2/opening_notice/profile.svg'),
                      const SizedBox(width: 8),
                      const Text(
                        "아티스트 정보",
                        style: TextStyle(
                          fontFamily: 'Pretendard',
                          fontSize: 18,
                          color: f_100,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                      width: MediaQuery.of(context).size.width - 40,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                          children: List.generate(ticketResponse.artists.length, (index) {
                            return Column(
                              children: [
                                SizedBox(height: 48,child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            ticketResponse.artists[index].name,
                                            style: const TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontSize: 16,
                                              color: f_100,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          if (ticketResponse.artists[index].nicknames !=
                                              null)
                                            Text(
                                              ticketResponse.artists[index].nicknames!,
                                              style: const TextStyle(
                                                fontFamily: 'Pretendard',
                                                fontSize: 14,
                                                color: f_50,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            )
                                        ],
                                      ),
                                      if (isFavoriteArtist[index]) //관심 아티스트 아님
                                        GestureDetector(
                                            child: const Text(
                                              "관심 아티스트에서 제거",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontFamily: 'Pretendard',
                                                fontSize: 12,
                                                color: f_60,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            onTap: () async {
                                              await artistRepository.deleteFavoriteArtist(
                                                  ticketResponse.artists[index].artistId,
                                                  context);
                                              setState(() {
                                                isFavoriteArtist[index] = false;
                                              });
                                            })
                                      else //관심 아티스트
                                        GestureDetector(
                                            child: Container(
                                                width: 111,
                                                height: 36,
                                                padding: const EdgeInsets.only(
                                                    left: 12, top: 8, bottom: 8),
                                                clipBehavior: Clip.antiAlias,
                                                decoration: ShapeDecoration(
                                                  color: pt_10,
                                                  shape: RoundedRectangleBorder(
                                                    side: const BorderSide(
                                                        width: 1, color: pt_20),
                                                    borderRadius:
                                                    BorderRadius.circular(8),
                                                  ),
                                                ),
                                                child: Row(children: [
                                                  const Text(
                                                    "관심 아티스트",
                                                    style: TextStyle(
                                                      fontFamily: 'Pretendard',
                                                      fontSize: 12,
                                                      color: pn_100,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 4),
                                                  SvgPicture.asset(
                                                      'images/v2/opening_notice/add.svg',
                                                      width: 20,
                                                      height: 20)
                                                ])),
                                            onTap: () async {
                                              final isSuccess = await artistRepository.addFavoriteArtist(
                                                  ticketResponse.artists[index].artistId,
                                                  context);
                                              if(isSuccess){
                                                setState(() {
                                                  isFavoriteArtist[index] = true;
                                                });
                                              }
                                            })
                                    ])),
                                const SizedBox(height: 12),
                              ],
                            );
                          })))
                ],
              ))
        ])),
        bottomNavigationBar: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width - 40,
            height: 122,
            padding: const EdgeInsets.only(bottom: 54, top: 12, left: 20, right: 20),
            child: ticketResponse.isAvailableNotification
                ? // 티켓 알림 받기
                ElevatedButton(
                    onPressed: () async {
                      // 요청 전송
                      if (!isNotification) {
                        // 알림 안받은 상태에서
                        bool success = await NotificationRepository().addTicketNotification(context, widget.concertId);
                        if(success){
                          showToast(context);
                          AmplitudeConfig.amplitude.logEvent('addTicketNotification(concertId:${widget.concertId}');
                          setState(() {
                            isNotification = !isNotification;
                          });
                        }
                      } else {
                        // 알림 받은 상태에서
                        await NotificationRepository().deleteTicketNotification(context, widget.concertId);
                        AmplitudeConfig.amplitude.logEvent('cancelTicketNotification(concertId:${widget.concertId}');
                        setState(() {
                          isNotification = !isNotification;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0, // 그림자 제거
                      backgroundColor: isNotification ? pt_20 : pn_100, // 버튼 배경색
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16), // 상하 패딩
                      //fixedSize: Size(MediaQuery.of(context).size.width - 40, 56), // 고정 크기
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(isNotification
                            ? 'images/v2/opening_notice/notification_off.svg'
                            : 'images/v2/opening_notice/notification_on.svg'),
                        const SizedBox(width: 10),
                        Text(
                          isNotification ? '알림 해제하기' : '알림 받기',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w600,
                              color: isNotification ? pn_100 : Colors.white),
                        )
                      ],
                    ),
                  )
                : //예매 진행 중인 티켓
                Container(
                    height: 56,
                    decoration: ShapeDecoration(
                        color: f_10,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        )),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: const Text(
                      '예매 진행 중인 티켓',
                      textAlign: TextAlign.center,
                      style:
                          TextStyle(fontSize: 16, fontFamily: 'Pretendard', fontWeight: FontWeight.w600, color: f_30),
                    ))));
  }
}
