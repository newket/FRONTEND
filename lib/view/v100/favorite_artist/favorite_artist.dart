import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';
import 'package:newket/config/amplitude_config.dart';
import 'package:newket/model/artist_model.dart';
import 'package:newket/model/auth_model.dart';
import 'package:newket/repository/artist_repository.dart';
import 'package:newket/repository/auth_repository.dart';
import 'package:newket/repository/user_repository.dart';
import 'package:newket/theme/colors.dart';
import 'package:newket/view/v100/favorite_artist/artist_request.dart';
import 'package:newket/view/v100/tapbar/tap_bar.dart';

class FavoriteArtistV1 extends StatefulWidget {
  const FavoriteArtistV1({super.key});

  @override
  State<StatefulWidget> createState() => _FavoriteArtistV1();
}

class _FavoriteArtistV1 extends State<FavoriteArtistV1> {
  late ArtistRepository artistRepository;
  final TextEditingController _searchController = TextEditingController();
  List<Artist> artists = []; // 검색 결과를 담을 리스트
  List<Artist> myArtists = []; //선택한 아티스트들을 담을 리스트

  Future<void> _searchArtists(String keyword) async {
    if (keyword.isNotEmpty) {
      SearchArtists result = await artistRepository.searchArtist(keyword);
      setState(() {
        artists = result.artists;
      });
    } else {
      artists = [];
    }
  }

