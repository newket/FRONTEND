import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newket/repository/user_repository.dart';
import 'package:newket/theme/Colors.dart';
import 'package:newket/view/agreement/privacy_policy.dart';
import 'package:newket/view/agreement/terms_of_service.dart';
import 'package:newket/view/onboarding/login.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyPage(),
    );
  }
}

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<StatefulWidget> createState() => _MyPage();
}

class _MyPage extends State<MyPage> {
  late UserRepository userRepository;
  bool artistNotification = true;
  bool ticketNotification = true;
  Color artistBackground = b_900;
  Color ticketBackground = b_900;

  @override
  void initState() {
    super.initState();
    userRepository = UserRepository();
    _loadNotificationSettings(); // 알림 설정 불러오기
  }

  Future<void> _loadNotificationSettings() async {
    try {
      final response = await userRepository.getNotificationAllow(context);
      // 알림 설정 값 상태에 반영
      setState(() {
        artistNotification = response.artistNotification;
        artistBackground = artistNotification ? pt_20 : b_900;
        ticketNotification = response.ticketNotification;
        ticketBackground = ticketNotification ? pt_20 : b_900;
      });
    } catch (e) {
      // 에러 처리 (로그인 페이지로 리다이렉트 또는 에러 핸들링)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const Login()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: b_950,
          title: const Text(
            "마이페이지",
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 20,
              color: b_100,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        backgroundColor: p_700,
        body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
              Stack(children: [
                //점선 위 전체
                Container(
                  width: double.infinity,
                  height: 90,
                  decoration: const ShapeDecoration(
                    color: b_950,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(24),
                        bottomRight: Radius.circular(24),
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "사용자 계정",
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          FutureBuilder(
                              future: userRepository.getUserInfoApi(context),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center();
                                } else if (snapshot.hasError || !snapshot.hasData) {
                                  // 데이터 로딩 실패
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const Login(),
                                    ),
                                  );
                                  return const Center();
                                } else {
                                  final response = snapshot.data!;
                                  return Row(children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.asset("images/mypage/kakao.png", width: 20),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      response.email,
                                      style: const TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: 12,
                                        color: b_400,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  ]);
                                }
                              })
                        ])),
              ]),
              // 점선
              Stack(children: [
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
                  // 스크롤 할 때 최소 크기
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height-100, //밑에 네비바 100
                  ),
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
                Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset("images/mypage/star.svg", height: 20, width: 20),
                                const SizedBox(width: 8),
                                const Text(
                                  '나의 관심 아티스트',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 16,
                                    color: b_100,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              ],
                            ),
                            const Icon(Icons.keyboard_arrow_right_rounded, color: Colors.white)
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.only(left: 8, right: 8, top: 12, bottom: 12),
                          width: double.infinity,
                          height: 66,
                          decoration: BoxDecoration(
                            color: artistBackground,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '관심 아티스트 알림',
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '관심 아티스트의 티켓이 등록되면 알림을 보내드려요.',
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: 12,
                                      color: b_100,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                ],
                              ),
                              CupertinoSwitch(
                                value: artistNotification,
                                activeColor: p_700,
                                onChanged: (bool value) async {
                                  // UI 상태 업데이트
                                  setState(() {
                                    artistNotification = value;
                                    artistBackground = artistNotification ? pt_20 : b_900;
                                  });
                                  String isAllow = value ? 'on' : 'off';
                                  await userRepository.putNotificationAllow(context, isAllow, "artist");
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                SvgPicture.asset("images/mypage/ticket.svg", height: 20, width: 20),
                                const SizedBox(width: 8),
                                const Text(
                                  '알림 받기 신청한 티켓',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 16,
                                    color: b_100,
                                    fontWeight: FontWeight.w700,
                                  ),
                                )
                              ],
                            ),
                            const Icon(Icons.keyboard_arrow_right_rounded, color: Colors.white)
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.only(left: 8, right: 8, top: 12, bottom: 12),
                          width: double.infinity,
                          height: 66,
                          decoration: BoxDecoration(
                            color: ticketBackground,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '티켓 오픈 임박 알림',
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '티켓 오픈 하루 전, 1시간 전에 알려드려요.',
                                    style: TextStyle(
                                      fontFamily: 'Pretendard',
                                      fontSize: 12,
                                      color: b_100,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  )
                                ],
                              ),
                              CupertinoSwitch(
                                value: ticketNotification,
                                activeColor: p_700,
                                onChanged: (bool value) async {
                                  // UI 상태 업데이트
                                  setState(() {
                                    ticketNotification = value;
                                    ticketBackground = ticketNotification ? pt_20 : b_900;
                                  });
                                  String isAllow = value ? 'on' : 'off';
                                  await userRepository.putNotificationAllow(context, isAllow, "ticket");
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(color: b_800, height: 2),
                        const SizedBox(height: 24),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const PrivacyPolicy(),
                                ),
                              );
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '개인정보처리 방침',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Icon(Icons.keyboard_arrow_right_rounded, color: Colors.white)
                              ],
                            )),
                        const SizedBox(height: 24),
                        GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const TermsOfService(),
                                ),
                              );
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '서비스 이용약관',
                                  style: TextStyle(
                                    fontFamily: 'Pretendard',
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                Icon(Icons.keyboard_arrow_right_rounded, color: Colors.white)
                              ],
                            )),
                        const SizedBox(height: 24),
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '문의하기',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Icon(Icons.keyboard_arrow_right_rounded, color: Colors.white)
                          ],
                        ),
                        const SizedBox(height: 24),
                        GestureDetector(
                            onTap: () {
                              // 로그인 페이지로 이동
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Login(),
                                ),
                              );
                            },
                            child: const Text(
                              '로그아웃',
                              style: TextStyle(
                                fontFamily: 'Pretendard',
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.w400,
                              ),
                            )),
                        const SizedBox(height: 24),
                        const Text('회원 탈퇴',
                            style: TextStyle(
                              fontFamily: 'Pretendard',
                              fontSize: 14,
                              color: b_500,
                              fontWeight: FontWeight.w400,
                            )),
                      ],
                    ))
              ])
            ])));
  }
}
