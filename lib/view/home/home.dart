import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:newket/repository/ticket_repository.dart';
import 'package:newket/repository/user_repository.dart';
import 'package:newket/theme/colors.dart';
import 'package:newket/view/favorite_artist/my_favorite_aritst.dart';
import 'package:newket/view/home/notifications.dart';
import 'package:newket/view/on_sale/on_sale.dart';
import 'package:newket/view/on_sale/on_sale_detail.dart';
import 'package:newket/view/opening_notice/opening_notice.dart';
import 'package:newket/view/opening_notice/opening_notice_detail.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<StatefulWidget> createState() => _Home();
}

class _Home extends State<Home> {
  late UserRepository userRepository;
  late TicketRepository ticketRepository;
  String name = '';
  String artist = '';
  List<String> favoriteArtists = [];
  bool isLoading = true; // 로딩 상태 추가


  Future<void> _getUserInfoApi(BuildContext context) async {
    try {
      final user = await userRepository.getUserInfoApi(context);
      final favorite = await ticketRepository.getFavoriteOpeningNotice(context);
      final normal = await ticketRepository.openingNoticeApi();
      // 정보를 상태에 한 번만 저장
      setState(() {
        name = user.name;
        if (favorite.artistName != 'NONE') {
          artist = favorite.artistName;
        } else {
          artist = normal.artistName;
        }
        isLoading = false; // 로딩 완료 시 로딩 상태 해제
      });
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    userRepository = UserRepository();
    ticketRepository = TicketRepository();
    _getUserInfoApi(context);
  }

  @override
  Widget build(BuildContext context) {
    // 로딩 중일 때 로딩 화면을 표시
    if (isLoading) {
      return Container();
    }
    return Scaffold(
      //배경
      backgroundColor: b_950,

      //앱바
      appBar: AppBar(
        backgroundColor: b_950,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Image.asset("images/appbar/appbar_ticket.png", height: 28),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Notifications(),
                  ),
                );
              },
              child: Image.asset("images/appbar/appbar_alarm.png", height: 28),
            )
          ],
        ),
      ),

      //내용
      body: RefreshIndicator(
        //새로 고침
        onRefresh: () async {
          setState(() {});
        },
        child: SingleChildScrollView(
          //스크롤 가능
          child: Container(
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(color: p_700),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(children: [
                  Container(
                    width: double.infinity,
                    height: 533,
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
                  //배경에 원 뿌옇게
                  Positioned(
                    top: 77,
                    right: 0,
                    child: Container(
                      width: 118,
                      height: 118,
                      decoration: const BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: pt_30,
                            blurRadius: 92.18,
                            offset: Offset(0, 5),
                            spreadRadius: 0,
                          )
                        ],
                      ),
                    ),
                  ),
                  //안내 멘트
                  Positioned(
                      left: 20,
                      top: 20,
                      right: 20,
                      child: FutureBuilder(
                          future: ticketRepository.getFavoriteOpeningNotice(context),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CircularProgressIndicator());
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
                                            fontFamily: 'Pretendard',
                                            fontSize: 20,
                                            color: b_100,
                                            fontWeight: FontWeight.w700)),
                                    Row(
                                      children: [
                                        Text(artist,
                                            style: const TextStyle(
                                                fontFamily: 'Pretendard',
                                                fontSize: 20,
                                                color: p_400,
                                                fontWeight: FontWeight.w700)),
                                        const Text("의 티켓, 확인해 볼까요?",
                                            style: TextStyle(
                                                fontFamily: 'Pretendard',
                                                fontSize: 20,
                                                color: b_100,
                                                fontWeight: FontWeight.w700))
                                      ],
                                    ),
                                    const SizedBox(height: 32),
                                    // 관심 아티스트의 오픈 예정 티켓
                                    Row(children: [
                                      SvgPicture.asset("images/favorite_artist/star.svg", height: 20),
                                      Container(width: 8),
                                      const Text("관심 아티스트의 오픈 예정 티켓",
                                          style: TextStyle(
                                              fontFamily: 'Pretendard',
                                              fontSize: 18,
                                              color: b_100,
                                              fontWeight: FontWeight.w700))
                                    ]),
                                    const SizedBox(height: 6),
                                    //아티스트 칩
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
                                                      color: pt_20,
                                                      shape: RoundedRectangleBorder(
                                                        side: const BorderSide(width: 1, color: pt_30),
                                                        borderRadius: BorderRadius.circular(8),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      artist,
                                                      textAlign: TextAlign.center,
                                                      style: const TextStyle(
                                                        color: p_500,
                                                        fontSize: 12,
                                                        fontFamily: 'Pretendard',
                                                        fontWeight: FontWeight.w400,
                                                      ),
                                                    ),
                                                  );
                                                }).toList()))),
                                    const SizedBox(height: 20),
                                    if (response.concerts.isNotEmpty)
                                      SizedBox(
                                        height: 322,
                                        child: ListView.builder(
                                          scrollDirection: Axis.horizontal, // 가로 스크롤
                                          itemCount: response.concerts.length,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                              onTap: () {
                                                // 상세 페이지로 이동
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) => OpeningNoticeDetail(
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
                                                  mainAxisSize: MainAxisSize.min, // Column의 크기를 자식 크기에 맞춤
                                                  children: [
                                                    ClipRRect(
                                                      borderRadius: BorderRadius.circular(8.0),
                                                      child: Image.network(
                                                        response.concerts[index].imageUrl,
                                                        width: 154,
                                                        height: 205,
                                                        fit: BoxFit.fill,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    SizedBox(
                                                      height: 35,
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
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Column(
                                                      children: List.generate(
                                                        //최대 2개
                                                        response.concerts[index].ticketingSchedules.length > 2
                                                            ? 2
                                                            : response.concerts[index].ticketingSchedules.length,
                                                        (index1) {
                                                          return Column(
                                                            children: [
                                                              Container(
                                                                height: 25,
                                                                decoration: BoxDecoration(
                                                                  color: b_900,
                                                                  borderRadius: BorderRadius.circular(8),
                                                                ),
                                                                padding: const EdgeInsets.only(left: 8, right: 8),
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                                                      "${response.concerts[index].ticketingSchedules[index1].dday}",
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
                                                              ),
                                                              const SizedBox(height: 8),
                                                            ],
                                                          );
                                                        },
                                                      ),
                                                    ),
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
                                          height: 337,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: ShapeDecoration(
                                            gradient: const LinearGradient(
                                              begin: Alignment(0.00, -1.00),
                                              end: Alignment(0, 1),
                                              colors: [b_950, Color(0xFF090C2B), Color(0xFF201D65)],
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              const SizedBox(height: 63),
                                              SvgPicture.asset("images/search/ticket_null.svg", height: 92, width: 92),
                                              const SizedBox(height: 20),
                                              const Text(
                                                '아직 관심 아티스트의\n티켓이 뜨지 않았어요!',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontFamily: 'Pretendard',
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              const Text(
                                                '관심 아티스트의 티켓이\n뜨면 바로 알려드릴게요!',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: b_400,
                                                    fontSize: 14,
                                                    fontFamily: 'Pretendard',
                                                    fontWeight: FontWeight.w400),
                                              ),
                                            ],
                                          ))
                                    else
                                      Container(
                                          width: MediaQuery.of(context).size.width - 40,
                                          height: 337,
                                          clipBehavior: Clip.antiAlias,
                                          decoration: ShapeDecoration(
                                            gradient: const LinearGradient(
                                              begin: Alignment(0.00, -1.00),
                                              end: Alignment(0, 1),
                                              colors: [b_950, Color(0xFF090C2B), Color(0xFF201D65)],
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                          ),
                                          child: Column(
                                            children: [
                                              const SizedBox(height: 63),
                                              SvgPicture.asset("images/search/ticket_null.svg", height: 92, width: 92),
                                              const SizedBox(height: 20),
                                              const Text(
                                                '아직 관심 아티스트를\n등록하지 않았어요!',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontFamily: 'Pretendard',
                                                  fontWeight: FontWeight.w700,
                                                ),
                                              ),
                                              const SizedBox(height: 16),
                                              GestureDetector(
                                                  //아티스트 검색으로
                                                  onTap: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => const MyFavoriteArtist(),
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    width: 184,
                                                    height: 40,
                                                    clipBehavior: Clip.antiAlias,
                                                    decoration: ShapeDecoration(
                                                      color: p_700,
                                                      shape: RoundedRectangleBorder(
                                                        side: const BorderSide(width: 1, color: p_400),
                                                        borderRadius: BorderRadius.circular(12),
                                                      ),
                                                      shadows: const [
                                                        BoxShadow(
                                                          color: p_700,
                                                          blurRadius: 28,
                                                          offset: Offset(0, 5),
                                                          spreadRadius: 0,
                                                        )
                                                      ],
                                                    ),
                                                    child: const Row(
                                                      mainAxisAlignment: MainAxisAlignment.center,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Icon(Icons.add, size: 24, color: Colors.white),
                                                        SizedBox(width: 10),
                                                        Text(
                                                          '관심 아티스트 추가하기',
                                                          textAlign: TextAlign.center,
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14,
                                                            fontFamily: 'Pretendard',
                                                            fontWeight: FontWeight.w700,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ))
                                            ],
                                          ))
                                  ]);
                            }
                          }))
                ]),
                //오픈 예정 티켓
                Stack(
                  children: [
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
                      height: 502,
                      decoration: const ShapeDecoration(
                        color: b_950,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24)),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      top: 20,
                      right: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        //왼쪽 정렬
                        children: [
                          FutureBuilder(
                              future: ticketRepository.openingNoticeApi(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const Center(child: CircularProgressIndicator());
                                } else if (snapshot.hasError || !snapshot.hasData) {
                                  //데이터 로딩 실패
                                  return Center(
                                      child: Row(children: [
                                    Image.asset("images/opening_notice/opening_notice_logo.png", height: 24),
                                    Container(width: 8),
                                    const Text("오픈 예정 티켓",
                                        style: TextStyle(
                                            fontFamily: 'Pretendard',
                                            fontSize: 18,
                                            color: b_100,
                                            fontWeight: FontWeight.w700)),
                                  ]));
                                } else {
                                  final openingResponse = snapshot.data!;
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      //로고 + 오픈 예정 티켓
                                      Row(children: [
                                        Image.asset("images/opening_notice/opening_notice_logo.png", height: 24),
                                        Container(width: 8),
                                        const Text("오픈 예정 티켓",
                                            style: TextStyle(
                                                fontFamily: 'Pretendard',
                                                fontSize: 18,
                                                color: b_100,
                                                fontWeight: FontWeight.w700))
                                      ]),
                                      //빈공간 12
                                      Container(height: 12),
                                      //티켓
                                      Column(
                                        children: List.generate(openingResponse.totalNum<3? openingResponse.totalNum: 3, (index1) {
                                          return Column(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  // 상세 페이지로 이동
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => OpeningNoticeDetail(
                                                        concertId: openingResponse
                                                            .concerts[index1].concertId, // 상세 페이지에 데이터 전달
                                                      ),
                                                    ),
                                                  );
                                                },
                                                child: Row(
                                                  children: [
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
                                                                if (openingResponse
                                                                        .concerts[index1].ticketingSchedules.length ==
                                                                    1)
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
                                                                            if (openingResponse.concerts[index1]
                                                                                        .ticketingSchedules[0].dday ==
                                                                                    'D-3' ||
                                                                                openingResponse.concerts[index1]
                                                                                        .ticketingSchedules[0].dday ==
                                                                                    'D-2' ||
                                                                                openingResponse.concerts[index1]
                                                                                        .ticketingSchedules[0].dday ==
                                                                                    'D-1' ||
                                                                                openingResponse.concerts[index1]
                                                                                        .ticketingSchedules[0].dday ==
                                                                                    'D-Day')
                                                                              Text(
                                                                                openingResponse.concerts[index1]
                                                                                    .ticketingSchedules[0].dday,
                                                                                style: const TextStyle(
                                                                                  fontFamily: 'Pretendard',
                                                                                  fontSize: 12,
                                                                                  color: Color(0xffFF5F5F),
                                                                                  fontWeight: FontWeight.w700,
                                                                                ),
                                                                              )
                                                                            else
                                                                              Text(
                                                                                openingResponse.concerts[index1]
                                                                                    .ticketingSchedules[0].dday,
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
                                                                          if (openingResponse.concerts[index1]
                                                                                      .ticketingSchedules[0].dday ==
                                                                                  'D-3' ||
                                                                              openingResponse.concerts[index1]
                                                                                      .ticketingSchedules[0].dday ==
                                                                                  'D-2' ||
                                                                              openingResponse.concerts[index1]
                                                                                      .ticketingSchedules[0].dday ==
                                                                                  'D-1' ||
                                                                              openingResponse.concerts[index1]
                                                                                      .ticketingSchedules[0].dday ==
                                                                                  'D-Day')
                                                                            Text(
                                                                              openingResponse.concerts[index1]
                                                                                  .ticketingSchedules[0].dday,
                                                                              style: const TextStyle(
                                                                                fontFamily: 'Pretendard',
                                                                                fontSize: 12,
                                                                                color: Color(0xffFF5F5F),
                                                                                fontWeight: FontWeight.w700,
                                                                              ),
                                                                            )
                                                                          else
                                                                            Text(
                                                                              openingResponse.concerts[index1]
                                                                                  .ticketingSchedules[0].dday,
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
                                                                        margin: const EdgeInsets.symmetric(
                                                                            horizontal: 12), // 여백
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
                                                                          if (openingResponse.concerts[index1]
                                                                                      .ticketingSchedules[1].dday ==
                                                                                  'D-3' ||
                                                                              openingResponse.concerts[index1]
                                                                                      .ticketingSchedules[1].dday ==
                                                                                  'D-2' ||
                                                                              openingResponse.concerts[index1]
                                                                                      .ticketingSchedules[1].dday ==
                                                                                  'D-1' ||
                                                                              openingResponse.concerts[index1]
                                                                                      .ticketingSchedules[1].dday ==
                                                                                  'D-Day')
                                                                            Text(
                                                                              openingResponse.concerts[index1]
                                                                                  .ticketingSchedules[1].dday,
                                                                              style: const TextStyle(
                                                                                fontFamily: 'Pretendard',
                                                                                fontSize: 12,
                                                                                color: Color(0xffFF5F5F),
                                                                                fontWeight: FontWeight.w700,
                                                                              ),
                                                                            )
                                                                          else
                                                                            Text(
                                                                              openingResponse.concerts[index1]
                                                                                  .ticketingSchedules[1].dday,
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
                                              ),
                                              Container(height: 12),
                                            ],
                                          );
                                        }),
                                      ),
                                      //오픈 예정 티켓 00개 모두 보기
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => const OpeningNotice()),
                                          );
                                        },
                                        child: Container(
                                          width: MediaQuery.of(context).size.width - 40,
                                          height: 44,
                                          decoration: ShapeDecoration(
                                            color: Colors.white.withOpacity(0.1),
                                            shape: RoundedRectangleBorder(
                                              side: const BorderSide(width: 1, color: b_600),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              const Text('오픈 예정 티겟 ',
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontFamily: 'Pretendard',
                                                      fontWeight: FontWeight.w500)),
                                              Text(
                                                '${openingResponse.totalNum}개',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontFamily: 'Pretendard',
                                                    fontWeight: FontWeight.w700),
                                              ),
                                              const Text(' 모두 보기',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                    fontFamily: 'Pretendard',
                                                    fontWeight: FontWeight.w500,
                                                  ))
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
                //예매 중인 티켓
                Stack(
                  children: [
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
                      height: 591,
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
                    Positioned(
                        left: 20,
                        top: 24,
                        right: 20,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start, //왼쪽 정렬
                            children: [
                              //로고 + 예매 중인 티켓
                              Row(children: [
                                Image.asset("images/on_sale/on_sale_logo.png", height: 24),
                                Container(width: 8),
                                const Text("예매 중인 티켓",
                                    style: TextStyle(
                                        fontFamily: 'Pretendard',
                                        fontSize: 18,
                                        color: b_100,
                                        fontWeight: FontWeight.w700))
                              ]),
                              //빈공간 12
                              Container(height: 12),
                              FutureBuilder(
                                  future: ticketRepository.onSaleApi(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return const Center(child: CircularProgressIndicator());
                                    } else if (snapshot.hasError) {
                                      //데이터 로딩 실패
                                      return const Center();
                                    } else if (!snapshot.hasData) {
                                      //데이터 없음
                                      return const Center();
                                    } else {
                                      final onSaleResponse = snapshot.data!;
                                      return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                        Column(
                                          children: List.generate(onSaleResponse.totalNum<3? onSaleResponse.totalNum: 3, (index1) {
                                            return Column(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    // 상세 페이지로 이동
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => OnSaleDetail(
                                                          concertId: onSaleResponse
                                                              .concerts[index1].concertId, // 상세 페이지에 데이터 전달
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  child: Row(
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius: BorderRadius.circular(8.0),
                                                        child: Image.network(
                                                          onSaleResponse.concerts[index1].imageUrl,
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
                                                                          text: onSaleResponse.concerts[index1].title,
                                                                          style: const TextStyle(
                                                                            fontFamily: 'Pretendard',
                                                                            fontSize: 14,
                                                                            color: Colors.white,
                                                                            fontWeight: FontWeight.w500,
                                                                          ),
                                                                        ),
                                                                      )),
                                                                  // 티켓 공연 정보
                                                                  Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                                    children: [
                                                                      const Text("공연 일시",
                                                                          style: TextStyle(
                                                                            fontFamily: 'Pretendard',
                                                                            fontSize: 12,
                                                                            color: b_400,
                                                                            fontWeight: FontWeight.w400,
                                                                          )),
                                                                      Text(
                                                                        onSaleResponse.concerts[index1].date,
                                                                        style: const TextStyle(
                                                                          fontFamily: 'Pretendard',
                                                                          fontSize: 12,
                                                                          color: b_400,
                                                                          fontWeight: FontWeight.w400,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(height: 12),
                                              ],
                                            );
                                          }),
                                        ),
                                        // 예매 중인 티켓 00개 모두 보기
                                        GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (context) => const OnSale()),
                                              );
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context).size.width - 40,
                                              height: 44,
                                              decoration: ShapeDecoration(
                                                color: Colors.white.withOpacity(0.1),
                                                shape: RoundedRectangleBorder(
                                                  side: const BorderSide(width: 1, color: b_600),
                                                  borderRadius: BorderRadius.circular(12),
                                                ),
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  const Text('예매 중인 티겟 ',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14,
                                                          fontFamily: 'Pretendard',
                                                          fontWeight: FontWeight.w500)),
                                                  Text(
                                                    '${onSaleResponse.totalNum}개',
                                                    style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontFamily: 'Pretendard',
                                                        fontWeight: FontWeight.w700),
                                                  ),
                                                  const Text(' 모두 보기',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 14,
                                                        fontFamily: 'Pretendard',
                                                        fontWeight: FontWeight.w500,
                                                      ))
                                                ],
                                              ),
                                            ))
                                      ]);
                                    }
                                  })
                            ]))
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