  @override
  void initState() {
    super.initState();
    artistRepository = ArtistRepository();
    _searchController.addListener(() {
      _searchArtists(_searchController.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
        resizeToAvoidBottomInset: false, //키보드가 올라 오지 않도록

        //배경
        backgroundColor: b_950,

        //앱바
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
          title: const Text(
            "관심 아티스트 등록",
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 16,
              color: b_100,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        //내용
        body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(), // 키보드 외부를 탭하면 키보드 숨기기
            child: Stack(
              children: [
                Positioned.fill(
                    child: Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.00, -1.00),
                            end: Alignment(0, 1),
                            colors: [b_950, Color(0xFF090C2B), Color(0xFF201D65)],
                          ),
                        ),
                        child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20, top: 24),
                            child: Column(children: [
                              const Text(
                                "관심 아티스트를\n검색해서 등록해보세요!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: 24,
                                  color: b_100,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "나중에 등록하거나 수정할 수도 있어요.",
                                style: TextStyle(
                                  fontFamily: 'Pretendard',
                                  fontSize: 14,
                                  color: b_400,
                                  fontWeight: FontWeight.w400,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 28),
                              //검색
                              Container(
                                height: 40,
                                decoration: ShapeDecoration(
                                  color: isKeyboardVisible ? v1pt_20 : b_900, // 내부 배경색
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(width: 1, color: v1pt_50), // 테두리 색상 및 두께
                                    borderRadius: BorderRadius.circular(42),
                                  ),
                                ),
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // 검색 아이콘
                                    Image.asset('images/v1/navigator/search_on.png', height: 20, width: 20),
                                    const SizedBox(width: 12),
                                    // 텍스트 필드 (예시 텍스트)
                                    Expanded(
                                        child: TextField(
                                      decoration: const InputDecoration(
                                        border: InputBorder.none, // 입력 필드의 기본 테두리 제거
                                        hintText:
                                            '관심 있는 아티스트을 검색해보세요!                                                            ',
                                        hintStyle: TextStyle(
                                          color: b_500, // 텍스트 색상
                                          fontSize: 12,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontFamily: 'Pretendard',
                                        fontWeight: FontWeight.w400,
                                      ),
                                      onChanged: (value) {
                                        _searchArtists(value); // 검색 로직 호출
                                      },
                                      controller: _searchController,
                                    )),
                                    GestureDetector(
                                        onTap: () => {
                                              setState(() {
                                                _searchController.clear();
                                                artists = [];
                                              })
                                            },
                                        child: SvgPicture.asset('images/v1/favorite_artist/close-circle.svg',
                                            height: 16, width: 16))
                                  ],
                                ),
                              ),
                              const SizedBox(height: 44),
                            ])))),
                Positioned(
                    top: 220, // 검색 창 바로 아래에 위치
                    left: 32,
                    right: 32,
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      //선택한 아티스트 아이콘
                      Row(
                        children: [
                          SvgPicture.asset("images/v1/favorite_artist/star.svg", height: 20, width: 20),
                          const SizedBox(width: 8),
                          const Text(
                            '선택한 아티스트',
                            style: TextStyle(
                              color: b_100,
                              fontSize: 16,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w700,
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 12),
                      if (myArtists.isNotEmpty)
                        SizedBox(
                            height: MediaQuery.of(context).size.height - 500,
                            child: SingleChildScrollView(
                                child: Wrap(
                                    alignment: WrapAlignment.start,
                                    //왼쪽 부터 시작
                                    direction: Axis.horizontal,
                                    spacing: 8.0,
                                    // 각 아이템 간 간격
                                    runSpacing: 8.0,
                                    // 줄 바꿈 시 간격
                                    children: myArtists.map((artist) {
                                      return Container(
                                        height: 36,
                                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                        clipBehavior: Clip.antiAlias,
                                        decoration: ShapeDecoration(
                                          color: v1pt_20,
                                          shape: RoundedRectangleBorder(
                                            side: const BorderSide(width: 1, color: v1pt_30),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                        child: GestureDetector(
                                            onTap: () {
                                              // X 아이콘 클릭 시 myArtists 리스트에서 제거
                                              setState(() {
                                                myArtists.remove(artist);
                                              });
                                            },
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  artist.name,
                                                  textAlign: TextAlign.center,
                                                  style: const TextStyle(
                                                    color: p_500,
                                                    fontSize: 14,
                                                    fontFamily: 'Pretendard',
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                const Icon(Icons.clear, color: Colors.white, size: 16)
                                              ],
                                            )),
                                      );
                                    }).toList())))
                      else
                        Container(
                          height: 40,
                          padding: const EdgeInsets.only(
                            top: 12,
                            bottom: 12,
                          ),
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            color: b_900,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                '아직 선택한 아티스트가 없어요!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: b_500,
                                  fontSize: 12,
                                  fontFamily: 'Pretendard',
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        )
                    ])),
                Positioned(
                    bottom: 44, // 검색 창 바로 아래에 위치
                    left: 32,
                    right: 32,
                    child: ElevatedButton(
                      onPressed: () async {
                        var storage = const FlutterSecureStorage();
                        final accessToken = await storage.read(key: 'KAKAO_TOKEN');
                        //signup
                        //await AuthRepository().signUpApi(SignUpRequest(accessToken!, myArtists.map((artist) => artist.artistId).toList()));
                        //기기 토큰 저장
                        final serverToken = await storage.read(key: 'ACCESS_TOKEN');
                        await UserRepository().putDeviceTokenApi(serverToken!);
                        //home 으로
                        Get.offAll(const TapBarV1());
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: p_700, // 버튼 색상
                        padding: const EdgeInsets.all(12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size(0, 48), // 버튼 높이 조정
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '다음',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontFamily: 'Pretendard',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    )),
                if (artists.isNotEmpty)
                  Positioned(
                      top: 186, // 검색 창 바로 아래에 위치
                      left: 32,
                      right: 32,
                      child: SingleChildScrollView(
                        child: Container(
                          height: (58 * artists.length.toDouble() > 232) ? 232 : 58 * artists.length.toDouble(),
                          // 적절한 크기 조정 가능
                          decoration: ShapeDecoration(
                            color: b_900,
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 1, color: v1pt_90),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: ListView.builder(
                            shrinkWrap: true, // 콘텐츠 크기에 맞게 ListView의 크기를 조정
                            itemCount: artists.length,
                            itemBuilder: (context, index) {
                              final artist = artists[index];
                              return GestureDetector(
                                onTap: () {
                                  // 아이콘 클릭 시 myArtists 리스트에 추가
                                  setState(() {
                                    // 기존 리스트에서 중복을 체크하는 함수
                                    bool artistExists = myArtists.any((a) => a.artistId == artist.artistId);

                                    if (!artistExists) {
                                      myArtists.add(artist);
                                    }
                                    artists = [];
                                    _searchController.clear(); // 텍스트 필드 값을 빈 문자열로 리셋
                                  });
                                },
                                child: Container(
                                    color: Colors.transparent,
                                    padding: const EdgeInsets.only(top: 10, bottom: 10, left: 8, right: 8),
                                    width: MediaQuery.of(context).size.width - 64,
                                    height: 58,
                                    child: Row(
                                      children: [
                                        const Icon(Icons.add, color: Colors.white),
                                        const SizedBox(width: 4),
                                        if (artist.nicknames != null)
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                artist.name,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontFamily: 'Pretendard',
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                              Text(
                                                artist.nicknames ?? '',
                                                style: TextStyle(
                                                  color: Colors.white.withOpacity(0.5),
                                                  fontSize: 12,
                                                  fontFamily: 'Pretendard',
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                textAlign: TextAlign.center,
                                              )
                                            ],
                                          )
                                        else
                                          Text(
                                            artist.name,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 14,
                                              fontFamily: 'Pretendard',
                                              fontWeight: FontWeight.w700,
                                            ),
                                            textAlign: TextAlign.center,
                                          )
                                      ],
                                    )),
                              );
                            },
                          ),
                        ),
                      ))
                else if (_searchController.text != '')
                  Positioned(
                      top: 186, // 검색 창 바로 아래에 위치
                      left: 32,
                      right: 32,
                      child: Container(
                        width: 296,
                        height: 181,
                        padding: const EdgeInsets.only(
                          top: 24,
                          left: 32,
                          right: 32,
                          bottom: 24,
                        ),
                        decoration: ShapeDecoration(
                          color: b_900,
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(width: 1, color: v1pt_90),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              '찾으시는 아티스트가 없나요?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Text(
                              '원하는 아티스트를 요청해주세요.\n새로운 아티스트로 등록되면 알림을 보내드릴게요!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.5),
                                fontSize: 12,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 28),
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => const ArtistRequestV1()),
                                  );
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 40,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: ShapeDecoration(
                                    color: v1pt_30,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        '아티스트 등록 요청하러가기',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: p_600,
                                          fontSize: 14,
                                          fontFamily: 'Pretendard',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      SvgPicture.asset("images/v1/favorite_artist/request.svg", height: 24, width: 24),
                                    ],
                                  ),
                                ))
                          ],
                        ),
                      ))
              ],
            )));
  }
}
