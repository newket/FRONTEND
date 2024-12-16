import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';
import 'package:newket/component/opening_notice_card.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/repository/notification_repository.dart';
import 'package:newket/repository/ticket_repository.dart';
import 'package:newket/repository/user_repository.dart';
import 'package:newket/constant/colors.dart';
import 'package:newket/view/login/login.dart';
import 'package:newket/view/tapbar/tab_bar.dart';
import 'package:newket/view/ticket_detail/ticket_detail.dart';

class MyTicketV2 extends StatefulWidget {
  const MyTicketV2({super.key});

  @override
  State<StatefulWidget> createState() => _MyTicketV2();
}

class _MyTicketV2 extends State<MyTicketV2> {
  late UserRepository userRepository;
  late TicketRepository ticketRepository;
  late NotificationRepository notificationRepository;
  String name = '';
  String artist = '';
  bool isLoading = true; // 로딩 상태 추가
  Future<void> _getUserInfoApi() async {
    try {
      final user = await userRepository.getUserInfoApi(context);
      final favoriteTickets = await ticketRepository.getFavoriteOpeningNotice(context);
      final notificationTicket = await notificationRepository.getAllTicketNotifications(context);

      // 정보를 상태에 한 번만 저장
      setState(() {
        name = user.name;
        if (favoriteTickets.artistName != 'NONE') {
          artist = favoriteTickets.artistName;
        } else if (notificationTicket.artistName != 'NONE') {
          artist = notificationTicket.artistName;
        } else {
          artist = 'NONE';
        }
        isLoading = false; // 로딩 완료 시 로딩 상태 해제
      });
    } catch (e) {
      print("Error in _getUserInfoApi: $e"); // 에러 내용을 출력
      // 에러 처리 (로그인 페이지로 리다이렉트 또는 에러 핸들링)
      AmplitudeConfig.amplitude.logEvent('MyTicket error->LoginV2 $e');
      Get.offAll(() => const LoginV2());
      var storage = const FlutterSecureStorage();
      await storage.deleteAll();
    }
  }

  @override
  void initState() {
    super.initState();
    userRepository = UserRepository();
    ticketRepository = TicketRepository();
    notificationRepository = NotificationRepository();
    _getUserInfoApi();
  }

  @override
  Widget build(BuildContext context) {
    // 로딩 중일 때 로딩 화면을 표시
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false, //키보드가 올라 오지 않도록
      body: SingleChildScrollView(
        //스크롤 가능
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(children: [
                Container(
                    height: 547,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.00, 1.00),
                        end: Alignment(0, -1),
                        colors: [
                          Colors.white,
                          Color(0xFFE0DDFF),
                          Color(0xFF9F97FF),
                          pn_100,
                        ],
                      ),
                    )),
                Positioned(
                    left: 20,
                    top: 20,
                    right: 20,
                    child: FutureBuilder(
                        future: ticketRepository.getFavoriteOpeningNotice(context),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center();
                          } else if (snapshot.hasError || !snapshot.hasData) {
                            //데이터 로딩 실패
                            return const Center();
                          } else {
                            final response = snapshot.data!;
                            return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                //왼쪽 정렬
                                children: [
                                  // OO0님,
                                  Text("${name}님,",
                                      style: const TextStyle(
                                          color: b_100,
                                          fontSize: 24,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w400)),
                                  (artist == 'NONE')
                                      ? const Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("아직 알림 받기한 티켓이 없어요.",
                                                style: TextStyle(
                                                    fontFamily: 'Pretendard',
                                                    fontSize: 24,
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700)),
                                            Text("티켓을 찾아보러 가볼까요?",
                                                style: TextStyle(
                                                    fontFamily: 'Pretendard',
                                                    fontSize: 24,
                                                    color: b_100,
                                                    fontWeight: FontWeight.w400))
                                          ],
                                        )
                                      : Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(artist,
                                                    style: const TextStyle(
                                                        fontFamily: 'Pretendard',
                                                        fontSize: 24,
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.w700)),
                                                const Text("의 티켓",
                                                    style: const TextStyle(
                                                        color: b_100,
                                                        fontSize: 24,
                                                        fontFamily: 'Pretendard',
                                                        fontWeight: FontWeight.w400))
                                              ],
                                            ),
                                            const Text("확인해 볼까요?",
                                                style: const TextStyle(
                                                    color: b_100,
                                                    fontSize: 24,
                                                    fontFamily: 'Pretendard',
                                                    fontWeight: FontWeight.w400))
                                          ],
                                        ),
                                  const SizedBox(height: 24),
                                  // 관심 아티스트의 오픈 예정 티켓
                                  Row(children: [
                                    SvgPicture.asset("images/v2/my_ticket/star.svg", height: 20),
                                    Container(width: 8),
                                    const Text("관심 아티스트의 오픈 예정 티켓",
                                        style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontSize: 18,
                                            color: b_100,
                                            fontWeight: FontWeight.w600))
                                  ]),
                                  const SizedBox(height: 8),
                                  //아티스트 칩
                                  if (response.favoriteArtistNames.isNotEmpty)
                                    SizedBox(
                                        height: 25,
                                        child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Wrap(
                                                alignment: WrapAlignment.start,
                                                //왼쪽 부터 시작
                                                direction: Axis.horizontal,
                                                spacing: 8.0,
                                                // 각 아이템 간 간격
                                                runSpacing: 8.0,
                                                // 줄 바꿈 시 간격
                                                children: response.favoriteArtistNames.map((artist) {
                                                  return Container(
                                                    height: 25,
                                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                                    clipBehavior: Clip.antiAlias,
                                                    decoration: ShapeDecoration(
                                                      color: Colors.white.withOpacity(0.15),
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      artist,
                                                      textAlign: TextAlign.center,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontFamily: 'Pretendard',
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  );
                                                }).toList()))),
                                  const SizedBox(height: 12),
                                  if (response.concerts.isNotEmpty)
                                    SizedBox(
                                      height: 322,
                                      child: ListView.builder(
                                        scrollDirection: Axis.horizontal, // 가로 스크롤
                                        itemCount: response.concerts.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              AmplitudeConfig.amplitude.logEvent(
                                                  'OpeningNoticeDetail(id:${response.concerts[index].concertId})');
                                              // 상세 페이지로 이동
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => TicketDetailV2(
                                                    concertId: response.concerts[index].concertId, // 상세 페이지에 데이터 전달
                                                  ),
                                                ),
                                              );
                                            },
                                            child: Container(
                                              width: 154, // 각 아이템의 너비 설정
                                              margin: const EdgeInsets.only(right: 12), // 아이템 간 간격
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
                                                      ClipRRect(
                                                        borderRadius: BorderRadius.circular(8.0),
                                                        child: Image.network(
                                                          response.concerts[index].imageUrl,
                                                          width: 169,
                                                          height: 225,
                                                          fit: BoxFit.fill,
                                                          loadingBuilder: (BuildContext context, Widget child,
                                                              ImageChunkEvent? loadingProgress) {
                                                            if (loadingProgress == null) {
                                                              return child; // 로딩이 완료되었을 때의 이미지
                                                            }
                                                            return Container(
                                                              width: 169,
                                                              height: 225,
                                                              color: f_100, // 로딩 중일 때의 배경색
                                                            );
                                                          },
                                                          errorBuilder: (BuildContext context, Object error,
                                                              StackTrace? stackTrace) {
                                                            return Container(
                                                              width: 169,
                                                              height: 225,
                                                              color: f_100, // 로딩 실패 시의 배경색
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      Container(
                                                        width: 169,
                                                        height: 148,
                                                        decoration: const ShapeDecoration(
                                                          gradient: LinearGradient(
                                                            begin: Alignment(0.00, -1.00),
                                                            end: Alignment(0, 1),
                                                            colors: [
                                                              Color(0x001A1A25),
                                                              Color(0x351A1A25),
                                                              Color(0xA61A1A25),
                                                              Color(0xFF1A1A25)
                                                            ],
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
                                                        height: 44,
                                                        child: RichText(
                                                          maxLines: 2,
                                                          overflow: TextOverflow.ellipsis,
                                                          text: TextSpan(
                                                            text: response.concerts[index].title,
                                                            style: const TextStyle(
                                                              fontFamily: 'Pretendard',
                                                              fontSize: 14,
                                                              color: Colors.white,
                                                              fontWeight: FontWeight.w500,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Container(
                                                    width: 169,
                                                    height: 70,
                                                    decoration: ShapeDecoration(
                                                      color: f_100,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(8)),
                                                    ),
                                                    child: Column(
                                                      children: [
                                                        Container(color: f_80, width: 89, height: 1),
                                                        Padding(
                                                            padding: const EdgeInsets.all(12),
                                                            child: Column(
                                                              children: List.generate(
                                                                //최대 2개
                                                                response.concerts[index].ticketingSchedules.length > 2
                                                                    ? 2
                                                                    : response
                                                                        .concerts[index].ticketingSchedules.length,
                                                                (index1) {
                                                                  return Column(
                                                                    children: [
                                                                      Row(
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        children: [
                                                                          Text(
                                                                            "${response.concerts[index].ticketingSchedules[index1].type} 오픈",
                                                                            style: const TextStyle(
                                                                              fontFamily: 'Pretendard',
                                                                              fontSize: 12,
                                                                              color: b_400,
                                                                              fontWeight: FontWeight.w400,
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            response.concerts[index]
                                                                                .ticketingSchedules[index1].dday,
                                                                            style: TextStyle(
                                                                              fontFamily: 'Pretendard',
                                                                              fontSize: 12,
                                                                              color: response.concerts[index]
                                                                                      .ticketingSchedules[index1].dday
                                                                                      .contains("D-")
                                                                                  ? const Color(0xffFF5F5F)
                                                                                  : Colors.white,
                                                                              fontWeight: FontWeight.w700,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      const SizedBox(height: 4),
                                                                    ],
                                                                  );
                                                                },
                                                              ),
                                                            ))
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                  else if (response.favoriteArtistNames.isNotEmpty)
                                    Container(
                                        width: MediaQuery.of(context).size.width - 40,
                                        height: 295,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: ShapeDecoration(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            const SizedBox(height: 39),
                                            Image.asset("images/v2/my_ticket/favorite_ticket.png",
                                                height: 131, width: 169),
                                            const SizedBox(height: 8),
                                            const Text(
                                              '아직 관심 아티스트의\n티켓이 뜨지 않았어요!',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: f_90,
                                                fontSize: 18,
                                                fontFamily: 'Pretendard',
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            const Text(
                                              '관심 아티스트의 티켓이\n뜨면 바로 알려드릴게요!',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: f_50,
                                                fontSize: 14,
                                                fontFamily: 'Pretendard',
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ))
                                  else
                                    Container(
                                        width: MediaQuery.of(context).size.width - 40,
                                        height: 331,
                                        clipBehavior: Clip.antiAlias,
                                        decoration: ShapeDecoration(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: Column(
                                          children: [
                                            const SizedBox(height: 27),
                                            Image.asset("images/v2/my_ticket/favorite_artist_null.png",
                                                height: 160, width: 160),
                                            const SizedBox(height: 20),
                                            const Text(
                                              '아직 관심 아티스트를\n등록하지 않았어요!',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: f_90,
                                                fontSize: 18,
                                                fontFamily: 'Pretendard',
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            const SizedBox(height: 12),
                                            GestureDetector(
                                                //아티스트 검색으로
                                                onTap: () {
                                                  AmplitudeConfig.amplitude.logEvent('MyTicket->AddFavoriteArtist');
                                                  tabController.index = 0;
                                                },
                                                child: Container(
                                                  width: 184,
                                                  height: 46,
                                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                                  clipBehavior: Clip.antiAlias,
                                                  decoration: ShapeDecoration(
                                                    color: p_normal,
                                                    shape:
                                                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                                  ),
                                                  child: const Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: [
                                                      Text(
                                                        '관심 아티스트 추가하기',
                                                        textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                          fontFamily: 'Pretendard',
                                                          fontWeight: FontWeight.w600,
                                                        ),
                                                      ),
                                                      SizedBox(width: 8),
                                                      Icon(Icons.add, size: 20, color: Colors.white),
                                                    ],
                                                  ),
                                                ))
                                          ],
                                        ))
                                ]);
                          }
                        }))
              ]),
              FutureBuilder(
                  future: notificationRepository.getAllTicketNotifications(context),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: Column(children: [SizedBox(height: 12), CircularProgressIndicator()]));
                    } else if (snapshot.hasError) {
                      // 데이터 로딩 실패
                      return const Center();
                    } else if (!snapshot.hasData) {
                      // 데이터 없음
                      return const Center();
                    } else {
                      final openingResponse = snapshot.data!;
                      return Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Column(children: [
                            Container(height: 20),
                            Row(
                              children: [
                                const Text(
                                  "알림 받기한 티켓",
                                  style: TextStyle(
                                    color: f_100,
                                    fontSize: 18,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  '${openingResponse.totalNum}개',
                                  style: const TextStyle(
                                    color: p_normal,
                                    fontSize: 16,
                                    fontFamily: 'Pretendard',
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            (openingResponse.concerts.isEmpty)
                                ? Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                                    const SizedBox(height: 44),
                                    Image.asset('images/v2/my_ticket/ticket_null.png', width: 160, height: 160),
                                    const SizedBox(height: 8),
                                    const Text(
                                      '아직 알림 받기 한 티켓이 없어요',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        color: f_90,
                                        fontSize: 18,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: -0.54,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    GestureDetector(
                                        //아티스트 검색으로
                                        onTap: () {
                                          AmplitudeConfig.amplitude.logEvent('MyTicket->AddFavoriteArtist');
                                          tabController.index = 0;
                                        },
                                        child: Container(
                                          width: 134,
                                          height: 46,
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                                          clipBehavior: Clip.antiAlias,
                                          decoration: ShapeDecoration(
                                            color: p_normal,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          ),
                                          child: const Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                '티켓 찾아보기',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  letterSpacing: -0.42,
                                                  fontFamily: 'Pretendard',
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              Icon(Icons.search, size: 20, color: Colors.white),
                                            ],
                                          ),
                                        )),
                                    const SizedBox(height: 45)
                                  ])
                                : Column(
                                    children: List.generate(
                                      openingResponse.concerts.length,
                                      (index) {
                                        return Column(children: [
                                          GestureDetector(
                                            onTap: () {
                                              AmplitudeConfig.amplitude.logEvent(
                                                  'OpeningNoticeDetail(id:${openingResponse.concerts[index].concertId})');
                                              // 상세 페이지로 이동
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => TicketDetailV2(
                                                    concertId:
                                                        openingResponse.concerts[index].concertId, // 상세 페이지에 데이터 전달
                                                  ),
                                                ),
                                              );
                                            },
                                            child: OpeningNoticeCard(openingResponse: openingResponse, index: index),
                                          ),
                                          const SizedBox(height: 12)
                                        ]);
                                      },
                                    ),
                                  ),
                            const SizedBox(height: 122)
                          ]));
                    }
                  })
            ]),
      ),
    );
  }
}
